import 'dart:async';

import 'package:flutter/material.dart';
import '../services/firestore_helper.dart';
import '../services/local_progress_service.dart';
import '../services/app_settings_service.dart';
import '../utils/achievements_service.dart';
import '../utils/currency_helper.dart';
import '../utils/progress_service.dart';
import '../utils/streak_day_helper.dart';
import '../utils/streak_service.dart';

class AppProvider extends ChangeNotifier {
  final LocalProgressService _localProgress = LocalProgressService();
  final AppSettingsService _settings = AppSettingsService();

  String _selectedLanguage = 'es';
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  bool _developerMode = false;
  double _fontSize = 16.0;
  
  // User Progress
  String _username = 'Usuario Finance4U';
  String _email = 'usuario@finance4u.com';
  int _userLevel = 1;
  int _totalXP = 0;
  int _streakDays = 0;
  int? _lastStreakDay;
  DateTime? _lastCompletionDate;
  Set<String> _completedLessons = {};
  Set<String> _completedTopics = {};
  int _classPoints = 0;
  String? _progressUserId;
  static const _starterGames = ['budget_master'];

  List<String> _unlockedGames = List.from(_starterGames);
  
  // Datos de juegos (alternativa a SharedPreferences)
  Map<String, dynamic> _gameData = {};
  
  // Configuraciones
  String _reminderTime = '09:00';
  String _currency = 'EUR';
  
  // Getters
  String get selectedLanguage => _selectedLanguage;
  bool get soundEnabled => _soundEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get developerMode => _developerMode;
  double get fontSize => _fontSize;
  String get username => _username;
  String get email => _email;
  int get userLevel => _userLevel;
  int get totalXP => _totalXP;
  int get streakDays => _streakDays;
  int? get lastStreakDay => _lastStreakDay;
  Set<String> get completedLessons => _completedLessons;
  Set<String> get completedTopics => _completedTopics;
  int get classPoints => _classPoints;
  String? get progressUserId => _progressUserId;
  List<String> get unlockedGames => List.unmodifiable(_unlockedGames);
  String get reminderTime => _reminderTime;
  String get currency => _currency;
  
  // Methods
  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
  
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }
  
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
  
  void setFontSize(double size) {
    _fontSize = size.clamp(12.0, 24.0);
    notifyListeners();
  }
  
  void addXP(int xp) {
    _totalXP += xp;
    _checkLevelUp();
    notifyListeners();
  }
  
  Future<void> loadSettings() async {
    try {
      _developerMode = await _settings.loadDeveloperMode();
      _currency = await _settings.loadCurrency();
      notifyListeners();
    } catch (e) {
      debugPrint('AppProvider.loadSettings error: $e');
    }
  }

  Future<void> loadLocalProgress({String? userId}) async {
    try {
      if (userId != null) _progressUserId = userId;
      final data = await _localProgress.load(userId: userId ?? _progressUserId);
      if (data != null) {
        _applyProgressData(data, merge: true);
        _validateStreak();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('AppProvider.loadLocalProgress error: $e');
    }
  }

  Future<void> setDeveloperMode(bool enabled) async {
    if (_developerMode == enabled) return;
    _developerMode = enabled;
    notifyListeners();
    try {
      await _settings.saveDeveloperMode(enabled);
    } catch (e) {
      debugPrint('AppProvider.setDeveloperMode error: $e');
    }
  }

  void toggleDeveloperMode() {
    setDeveloperMode(!_developerMode);
  }

  void setProgressUserId(String? userId) {
    _progressUserId = userId;
  }

  void completeLesson(String lessonId, {String? userId}) {
    if (_completedLessons.contains(lessonId)) return;
    _completedLessons.add(lessonId);
    _classPoints += 10;
    addXP(10);
    _updateStreak();

    final topicId = AchievementsService.topicIdForPill(lessonId);
    if (topicId != null &&
        !_completedTopics.contains(topicId) &&
        AchievementsService.isTopicComplete(topicId, _completedLessons)) {
      _completedTopics.add(topicId);
      _classPoints += 10;
      addXP(10);
    }

    if (userId != null) _progressUserId = userId;
    _scheduleBackgroundSync(userId);
    notifyListeners();
  }

  void _scheduleBackgroundSync(String? userId) {
    unawaited(Future<void>(() async {
      await _saveLocalProgress();
      if (userId != null) {
        await _persistProgressWithRetry(userId);
      }
    }));
  }

  Future<void> _persistProgressWithRetry(String userId) async {
    const attempts = [
      Duration.zero,
      Duration(seconds: 2),
      Duration(seconds: 5),
      Duration(seconds: 10),
      Duration(seconds: 20),
    ];

    for (var i = 0; i < attempts.length; i++) {
      if (attempts[i] > Duration.zero) {
        await Future<void>.delayed(attempts[i]);
      }
      final ok = await _persistProgress(userId);
      if (ok) return;
      debugPrint(
        'AppProvider._persistProgressWithRetry: intento ${i + 1} fallido',
      );
    }
  }

  Future<void> _saveLocalProgress() async {
    try {
      await _localProgress.save(
        userId: _progressUserId,
        completedLessons: _completedLessons.toList(),
        completedTopics: _completedTopics.toList(),
        classPoints: _classPoints,
        totalXP: _totalXP,
        userLevel: _userLevel,
        streakDays: _streakDays,
        lastStreakDay: _lastStreakDay,
      );
    } catch (e) {
      debugPrint('AppProvider._saveLocalProgress error: $e');
    }
  }

  Future<bool> _persistProgress(String userId) async {
    try {
      await FirestoreHelper.saveProgress(
        userId: userId,
        level: _userLevel,
        totalXP: _totalXP,
        streakDays: _streakDays,
        lastStreakDay: _lastStreakDay,
        completedLessons: _completedLessons.toList(),
        unlockedGames: _unlockedGames,
        classPoints: _classPoints,
        completedTopics: _completedTopics.toList(),
      );
      return true;
    } catch (e) {
      debugPrint('AppProvider._persistProgress error: $e');
      return false;
    }
  }

  void loadFromFirestore(Map<String, dynamic> data) {
    _applyProgressData(data, merge: true);
    _validateStreak();
    _saveLocalProgress();

    final games = data['unlockedGames'];
    if (games is List && games.isNotEmpty) {
      final remote = games.whereType<String>().toSet();
      _unlockedGames = {..._unlockedGames, ...remote}.toList();
    }

    notifyListeners();
  }

  void _applyProgressData(Map<String, dynamic> data, {required bool merge}) {
    final remoteLevel = (data['level'] as num?)?.toInt();
    final remoteXP = (data['totalXP'] as num?)?.toInt();
    final remoteStreak = (data['streakDays'] as num?)?.toInt();
    final remoteLastStreakDay = (data['lastStreakDay'] as num?)?.toInt();
    final remoteClassPoints = (data['classPoints'] as num?)?.toInt();

    if (merge) {
      if (remoteXP != null) {
        _totalXP = remoteXP > _totalXP ? remoteXP : _totalXP;
      }
      if (remoteLevel != null) {
        _userLevel = remoteLevel > _userLevel ? remoteLevel : _userLevel;
      }
      _syncLevelFromXP();
      _mergeStreak(
        remoteStreak: remoteStreak,
        remoteLastStreakDay: remoteLastStreakDay,
      );
      if (remoteClassPoints != null) {
        _classPoints = remoteClassPoints > _classPoints
            ? remoteClassPoints
            : _classPoints;
      }
    } else {
      _userLevel = remoteLevel ?? _userLevel;
      _totalXP = remoteXP ?? _totalXP;
      _syncLevelFromXP();
      _streakDays = remoteStreak ?? _streakDays;
      _lastStreakDay = remoteLastStreakDay ?? _lastStreakDay;
      _classPoints = remoteClassPoints ?? _classPoints;
    }

    final completed = data['completedLessons'];
    if (completed is List) {
      final remoteLessons = completed.whereType<String>().toSet();
      _completedLessons =
          merge ? {..._completedLessons, ...remoteLessons} : remoteLessons;
    }

    final topics = data['completedTopics'];
    if (topics is List) {
      final remoteTopics = topics.whereType<String>().toSet();
      _completedTopics =
          merge ? {..._completedTopics, ...remoteTopics} : remoteTopics;
    }

    _syncCompletedTopicsFromLessons();
    _syncStreakService();
  }

  void _syncLevelFromXP() {
    final levelFromXp = (_totalXP / 100).floor() + 1;
    if (levelFromXp != _userLevel) {
      _userLevel = levelFromXp;
      _unlockGamesForLevel(_userLevel);
    }
  }

  void _syncStreakService() {
    StreakService().syncFromApp(
      streakDays: _streakDays,
      lastStreakDay: _lastStreakDay,
    );
  }

  void _syncCompletedTopicsFromLessons() {
    for (final topicId in AchievementsService.topicPills.keys) {
      if (AchievementsService.isTopicComplete(topicId, _completedLessons)) {
        _completedTopics.add(topicId);
      }
    }
  }

  void _mergeStreak({int? remoteStreak, int? remoteLastStreakDay}) {
    if (remoteLastStreakDay != null) {
      if (_lastStreakDay == null || remoteLastStreakDay > _lastStreakDay!) {
        _lastStreakDay = remoteLastStreakDay;
        if (remoteStreak != null) _streakDays = remoteStreak;
      } else if (remoteLastStreakDay == _lastStreakDay &&
          remoteStreak != null &&
          remoteStreak > _streakDays) {
        _streakDays = remoteStreak;
      }
    } else if (remoteStreak != null && _lastStreakDay == null) {
      _streakDays = remoteStreak > _streakDays ? remoteStreak : _streakDays;
    }
  }

  void _validateStreak() {
    if (_lastStreakDay == null) return;
    if (StreakDayHelper.isStreakBroken(_lastStreakDay)) {
      _streakDays = 0;
    }
    _syncStreakService();
  }

  void _updateStreak() {
    final today = StreakDayHelper.currentStreakDay();
    if (_lastStreakDay == null) {
      _streakDays = 1;
    } else {
      final gap = today - _lastStreakDay!;
      if (gap == 0) {
        // Same streak day — count unchanged.
      } else if (gap == 1) {
        _streakDays++;
      } else {
        _streakDays = 1;
      }
    }
    _lastStreakDay = today;
    _lastCompletionDate = DateTime.now();
    _syncStreakService();
  }
  
  void unlockGame(String gameId) {
    if (!_unlockedGames.contains(gameId)) {
      _unlockedGames.add(gameId);
      notifyListeners();
    }
  }
  
  void incrementStreak() {
    _streakDays++;
    notifyListeners();
  }
  
  void resetStreak() {
    _streakDays = 0;
    _lastStreakDay = null;
    notifyListeners();
  }
  
  void _checkLevelUp() {
    int newLevel = (_totalXP / 100).floor() + 1;
    if (newLevel > _userLevel) {
      _userLevel = newLevel;
      // Unlock new games based on level
      _unlockGamesForLevel(newLevel);
    }
  }
  
  void _unlockGamesForLevel(int level) {
    Map<int, List<String>> levelUnlocks = {
      2: ['budget_master'],
      3: ['credit_score'],
      4: ['debt_destroyer'],
      5: ['emergency_fund'],
      6: ['trading'],
      7: ['real_estate'],
      8: ['insurance'],
      9: ['retirement'],
      10: ['smart_shopper'],
      12: ['entrepreneur'],
    };
    
    if (levelUnlocks.containsKey(level)) {
      for (String gameId in levelUnlocks[level]!) {
        _unlockedGames.add(gameId);
      }
    }
  }
  
  bool isGameUnlocked(String gameId) {
    return _unlockedGames.contains(gameId);
  }
  
  int getXPForNextLevel() {
    return (_userLevel * 100) - _totalXP;
  }
  
  double getLevelProgress() {
    int currentLevelXP = _totalXP % 100;
    return currentLevelXP / 100.0;
  }
  
  // Métodos para formateo de moneda — importes internos siempre en EUR.
  String formatCurrency(double eurAmount) {
    return CurrencyHelper.formatGame(eurAmount, _currency);
  }
  
  // Métodos para persistencia de juegos (alternativa a SharedPreferences)
  void saveGameData(String gameId, Map<String, dynamic> data) {
    _gameData[gameId] = data;
    notifyListeners();
  }
  
  Map<String, dynamic>? getGameData(String gameId) {
    return _gameData[gameId];
  }
  
  void clearGameData(String gameId) {
    _gameData.remove(gameId);
    notifyListeners();
  }
  
  // Métodos para guardar/cargar datos específicos de juegos
  void saveBudgetGameData({
    required double monthlyIncome,
    required int currentMonth,
    required int currentYear,
    required int level,
    required double experience,
    required double savingsGoal,
    required double totalSavings,
    required bool budgetSet,
    required int monthsCompleted,
    required double bestSavingsRate,
    required int eventsHandled,
    required List<String> achievements,
    required List<Map<String, dynamic>> categories,
  }) {
    saveGameData('budget_master', {
      'monthlyIncome': monthlyIncome,
      'currentMonth': currentMonth,
      'currentYear': currentYear,
      'level': level,
      'experience': experience,
      'savingsGoal': savingsGoal,
      'totalSavings': totalSavings,
      'budgetSet': budgetSet,
      'monthsCompleted': monthsCompleted,
      'bestSavingsRate': bestSavingsRate,
      'eventsHandled': eventsHandled,
      'achievements': achievements,
      'categories': categories,
    });
  }
  
  void saveDebtGameData({
    required double monthlyIncome,
    required double monthlyExpenses,
    required double extraPaymentBudget,
    required int currentMonth,
    required int currentYear,
    required int level,
    required double experience,
    required double totalDebtPaid,
    required int debtsEliminated,
    required String strategy,
    required bool gameCompleted,
    required List<String> achievements,
    required List<Map<String, dynamic>> debts,
  }) {
    saveGameData('debt_destroyer', {
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'extraPaymentBudget': extraPaymentBudget,
      'currentMonth': currentMonth,
      'currentYear': currentYear,
      'level': level,
      'experience': experience,
      'totalDebtPaid': totalDebtPaid,
      'debtsEliminated': debtsEliminated,
      'strategy': strategy,
      'gameCompleted': gameCompleted,
      'achievements': achievements,
      'debts': debts,
    });
  }
  
  // Métodos para actualizar datos del usuario
  void updateUsername(String username) {
    _username = username;
    notifyListeners();
  }
  
  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }
  
  void updateStreak(int days) {
    _streakDays = days;
    notifyListeners();
  }
  
  // Métodos para configuraciones
  void updateReminderTime(String time) {
    _reminderTime = time;
    notifyListeners();
  }
  
  void updateCurrency(String currency) {
    _currency = currency;
    notifyListeners();
    unawaited(_settings.saveCurrency(currency));
  }

  /// Clears gameplay progress without wiping profile settings.
  Future<void> clearProgressState() async {
    _userLevel = 1;
    _totalXP = 0;
    _streakDays = 0;
    _lastStreakDay = null;
    _lastCompletionDate = null;
    _completedLessons = {};
    _completedTopics = {};
    _classPoints = 0;
    _unlockedGames = List.from(_starterGames);
    _gameData.clear();
    StreakService().resetAllStats();
    ProgressService().resetProgress();
    _syncStreakService();
    notifyListeners();
  }

  Future<void> resetData({String? syncUserId}) async {
    _username = 'Usuario Finance4U';
    _email = 'usuario@finance4u.com';
    _userLevel = 1;
    _totalXP = 0;
    _streakDays = 0;
    _lastStreakDay = null;
    _lastCompletionDate = null;
    _completedLessons = {};
    _completedTopics = {};
    _classPoints = 0;
    _notificationsEnabled = true;
    _reminderTime = '09:00';
    _currency = 'EUR';
    _developerMode = false;
    await _settings.clear();
    _unlockedGames = List.from(_starterGames);
    _gameData.clear();
    StreakService().resetAllStats();
    ProgressService().resetProgress();
    await _localProgress.clear(userId: _progressUserId);
    if (syncUserId != null) {
      try {
        await FirestoreHelper.resetProgressDoc(syncUserId);
      } catch (e) {
        debugPrint('AppProvider.resetData Firestore error: $e');
      }
    }
    _syncStreakService();
    notifyListeners();
  }
} 