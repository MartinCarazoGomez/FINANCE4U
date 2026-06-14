import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/class_rank_entry.dart';
import '../providers/auth_provider.dart';
import '../services/class_chat_service.dart';
import '../services/class_service.dart';
import '../widgets/class_stats_panel.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  static const _green = Color(0xFF1B6B4B);
  static const _accent = Color(0xFF7ED957);

  final _messageController = TextEditingController();
  final _chatScrollController = ScrollController();

  Timer? _refreshTimer;
  Future<ClassRoomData>? _dataFuture;
  bool _sending = false;
  bool _chatExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refresh();
      _refreshTimer?.cancel();
      _refreshTimer =
          Timer.periodic(const Duration(seconds: 10), (_) => _refresh());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _refresh() {
    final auth = context.read<AuthProvider>();
    final groupId = auth.groupId;
    final uid = auth.firebaseUser?.uid;

    if (groupId == null || uid == null) {
      setState(() => _dataFuture = Future.value(ClassRoomData.empty));
      return;
    }

    setState(() {
      _dataFuture = ClassService.loadClassRoom(
        groupId: groupId,
        currentUserId: uid,
      );
    });
  }

  Future<void> _sendMessage() async {
    final auth = context.read<AuthProvider>();
    final groupId = auth.groupId;
    final uid = auth.firebaseUser?.uid;
    final username = auth.profile?.username ?? 'Usuario';
    final text = _messageController.text.trim();

    if (groupId == null || uid == null) return;
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      await ClassChatService.sendMessage(
        groupId: groupId,
        userId: uid,
        username: username,
        content: text,
      );
      _messageController.clear();
      if (mounted && !_chatExpanded) setState(() => _chatExpanded = true);
      _refresh();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo enviar el mensaje. Comprueba tu conexión.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final groupId = auth.groupId;
    final groupName = auth.profile?.groupName;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(groupName),
          Expanded(
            child: groupId == null
                ? _buildNoClassState(context)
                : FutureBuilder<ClassRoomData>(
                    future: _dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data ?? ClassRoomData.empty;
                      return Column(
                        children: [
                          Expanded(
                            child: _buildClassContent(data),
                          ),
                          _buildChatPanel(
                            data: data,
                            currentUserId: auth.firebaseUser?.uid,
                            isRefreshing: snapshot.connectionState ==
                                ConnectionState.waiting,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatPanel({
    required ClassRoomData data,
    required String? currentUserId,
    required bool isRefreshing,
  }) {
    final messageCount = data.messages.length;

    return Material(
      elevation: 6,
      shadowColor: Colors.black26,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() => _chatExpanded = !_chatExpanded);
              if (_chatExpanded) {
                Future<void>.delayed(const Duration(milliseconds: 280), () {
                  if (!mounted || !_chatScrollController.hasClients) return;
                  _chatScrollController.animateTo(
                    _chatScrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
              decoration: BoxDecoration(
                color: _chatExpanded
                    ? const Color(0xFFF0FAED)
                    : Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _chatExpanded
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline,
                    color: _green,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat de ${data.groupName ?? 'clase'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _green,
                          ),
                        ),
                        if (!_chatExpanded && messageCount > 0)
                          Text(
                            '$messageCount mensaje${messageCount == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isRefreshing)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  AnimatedRotation(
                    turns: _chatExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _chatExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.32)
                            .clamp(180.0, 320.0),
                        child: _buildChat(data.messages, currentUserId),
                      ),
                      _buildChatInput(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String? groupName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Image.asset('assets/logo.png', height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clase',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),
                if (groupName != null)
                  Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoClassState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aún no estás en una clase',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Únete con un código en tu perfil para ver el ranking y chatear con tus compañeros.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
              icon: const Icon(Icons.person),
              label: const Text('Ir al perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassContent(ClassRoomData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _green,
                ),
              ),
              const Spacer(),
              if (data.groupCode != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FCE3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.groupCode!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _green,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClassStatsPanel(stats: data.stats),
          if (data.topicCompletionCounts.isNotEmpty) ...[
            const SizedBox(height: 16),
            ClassTopicBars(
              topicCounts: data.topicCompletionCounts,
              memberCount: data.stats.memberCount,
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'Ranking de clase',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '10 pts por píldora · +10 pts al completar un tema',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: data.ranking.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Todavía no hay miembros en esta clase.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.ranking.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) => _rankTile(data.ranking[i], i),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _rankTile(ClassRankEntry entry, int index) {
    final medal = index == 0
        ? '🥇'
        : index == 1
            ? '🥈'
            : index == 2
                ? '🥉'
                : '${index + 1}.';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            entry.isCurrentUser ? _accent : Colors.grey[300],
        backgroundImage:
            entry.photoUrl != null ? NetworkImage(entry.photoUrl!) : null,
        child: entry.photoUrl == null
            ? Text(
                entry.username.isNotEmpty ? entry.username[0].toUpperCase() : '?',
                style: TextStyle(
                  color: entry.isCurrentUser ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        entry.username + (entry.isCurrentUser ? ' (Tú)' : ''),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '$medal · ${entry.pillsCompleted} píldoras · Nv.${entry.level}',
        style: const TextStyle(fontSize: 11),
      ),
      trailing: Text(
        '${entry.points} pts',
        style: const TextStyle(fontWeight: FontWeight.bold, color: _green),
      ),
      tileColor: entry.isCurrentUser ? const Color(0xFFE8FCE3) : null,
    );
  }

  Widget _buildChat(List<ClassMessage> messages, String? currentUserId) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'Sé el primero en escribir en el chat de clase.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      controller: _chatScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final msg = messages[i];
        final isMine = msg.userId == currentUserId;
        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMine ? const Color(0xFFE8FCE3) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMine)
                  Text(
                    msg.username,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _green,
                    ),
                  ),
                Text(msg.content, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  ClassChatService.timeAgo(msg.createdAt),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLength: 500,
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sending ? null : _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                counterText: '',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _sending ? null : _sendMessage,
            icon: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
