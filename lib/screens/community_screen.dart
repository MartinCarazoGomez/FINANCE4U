import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/community_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  final _messageFocus = FocusNode();

  bool _posting = false;
  bool _initialized = false;

  static const _green = Color(0xFF1B6B4B);

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    final name = await CommunityService.getDisplayName();
    if (mounted && name != null) {
      _nameController.text = name;
    }
    // Ensure anonymous auth is ready before first interaction
    await CommunityService.ensureUser();
    if (mounted) setState(() => _initialized = true);
  }

  Future<void> _submitPost() async {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty) {
      _showSnack('Por favor, escribe tu nombre.');
      return;
    }
    if (message.isEmpty) {
      _showSnack('El mensaje no puede estar vacío.');
      return;
    }

    setState(() => _posting = true);
    try {
      await CommunityService.createPost(username: name, content: message);
      _messageController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      _showSnack('Error al publicar. Comprueba tu conexión.');
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildPostForm(),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(child: _buildFeed()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Image.asset('assets/logo.png', height: 40),
          const SizedBox(width: 12),
          const Text(
            'Comunidad',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _green,
            ),
          ),
          const Spacer(),
          if (_initialized)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¡Comparte tu experiencia!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _green,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration('Tu nombre', Icons.person_outline),
            onSubmitted: (_) => _messageFocus.requestFocus(),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            focusNode: _messageFocus,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(
              '¿Qué quieres compartir sobre finanzas?',
              Icons.edit_outlined,
            ),
            minLines: 2,
            maxLines: 4,
            maxLength: 280,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _posting ? null : _submitPost,
              icon: _posting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, size: 18),
              label: Text(_posting ? 'Publicando…' : 'Publicar'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: _green, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _green, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: true,
      counterStyle: const TextStyle(fontSize: 11),
    );
  }

  Widget _buildFeed() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: CommunityService.postsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildFeedError(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _green));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _PostCard(
            doc: docs[i],
            defaultUsername: _nameController.text.trim(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: _green.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text(
            '¡Sé el primero en publicar!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comparte tus dudas y consejos\nde finanzas con la comunidad.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No se pudo cargar la comunidad',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Comprueba tu conexión a internet.',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Post card ──────────────────────────────────────────────────────────────

class _PostCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final String defaultUsername;

  const _PostCard({
    required this.doc,
    required this.defaultUsername,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  static const _green = Color(0xFF1B6B4B);
  static const _greenLight = Color(0xFFD6F5E3);

  bool _showReplies = false;
  bool _replying = false;
  final _replyController = TextEditingController();
  final _replyFocus = FocusNode();

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocus.dispose();
    super.dispose();
  }

  String get postId => widget.doc.id;

  Map<String, dynamic> get data => widget.doc.data();

  Future<void> _submitReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    var username = widget.defaultUsername;
    if (username.isEmpty) {
      username = await CommunityService.getDisplayName() ?? '';
    }
    if (username.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Escribe tu nombre arriba antes de responder.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() => _replying = true);
    try {
      await CommunityService.createComment(
        postId: postId,
        username: username,
        content: content,
      );
      _replyController.clear();
      if (!_showReplies) setState(() => _showReplies = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo enviar la respuesta.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _replying = false);
    }
  }

  void _toggleReplies() {
    setState(() => _showReplies = !_showReplies);
    if (_showReplies) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _replyFocus.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = data['username'] as String? ?? 'Anónimo';
    final content = data['content'] as String? ?? '';
    final likeCount = (data['likeCount'] as num?)?.toInt() ?? 0;
    final likedBy = List<String>.from(data['likedBy'] ?? []);
    final commentCount = (data['commentCount'] as num?)?.toInt() ?? 0;
    final ts = data['createdAt'] as Timestamp?;
    final timeStr = CommunityService.timeAgo(ts);
    final currentUid = CommunityService.currentUserId;
    final isLiked = currentUid != null && likedBy.contains(currentUid);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _greenLight,
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: _green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: _green,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF212121),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  iconColor: isLiked ? Colors.red[400]! : Colors.grey[500]!,
                  label: '$likeCount',
                  onTap: () => CommunityService.toggleLike(postId),
                ),
                const SizedBox(width: 20),
                _ActionButton(
                  icon: _showReplies
                      ? Icons.mode_comment
                      : Icons.mode_comment_outlined,
                  iconColor: _showReplies ? _green : Colors.grey[500]!,
                  label: commentCount > 0 ? '$commentCount' : 'Responder',
                  onTap: _toggleReplies,
                ),
              ],
            ),
            if (_showReplies) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _RepliesList(postId: postId),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      focusNode: _replyFocus,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 280,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Escribe una respuesta…',
                        isDense: true,
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _green, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        counterText: '',
                      ),
                      onSubmitted: (_) => _replying ? null : _submitReply(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _replying ? null : _submitReply,
                    icon: _replying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RepliesList extends StatelessWidget {
  final String postId;

  const _RepliesList({required this.postId});

  static const _green = Color(0xFF1B6B4B);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: CommunityService.commentsStream(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: _green),
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Aún no hay respuestas. ¡Sé el primero!',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          );
        }

        return Column(
          children: docs.map((doc) => _ReplyTile(doc: doc, postId: postId)).toList(),
        );
      },
    );
  }
}

class _ReplyTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final String postId;

  const _ReplyTile({required this.doc, required this.postId});

  static const _green = Color(0xFF1B6B4B);

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final username = data['username'] as String? ?? 'Anónimo';
    final content = data['content'] as String? ?? '';
    final userId = data['userId'] as String? ?? '';
    final ts = data['createdAt'] as Timestamp?;
    final timeStr = CommunityService.timeAgo(ts);
    final isMine = CommunityService.currentUserId == userId;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: _green,
                  ),
                ),
              ),
              Text(
                timeStr,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              if (isMine) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => CommunityService.deleteComment(
                    postId: postId,
                    commentId: doc.id,
                  ),
                  child: Icon(Icons.close, size: 16, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
