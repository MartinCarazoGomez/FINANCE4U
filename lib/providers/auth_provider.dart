import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_helper.dart';
import '../services/firebase_service.dart';
import '../services/group_service.dart';
import '../services/community_service.dart';
import '../utils/profile_photo_helper.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AppProvider? appProvider}) : _appProvider = appProvider;

  AppProvider? _appProvider;

  final AuthService _auth = AuthService.instance;

  UserProfile? _profile;
  User? _firebaseUser;
  bool _initialized = false;
  bool _busy = false;
  String? _error;
  StreamSubscription<User?>? _authSub;

  UserProfile? get profile => _profile;
  User? get firebaseUser => _firebaseUser;
  bool get initialized => _initialized;
  bool get busy => _busy;
  String? get error => _error;
  bool get isSignedIn => _firebaseUser != null;
  bool get isGuest => _profile?.isGuest ?? _firebaseUser?.isAnonymous ?? true;
  bool get onboardingCompleted => _profile?.onboardingCompleted ?? false;
  String? get groupId => _profile?.groupId;
  String? get photoUrl => _profile?.photoUrl;
  String? get photoBase64 => _profile?.photoBase64;

  void attachAppProvider(AppProvider appProvider) {
    _appProvider = appProvider;
    if (_profile != null) _syncAppProvider();
  }

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      if (!FirebaseService.instance.isInitialized) {
        await FirebaseService.instance.initialize();
      }

      _authSub = _auth.authStateChanges.listen(_onAuthStateChanged);

      final current = _auth.currentUser;
      if (current != null) {
        _firebaseUser = current;
        await _loadProfile(current.uid);
      }

      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('AuthProvider.initialize error: $e');
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user == null) {
      _profile = null;
      notifyListeners();
      return;
    }
    if (_profile?.uid == user.uid) return;
    await _loadProfile(user.uid);
  }

  Future<void> _loadProfile(String uid) async {
    try {
      final data = await FirestoreHelper.getUser(uid);
      if (data != null) {
        _profile = UserProfile.fromFirestore(uid, data);
      } else {
        _profile = UserProfile(
          uid: uid,
          username: _firebaseUser?.displayName ?? 'Usuario',
          email: _firebaseUser?.email ?? '',
          photoUrl: _firebaseUser?.photoURL,
          isGuest: _firebaseUser?.isAnonymous ?? false,
          authProvider: _firebaseUser?.isAnonymous == true ? 'guest' : 'google',
        );
      }
      _syncAppProvider();
      await _loadProgress(uid);
      await _cacheProfileLocally();
    } catch (e) {
      debugPrint('AuthProvider._loadProfile error: $e');
      _profile ??= UserProfile(
        uid: uid,
        username: _firebaseUser?.displayName ?? 'Usuario',
        email: _firebaseUser?.email ?? '',
        isGuest: _firebaseUser?.isAnonymous ?? true,
      );
      _syncAppProvider();
    }
    notifyListeners();
  }

  void _syncAppProvider() {
    final p = _profile;
    if (p == null || _appProvider == null) return;
    _appProvider!.updateUsername(p.username);
    if (p.email.isNotEmpty) {
      _appProvider!.updateEmail(p.email);
    }
    CommunityService.saveDisplayName(p.username);
  }

  Future<void> _loadProgress(String uid) async {
    if (_appProvider == null) return;
    try {
      _appProvider!.setProgressUserId(uid);
      await _appProvider!.loadLocalProgress(userId: uid);
      final data = await FirestoreHelper.getProgress(uid);
      if (data != null) {
        _appProvider!.loadFromFirestore(data);
      }
    } catch (e) {
      debugPrint('AuthProvider._loadProgress error: $e');
    }
  }

  Future<void> _cacheProfileLocally() async {
    final p = _profile;
    if (p == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_username', p.username);
    await prefs.setString('cached_uid', p.uid);
    if (p.photoUrl != null) {
      await prefs.setString('cached_photo_url', p.photoUrl!);
    }
    await prefs.setBool('onboarding_completed', p.onboardingCompleted);
  }

  Future<void> signInWithGoogle() async {
    await _runBusy(() async {
      await _auth.signInWithGoogle();
      final user = _auth.currentUser;
      if (user != null) await _loadProfile(user.uid);
    });
  }

  Future<void> signInAsGuest() async {
    await _runBusy(() async {
      await _auth.signInAsGuest();
      final user = _auth.currentUser;
      if (user != null) await _loadProfile(user.uid);
    });
  }

  Future<void> linkGoogleAccount() async {
    await _runBusy(() async {
      await _auth.linkWithGoogle();
      final user = _auth.currentUser;
      if (user != null) await _loadProfile(user.uid);
    });
  }

  Future<void> completeOnboarding({
    required String username,
    String? groupCode,
    String? groupPin,
    File? photoFile,
  }) async {
    final user = _firebaseUser;
    if (user == null) {
      throw Exception('Debes iniciar sesión primero');
    }

    await _runBusy(() async {
      String? photoBase64;

      if (photoFile != null) {
        photoBase64 = await ProfilePhotoHelper.encodeFile(photoFile);
      }

      String? groupId;
      String? joinedCode;
      String? groupName;

      if (groupCode != null && groupCode.trim().isNotEmpty) {
        final joined = await GroupService.joinByCode(
          userId: user.uid,
          code: groupCode,
          pin: groupPin ?? '',
        );
        groupId = joined.groupId;
        joinedCode = joined.code;
        groupName = joined.name;
      }

      await _auth.updateProfile(displayName: username.trim());

      await FirestoreHelper.updateUser(user.uid, {
        'username': username.trim(),
        'onboardingCompleted': true,
        if (photoBase64 != null) 'photoBase64': photoBase64,
        if (groupId != null) 'groupId': groupId,
        if (joinedCode != null) 'groupCode': joinedCode,
        if (groupName != null) 'groupName': groupName,
      });

      await _loadProfile(user.uid);
    });
  }

  Future<void> updateUsername(String username) async {
    final user = _firebaseUser;
    if (user == null) return;

    await _runBusy(() async {
      await _auth.updateProfile(displayName: username.trim());
      await FirestoreHelper.updateUser(user.uid, {'username': username.trim()});
      await _loadProfile(user.uid);
    });
  }

  Future<void> updateProfilePhoto(File photoFile) async {
    final user = _firebaseUser;
    if (user == null) return;

    await _runBusy(() async {
      final photoBase64 = await ProfilePhotoHelper.encodeFile(photoFile);
      await FirestoreHelper.updateUser(user.uid, {
        'photoBase64': photoBase64,
      });
      await _loadProfile(user.uid);
    });
  }

  Future<void> joinGroup(String code, String pin) async {
    final user = _firebaseUser;
    if (user == null) return;

    await _runBusy(() async {
      if (_profile?.groupId != null) {
        await GroupService.leaveGroup(
          userId: user.uid,
          groupId: _profile!.groupId!,
        );
      }

      final joined = await GroupService.joinByCode(
        userId: user.uid,
        code: code,
        pin: pin,
      );

      await FirestoreHelper.updateUser(user.uid, {
        'groupId': joined.groupId,
        'groupCode': joined.code,
        'groupName': joined.name,
      });
      await _loadProfile(user.uid);
    });
  }

  Future<void> leaveGroup() async {
    final user = _firebaseUser;
    final groupId = _profile?.groupId;
    if (user == null || groupId == null) return;

    await _runBusy(() async {
      await GroupService.leaveGroup(userId: user.uid, groupId: groupId);
      await FirestoreHelper.updateUser(user.uid, {
        'groupId': FieldValue.delete(),
        'groupCode': FieldValue.delete(),
        'groupName': FieldValue.delete(),
      });
      await _loadProfile(user.uid);
    });
  }

  Future<void> signOut() async {
    await _runBusy(() async {
      await _auth.signOut();
      _profile = null;
      _firebaseUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('onboarding_completed');
    });
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _error = e is String ? e : e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
