import 'package:flutter/material.dart';
import '../utils/progress_service.dart';
import '../utils/achievements_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  final AchievementsService _achievementsService = AchievementsService();
  late TabController _tabController;
  // In-memory unlocked achievement IDs for demo; replace with provider/state as needed
  Set<String> unlockedAchievementIds = <String>{};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estadísticas',
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
            Tab(text: 'General'),
            Tab(text: 'Progreso'),
            Tab(text: 'Actividad'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildProgressTab(),
          _buildActivityTab(),
        ],
      ),
    );
  }
  
  Widget _buildGeneralTab() {
    final progress = _progressService.getUserProgress();
    final totalXP = progress['totalXP'] ?? 0;
    final currentLevel = _progressService.getCurrentLevel();
    final xpForNextLevel = _progressService.getXPForNextLevel();
    final currentLevelXP = _progressService.getCurrentLevelXP();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildLevelCard(currentLevel, currentLevelXP, xpForNextLevel, totalXP),
          const SizedBox(height: 16),
          _buildStatsGrid(progress),
          const SizedBox(height: 16),
          _buildAchievementsOverview(),
        ],
      ),
    );
  }
  
  Widget _buildProgressTab() {
    final progress = _progressService.getUserProgress();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressCard('Lecciones Completadas', progress['lessonsCompleted'] ?? 0, 30, Icons.school, Colors.blue),
          const SizedBox(height: 16),
          _buildProgressCard('Juegos Completados', progress['gamesCompleted'] ?? 0, 20, Icons.games, Colors.green),
          const SizedBox(height: 16),
          _buildProgressCard('Juegos Jugados', progress['gamesPlayed'] ?? 0, 50, Icons.videogame_asset, Colors.purple),
          const SizedBox(height: 16),
          _buildStreakCard(progress['currentStreak'] ?? 0, progress['maxStreak'] ?? 0),
          const SizedBox(height: 16),
          _buildXPBreakdown(progress),
        ],
      ),
    );
  }
  
  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWeeklyActivity(),
          const SizedBox(height: 16),
          _buildDailyGoals(),
          const SizedBox(height: 16),
          _buildRecentAchievements(),
        ],
      ),
    );
  }
  
  Widget _buildLevelCard(int level, int currentXP, int nextLevelXP, int totalXP) {
    final progress = currentXP / nextLevelXP;
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B6B4B), Color(0xFF7ED957)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nivel Actual',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.military_tech,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso al Nivel ${level + 1}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$currentXP / $nextLevelXP XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'XP Total: $totalXP',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsGrid(Map<String, dynamic> progress) {
    final stats = [
      StatItem('Días Activos', '${progress['daysActive'] ?? 7}', Icons.calendar_today, Colors.blue),
      StatItem('Tiempo Total', '${progress['totalMinutes'] ?? 120} min', Icons.timer, Colors.orange),
      StatItem('Precisión', '${progress['accuracy'] ?? 85}%', Icons.track_changes, Colors.green),
      StatItem('Racha Actual', '${progress['currentStreak'] ?? 3} días', Icons.local_fire_department, Colors.red),
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: stat.color.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(stat.icon, color: stat.color, size: 32),
                const SizedBox(height: 8),
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: stat.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAchievementsOverview() {
    final allAchievements = _achievementsService.achievements;
    final unlockedCount = unlockedAchievementIds.length;
    final totalCount = allAchievements.length;
    final percentage = totalCount == 0 ? 0 : (unlockedCount / totalCount) * 100;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Logros',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$unlockedCount/$totalCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.round()}% completado',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressCard(String title, int current, int total, IconData icon, Color color) {
    final progress = current / total;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$current/$total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).clamp(0, 100).round()}% completado',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStreakCard(int currentStreak, int maxStreak) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.withOpacity(0.1),
              Colors.red.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.red, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      '$currentStreak',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      'Racha Actual',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey[300],
                ),
                Column(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      '$maxStreak',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const Text(
                      'Mejor Racha',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildXPBreakdown(Map<String, dynamic> progress) {
    final xpSources = [
      XPSource('Lecciones', (progress['lessonsCompleted'] ?? 0) * 50, Colors.blue),
      XPSource('Juegos', (progress['gamesCompleted'] ?? 0) * 100, Colors.green),
      XPSource('Bonificaciones', progress['bonusXP'] ?? 200, Colors.orange),
    ];
    
    final totalXP = xpSources.fold(0, (sum, source) => sum + source.xp);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribución de XP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...xpSources.map((source) => _buildXPSourceRow(source, totalXP)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildXPSourceRow(XPSource source, int totalXP) {
    final percentage = totalXP > 0 ? (source.xp / totalXP) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                source.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${source.xp} XP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: source.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(source.color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeeklyActivity() {
    // Simular datos de actividad semanal
    final weeklyData = [
      DayActivity('L', 2, Colors.green),
      DayActivity('M', 3, Colors.green),
      DayActivity('X', 1, Colors.orange),
      DayActivity('J', 4, Colors.green),
      DayActivity('V', 0, Colors.grey),
      DayActivity('S', 2, Colors.green),
      DayActivity('D', 3, Colors.green),
    ];
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actividad Semanal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weeklyData.map((day) => _buildDayColumn(day)).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDayColumn(DayActivity day) {
    return Column(
      children: [
        Text(
          day.day,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 60,
          decoration: BoxDecoration(
            color: day.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 32,
                height: (day.sessions * 12.0).clamp(4.0, 60.0),
                decoration: BoxDecoration(
                  color: day.color,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${day.sessions}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: day.color,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDailyGoals() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Objetivos Diarios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalRow('Completar 1 lección', true, Colors.green),
            _buildGoalRow('Jugar 2 juegos', true, Colors.blue),
            _buildGoalRow('Obtener 200 XP', false, Colors.orange),
            _buildGoalRow('Mantener racha', true, Colors.red),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGoalRow(String goal, bool completed, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? color : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            goal,
            style: TextStyle(
              fontSize: 14,
              color: completed ? Colors.black87 : Colors.grey,
              decoration: completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentAchievements() {
    final allAchievements = _achievementsService.achievements;
    final recentAchievements = allAchievements.where((a) => unlockedAchievementIds.contains(a.id)).take(3).toList();
    
    if (recentAchievements.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logros Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recentAchievements.map((achievement) => _buildRecentAchievementRow(achievement)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentAchievementRow(Achievement achievement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color: achievement.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.amber, size: 16),
        ],
      ),
    );
  }
}

class StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  
  StatItem(this.label, this.value, this.icon, this.color);
}

class XPSource {
  final String name;
  final int xp;
  final Color color;
  
  XPSource(this.name, this.xp, this.color);
}

class DayActivity {
  final String day;
  final int sessions;
  final Color color;
  
  DayActivity(this.day, this.sessions, this.color);
} 