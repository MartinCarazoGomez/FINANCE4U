import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<_ForumPostData> _posts = [
    _ForumPostData(
      user: 'María G.',
      time: 'hace 1h',
      content: '¿Cuáles son buenas estrategias para pagar deudas de tarjeta de crédito?',
      likes: 15,
      comments: 7,
    ),
    _ForumPostData(
      user: 'David W.',
      time: 'hace 5h',
      content: 'Quiero invertir en acciones por primera vez. ¿Algún consejo para principiantes?',
      likes: 8,
      comments: 12,
    ),
    _ForumPostData(
      user: 'Emilia R.',
      time: 'hace 8h',
      content: 'La regla 50/30/20 me ha ayudado a gestionar mi presupuesto. ¿La usas tú?',
      likes: 10,
      comments: 3,
    ),
  ];

  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  void _addPost() {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();
    if (name.isEmpty || message.isEmpty) return;
    setState(() {
      _posts.insert(
        0,
        _ForumPostData(
          user: name,
          time: 'ahora',
          content: message,
          likes: 0,
          comments: 0,
        ),
      );
      _nameController.clear();
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Image.asset('assets/logo.png', height: 40),
                const SizedBox(width: 12),
                const Text(
                  'Comunidad',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B6B4B),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('¡Publica tu mensaje!', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Tu nombre',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: '¿Qué quieres compartir?',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6B4B),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _addPost,
                    child: const Text('Publicar'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: _posts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final post = _posts[index];
                return _ForumPost(
                  user: post.user,
                  time: post.time,
                  content: post.content,
                  likes: post.likes,
                  comments: post.comments,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class _ForumPostData {
  final String user;
  final String time;
  final String content;
  final int likes;
  final int comments;
  
  _ForumPostData({
    required this.user,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
  });
}

class _ForumPost extends StatelessWidget {
  final String user;
  final String time;
  final String content;
  final int likes;
  final int comments;

  const _ForumPost({
    required this.user,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFD6F5E3),
                  child: Icon(Icons.person, color: Color(0xFF1B6B4B)),
                ),
                const SizedBox(width: 12),
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B6B4B),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 18, color: Color(0xFF1B6B4B)),
                const SizedBox(width: 4),
                Text('$likes'),
                const SizedBox(width: 16),
                const Icon(Icons.mode_comment_outlined, size: 18, color: Color(0xFF1B6B4B)),
                const SizedBox(width: 4),
                Text('$comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 