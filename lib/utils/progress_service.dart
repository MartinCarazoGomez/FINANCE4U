import 'dart:convert';
import 'achievements_service.dart';
import 'streak_service.dart';
import 'haptic_service.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();
  
  // Servicios integrados
  final AchievementsService _achievementsService = AchievementsService();
  final StreakService _streakService = StreakService();
  final HapticService _hapticService = HapticService();

  // Almacén en memoria del progreso (en una app real usarías SharedPreferences)
  final Map<String, dynamic> _progressData = {};

  // Progreso de juegos completados
  final Map<String, bool> _completedGames = {};
  
  // Puntuaciones por juego
  final Map<String, int> _gameScores = {};
  
  // Tiempo total estudiado
  int _totalStudyTimeMinutes = 0;
  
  // Racha de días consecutivos
  int _currentStreak = 3; // Empezamos con 3 días para mostrar progreso
  
  // Nivel general del usuario
  int _userLevel = 1;
  int _userExperience = 0;
  
  // Lecciones completadas
  final Set<String> _completedLessons = {};

  // Getters
  bool isGameCompleted(String gameId) => _completedGames[gameId] ?? false;
  int getGameScore(String gameId) => _gameScores[gameId] ?? 0;
  int get totalStudyTime => _totalStudyTimeMinutes;
  int get currentStreak => _currentStreak;
  int get userLevel => _userLevel;
  int get userExperience => _userExperience;
  int get completedGamesCount => _completedGames.values.where((completed) => completed).length;
  int get completedLessonsCount => _completedLessons.length;

  // Marcar juego como completado
  void completeGame(String gameId, int score) {
    _completedGames[gameId] = true;
    _gameScores[gameId] = score;
    _addExperience(50); // 50 XP por completar un juego
    _addStudyTime(2); // 2 minutos estimados por juego
    
    // Marcar como activo en streak service
    _streakService.markTodayAsActive();
    
    // Verificar logros
    final newAchievements = _achievementsService.checkAchievements(
      gamesCompleted: completedGamesCount,
      totalXP: _userExperience,
      currentStreak: _streakService.currentStreak,
      lessonsCompleted: completedLessonsCount,
    );
    
    // Feedback háptico para logros
    if (newAchievements.isNotEmpty) {
      _hapticService.achievementUnlocked();
    } else {
      _hapticService.lessonCompleted();
    }
    
    print('🎮 Juego completado: $gameId - Puntuación: $score');
    _saveProgress();
  }

  // Marcar lección como completada
  void completeLesson(String lessonId) {
    _completedLessons.add(lessonId);
    _addExperience(100); // 100 XP por completar una lección
    _addStudyTime(5); // 5 minutos estimados por lección
    
    // Marcar como activo en streak service
    _streakService.markTodayAsActive();
    
    // Verificar logros
    final newAchievements = _achievementsService.checkAchievements(
      lessonsCompleted: completedLessonsCount,
      totalXP: _userExperience,
      currentStreak: _streakService.currentStreak,
    );
    
    // Feedback háptico para logros
    if (newAchievements.isNotEmpty) {
      _hapticService.achievementUnlocked();
    } else {
      _hapticService.lessonCompleted();
    }
    
    print('📚 Lección completada: $lessonId');
    _saveProgress();
  }

  // Agregar experiencia y manejar subidas de nivel
  void _addExperience(int exp) {
    int oldLevel = _userLevel;
    _userExperience += exp;
    
    // Cada 500 XP subes de nivel
    int newLevel = (_userExperience / 500).floor() + 1;
    if (newLevel > _userLevel) {
      _userLevel = newLevel;
      _hapticService.levelUp();
      print('🎉 ¡Subiste al nivel $_userLevel!');
    }
  }

  // Agregar tiempo de estudio
  void _addStudyTime(int minutes) {
    _totalStudyTimeMinutes += minutes;
  }

  // Actualizar racha
  void updateStreak() {
    // En una app real, verificarías la fecha del último acceso
    _currentStreak++;
    print('🔥 Racha actualizada: $_currentStreak días');
    _saveProgress();
  }

  // Obtener progreso por módulo
  Map<String, double> getModuleProgress() {
    // Simulamos el progreso basado en juegos completados
    final modules = ['savings', 'investments', 'budget', 'entrepreneurship', 'debt', 'planning'];
    final Map<String, double> progress = {};
    
    for (String module in modules) {
      // Cada módulo tiene 5 juegos
      int completedInModule = 0;
      for (int i = 1; i <= 5; i++) {
        if (isGameCompleted('${module}_game_$i')) {
          completedInModule++;
        }
      }
      progress[module] = completedInModule / 5.0;
    }
    
    return progress;
  }

  // Obtener estadísticas generales
  Map<String, dynamic> getStats() {
    return {
      'level': _userLevel,
      'experience': _userExperience,
      'experienceToNext': 500 - (_userExperience % 500),
      'completedGames': completedGamesCount,
      'totalGames': 30, // 6 módulos × 5 juegos
      'completedLessons': completedLessonsCount,
      'totalLessons': 30, // 6 módulos × 5 lecciones
      'studyTime': _totalStudyTimeMinutes,
      'currentStreak': _currentStreak,
      'overallProgress': (completedGamesCount + completedLessonsCount) / 60.0,
    };
  }

  // Simular guardado (en una app real usarías SharedPreferences)
  void _saveProgress() {
    _progressData['completedGames'] = _completedGames;
    _progressData['gameScores'] = _gameScores;
    _progressData['completedLessons'] = _completedLessons.toList();
    _progressData['userLevel'] = _userLevel;
    _progressData['userExperience'] = _userExperience;
    _progressData['totalStudyTime'] = _totalStudyTimeMinutes;
    _progressData['currentStreak'] = _currentStreak;
    
    print('💾 Progreso guardado automáticamente');
  }

  // Cargar progreso guardado
  void loadProgress() {
    // En una app real, cargarías desde SharedPreferences
    if (_progressData.isNotEmpty) {
      _completedGames.addAll(Map<String, bool>.from(_progressData['completedGames'] ?? {}));
      _gameScores.addAll(Map<String, int>.from(_progressData['gameScores'] ?? {}));
      _completedLessons.addAll(Set<String>.from(_progressData['completedLessons'] ?? []));
      _userLevel = _progressData['userLevel'] ?? 1;
      _userExperience = _progressData['userExperience'] ?? 0;
      _totalStudyTimeMinutes = _progressData['totalStudyTime'] ?? 0;
      _currentStreak = _progressData['currentStreak'] ?? 1;
      
      print('📱 Progreso cargado exitosamente');
    }
  }

  // Resetear progreso (para testing)
  void resetProgress() {
    _completedGames.clear();
    _gameScores.clear();
    _completedLessons.clear();
    _userLevel = 1;
    _userExperience = 0;
    _totalStudyTimeMinutes = 0;
    _currentStreak = 1;
    _progressData.clear();
    
    print('🔄 Progreso reseteado');
  }

  // Obtener recomendaciones basadas en progreso
  List<String> getRecommendations() {
    List<String> recommendations = [];
    
    if (completedGamesCount < 5) {
      recommendations.add('Completa más juegos para ganar experiencia');
    }
    
    if (_currentStreak < 7) {
      recommendations.add('Mantén una racha de 7 días para obtener bonificaciones');
    }
    
    if (_userLevel < 3) {
      recommendations.add('Alcanza el nivel 3 para desbloquear contenido avanzado');
    }
    
    final moduleProgress = getModuleProgress();
    for (var entry in moduleProgress.entries) {
      if (entry.value < 0.5) {
        recommendations.add('Continúa con el módulo de ${_getModuleName(entry.key)}');
        break; // Solo una recomendación de módulo
      }
    }
    
    return recommendations;
  }

  String _getModuleName(String moduleId) {
    final names = {
      'savings': 'Ahorros',
      'investments': 'Inversiones',
      'budget': 'Presupuesto',
      'entrepreneurship': 'Emprendimiento',
      'debt': 'Deudas y Crédito',
      'planning': 'Planificación Financiera',
    };
    return names[moduleId] ?? moduleId;
  }

  // Obtener progreso del usuario para otros servicios
  Map<String, dynamic> getUserProgress() {
    return {
      'totalXP': _userExperience,
      'currentLevel': _userLevel,
      'lessonsCompleted': completedLessonsCount,
      'gamesCompleted': completedGamesCount,
      'gamesPlayed': completedGamesCount,
      'currentStreak': _streakService.currentStreak,
      'maxStreak': _streakService.maxStreak,
      'todayCompleted': _getTodayCompleted(),
      'daysActive': _streakService.activeDays.length,
      'totalMinutes': _totalStudyTimeMinutes,
      'accuracy': _calculateAccuracy(),
      'bonusXP': _getBonusXP(),
    };
  }
  
  // Obtener el nivel actual
  int getCurrentLevel() {
    return _userLevel;
  }
  
  // Obtener XP para el siguiente nivel
  int getXPForNextLevel() {
    return 500 - (_userExperience % 500);
  }
  
  // Obtener XP del nivel actual
  int getCurrentLevelXP() {
    return _userExperience % 500;
  }
  
  // Agregar XP directamente (para práctica rápida, etc.)
  void addXP(int xp) {
    _addExperience(xp);
    _saveProgress();
  }
  
  // Incrementar actividades completadas hoy
  void incrementTodayCompleted() {
    // En implementación real, guardarías la fecha
  }
  
  // Obtener actividades completadas hoy (simulado)
  int _getTodayCompleted() {
    return 2; // Simulado
  }
  
  // Calcular precisión promedio (simulado)
  int _calculateAccuracy() {
    if (_gameScores.isEmpty) return 0;
    final totalScore = _gameScores.values.reduce((a, b) => a + b);
    return (totalScore / _gameScores.length).round();
  }
  
  // Obtener XP de bonificaciones (simulado)
  int _getBonusXP() {
    return _streakService.currentStreak * 10; // 10 XP por día de racha
  }

  // Simular datos iniciales para demo
  void initDemoData() {
    // Completar algunos juegos para mostrar progreso
    completeGame('savings_game_1', 85);
    completeGame('savings_game_2', 92);
    completeGame('investments_game_1', 78);
    
    completeLesson('savings_lesson_1');
    completeLesson('savings_lesson_2');
    
    _currentStreak = 3;
    _totalStudyTimeMinutes = 45;
    
    // Inicializar servicios con datos demo
    _streakService.initDemoData();
    
    print('🎮 Datos de demo inicializados');
  }
} 