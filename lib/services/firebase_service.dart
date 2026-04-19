import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:finance4u/firebase_options.dart';

/// Singleton service for Firebase initialization and core functionality
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  FirebaseService._();

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseStorage? _storage;
  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;

  bool _initialized = false;

  /// Initialize Firebase services
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // Enable Crashlytics in debug mode for testing
      await _crashlytics?.setCrashlyticsCollectionEnabled(true);

      // Pass all uncaught errors to Crashlytics
      FlutterError.onError = (errorDetails) {
        _crashlytics?.recordFlutterFatalError(errorDetails);
      };

      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Firebase: $e');
    }
  }

  /// Get Firebase Auth instance
  FirebaseAuth get auth {
    if (!_initialized || _auth == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _auth!;
  }

  /// Get Firestore instance
  FirebaseFirestore get firestore {
    if (!_initialized || _firestore == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _firestore!;
  }

  /// Get Storage instance
  FirebaseStorage get storage {
    if (!_initialized || _storage == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _storage!;
  }

  /// Get Analytics instance
  FirebaseAnalytics get analytics {
    if (!_initialized || _analytics == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _analytics!;
  }

  /// Get Crashlytics instance
  FirebaseCrashlytics get crashlytics {
    if (!_initialized || _crashlytics == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _crashlytics!;
  }

  /// Check if Firebase is initialized
  bool get isInitialized => _initialized;
}

