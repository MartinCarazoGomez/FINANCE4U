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
          itemBuilder: (context, i) => _PostCard(doc: docs[i]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: _green.withOpacity(0.3)),
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

class _PostCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  const _PostCard({required this.doc});

  static const _green = Color(0xFF1B6B4B);
  static const _greenLight = Color(0xFFD6F5E3);

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final postId = doc.id;
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
            color: Colors.black.withOpacity(0.05),
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
            // Header row
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

            // Content
            Text(
              content,
              style: const TextStyle(fontSize: 15, color: Color(0xFF212121), height: 1.4),
            ),

            const SizedBox(height: 14),

            // Actions row
            Row(
              children: [
                // Like button
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  iconColor: isLiked ? Colors.red[400]! : Colors.grey[500]!,
                  label: '$likeCount',
                  onTap: () => CommunityService.toggleLike(postId),
                ),
                const SizedBox(width: 20),
                // Comment count (display only for now)
                _ActionButton(
                  icon: Icons.mode_comment_outlined,
                  iconColor: Colors.grey[500]!,
                  label: '$commentCount',
                  onTap: null,
                ),
              ],
            ),
          ],
        ),
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
