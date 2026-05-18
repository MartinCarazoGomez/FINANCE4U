import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _key = 'tutorial_completed_v1';

  /// In-memory cache so re-runs from Settings show the tutorial instantly,
  /// without waiting for SharedPreferences on the next cold read.
  static bool? _cached;

  /// Synchronous read of the in-memory cache.
  /// Returns false when unknown (first ever cold boot before async read).
  static bool get cachedShouldShow => _cached ?? false;

  static Future<bool> shouldShowTutorial() async {
    if (_cached != null) return _cached!;
    final prefs = await SharedPreferences.getInstance();
    _cached = !(prefs.getBool(_key) ?? false);
    return _cached!;
  }

  static Future<void> markCompleted() async {
    _cached = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  static Future<void> resetTutorial() async {
    _cached = true; // immediately visible to the next shouldShowTutorial() call
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
