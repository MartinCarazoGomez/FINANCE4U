import 'package:flutter/material.dart';
import '../utils/achievements_service.dart';
import '../utils/progress_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with TickerProviderStateMixin {
  final AchievementsService _achievementsService = AchievementsService();
  final ProgressService _progressService = ProgressService();
  late TabController _tabController;
  // In-memory unlocked achievement IDs for demo; replace with provider/state as needed
  Set<String> unlockedAchievementIds = <String>{};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkAndUpdateAchievements();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _checkAndUpdateAchievements() {
    final progress = _progressService.getUserProgress();
    final newlyUnlocked = _achievementsService.checkAchievements(
      lessonsCompleted: progress['lessonsCompleted'] ?? 0,
      gamesCompleted: progress['gamesCompleted'] ?? 0,
      currentStreak: progress['currentStreak'] ?? 0,
      totalXP: progress['totalXP'] ?? 0,
    );
    setState(() {
      unlockedAchievementIds.addAll(newlyUnlocked.map((a) => a.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAchievements = _achievementsService.achievements;
    final unlocked = allAchievements.where((a) => unlockedAchievementIds.contains(a.id)).toList();
    final locked = allAchievements.where((a) => !unlockedAchievementIds.contains(a.id)).toList();
    final unlockedCount = unlocked.length;
    final totalCount = allAchievements.length;
    final completionPercentage = totalCount == 0 ? 0.0 : (unlockedCount / totalCount) * 100.0;

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
          _buildProgressHeader(unlockedCount, totalCount, completionPercentage),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementsList(unlocked, true),
                _buildAchievementsList(locked, false),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressHeader(int unlockedCount, int totalCount, double completionPercentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1B6B4B),
            const Color(0xFF1B6B4B).withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                'Desbloqueados',
                '$unlockedCount',
                Icons.emoji_events,
                Colors.amber,
              ),
              _buildStatCard(
                'Total',
                '$totalCount',
                Icons.flag,
                Colors.blue,
              ),
              _buildStatCard(
                'Progreso',
                '${completionPercentage.round()}%',
                Icons.trending_up,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completionPercentage / 100.0,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAchievementsList(List<Achievement> achievements, bool isUnlocked) {
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
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isUnlocked
                  ? 'Sigue estudiando para obtener tu primer logro'
                  : '¡Felicitaciones! Eres un maestro completo',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // Agrupar por categoría
    Map<String, List<Achievement>> groupedAchievements = {};
    for (var achievement in achievements) {
      if (!groupedAchievements.containsKey(achievement.category)) {
        groupedAchievements[achievement.category] = [];
      }
      groupedAchievements[achievement.category]!.add(achievement);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedAchievements.keys.length,
      itemBuilder: (context, index) {
        final category = groupedAchievements.keys.elementAt(index);
        final categoryAchievements = groupedAchievements[category]!;
        
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
            ...categoryAchievements.map((achievement) => 
              _buildAchievementCard(achievement, isUnlocked)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
  
  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isUnlocked ? 8 : 2,
        shadowColor: isUnlocked ? achievement.color.withOpacity(0.3) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isUnlocked 
                ? achievement.color.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
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
                      achievement.color.withOpacity(0.1),
                      achievement.color.withOpacity(0.05),
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
                color: isUnlocked 
                    ? achievement.color
                    : Colors.grey[300],
                boxShadow: isUnlocked ? [
                  BoxShadow(
                    color: achievement.color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ] : null,
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
                if (!isUnlocked && achievement.requirement > 1) ...[
                  const SizedBox(height: 8),
                  _buildProgressIndicator(achievement),
                ],
              ],
            ),
            trailing: isUnlocked 
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: achievement.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✓',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Icon(
                    Icons.lock_outline,
                    color: Colors.grey[400],
                  ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator(Achievement achievement) {
    final progress = _progressService.getUserProgress();
    int currentValue = 0;
    
    switch (achievement.category) {
      case 'Aprendizaje':
        currentValue = progress['lessonsCompleted'] ?? 0;
        break;
      case 'Juegos':
        currentValue = progress['gamesCompleted'] ?? 0;
        break;
      case 'Rachas':
        currentValue = progress['currentStreak'] ?? 0;
        break;
      case 'Experiencia':
        currentValue = progress['totalXP'] ?? 0;
        break;
      default:
        currentValue = 0;
    }
    
    final progressValue = (currentValue / achievement.requirement).clamp(0.0, 1.0);
    
    return Column(
      children: [
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
          minHeight: 4,
        ),
        const SizedBox(height: 4),
        Text(
          '$currentValue / ${achievement.requirement}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 