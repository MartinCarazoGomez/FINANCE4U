import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

/// Typed helper functions for Firestore collections
/// Following Firebase v9+ modular approach principles
class FirestoreHelper {
  static final FirebaseFirestore _db = FirebaseService.instance.firestore;

  // Collection references with type safety
  static CollectionReference<Map<String, dynamic>> _usersCollection() {
    return _db.collection('users');
  }

  static CollectionReference<Map<String, dynamic>> _progressCollection() {
    return _db.collection('user_progress');
  }

  static CollectionReference<Map<String, dynamic>> _gamesCollection() {
    return _db.collection('game_data');
  }

  static CollectionReference<Map<String, dynamic>> _achievementsCollection() {
    return _db.collection('achievements');
  }

  static CollectionReference<Map<String, dynamic>> _lessonsCollection() {
    return _db.collection('lessons');
  }

  // User document helpers
  static DocumentReference<Map<String, dynamic>> userDoc(String userId) {
    return _usersCollection().doc(userId);
  }

  static Future<void> createUser({
    required String userId,
    required String email,
    required String username,
  }) async {
    await userDoc(userId).set({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await userDoc(userId).get();
    return doc.data();
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await userDoc(userId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Progress document helpers
  static DocumentReference<Map<String, dynamic>> progressDoc(String userId) {
    return _progressCollection().doc(userId);
  }

  static Future<void> saveProgress({
    required String userId,
    required int level,
    required int totalXP,
    required int streakDays,
    required List<String> completedLessons,
    required List<String> unlockedGames,
  }) async {
    await progressDoc(userId).set({
      'userId': userId,
      'level': level,
      'totalXP': totalXP,
      'streakDays': streakDays,
      'completedLessons': completedLessons,
      'unlockedGames': unlockedGames,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getProgress(String userId) async {
    final doc = await progressDoc(userId).get();
    return doc.data();
  }

  // Game data helpers
  static DocumentReference<Map<String, dynamic>> gameDataDoc(String userId, String gameId) {
    return _gamesCollection().doc('${userId}_$gameId');
  }

  static Future<void> saveGameData({
    required String userId,
    required String gameId,
    required Map<String, dynamic> data,
  }) async {
    await gameDataDoc(userId, gameId).set({
      'userId': userId,
      'gameId': gameId,
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getGameData(String userId, String gameId) async {
    final doc = await gameDataDoc(userId, gameId).get();
    return doc.data();
  }

  // Achievements helpers
  static DocumentReference<Map<String, dynamic>> achievementDoc(String userId, String achievementId) {
    return _achievementsCollection().doc('${userId}_$achievementId');
  }

  static Future<void> unlockAchievement({
    required String userId,
    required String achievementId,
    required String title,
    required String description,
  }) async {
    await achievementDoc(userId, achievementId).set({
      'userId': userId,
      'achievementId': achievementId,
      'title': title,
      'description': description,
      'unlockedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    final snapshot = await _achievementsCollection()
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Lessons helpers
  static DocumentReference<Map<String, dynamic>> lessonDoc(String lessonId) {
    return _lessonsCollection().doc(lessonId);
  }

  static Future<List<Map<String, dynamic>>> getAllLessons() async {
    final snapshot = await _lessonsCollection().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> userProgressStream(String userId) {
    return progressDoc(userId).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> userGamesStream(String userId) {
    return _gamesCollection()
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}

