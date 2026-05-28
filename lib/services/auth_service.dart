import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/google_auth_config.dart';
import '../utils/platform_auth.dart';
import 'firebase_service.dart';
import 'firestore_helper.dart';

/// Singleton service for Firebase Authentication
class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  AuthService._();

  FirebaseAuth get _auth => FirebaseService.instance.auth;

  GoogleSignIn? _googleSignIn;

  GoogleSignIn get _googleSignInInstance {
    if (!isGoogleSignInSupported) {
      throw Exception(kGoogleSignInUnsupportedMessage);
    }
    return _googleSignIn ??= GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: kGoogleWebClientId,
    );
  }

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Stream<User?> get userChanges => _auth.userChanges();
  bool get isSignedIn => _auth.currentUser != null;

  /// Sign in with Google. Creates Firestore profile if new user.
  Future<UserCredential> signInWithGoogle() async {
    if (!isGoogleSignInSupported) {
      throw Exception(kGoogleSignInUnsupportedMessage);
    }

    try {
      final googleUser = await _googleSignInInstance.signIn();
      if (googleUser == null) {
        throw Exception('Inicio de sesión cancelado');
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw Exception(
          'No se pudo obtener el token de Google. '
          'Comprueba que Google Sign-In está activado en Firebase y que '
          'añadiste el SHA-1 del keystore en la consola de Firebase.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await _ensureUserDocument(
          user: user,
          authProvider: 'google',
          isGuest: false,
          defaultUsername: user.displayName ?? 'Usuario',
          photoUrl: user.photoURL,
        );
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } on PlatformException catch (e) {
      throw Exception(_mapGooglePlatformError(e));
    } on MissingPluginException {
      throw Exception(kGoogleSignInUnsupportedMessage);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  /// Link anonymous/guest account to Google.
  Future<UserCredential> linkWithGoogle() async {
    if (!isGoogleSignInSupported) {
      throw Exception(kGoogleSignInUnsupportedMessage);
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No hay sesión activa');
    }

    try {
      final googleUser = await _googleSignInInstance.signIn();
      if (googleUser == null) {
        throw Exception('Vinculación cancelada');
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw Exception(
          'No se pudo obtener el token de Google. '
          'Añade el SHA-1 del keystore en Firebase Console.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential linked;
      if (user.isAnonymous) {
        linked = await user.linkWithCredential(credential);
      } else {
        linked = await _auth.signInWithCredential(credential);
      }

      final linkedUser = linked.user;
      if (linkedUser != null) {
        await FirestoreHelper.updateUser(linkedUser.uid, {
          'isGuest': false,
          'authProvider': 'google',
          'email': linkedUser.email ?? '',
          if (linkedUser.photoURL != null) 'photoUrl': linkedUser.photoURL,
        });
        if (linkedUser.displayName != null) {
          await linkedUser.updateDisplayName(linkedUser.displayName);
        }
      }
      return linked;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } on PlatformException catch (e) {
      throw Exception(_mapGooglePlatformError(e));
    } on MissingPluginException {
      throw Exception(kGoogleSignInUnsupportedMessage);
    }
  }

  /// Sign in anonymously as guest.
  Future<UserCredential> signInAsGuest() async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;
      if (user != null) {
        await _ensureUserDocument(
          user: user,
          authProvider: 'guest',
          isGuest: true,
          defaultUsername: 'Invitado',
        );
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  /// Update display name and optional external photo URL (Google) in Auth + Firestore.
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (photoURL != null) {
      await user.updatePhotoURL(photoURL);
    }
    await user.reload();

    final updates = <String, dynamic>{};
    if (displayName != null) updates['username'] = displayName;
    if (photoURL != null) updates['photoUrl'] = photoURL;
    if (updates.isNotEmpty) {
      await FirestoreHelper.updateUser(user.uid, updates);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _loadUserData(credential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await FirestoreHelper.createUser(
          userId: credential.user!.uid,
          email: email,
          username: username,
          authProvider: 'email',
        );

        await FirestoreHelper.saveProgress(
          userId: credential.user!.uid,
          level: 1,
          totalXP: 0,
          streakDays: 0,
          completedLessons: [],
          unlockedGames: ['budget_master'],
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  Future<void> signOut() async {
    final futures = <Future<void>>[_auth.signOut()];
    if (isGoogleSignInSupported && _googleSignIn != null) {
      futures.add(_googleSignIn!.signOut());
    }
    await Future.wait(futures);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    await user.verifyBeforeUpdateEmail(newEmail);
    await FirestoreHelper.updateUser(user.uid, {'email': newEmail});
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');
    await user.delete();
  }

  Future<void> _ensureUserDocument({
    required User user,
    required String authProvider,
    required bool isGuest,
    required String defaultUsername,
    String? photoUrl,
  }) async {
    final existing = await FirestoreHelper.getUser(user.uid);
    if (existing != null) return;

    await FirestoreHelper.createUser(
      userId: user.uid,
      email: user.email ?? '',
      username: user.displayName ?? defaultUsername,
      photoUrl: photoUrl ?? user.photoURL,
      isGuest: isGuest,
      authProvider: authProvider,
      onboardingCompleted: false,
    );

    await FirestoreHelper.saveProgress(
      userId: user.uid,
      level: 1,
      totalXP: 0,
      streakDays: 0,
      completedLessons: [],
      unlockedGames: ['budget_master'],
    );
  }

  Future<void> _loadUserData(String userId) async {
    await FirestoreHelper.getUser(userId);
  }

  String _mapGooglePlatformError(PlatformException e) {
    final message = e.message ?? '';
    if (message.contains('10') || message.contains('DEVELOPER_ERROR')) {
      return 'Configuración de Google incorrecta. Añade el SHA-1 del keystore '
          'de tu APK en Firebase Console → Configuración del proyecto → '
          'Tu app Android, descarga de nuevo google-services.json y recompila.';
    }
    if (e.code == 'network_error') {
      return 'Sin conexión. Comprueba tu internet e inténtalo de nuevo.';
    }
    if (e.code == 'sign_in_failed') {
      return 'Google Sign-In falló. Verifica que el proveedor Google esté '
          'activado en Firebase Authentication.';
    }
    return 'Error de Google Sign-In (${e.code}): $message';
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'email-already-in-use':
        return 'Este correo ya está registrado';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Google Sign-In no está activado en Firebase Console';
      case 'invalid-credential':
        return 'Credencial de Google inválida. Revisa SHA-1 y google-services.json';
      case 'credential-already-in-use':
        return 'Esta cuenta de Google ya está vinculada a otro usuario';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con ese correo';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
