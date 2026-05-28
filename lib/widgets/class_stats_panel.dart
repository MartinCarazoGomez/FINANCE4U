import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/class_rank_entry.dart';
import '../utils/achievements_service.dart';

/// Creative stats dashboard for the class tab.
class ClassStatsPanel extends StatelessWidget {
  final ClassStats stats;

  const ClassStatsPanel({
    super.key,
    required this.stats,
  });

  static const _green = Color(0xFF1B6B4B);
  static const _accent = Color(0xFF7ED957);
  static const _gold = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pulseCard(),
        if (stats.topThree.length >= 2) ...[
          const SizedBox(height: 14),
          _podium(),
        ],
        const SizedBox(height: 14),
        _metricsStrip(),
        if (stats.pillRecordHolder != null ||
            stats.streakRecordHolder != null) ...[
          const SizedBox(height: 14),
          _recordsCard(),
        ],
        if (stats.basicPills + stats.intermediatePills + stats.advancedPills >
            0) ...[
          const SizedBox(height: 14),
          _difficultyBreakdown(),
        ],
        const SizedBox(height: 14),
        _classOverviewGrid(),
        if (stats.userRank != null) ...[
          const SizedBox(height: 14),
          _yourPerformanceCard(),
        ],
        if (stats.starTopicName != null || stats.weakestTopicName != null) ...[
          const SizedBox(height: 14),
          _topicInsightsRow(),
        ],
      ],
    );
  }

  Widget _pulseCard() {
    final pillPct = (stats.pillProgress * 100).round();
    final topicPct = (stats.topicProgress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B6B4B), Color(0xFF2E8B57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: _accent, size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pulso de la clase',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stats.participationLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ringStat(
                progress: stats.pillProgress,
                label: 'Píldoras',
                value: '$pillPct%',
                color: _accent,
              ),
              const SizedBox(width: 16),
              _ringStat(
                progress: stats.topicProgress,
                label: 'Temas',
                value: '$topicPct%',
                color: const Color(0xFF4FC3F7),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.totalPoints}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const Text(
                      'pts totales',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${stats.totalPills} píldoras · ${stats.totalTopics} temas',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      '${stats.activeMembers}/${stats.memberCount} alumnos activos',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ringStat({
    required double progress,
    required String label,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _podium() {
    final top = stats.topThree;
    final first = top.isNotEmpty ? top[0] : null;
    final second = top.length > 1 ? top[1] : null;
    final third = top.length > 2 ? top[2] : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          const Text(
            'Podio de la clase',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _green,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _podiumPlace(
                  entry: second,
                  rank: 2,
                  height: 56,
                  color: const Color(0xFFB0BEC5),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _podiumPlace(
                  entry: first,
                  rank: 1,
                  height: 76,
                  color: _gold,
                  highlight: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _podiumPlace(
                  entry: third,
                  rank: 3,
                  height: 44,
                  color: const Color(0xFFCD7F32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _podiumPlace({
    required ClassRankEntry? entry,
    required int rank,
    required double height,
    required Color color,
    bool highlight = false,
  }) {
    final medal = rank == 1 ? '🥇' : rank == 2 ? '🥈' : '🥉';

    return Column(
      children: [
        if (entry != null) ...[
          CircleAvatar(
            radius: highlight ? 22 : 18,
            backgroundColor: color.withValues(alpha: 0.25),
            backgroundImage:
                entry.photoUrl != null ? NetworkImage(entry.photoUrl!) : null,
            child: entry.photoUrl == null
                ? Text(
                    entry.username.isNotEmpty
                        ? entry.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _green,
                      fontSize: highlight ? 16 : 14,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            entry.username.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: _green,
            ),
          ),
          Text(
            '${entry.points} pts',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ] else
          const SizedBox(height: 48),
        const SizedBox(height: 6),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.withValues(alpha: entry != null ? 0.85 : 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 6),
          child: Text(medal, style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _metricsStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _metricChip(
            Icons.auto_graph,
            'Media',
            '${stats.avgPoints} pts',
            const Color(0xFFCE93D8),
          ),
          _metricChip(
            Icons.menu_book_outlined,
            'Píldoras/alumno',
            '${stats.avgPills}',
            const Color(0xFF4FC3F7),
          ),
          _metricChip(
            Icons.layers_outlined,
            'Temas/alumno',
            '${stats.avgTopics}',
            const Color(0xFF81C784),
          ),
          _metricChip(
            Icons.trending_up,
            'Nivel medio',
            'Nv.${stats.avgLevel}',
            const Color(0xFF7986CB),
          ),
          _metricChip(
            Icons.local_fire_department,
            'Racha máx.',
            '${stats.maxStreak} d',
            const Color(0xFFFF7043),
          ),
          _metricChip(
            Icons.chat_bubble_outline,
            'Chat',
            '${stats.chatMessages}',
            const Color(0xFFFFB74D),
          ),
          _metricChip(
            Icons.person_off_outlined,
            'Inactivos',
            '${stats.idleMembers}',
            const Color(0xFF90A4AE),
          ),
          _metricChip(
            Icons.emoji_events_outlined,
            'Temas 100%',
            '${stats.topicsMasteredCount}',
            const Color(0xFFFFD54F),
          ),
          _metricChip(
            Icons.leaderboard_outlined,
            'Sobre media',
            '${stats.membersAboveAverage}',
            const Color(0xFF26A69A),
          ),
          _metricChip(
            Icons.whatshot_outlined,
            'Racha media',
            '${stats.avgStreak} d',
            const Color(0xFFEF5350),
          ),
          _metricChip(
            Icons.forum_outlined,
            'En el chat',
            '${stats.chatAuthors}',
            const Color(0xFF9575CD),
          ),
        ],
      ),
    );
  }

  Widget _metricChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color.withValues(alpha: 0.95),
                  height: 1,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recordsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.military_tech, color: _gold, size: 20),
              SizedBox(width: 8),
              Text(
                'Récords de la clase',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _green,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (stats.pillRecordHolder != null)
                Expanded(
                  child: _recordTile(
                    icon: Icons.menu_book,
                    color: const Color(0xFF4FC3F7),
                    label: 'Más píldoras',
                    name: stats.pillRecordHolder!.username.split(' ').first,
                    value: '${stats.maxPillsSingle}',
                  ),
                ),
              if (stats.pillRecordHolder != null &&
                  stats.streakRecordHolder != null)
                const SizedBox(width: 8),
              if (stats.streakRecordHolder != null)
                Expanded(
                  child: _recordTile(
                    icon: Icons.local_fire_department,
                    color: const Color(0xFFFF7043),
                    label: 'Mejor racha',
                    name: stats.streakRecordHolder!.username.split(' ').first,
                    value: '${stats.streakRecordHolder!.streakDays} d',
                  ),
                ),
              if (stats.streakRecordHolder != null &&
                  stats.topicRecordHolder != null)
                const SizedBox(width: 8),
              if (stats.topicRecordHolder != null &&
                  stats.maxTopicsSingle > 0)
                Expanded(
                  child: _recordTile(
                    icon: Icons.layers,
                    color: const Color(0xFF81C784),
                    label: 'Más temas',
                    name: stats.topicRecordHolder!.username.split(' ').first,
                    value: '${stats.maxTopicsSingle}',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recordTile({
    required IconData icon,
    required Color color,
    required String label,
    required String name,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color.withValues(alpha: 0.95),
              height: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _green,
            ),
          ),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _difficultyBreakdown() {
    final total =
        stats.basicPills + stats.intermediatePills + stats.advancedPills;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: _green, size: 20),
              SizedBox(width: 8),
              Text(
                'Píldoras por dificultad',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _green,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$total completadas en total por la clase',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          _difficultyRow(
            'Básico',
            stats.basicPills,
            total,
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 8),
          _difficultyRow(
            'Intermedio',
            stats.intermediatePills,
            total,
            const Color(0xFFFF9800),
          ),
          const SizedBox(height: 8),
          _difficultyRow(
            'Avanzado',
            stats.advancedPills,
            total,
            const Color(0xFFE53935),
          ),
        ],
      ),
    );
  }

  Widget _difficultyRow(
    String label,
    int count,
    int total,
    Color color,
  ) {
    final frac = count / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              '$count (${(frac * 100).round()}%)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: frac.clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _classOverviewGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Panorama de la clase',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _green,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = (constraints.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _overviewTile(
                  width: w,
                  icon: Icons.groups_2_outlined,
                  color: const Color(0xFF26A69A),
                  value: '${stats.membersWithFullTopic}/${stats.memberCount}',
                  label: 'Con un tema hecho',
                ),
                _overviewTile(
                  width: w,
                  icon: Icons.flag_outlined,
                  color: const Color(0xFF5C6BC0),
                  value: '${stats.membersWithHalfPills}/${stats.memberCount}',
                  label: 'Con +50% píldoras',
                ),
                _overviewTile(
                  width: w,
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF66BB6A),
                  value: '${stats.topicsMasteredCount}',
                  label: 'Temas al 100% grupal',
                ),
                _overviewTile(
                  width: w,
                  icon: Icons.timeline,
                  color: const Color(0xFFAB47BC),
                  value: '${stats.topicsInProgressCount}',
                  label: 'Temas en progreso',
                ),
                _overviewTile(
                  width: w,
                  icon: Icons.swap_vert,
                  color: const Color(0xFF78909C),
                  value: '${stats.pointsSpread} pts',
                  label: 'Brecha líder–último',
                ),
                _overviewTile(
                  width: w,
                  icon: Icons.percent,
                  color: const Color(0xFF29B6F6),
                  value: '${(stats.participationRate * 100).round()}%',
                  label: 'Participación activa',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _overviewTile({
    required double width,
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color.withValues(alpha: 0.95),
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _yourPerformanceCard() {
    final rank = stats.userRank!;
    final isLeader = rank == 1;
    final pillVsAvg = stats.avgPills > 0
        ? (stats.userPills / stats.avgPills).clamp(0.0, 2.0)
        : 0.0;
    final ptsVsAvg = stats.avgPoints > 0
        ? (stats.userPoints / stats.avgPoints).clamp(0.0, 2.0)
        : 0.0;

    String subtitle;
    if (isLeader) {
      subtitle = '¡Lideras la clase! Sigue así.';
    } else if (stats.pointsToNextRank != null) {
      subtitle =
          'Te faltan ${stats.pointsToNextRank} pts para subir al #${rank - 1}';
    } else {
      subtitle = 'Top ${stats.userPercentile}% de la clase';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FCE3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _rankBadge(rank),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu rendimiento',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _green,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${stats.userPoints}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _green,
                    ),
                  ),
                  Text(
                    '${stats.userPills} píld. · ${stats.userTopics} temas',
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  ),
                  Text(
                    'Nv.${stats.userLevel} · ${stats.userStreak} d racha',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _compareBar(
            label: 'Píldoras vs media (${stats.avgPills})',
            fraction: pillVsAvg / 2,
            userValue: stats.userPills,
            color: const Color(0xFF4FC3F7),
          ),
          const SizedBox(height: 8),
          _compareBar(
            label: 'Puntos vs media (${stats.avgPoints})',
            fraction: ptsVsAvg / 2,
            userValue: stats.userPoints,
            color: _accent,
          ),
          if (stats.avgStreak > 0) ...[
            const SizedBox(height: 8),
            _compareBar(
              label: 'Racha vs media (${stats.avgStreak} d)',
              fraction: (stats.userStreak / stats.avgStreak).clamp(0.0, 2.0) / 2,
              userValue: stats.userStreak,
              color: const Color(0xFFFF7043),
            ),
          ],
          if (!isLeader && stats.pointsToLeader > 0) ...[
            const SizedBox(height: 10),
            Text(
              'Distancia al líder: ${stats.pointsToLeader} pts',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _compareBar({
    required String label,
    required double fraction,
    required int userValue,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: _green),
              ),
            ),
            Text(
              '$userValue',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.05, 1.0),
            minHeight: 7,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _topicInsightsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stats.starTopicName != null)
          Expanded(
            child: _insightTile(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFF1976D2),
              bg: const Color(0xFFE3F2FD),
              title: 'Tema estrella',
              topic: stats.starTopicName!,
              detail:
                  '${stats.starTopicCompletions}/${stats.memberCount} alumnos',
            ),
          ),
        if (stats.starTopicName != null && stats.weakestTopicName != null)
          const SizedBox(width: 10),
        if (stats.weakestTopicName != null &&
            stats.weakestTopicId != stats.starTopicId)
          Expanded(
            child: _insightTile(
              icon: Icons.lightbulb_outline,
              iconColor: const Color(0xFFE65100),
              bg: const Color(0xFFFFF3E0),
              title: 'Por reforzar',
              topic: stats.weakestTopicName!,
              detail:
                  'Solo ${stats.weakestTopicCompletions}/${stats.memberCount} lo completaron',
            ),
          ),
      ],
    );
  }

  Widget _insightTile({
    required IconData icon,
    required Color iconColor,
    required Color bg,
    required String title,
    required String topic,
    required String detail,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            topic,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: _green,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: TextStyle(fontSize: 10, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _rankBadge(int rank) {
    final emoji = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : rank == 3
                ? '🥉'
                : null;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.15),
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: emoji != null
          ? Text(emoji, style: const TextStyle(fontSize: 22))
          : Text(
              '#$rank',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: _green,
                fontSize: 13,
              ),
            ),
    );
  }
}

/// Topic completion bars with class-wide percentages.
class ClassTopicBars extends StatelessWidget {
  final Map<String, int> topicCounts;
  final int memberCount;
  final int maxBars;

  const ClassTopicBars({
    super.key,
    required this.topicCounts,
    this.memberCount = 1,
    this.maxBars = 5,
  });

  static const _green = Color(0xFF1B6B4B);

  @override
  Widget build(BuildContext context) {
    if (topicCounts.isEmpty) return const SizedBox.shrink();

    final sorted = topicCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(maxBars).toList();
    final members = memberCount.clamp(1, 999);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: _green, size: 20),
              SizedBox(width: 8),
              Text(
                'Progreso por tema',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Cuántos alumnos completaron cada tema al 100%',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          ...top.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            final name =
                AchievementsService.topicDisplayNames[e.key] ?? e.key;
            final pct = (e.value / members * 100).round();
            final frac = e.value / members;
            final barColor = Color.lerp(
              const Color(0xFF7ED957),
              const Color(0xFF1B6B4B),
              i / math.max(top.length - 1, 1),
            )!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${e.value}/$members',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: barColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$pct%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: barColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: frac.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
