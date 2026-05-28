import 'package:shared_preferences/shared_preferences.dart';

/// Persists pill progress on device so completions survive app restarts
/// and are not lost when Firestore reloads with stale data.
class LocalProgressService {
  static const _keyLastUid = 'progress_last_uid';

  String _storageKey(String userId) => 'pill_progress_$userId';

  Future<Map<String, dynamic>?> load({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = userId ?? prefs.getString(_keyLastUid) ?? 'guest';
    final raw = prefs.getString(_storageKey(uid));
    if (raw == null) return null;

    final parts = raw.split('|');
    if (parts.length < 6) return null;

    return {
      'completedLessons':
          parts[0].isEmpty ? <String>[] : parts[0].split('\u001f'),
      'completedTopics':
          parts[1].isEmpty ? <String>[] : parts[1].split('\u001f'),
      'classPoints': int.tryParse(parts[2]) ?? 0,
      'totalXP': int.tryParse(parts[3]) ?? 0,
      'level': int.tryParse(parts[4]) ?? 1,
      'streakDays': int.tryParse(parts[5]) ?? 0,
      if (parts.length >= 7 && parts[6].isNotEmpty)
        'lastStreakDay': int.tryParse(parts[6]),
    };
  }

  Future<void> save({
    required String? userId,
    required List<String> completedLessons,
    required List<String> completedTopics,
    required int classPoints,
    required int totalXP,
    required int userLevel,
    required int streakDays,
    int? lastStreakDay,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = userId ?? 'guest';
    await prefs.setString(_keyLastUid, uid);

    final encoded = [
      completedLessons.join('\u001f'),
      completedTopics.join('\u001f'),
      classPoints.toString(),
      totalXP.toString(),
      userLevel.toString(),
      streakDays.toString(),
      lastStreakDay?.toString() ?? '',
    ].join('|');

    await prefs.setString(_storageKey(uid), encoded);
  }

  Future<void> clear({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = userId ?? prefs.getString(_keyLastUid) ?? 'guest';
    await prefs.remove(_storageKey(uid));
  }
}
