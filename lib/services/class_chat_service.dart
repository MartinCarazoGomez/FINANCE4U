import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

/// Group-scoped chat for a class.
class ClassChatService {
  static FirebaseFirestore get _db => FirebaseService.instance.firestore;

  static CollectionReference<Map<String, dynamic>> get _messages =>
      _db.collection('group_messages');

  static Future<void> sendMessage({
    required String groupId,
    required String userId,
    required String username,
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    await _messages.add({
      'groupId': groupId,
      'userId': userId,
      'username': username.trim(),
      'content': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static String timeAgo(DateTime? time) {
    if (time == null) return 'ahora';
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'hace ${diff.inDays}d';
    return 'hace ${(diff.inDays / 7).floor()}sem';
  }
}
