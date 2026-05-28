import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Singleton service for Firebase initialization and core functionality.
/// Firebase.initializeApp() must be called once in main() before this service
/// is used — this service only wires up the singleton instances.
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  FirebaseService._();

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;

  bool _initialized = false;

  /// Wire up Firebase service references.
  /// Assumes Firebase.initializeApp() has already been called.
  Future<void> initialize() async {
    if (_initialized) return;

    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _analytics = FirebaseAnalytics.instance;

    try {
      _crashlytics = FirebaseCrashlytics.instance;
      await _crashlytics?.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = (errorDetails) {
        _crashlytics?.recordFlutterFatalError(errorDetails);
      };
    } catch (e) {
      debugPrint('Crashlytics init skipped: $e');
    }

    _initialized = true;
  }

  FirebaseAuth get auth {
    if (!_initialized || _auth == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _auth!;
  }

  FirebaseFirestore get firestore {
    if (!_initialized || _firestore == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _firestore!;
  }

  FirebaseAnalytics get analytics {
    if (!_initialized || _analytics == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _analytics!;
  }

  FirebaseCrashlytics get crashlytics {
    if (!_initialized || _crashlytics == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _crashlytics!;
  }

  bool get isInitialized => _initialized;
}
