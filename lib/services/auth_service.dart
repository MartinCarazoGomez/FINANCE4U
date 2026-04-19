import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';
import 'firestore_helper.dart';

/// Singleton service for Firebase Authentication
/// Similar to React Context pattern but using Singleton
class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  AuthService._();

  FirebaseAuth get _auth => FirebaseService.instance.auth;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Stream of user changes
  Stream<User?> get userChanges => _auth.userChanges();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Load user data from Firestore if exists
      if (credential.user != null) {
        await _loadUserData(credential.user!.uid);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Create account with email and password
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
        // Create user document in Firestore
        await FirestoreHelper.createUser(
          userId: credential.user!.uid,
          email: email,
          username: username,
        );

        // Initialize progress
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
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    await user.updateDisplayName(displayName);
    if (photoURL != null) {
      await user.updatePhotoURL(photoURL);
    }
    await user.reload();

    // Sync with Firestore
    if (displayName != null) {
      await FirestoreHelper.updateUser(user.uid, {'username': displayName});
    }
  }

  /// Update email
  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    await user.updateEmail(newEmail);
    await FirestoreHelper.updateUser(user.uid, {'email': newEmail});
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    await user.updatePassword(newPassword);
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    final userId = user.uid;
    await user.delete();

    // Optionally delete user data from Firestore
    // await FirestoreHelper.userDoc(userId).delete();
  }

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Load user data from Firestore
  Future<void> _loadUserData(String userId) async {
    // This can be used to sync Firestore data with local state
    // Implementation depends on your state management approach
  }

  /// Handle Firebase Auth exceptions
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
        return 'Operación no permitida';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}

