import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../utils/achievements_service.dart';
import '../utils/progress_service.dart';
import '../utils/streak_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  final AchievementsService _service = AchievementsService();
  final ProgressService _progress = ProgressService();
  late TabController _tabController;

  Set<String> _unlockedIds = {};
  bool _loading = true;
  Map<String, dynamic> _enrichedProgress = {};

  static const String _prefsKey = 'unlocked_achievement_ids';
  // Bump this whenever achievement logic changes to clear stale data
  static const String _prefsVersionKey = 'unlocked_achievements_version';
  static const int _currentVersion = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Init: load persisted IDs first, then check current progress ──────────

  Future<void> _init() async {
    await _loadPersisted();
    _checkProgress();
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear stale data if the version has changed
    final savedVersion = prefs.getInt(_prefsVersionKey) ?? 0;
    if (savedVersion < _currentVersion) {
      await prefs.remove(_prefsKey);
      await prefs.setInt(_prefsVersionKey, _currentVersion);
    }
    final saved = prefs.getStringList(_prefsKey) ?? [];
    if (mounted) setState(() => _unlockedIds.addAll(saved));
  }

  Future<void> _savePersisted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _unlockedIds.toList());
  }

  void _checkProgress() {
    final app = Provider.of<AppProvider>(context, listen: false);
    StreakService().syncFromApp(
      streakDays: app.streakDays,
      lastStreakDay: app.lastStreakDay,
    );
    final p = _progress.getUserProgress();

    // Pull completed lesson titles from AppProvider for difficulty/topic checks
    final completedLessons = app.completedLessons;

    // Compute per-difficulty and per-topic counts and fold into the progress map
    final enriched = Map<String, dynamic>.from(p)
      ..['basicCompleted'] =
          AchievementsService.basicCount(completedLessons)
      ..['intermediateCompleted'] =
          AchievementsService.intermediateCount(completedLessons)
      ..['advancedCompleted'] =
          AchievementsService.advancedCount(completedLessons)
      ..['completedLessons'] = completedLessons;

    for (final topicId in AchievementsService.topicPills.keys) {
      enriched[topicId] =
          AchievementsService.topicCount(topicId, completedLessons);
    }

    // Re-compute from scratch (no time-based achievements on screen open)
    final dataUnlocked = _service.checkAchievements(
      lessonsCompleted: completedLessons.length,
      gamesCompleted: p['gamesCompleted'] ?? 0,
      currentStreak: app.streakDays,
      totalXP: app.totalXP,
      currentLevel: app.userLevel,
      studyTimeMinutes: p['totalMinutes'] ?? 0,
      completedLessons: completedLessons,
      allowTimeAchievements: false, // never grant time-based on screen open
    );

    // Data-driven IDs computed fresh; keep any persisted time-based ones
    // (night_owl, early_bird, weekend_warrior) that were legitimately earned.
    const timeBasedIds = {'night_owl', 'early_bird', 'weekend_warrior'};
    final freshDataIds = dataUnlocked.map((a) => a.id).toSet();
    final persistedTimeBased = _unlockedIds.intersection(timeBasedIds);

    // Final set = data-derived + legitimately-persisted time-based
    final validIds = {...freshDataIds, ...persistedTimeBased};
    final hasNew = !freshDataIds.every(_unlockedIds.contains);

    if (mounted) {
      setState(() {
        _unlockedIds
          ..clear()
          ..addAll(validIds);
        _loading = false;
        _enrichedProgress = enriched;
      });
    }
    if (hasNew) _savePersisted();
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final all = _service.achievements;
    final unlocked = all.where((a) => _unlockedIds.contains(a.id)).toList();
    final locked = all.where((a) => !_unlockedIds.contains(a.id)).toList();
    final pct = all.isEmpty ? 0.0 : unlocked.length / all.length * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logros',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1B6B4B),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Desbloqueados'),
            Tab(text: 'Por Desbloquear'),
          ],
        ),
      ),
      body: Column(
        children: [
          _ProgressHeader(
            unlocked: unlocked.length,
            total: all.length,
            pct: pct,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AchievementsList(
                  achievements: unlocked,
                  isUnlocked: true,
                  progress: _enrichedProgress,
                ),
                _AchievementsList(
                  achievements: locked,
                  isUnlocked: false,
                  progress: _enrichedProgress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Progress header ───────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  final int unlocked;
  final int total;
  final double pct;

  const _ProgressHeader({
    required this.unlocked,
    required this.total,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1B6B4B),
            const Color(0xFF1B6B4B).withValues(alpha: 0.82),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatCard(
                  label: 'Desbloqueados',
                  value: '$unlocked',
                  icon: Icons.emoji_events,
                  color: Colors.amber),
              _StatCard(
                  label: 'Total',
                  value: '$total',
                  icon: Icons.flag,
                  color: Colors.blue),
              _StatCard(
                  label: 'Progreso',
                  value: '${pct.round()}%',
                  icon: Icons.trending_up,
                  color: Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85))),
        ],
      ),
    );
  }
}

// ── Achievements list ─────────────────────────────────────────────────────

class _AchievementsList extends StatelessWidget {
  final List<Achievement> achievements;
  final bool isUnlocked;
  final Map<String, dynamic> progress;

  const _AchievementsList({
    required this.achievements,
    required this.isUnlocked,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? Icons.emoji_events : Icons.lock_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isUnlocked
                  ? '¡Aún no has desbloqueado ningún logro!'
                  : '¡Todos los logros desbloqueados!',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isUnlocked
                  ? 'Sigue estudiando para obtener tu primer logro'
                  : '¡Felicitaciones! Eres un maestro completo',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group by category
    final grouped = <String, List<Achievement>>{};
    for (final a in achievements) {
      grouped.putIfAbsent(a.category, () => []).add(a);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, i) {
        final category = grouped.keys.elementAt(i);
        final items = grouped[category]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B6B4B),
                ),
              ),
            ),
            ...items.map((a) =>
                _AchievementCard(a, isUnlocked: isUnlocked, progress: progress)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

// ── Achievement card ──────────────────────────────────────────────────────

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final Map<String, dynamic> progress;

  const _AchievementCard(this.achievement,
      {required this.isUnlocked, required this.progress});

  static String _fmtMin(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  int _currentValue() {
    switch (achievement.category) {
      case 'Juegos':
        return progress['gamesCompleted'] ?? 0;
      case 'Aprendizaje':
        return progress['lessonsCompleted'] ?? 0;
      case 'Rachas':
        return progress['currentStreak'] ?? 0;
      case 'Experiencia':
        return progress['totalXP'] ?? 0;
      case 'Nivel':
        return progress['currentLevel'] ?? 1;
      case 'Tiempo':
        return progress['totalMinutes'] ?? 0;
      case 'Dificultad':
        if (achievement.id.startsWith('basic')) {
          return progress['basicCompleted'] ?? 0;
        }
        if (achievement.id.startsWith('intermediate')) {
          return progress['intermediateCompleted'] ?? 0;
        }
        if (achievement.id.startsWith('advanced')) {
          return progress['advancedCompleted'] ?? 0;
        }
        return 0;
      case 'Temático':
        if (achievement.id == 'all_topics') {
          return progress['lessonsCompleted'] ?? 0;
        }
        return progress[achievement.id] ?? 0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = achievement.color;
    final cur = _currentValue();
    final showBar =
        !isUnlocked && achievement.requirement > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isUnlocked ? 8 : 2,
        shadowColor: isUnlocked ? color.withValues(alpha: 0.3) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isUnlocked
                ? color.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.1),
                      color.withValues(alpha: 0.05),
                    ],
                  )
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? color : Colors.grey[300],
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Icon(
                achievement.icon,
                color: isUnlocked ? Colors.white : Colors.grey[600],
                size: 28,
              ),
            ),
            title: Text(
              achievement.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.black87 : Colors.grey[600],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked ? Colors.black54 : Colors.grey[500],
                  ),
                ),
                if (showBar) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (cur / achievement.requirement).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 4,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.category == 'Tiempo'
                        ? '${_fmtMin(cur)} / ${_fmtMin(achievement.requirement)}'
                        : '$cur / ${achievement.requirement}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                // Show XP reward
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.bolt,
                        size: 14,
                        color: isUnlocked
                            ? Colors.amber[700]
                            : Colors.grey[400]),
                    const SizedBox(width: 2),
                    Text(
                      '+${achievement.xpReward} XP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked
                            ? Colors.amber[700]
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: isUnlocked
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✓',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                : Icon(Icons.lock_outline, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}
