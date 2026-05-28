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

  // ── Pill difficulty lookup (title → 1/2/3) ─────────────────────────────
  static const Map<String, int> pillDifficulty = {
    // Ahorros
    'Regla 50/30/20': 1,
    'Fondo de emergencia': 1,
    'Ahorro automático': 2,
    'Evita gastos hormiga': 2,
    'Reto de 30 días': 3,
    // Impuestos
    '¿Qué son los impuestos?': 1,
    'IRPF: El impuesto principal': 2,
    'Seguridad Social': 2,
    'IVA: El impuesto invisible': 2,
    'Ejemplo completo: ¿Cuánto se lleva el Estado?': 3,
    // Inversiones
    '¿Qué es invertir?': 1,
    'Diversificación': 1,
    'Riesgo y rentabilidad': 2,
    'Invierte a largo plazo': 2,
    'Fondos de inversión': 2,
    'Cómo crean dinero los bancos': 2,
    'Planes de pensiones': 3,
    'FOREX y cobertura cambiaria': 3,
    'Simula una inversión': 3,
    // Presupuesto
    '¿Qué es un presupuesto?': 1,
    'Registra tus gastos': 1,
    'Prioriza necesidades': 2,
    'Ajusta tu presupuesto': 2,
    'Crea tu presupuesto': 3,
    // Emprendimiento
    '¿Qué es emprender?': 1,
    'Detecta oportunidades': 1,
    'Plan de negocio': 2,
    'Aprende de los errores': 2,
    'Crea tu pitch': 3,
    // Deudas y Crédito
    'Deuda buena vs mala': 1,
    'Método bola de nieve': 2,
    'Historial crediticio': 2,
    'Evita el sobreendeudamiento': 2,
    'Auditoría de deudas': 3,
    // Seguros y Protección
    '¿Qué es un seguro?': 1,
    'Seguro de salud': 1,
    'Seguro de vida': 2,
    'Compara seguros': 2,
    'Revisa tus pólizas': 3,
    // Planificación Financiera
    'Establece metas financieras': 1,
    'Corto, medio y largo plazo': 1,
    'Crea tu plan financiero': 2,
    'Revisa y ajusta tu plan': 2,
    'Simula tu futuro financiero': 3,
    // Psicología del Dinero
    '¿Por qué gastamos más de la cuenta?': 1,
    'Sesgos cognitivos y dinero': 2,
    'El coste emocional del dinero': 2,
    'Cómo mejorar tu disciplina financiera': 2,
    'Diseña tus hábitos financieros': 3,
    // Bienes Raíces
    '¿Comprar o alquilar?': 1,
    'Cómo funciona la hipoteca': 2,
    'Gastos ocultos al comprar vivienda': 2,
    'La vivienda como inversión': 2,
    'Simula tu hipoteca': 3,
  };

  // ── Topic pill lists ────────────────────────────────────────────────────
  static const Map<String, List<String>> topicPills = {
    'topic_ahorros': [
      'Regla 50/30/20',
      'Fondo de emergencia',
      'Ahorro automático',
      'Evita gastos hormiga',
      'Reto de 30 días',
    ],
    'topic_impuestos': [
      '¿Qué son los impuestos?',
      'IRPF: El impuesto principal',
      'Seguridad Social',
      'IVA: El impuesto invisible',
      'Ejemplo completo: ¿Cuánto se lleva el Estado?',
    ],
    'topic_inversiones': [
      '¿Qué es invertir?',
      'Diversificación',
      'Riesgo y rentabilidad',
      'Invierte a largo plazo',
      'Fondos de inversión',
      'Cómo crean dinero los bancos',
      'Planes de pensiones',
      'FOREX y cobertura cambiaria',
      'Simula una inversión',
    ],
    'topic_presupuesto': [
      '¿Qué es un presupuesto?',
      'Registra tus gastos',
      'Prioriza necesidades',
      'Ajusta tu presupuesto',
      'Crea tu presupuesto',
    ],
    'topic_emprendimiento': [
      '¿Qué es emprender?',
      'Detecta oportunidades',
      'Plan de negocio',
      'Aprende de los errores',
      'Crea tu pitch',
    ],
    'topic_deudas': [
      'Deuda buena vs mala',
      'Método bola de nieve',
      'Historial crediticio',
      'Evita el sobreendeudamiento',
      'Auditoría de deudas',
    ],
    'topic_seguros': [
      '¿Qué es un seguro?',
      'Seguro de salud',
      'Seguro de vida',
      'Compara seguros',
      'Revisa tus pólizas',
    ],
    'topic_planificacion': [
      'Establece metas financieras',
      'Corto, medio y largo plazo',
      'Crea tu plan financiero',
      'Revisa y ajusta tu plan',
      'Simula tu futuro financiero',
    ],
    'topic_psicologia': [
      '¿Por qué gastamos más de la cuenta?',
      'Sesgos cognitivos y dinero',
      'El coste emocional del dinero',
      'Cómo mejorar tu disciplina financiera',
      'Diseña tus hábitos financieros',
    ],
    'topic_bienes_raices': [
      '¿Comprar o alquilar?',
      'Cómo funciona la hipoteca',
      'Gastos ocultos al comprar vivienda',
      'La vivienda como inversión',
      'Simula tu hipoteca',
    ],
  };

  static const int totalPills = 54;
  static const int totalBasic = 16;
  static const int totalIntermediate = 26;
  static const int totalAdvanced = 12;

  // ── Helpers ─────────────────────────────────────────────────────────────
  static int basicCount(Set<String> completed) =>
      completed.where((t) => pillDifficulty[t] == 1).length;

  static int intermediateCount(Set<String> completed) =>
      completed.where((t) => pillDifficulty[t] == 2).length;

  static int advancedCount(Set<String> completed) =>
      completed.where((t) => pillDifficulty[t] == 3).length;

  static int topicCount(String topicId, Set<String> completed) {
    final pills = topicPills[topicId];
    if (pills == null) return 0;
    return completed.where(pills.contains).length;
  }

  static String? topicIdForPill(String pillTitle) {
    for (final entry in topicPills.entries) {
      if (entry.value.contains(pillTitle)) return entry.key;
    }
    return null;
  }

  static bool isTopicComplete(String topicId, Set<String> completed) {
    final pills = topicPills[topicId];
    if (pills == null || pills.isEmpty) return false;
    return pills.every(completed.contains);
  }

  static const Map<String, String> topicDisplayNames = {
    'topic_ahorros': 'Ahorros',
    'topic_presupuesto': 'Presupuesto',
    'topic_planificacion': 'Planificación Financiera',
    'topic_impuestos': 'Impuestos',
    'topic_deudas': 'Deudas y Crédito',
    'topic_seguros': 'Seguros y Protección',
    'topic_psicologia': 'Psicología del Dinero',
    'topic_inversiones': 'Inversiones',
    'topic_emprendimiento': 'Emprendimiento',
    'topic_bienes_raices': 'Bienes Raíces',
  };

  // ── All achievements ─────────────────────────────────────────────────────
  static const List<Achievement> _achievements = [
    // ── Juegos ─────────────────────────────────────────────────────────────
    Achievement(
      id: 'first_game',
      title: 'Primer Juego',
      description: 'Completa tu primer juego',
      icon: Icons.games,
      color: Colors.green,
      requirement: 1,
      category: 'Juegos',
      xpReward: 50,
    ),
    Achievement(
      id: 'games_5',
      title: 'A Buen Ritmo',
      description: 'Completa 5 juegos',
      icon: Icons.sports_esports,
      color: Color(0xFF43A047),
      requirement: 5,
      category: 'Juegos',
      xpReward: 150,
    ),
    Achievement(
      id: 'perfect_score',
      title: 'Puntuación Perfecta',
      description: 'Obtén 100% en un juego',
      icon: Icons.star,
      color: Colors.yellow,
      requirement: 1,
      category: 'Juegos',
      xpReward: 100,
    ),
    Achievement(
      id: 'game_master',
      title: 'Maestro de Juegos',
      description: 'Completa 10 juegos',
      icon: Icons.emoji_events,
      color: Colors.amber,
      requirement: 10,
      category: 'Juegos',
      xpReward: 750,
    ),

    // ── Aprendizaje ─────────────────────────────────────────────────────────
    Achievement(
      id: 'lesson_master',
      title: 'Maestro del Conocimiento',
      description: 'Completa 10 píldoras',
      icon: Icons.book,
      color: Colors.purple,
      requirement: 10,
      category: 'Aprendizaje',
      xpReward: 200,
    ),
    Achievement(
      id: 'finance_guru',
      title: 'Gurú Financiero',
      description: 'Completa 25 píldoras',
      icon: Icons.psychology,
      color: Colors.orange,
      requirement: 25,
      category: 'Aprendizaje',
      xpReward: 500,
    ),

    // ── Rachas ──────────────────────────────────────────────────────────────
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
      id: 'streak_14',
      title: 'Dos Semanas',
      description: 'Mantén una racha de 14 días',
      icon: Icons.flare,
      color: Color(0xFFBF360C),
      requirement: 14,
      category: 'Rachas',
      xpReward: 400,
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
    Achievement(
      id: 'streak_100',
      title: 'Centenario',
      description: 'Mantén una racha de 100 días',
      icon: Icons.electric_bolt,
      color: Color(0xFF00BCD4),
      requirement: 100,
      category: 'Rachas',
      xpReward: 2500,
    ),

    // ── Experiencia ─────────────────────────────────────────────────────────
    Achievement(
      id: 'xp_500',
      title: 'Primeros Pasos',
      description: 'Alcanza 500 XP',
      icon: Icons.star_border,
      color: Color(0xFF80CBC4),
      requirement: 500,
      category: 'Experiencia',
      xpReward: 50,
    ),
    Achievement(
      id: 'xp_1000',
      title: 'Aprendiz Financiero',
      description: 'Alcanza 1.000 XP',
      icon: Icons.trending_up,
      color: Colors.teal,
      requirement: 1000,
      category: 'Experiencia',
      xpReward: 100,
    ),
    Achievement(
      id: 'xp_2500',
      title: 'Inversor Intelectual',
      description: 'Alcanza 2.500 XP',
      icon: Icons.show_chart,
      color: Color(0xFF283593),
      requirement: 2500,
      category: 'Experiencia',
      xpReward: 250,
    ),

    // ── Nivel ───────────────────────────────────────────────────────────────
    Achievement(
      id: 'level_5',
      title: 'Inversor Novato',
      description: 'Alcanza el nivel 5',
      icon: Icons.bar_chart,
      color: Color(0xFF7CB342),
      requirement: 5,
      category: 'Nivel',
      xpReward: 100,
    ),
    Achievement(
      id: 'level_10',
      title: 'Analista Financiero',
      description: 'Alcanza el nivel 10',
      icon: Icons.leaderboard,
      color: Color(0xFF00897B),
      requirement: 10,
      category: 'Nivel',
      xpReward: 300,
    ),

    // ── Tiempo de estudio ───────────────────────────────────────────────────
    Achievement(
      id: 'study_30min',
      title: 'Primera Media Hora',
      description: 'Acumula 30 minutos de estudio',
      icon: Icons.timer,
      color: Color(0xFFAD1457),
      requirement: 30,
      category: 'Tiempo',
      xpReward: 50,
    ),
    Achievement(
      id: 'study_2hrs',
      title: 'Comprometido',
      description: 'Acumula 2 horas de estudio',
      icon: Icons.hourglass_bottom,
      color: Color(0xFF6A1B9A),
      requirement: 120,
      category: 'Tiempo',
      xpReward: 150,
    ),

    // ── Especiales ──────────────────────────────────────────────────────────
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

    // ── Dificultad ──────────────────────────────────────────────────────────
    Achievement(
      id: 'basic_first',
      title: 'Primer Contacto',
      description: 'Completa tu primera píldora básica',
      icon: Icons.signal_cellular_alt_1_bar,
      color: Color(0xFF4CAF50),
      requirement: 1,
      category: 'Dificultad',
      xpReward: 25,
    ),
    Achievement(
      id: 'basic_5',
      title: 'Bases Sólidas',
      description: 'Completa 5 píldoras básicas',
      icon: Icons.foundation,
      color: Color(0xFF43A047),
      requirement: 5,
      category: 'Dificultad',
      xpReward: 75,
    ),
    Achievement(
      id: 'basic_all',
      title: 'Fundamentos Completos',
      description: 'Completa las $totalBasic píldoras básicas',
      icon: Icons.check_circle_outline,
      color: Color(0xFF388E3C),
      requirement: totalBasic,
      category: 'Dificultad',
      xpReward: 300,
    ),
    Achievement(
      id: 'intermediate_first',
      title: 'Subiendo el Nivel',
      description: 'Completa tu primera píldora intermedia',
      icon: Icons.signal_cellular_alt_2_bar,
      color: Color(0xFFFF9800),
      requirement: 1,
      category: 'Dificultad',
      xpReward: 50,
    ),
    Achievement(
      id: 'intermediate_5',
      title: 'Ritmo Creciente',
      description: 'Completa 5 píldoras intermedias',
      icon: Icons.trending_up,
      color: Color(0xFFF57C00),
      requirement: 5,
      category: 'Dificultad',
      xpReward: 150,
    ),
    Achievement(
      id: 'intermediate_all',
      title: 'Nivel Intermedio',
      description: 'Completa las $totalIntermediate píldoras intermedias',
      icon: Icons.verified,
      color: Color(0xFFE65100),
      requirement: totalIntermediate,
      category: 'Dificultad',
      xpReward: 500,
    ),
    Achievement(
      id: 'advanced_first',
      title: 'Pensamiento Avanzado',
      description: 'Completa tu primera píldora avanzada',
      icon: Icons.signal_cellular_alt,
      color: Color(0xFFE53935),
      requirement: 1,
      category: 'Dificultad',
      xpReward: 100,
    ),
    Achievement(
      id: 'advanced_3',
      title: 'Élite Financiera',
      description: 'Completa 3 píldoras avanzadas',
      icon: Icons.workspace_premium,
      color: Color(0xFFC62828),
      requirement: 3,
      category: 'Dificultad',
      xpReward: 250,
    ),
    Achievement(
      id: 'advanced_all',
      title: 'Maestro de la Dificultad',
      description: 'Completa las $totalAdvanced píldoras avanzadas',
      icon: Icons.military_tech,
      color: Color(0xFFB71C1C),
      requirement: totalAdvanced,
      category: 'Dificultad',
      xpReward: 750,
    ),

    // ── Temático ────────────────────────────────────────────────────────────
    Achievement(
      id: 'topic_ahorros',
      title: 'Experto en Ahorros',
      description: 'Completa todas las píldoras de Ahorros',
      icon: Icons.savings,
      color: Color(0xFF7ED957),
      requirement: 5,
      category: 'Temático',
      xpReward: 150,
    ),
    Achievement(
      id: 'topic_impuestos',
      title: 'Experto en Impuestos',
      description: 'Completa todas las píldoras de Impuestos',
      icon: Icons.receipt_long,
      color: Color(0xFFFF6B6B),
      requirement: 5,
      category: 'Temático',
      xpReward: 150,
    ),
    Achievement(
      id: 'topic_inversiones',
      title: 'Experto en Inversiones',
      description: 'Completa todas las píldoras de Inversiones',
      icon: Icons.candlestick_chart,
      color: Color(0xFF7EC6F5),
      requirement: 7,
      category: 'Temático',
      xpReward: 200,
    ),
    Achievement(
      id: 'topic_presupuesto',
      title: 'Experto en Presupuesto',
      description: 'Completa todas las píldoras de Presupuesto',
      icon: Icons.attach_money,
      color: Color(0xFFFFE066),
      requirement: 5,
      category: 'Temático',
      xpReward: 150,
    ),
    Achievement(
      id: 'topic_emprendimiento',
      title: 'Experto en Emprendimiento',
      description: 'Completa todas las píldoras de Emprendimiento',
      icon: Icons.business,
      color: Color(0xFFB57EDC),
      requirement: 5,
      category: 'Temático',
      xpReward: 200,
    ),
    Achievement(
      id: 'topic_deudas',
      title: 'Experto en Deudas',
      description: 'Completa todas las píldoras de Deudas y Crédito',
      icon: Icons.credit_card,
      color: Color(0xFFFFA07A),
      requirement: 5,
      category: 'Temático',
      xpReward: 200,
    ),
    Achievement(
      id: 'topic_seguros',
      title: 'Experto en Seguros',
      description: 'Completa todas las píldoras de Seguros',
      icon: Icons.shield,
      color: Color(0xFF7ED9C2),
      requirement: 5,
      category: 'Temático',
      xpReward: 150,
    ),
    Achievement(
      id: 'topic_planificacion',
      title: 'Experto en Planificación',
      description: 'Completa todas las píldoras de Planificación Financiera',
      icon: Icons.flag,
      color: Color(0xFF4FC3F7),
      requirement: 5,
      category: 'Temático',
      xpReward: 150,
    ),
    Achievement(
      id: 'topic_psicologia',
      title: 'Experto en Psicología',
      description: 'Completa todas las píldoras de Psicología del Dinero',
      icon: Icons.psychology,
      color: Color(0xFFCE93D8),
      requirement: 5,
      category: 'Temático',
      xpReward: 200,
    ),
    Achievement(
      id: 'topic_bienes_raices',
      title: 'Experto Inmobiliario',
      description: 'Completa todas las píldoras de Bienes Raíces',
      icon: Icons.home_work,
      color: Color(0xFFFFAB91),
      requirement: 5,
      category: 'Temático',
      xpReward: 200,
    ),
    Achievement(
      id: 'all_topics',
      title: 'Polímata Financiero',
      description: 'Completa las $totalPills píldoras de todos los temas',
      icon: Icons.auto_awesome,
      color: Color(0xFFFFD700),
      requirement: totalPills,
      category: 'Temático',
      xpReward: 1500,
    ),
  ];

  List<Achievement> get achievements => _achievements;

  int get totalAchievements => _achievements.length;

  // ── Check which achievements should be unlocked ──────────────────────────
  /// [allowTimeAchievements] should only be true when the user is actively
  /// completing a lesson or game — NOT when simply opening the screen.
  List<Achievement> checkAchievements({
    int? gamesCompleted,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    bool? isPerfectScore,
    int? lessonsCompleted,
    int? currentLevel,
    int? studyTimeMinutes,
    Set<String>? completedLessons,
    bool allowTimeAchievements = false,
  }) {
    final List<Achievement> newlyUnlocked = [];

    // Pre-compute difficulty + topic stats when we have the full title set
    final basic = completedLessons != null ? basicCount(completedLessons) : 0;
    final intermediate =
        completedLessons != null ? intermediateCount(completedLessons) : 0;
    final advanced =
        completedLessons != null ? advancedCount(completedLessons) : 0;

    for (final achievement in _achievements) {
      bool shouldUnlock = false;

      switch (achievement.id) {
        // Juegos
        case 'first_game':
        case 'games_5':
        case 'game_master':
          shouldUnlock = gamesCompleted != null &&
              gamesCompleted >= achievement.requirement;
          break;
        case 'perfect_score':
          shouldUnlock = isPerfectScore == true;
          break;

        // Aprendizaje
        case 'lesson_master':
        case 'finance_guru':
          shouldUnlock = lessonsCompleted != null &&
              lessonsCompleted >= achievement.requirement;
          break;

        // Rachas
        case 'streak_3':
        case 'streak_7':
        case 'streak_14':
        case 'streak_30':
        case 'streak_100':
          shouldUnlock = currentStreak != null &&
              currentStreak >= achievement.requirement;
          break;

        // Experiencia
        case 'xp_500':
        case 'xp_1000':
        case 'xp_2500':
          shouldUnlock =
              totalXP != null && totalXP >= achievement.requirement;
          break;

        // Nivel
        case 'level_5':
        case 'level_10':
          shouldUnlock = currentLevel != null &&
              currentLevel >= achievement.requirement;
          break;

        // Tiempo
        case 'study_30min':
        case 'study_2hrs':
          shouldUnlock = studyTimeMinutes != null &&
              studyTimeMinutes >= achievement.requirement;
          break;

        // Especiales — only grant when the user is actively studying
        case 'night_owl':
          shouldUnlock = allowTimeAchievements && isNightTime;
          break;
        case 'early_bird':
          shouldUnlock = allowTimeAchievements && isEarlyMorning;
          break;
        case 'weekend_warrior':
          shouldUnlock = allowTimeAchievements && isWeekend;
          break;

        // Dificultad
        case 'basic_first':
          shouldUnlock = basic >= 1;
          break;
        case 'basic_5':
          shouldUnlock = basic >= 5;
          break;
        case 'basic_all':
          shouldUnlock = basic >= totalBasic;
          break;
        case 'intermediate_first':
          shouldUnlock = intermediate >= 1;
          break;
        case 'intermediate_5':
          shouldUnlock = intermediate >= 5;
          break;
        case 'intermediate_all':
          shouldUnlock = intermediate >= totalIntermediate;
          break;
        case 'advanced_first':
          shouldUnlock = advanced >= 1;
          break;
        case 'advanced_3':
          shouldUnlock = advanced >= 3;
          break;
        case 'advanced_all':
          shouldUnlock = advanced >= totalAdvanced;
          break;

        // Temático
        case 'topic_ahorros':
        case 'topic_impuestos':
        case 'topic_inversiones':
        case 'topic_presupuesto':
        case 'topic_emprendimiento':
        case 'topic_deudas':
        case 'topic_seguros':
        case 'topic_planificacion':
        case 'topic_psicologia':
        case 'topic_bienes_raices':
          if (completedLessons != null) {
            final pills = topicPills[achievement.id]!;
            shouldUnlock = pills.every(completedLessons.contains);
          }
          break;
        case 'all_topics':
          shouldUnlock = completedLessons != null &&
              completedLessons.length >= totalPills;
          break;
      }

      if (shouldUnlock) newlyUnlocked.add(achievement);
    }

    return newlyUnlocked;
  }

  List<Achievement> getAchievementsByCategory(String category) =>
      _achievements.where((a) => a.category == category).toList();

  List<String> get categories =>
      _achievements.map((a) => a.category).toSet().toList();

  bool get isNightTime {
    final h = DateTime.now().hour;
    return h >= 22 || h < 6;
  }

  bool get isEarlyMorning {
    final h = DateTime.now().hour;
    return h >= 5 && h < 7;
  }

  bool get isWeekend {
    final d = DateTime.now().weekday;
    return d == DateTime.saturday || d == DateTime.sunday;
  }
}
