import 'package:flutter/material.dart';
import '../utils/progress_service.dart';

class AppProvider extends ChangeNotifier {
  String _selectedLanguage = 'es';
  bool _isDarkMode = false;
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  double _fontSize = 16.0;
  
  // User Progress
  String _username = 'Usuario Finance4U';
  String _email = 'usuario@finance4u.com';
  int _userLevel = 1;
  int _totalXP = 0;
  int _streakDays = 0;
  Set<String> _completedLessons = {};
  List<String> _unlockedGames = [
    'budget_master',
    'credit_score', 
    'debt_destroyer',
    'emergency_fund',
    'entrepreneur',
    'trading',
    'real_estate',
    'insurance',
    'retirement',
    'smart_shopper'
  ];
  
  // Datos de juegos (alternativa a SharedPreferences)
  Map<String, dynamic> _gameData = {};
  
  // Configuraciones
  String _reminderTime = '09:00';
  String _currency = 'MXN';
  
  // Getters
  String get selectedLanguage => _selectedLanguage;
  bool get isDarkMode => _isDarkMode;
  bool get soundEnabled => _soundEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  double get fontSize => _fontSize;
  String get username => _username;
  String get email => _email;
  int get userLevel => _userLevel;
  int get totalXP => _totalXP;
  int get streakDays => _streakDays;
  Set<String> get completedLessons => _completedLessons;
  List<String> get unlockedGames => List.unmodifiable(_unlockedGames);
  String get reminderTime => _reminderTime;
  String get currency => _currency;
  
  // Methods
  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
  
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
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
  
  void completeLesson(String lessonId) {
    _completedLessons.add(lessonId);
    addXP(10);
    notifyListeners();
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
  
  // Métodos para formateo de moneda (simplificados)
  String formatCurrency(double amount) {
    switch (_currency) {
      case 'MXN':
        return '\$${amount.toStringAsFixed(2)} MXN';
      case 'USD':
        return '\$${amount.toStringAsFixed(2)} USD';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)} EUR';
      case 'COP':
        return '\$${amount.toStringAsFixed(0)} COP';
      case 'ARS':
        return '\$${amount.toStringAsFixed(2)} ARS';
      case 'CLP':
        return '\$${amount.toStringAsFixed(0)} CLP';
      default:
        return '\$${amount.toStringAsFixed(2)}';
    }
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
  }
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void resetData() {
    _username = 'Usuario Finance4U';
    _email = 'usuario@finance4u.com';
    _userLevel = 1;
    _totalXP = 0;
    _streakDays = 0;
    _notificationsEnabled = true;
    _reminderTime = '09:00';
    _currency = 'MXN';
    _isDarkMode = false;
    _unlockedGames = [
      'budget_master',
      'credit_score', 
      'debt_destroyer',
      'emergency_fund',
      'entrepreneur',
      'trading',
      'real_estate',
      'insurance',
      'retirement',
      'smart_shopper'
    ];
    _gameData.clear();
    notifyListeners();
  }
} 