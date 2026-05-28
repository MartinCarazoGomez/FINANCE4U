import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/class_rank_entry.dart';
import '../utils/achievements_service.dart';
import 'firebase_service.dart';

/// Class ranking, stats and group data from Firestore.
class ClassService {
  static FirebaseFirestore get _db => FirebaseService.instance.firestore;

  static CollectionReference<Map<String, dynamic>> get _groups =>
      _db.collection('groups');

  static CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  static CollectionReference<Map<String, dynamic>> get _progress =>
      _db.collection('user_progress');

  static CollectionReference<Map<String, dynamic>> get _messages =>
      _db.collection('group_messages');

  /// Loads ranking, stats + recent chat for the user's class.
  static Future<ClassRoomData> loadClassRoom({
    required String groupId,
    required String currentUserId,
    int messageLimit = 40,
  }) async {
    final groupSnap = await _groups.doc(groupId).get();
    if (!groupSnap.exists) return ClassRoomData.empty;

    final groupData = groupSnap.data()!;
    final memberIds = _asStringList(groupData['memberIds']);
    if (memberIds.isEmpty) {
      return ClassRoomData(
        groupName: groupData['name'] as String?,
        groupCode: groupData['code'] as String?,
      );
    }

    final usersById = await _fetchUsers(memberIds);
    final progressById = await _fetchMemberProgress(memberIds);
    final topicCounts = _aggregateTopicCompletions(progressById);

    final ranking = memberIds.map((uid) {
      final user = usersById[uid];
      final progress = progressById[uid];
      return ClassRankEntry(
        userId: uid,
        username: user?['username'] as String? ?? 'Usuario',
        points: progress?.classPoints ?? 0,
        pillsCompleted: progress?.pillCount ?? 0,
        topicsCompleted: progress?.topicCount ?? 0,
        streakDays: progress?.streakDays ?? 0,
        level: progress?.level ?? 1,
        photoUrl: user?['photoUrl'] as String?,
        isCurrentUser: uid == currentUserId,
        completedLessons: progress?.completedLessons ?? const [],
      );
    }).toList()
      ..sort((a, b) {
        final byPoints = b.points.compareTo(a.points);
        if (byPoints != 0) return byPoints;
        return a.username.toLowerCase().compareTo(b.username.toLowerCase());
      });

    final messagesSnap = await _messages
        .where('groupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .limit(messageLimit)
        .get();

    final messages = messagesSnap.docs.map((doc) {
      final data = doc.data();
      final ts = data['createdAt'];
      return ClassMessage(
        id: doc.id,
        userId: data['userId'] as String? ?? '',
        username: data['username'] as String? ?? 'Usuario',
        content: data['content'] as String? ?? '',
        createdAt: ts is Timestamp ? ts.toDate() : null,
      );
    }).toList();

    final reversedMessages = messages.reversed.toList();
    final stats = ClassStats.fromData(
      ranking: ranking,
      messages: reversedMessages,
      currentUserId: currentUserId,
      topicCounts: topicCounts,
    );

    return ClassRoomData(
      groupName: groupData['name'] as String?,
      groupCode: groupData['code'] as String?,
      ranking: ranking,
      messages: reversedMessages,
      stats: stats,
      topicCompletionCounts: topicCounts,
    );
  }

  static Future<Map<String, Map<String, dynamic>>> _fetchUsers(
    List<String> userIds,
  ) async {
    final result = <String, Map<String, dynamic>>{};
    for (final chunk in _chunks(userIds, 10)) {
      final snap =
          await _users.where(FieldPath.documentId, whereIn: chunk).get();
      for (final doc in snap.docs) {
        result[doc.id] = doc.data();
      }
    }
    return result;
  }

  static Future<Map<String, _MemberProgress>> _fetchMemberProgress(
    List<String> userIds,
  ) async {
    final result = <String, _MemberProgress>{};
    for (final chunk in _chunks(userIds, 10)) {
      final snap =
          await _progress.where(FieldPath.documentId, whereIn: chunk).get();
      for (final doc in snap.docs) {
        final data = doc.data();
        final lessons = data['completedLessons'];
        final topics = data['completedTopics'];
        result[doc.id] = _MemberProgress(
          classPoints: (data['classPoints'] as num?)?.toInt() ?? 0,
          pillCount: lessons is List ? lessons.length : 0,
          topicCount: topics is List ? topics.length : 0,
          streakDays: (data['streakDays'] as num?)?.toInt() ?? 0,
          level: (data['level'] as num?)?.toInt() ?? 1,
          completedTopics:
              topics is List ? topics.whereType<String>().toList() : const [],
          completedLessons:
              lessons is List ? lessons.whereType<String>().toList() : const [],
        );
      }
    }
    return result;
  }

  static Map<String, int> _aggregateTopicCompletions(
    Map<String, _MemberProgress> progressById,
  ) {
    final counts = <String, int>{};
    for (final progress in progressById.values) {
      for (final topicId in progress.completedTopics) {
        counts[topicId] = (counts[topicId] ?? 0) + 1;
      }
    }
    return counts;
  }

  static List<String> _asStringList(dynamic value) {
    if (value is! List) return [];
    return value.whereType<String>().toList();
  }

  static List<List<T>> _chunks<T>(List<T> items, int size) {
    if (items.isEmpty) return [];
    final chunks = <List<T>>[];
    for (var i = 0; i < items.length; i += size) {
      chunks.add(
        items.sublist(i, i + size > items.length ? items.length : i + size),
      );
    }
    return chunks;
  }
}

class _MemberProgress {
  final int classPoints;
  final int pillCount;
  final int topicCount;
  final int streakDays;
  final int level;
  final List<String> completedTopics;
  final List<String> completedLessons;

  const _MemberProgress({
    required this.classPoints,
    required this.pillCount,
    required this.topicCount,
    required this.streakDays,
    required this.level,
    required this.completedTopics,
    required this.completedLessons,
  });
}
