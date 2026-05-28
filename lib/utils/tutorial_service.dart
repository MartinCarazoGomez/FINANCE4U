import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _keyPrefix = 'tutorial_completed_v1';

  static String? _userId;
  static bool? _cached;

  static String _key(String userId) => '${_keyPrefix}_$userId';

  /// Synchronous read of the in-memory cache for the active user.
  static bool get cachedShouldShow => _cached ?? false;

  /// Bind tutorial state to a user and load completion from storage.
  /// Call before navigating to [MainNavigation] so the overlay can appear
  /// on the first frame without a flash.
  static Future<bool> prepareForUser(String userId) async {
    _userId = userId;
    _cached = null;
    return shouldShowTutorial(userId: userId);
  }

  static Future<bool> shouldShowTutorial({String? userId}) async {
    final uid = userId ?? _userId;
    if (uid == null || uid.isEmpty) return false;

    if (_cached != null && _userId == uid) return _cached!;

    final prefs = await SharedPreferences.getInstance();
    _userId = uid;
    _cached = !(prefs.getBool(_key(uid)) ?? false);
    return _cached!;
  }

  static Future<void> markCompleted({String? userId}) async {
    final uid = userId ?? _userId;
    if (uid == null || uid.isEmpty) return;

    _userId = uid;
    _cached = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(uid), true);
  }

  static Future<void> resetTutorial({String? userId}) async {
    final uid = userId ?? _userId;
    if (uid == null || uid.isEmpty) return;

    _userId = uid;
    _cached = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(uid));
  }
}
