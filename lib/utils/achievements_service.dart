import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int requirement;
  final String category;
  final int xpReward;
  
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.requirement,
    required this.category,
    required this.xpReward,
  });
}

class AchievementsService {
  static final AchievementsService _instance = AchievementsService._internal();
  factory AchievementsService() => _instance;
  AchievementsService._internal();

  static const List<Achievement> _achievements = [
    Achievement(
      id: 'first_game',
      title: 'Primer Juego',
      description: 'Completa tu primer juego',
      icon: Icons.games,
      color: Colors.green,
      requirement: 1,
      category: 'games',
      xpReward: 50,
    ),
    Achievement(
      id: 'perfect_score',
      title: 'Puntuación Perfecta',
      description: 'Obtén 100% en un juego',
      icon: Icons.star,
      color: Colors.yellow,
      requirement: 1,
      category: 'games',
      xpReward: 100,
    ),
    Achievement(
      id: 'game_master',
      title: 'Maestro de Juegos',
      description: 'Completa 15 juegos',
      icon: Icons.emoji_events,
      color: Colors.amber,
      requirement: 15,
      category: 'games',
      xpReward: 500,
    ),
    
    // Logros de Aprendizaje
    Achievement(
      id: 'first_lesson',
      title: '¡Primer Paso!',
      description: 'Completa tu primera lección',
      icon: Icons.school,
      color: Colors.blue,
      requirement: 1,
      category: 'Aprendizaje',
      xpReward: 25,
    ),
    Achievement(
      id: 'lesson_master',
      title: 'Maestro del Conocimiento',
      description: 'Completa 10 lecciones',
      icon: Icons.book,
      color: Colors.purple,
      requirement: 10,
      category: 'Aprendizaje',
      xpReward: 200,
    ),
    Achievement(
      id: 'finance_guru',
      title: 'Gurú Financiero',
      description: 'Completa 25 lecciones',
      icon: Icons.psychology,
      color: Colors.orange,
      requirement: 25,
      category: 'Aprendizaje',
      xpReward: 500,
    ),
    
    // Logros de Rachas
    Achievement(
      id: 'streak_3',
      title: 'Constancia',
      description: 'Mantén una racha de 3 días',
      icon: Icons.local_fire_department,
      color: Colors.red,
      requirement: 3,
      category: 'Rachas',
      xpReward: 100,
    ),
    Achievement(
      id: 'streak_7',
      title: 'Dedicación',
      description: 'Mantén una racha de 7 días',
      icon: Icons.whatshot,
      color: Colors.deepOrange,
      requirement: 7,
      category: 'Rachas',
      xpReward: 250,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Leyenda Financiera',
      description: 'Mantén una racha de 30 días',
      icon: Icons.diamond,
      color: Colors.cyan,
      requirement: 30,
      category: 'Rachas',
      xpReward: 1000,
    ),
    
    // Logros de XP
    Achievement(
      id: 'xp_1000',
      title: 'Aprendiz Financiero',
      description: 'Alcanza 1,000 XP',
      icon: Icons.trending_up,
      color: Colors.teal,
      requirement: 1000,
      category: 'Experiencia',
      xpReward: 100,
    ),
    Achievement(
      id: 'xp_5000',
      title: 'Experto en Finanzas',
      description: 'Alcanza 5,000 XP',
      icon: Icons.auto_graph,
      color: Colors.indigo,
      requirement: 5000,
      category: 'Experiencia',
      xpReward: 500,
    ),
    Achievement(
      id: 'xp_10000',
      title: 'Millonario en Conocimiento',
      description: 'Alcanza 10,000 XP',
      icon: Icons.military_tech,
      color: Colors.pink,
      requirement: 10000,
      category: 'Experiencia',
      xpReward: 1000,
    ),
    
    // Logros Especiales
    Achievement(
      id: 'night_owl',
      title: 'Búho Nocturno',
      description: 'Estudia después de las 10 PM',
      icon: Icons.nights_stay,
      color: Colors.deepPurple,
      requirement: 1,
      category: 'Especiales',
      xpReward: 50,
    ),
    Achievement(
      id: 'early_bird',
      title: 'Madrugador',
      description: 'Estudia antes de las 7 AM',
      icon: Icons.wb_sunny,
      color: Colors.yellow,
      requirement: 1,
      category: 'Especiales',
      xpReward: 50,
    ),
    Achievement(
      id: 'weekend_warrior',
      title: 'Guerrero de Fin de Semana',
      description: 'Estudia durante el fin de semana',
      icon: Icons.weekend,
      color: Colors.brown,
      requirement: 1,
      category: 'Especiales',
      xpReward: 75,
    ),
  ];

  List<Achievement> get achievements => _achievements;

  int get totalAchievements => _achievements.length;

  // Returns the list of achievements that should be unlocked based on progress
  List<Achievement> checkAchievements({
    int? gamesCompleted,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    bool? isPerfectScore,
    int? lessonsCompleted,
  }) {
    List<Achievement> newlyUnlocked = [];

    for (var achievement in _achievements) {
      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_game':
        case 'game_master':
          shouldUnlock = gamesCompleted != null && gamesCompleted >= achievement.requirement;
          break;
        case 'perfect_score':
          shouldUnlock = isPerfectScore == true;
          break;
        case 'first_lesson':
        case 'lesson_master':
        case 'finance_guru':
          shouldUnlock = lessonsCompleted != null && lessonsCompleted >= achievement.requirement;
          break;
        case 'streak_3':
        case 'streak_7':
        case 'streak_30':
          shouldUnlock = currentStreak != null && currentStreak >= achievement.requirement;
          break;
        case 'xp_1000':
        case 'xp_5000':
        case 'xp_10000':
          shouldUnlock = totalXP != null && totalXP >= achievement.requirement;
          break;
        case 'night_owl':
        case 'early_bird':
        case 'weekend_warrior':
          shouldUnlock = false; // Special handling elsewhere
          break;
      }

      if (shouldUnlock) {
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  // Obtener logros por categoría
  List<Achievement> getAchievementsByCategory(String category) {
    return _achievements.where((a) => a.category == category).toList();
  }

  // Obtener todas las categorías
  List<String> get categories {
    return _achievements.map((a) => a.category).toSet().toList();
  }

  // Verificar si es momento especial del día
  bool get isNightTime {
    final now = DateTime.now();
    return now.hour >= 22 || now.hour < 6;
  }

  bool get isEarlyMorning {
    final now = DateTime.now();
    return now.hour >= 5 && now.hour < 7;
  }

  bool get isWeekend {
    final now = DateTime.now();
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }
} 