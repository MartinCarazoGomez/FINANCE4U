import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All community (forum) operations backed by Firestore.
///
/// Firestore structure:
///   community_posts/{postId}
///     userId      : String
///     username    : String
///     content     : String
///     createdAt   : Timestamp
///     likeCount   : int
///     likedBy     : List<String>   (uids of users who liked)
///     commentCount: int
///
///   community_posts/{postId}/comments/{commentId}
///     userId      : String
///     username    : String
///     content     : String
///     createdAt   : Timestamp
class CommunityService {
  static const _kDisplayNameKey = 'community_display_name';

  static FirebaseFirestore get _db => FirebaseFirestore.instance;
  static FirebaseAuth get _auth => FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> get _posts =>
      _db.collection('community_posts');

  // ── Auth ────────────────────────────────────────────────────────────────

  /// Returns the current user's UID, signing in anonymously if needed.
  static Future<String> ensureUser() async {
    if (_auth.currentUser != null) return _auth.currentUser!.uid;
    final cred = await _auth.signInAnonymously();
    return cred.user!.uid;
  }

  /// Returns the UID synchronously (null if not yet signed in).
  static String? get currentUserId => _auth.currentUser?.uid;

  // ── Display name (stored in SharedPreferences) ──────────────────────────

  static Future<String?> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDisplayNameKey);
  }

  static Future<void> saveDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDisplayNameKey, name.trim());
  }

  // ── Posts ────────────────────────────────────────────────────────────────

  /// Real-time stream of the 50 most recent posts.
  static Stream<QuerySnapshot<Map<String, dynamic>>> postsStream() {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  /// Create a new post. Ensures the user is authenticated first.
  static Future<void> createPost({
    required String username,
    required String content,
  }) async {
    final userId = await ensureUser();
    await saveDisplayName(username);
    await _posts.add({
      'userId': userId,
      'username': username.trim(),
      'content': content.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': 0,
      'likedBy': <String>[],
      'commentCount': 0,
    });
  }

  /// Toggle like for the current user on [postId].
  static Future<void> toggleLike(String postId) async {
    final userId = await ensureUser();
    final ref = _posts.doc(postId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final likedBy = List<String>.from(snap.data()?['likedBy'] ?? []);
      if (likedBy.contains(userId)) {
        tx.update(ref, {
          'likedBy': FieldValue.arrayRemove([userId]),
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        tx.update(ref, {
          'likedBy': FieldValue.arrayUnion([userId]),
          'likeCount': FieldValue.increment(1),
        });
      }
    });
  }

  /// Delete a post (only succeeds if the current user owns it).
  static Future<void> deletePost(String postId) async {
    final userId = currentUserId;
    if (userId == null) return;

    final doc = await _posts.doc(postId).get();
    if (doc.data()?['userId'] == userId) {
      await _posts.doc(postId).delete();
    }
  }

  // ── Comments / replies ───────────────────────────────────────────────────

  static CollectionReference<Map<String, dynamic>> _comments(String postId) =>
      _posts.doc(postId).collection('comments');

  /// Real-time stream of replies for a post (oldest first).
  static Stream<QuerySnapshot<Map<String, dynamic>>> commentsStream(
    String postId, {
    int limit = 50,
  }) {
    return _comments(postId)
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .snapshots();
  }

  /// Reply to a post. Increments [commentCount] on the parent.
  static Future<void> createComment({
    required String postId,
    required String username,
    required String content,
  }) async {
    final userId = await ensureUser();
    await saveDisplayName(username);

    final postRef = _posts.doc(postId);
    final commentRef = _comments(postId).doc();

    await _db.runTransaction((tx) async {
      final postSnap = await tx.get(postRef);
      if (!postSnap.exists) {
        throw Exception('La publicación ya no existe');
      }

      tx.set(commentRef, {
        'userId': userId,
        'username': username.trim(),
        'content': content.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.update(postRef, {'commentCount': FieldValue.increment(1)});
    });
  }

  /// Delete own reply and decrement comment count.
  static Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final userId = currentUserId;
    if (userId == null) return;

    final commentRef = _comments(postId).doc(commentId);
    final postRef = _posts.doc(postId);

    await _db.runTransaction((tx) async {
      final commentSnap = await tx.get(commentRef);
      if (!commentSnap.exists) return;
      if (commentSnap.data()?['userId'] != userId) return;

      tx.delete(commentRef);
      tx.update(postRef, {'commentCount': FieldValue.increment(-1)});
    });
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Human-readable relative time (in Spanish).
  static String timeAgo(Timestamp? ts) {
    if (ts == null) return 'ahora';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inSeconds < 60) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'hace ${diff.inDays}d';
    return 'hace ${(diff.inDays / 7).floor()}sem';
  }
}
