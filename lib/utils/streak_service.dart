import 'dart:convert';
import 'package:flutter/material.dart';
import 'streak_day_helper.dart';

class StreakService {
  static final StreakService _instance = StreakService._internal();
  factory StreakService() => _instance;
  StreakService._internal();

  // Estado del streak
  int _currentStreak = 0;
  int _maxStreak = 0;
  int? _lastStreakDay;
  bool _todayActive = false;
  List<int> _activeStreakDays = [];
  
  // Getters
  int get currentStreak => _currentStreak;
  int get maxStreak => _maxStreak;
  bool get todayActive => _todayActive;
  int? get lastStreakDay => _lastStreakDay;
  List<DateTime> get activeDays => _activeStreakDays
      .map((d) => DateTime.fromMillisecondsSinceEpoch(
            d * Duration.millisecondsPerDay,
          ))
      .toList();
  
  // Verificar si el usuario ha estado activo hoy
  bool get hasCompletedToday {
    if (_lastStreakDay == null) return false;
    return _lastStreakDay == StreakDayHelper.currentStreakDay();
  }
  
  // Verificar si la racha está en peligro (ayer no estuvo activo)
  bool get streakAtRisk {
    if (_lastStreakDay == null || _currentStreak == 0) return false;
    return StreakDayHelper.daysSince(_lastStreakDay) == 1 &&
        !hasCompletedToday;
  }
  
  // Días de racha desde el último activo
  int get daysSinceLastActive {
    return StreakDayHelper.daysSince(_lastStreakDay);
  }
  
  // Registrar actividad para hoy
  void markTodayAsActive() {
    final today = StreakDayHelper.currentStreakDay();
    
    // Si ya está marcado como activo hoy, no hacer nada
    if (hasCompletedToday) return;
    
    // Verificar si mantiene la racha
    if (_lastStreakDay != null) {
      final gap = today - _lastStreakDay!;
      
      if (gap == 1) {
        _currentStreak++;
      } else if (gap == 0) {
        return;
      } else {
        _currentStreak = 1;
      }
    } else {
      _currentStreak = 1;
    }
    
    // Actualizar máxima racha
    if (_currentStreak > _maxStreak) {
      _maxStreak = _currentStreak;
    }
    
    _lastStreakDay = today;
    _todayActive = true;
    
    if (!_activeStreakDays.contains(today)) {
      _activeStreakDays.add(today);
    }
    
    final cutoffDay =
        StreakDayHelper.currentStreakDay() - 365;
    _activeStreakDays.removeWhere((day) => day < cutoffDay);
    
    _saveData();
  }
  
  // Verificar y actualizar el estado del streak
  void checkStreakStatus() {
    if (_lastStreakDay == null) return;
    
    if (StreakDayHelper.isStreakBroken(_lastStreakDay)) {
      _currentStreak = 0;
      _todayActive = false;
      _saveData();
    } else if (hasCompletedToday) {
      _todayActive = true;
    } else {
      _todayActive = false;
    }
  }
  
  // Obtener el número de días activos en la semana actual
  int getActiveThisWeek() {
    final today = StreakDayHelper.currentStreakDay();
    final startOfWeekDay = today - (StreakDayHelper.madridWeekday() - 1);

    return _activeStreakDays
        .where((day) => day >= startOfWeekDay && day <= startOfWeekDay + 6)
        .length;
  }
  
  // Obtener el número de días activos en el mes actual
  int getActiveThisMonth() {
    final now = StreakDayHelper.toMadrid(DateTime.now());
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final startDay = StreakDayHelper.streakDayIndex(startOfMonth);
    final endDay = StreakDayHelper.streakDayIndex(endOfMonth);
    
    return _activeStreakDays
        .where((day) => day >= startDay && day <= endDay)
        .length;
  }
  
  // Obtener mensaje motivacional basado en el streak
  String getMotivationalMessage() {
    if (_currentStreak == 0) {
      return "¡Empieza tu racha hoy! 🌟";
    } else if (_currentStreak == 1) {
      return "¡Buen comienzo! Continúa mañana 🔥";
    } else if (_currentStreak < 7) {
      return "¡Vas bien! $_currentStreak días seguidos 💪";
    } else if (_currentStreak < 30) {
      return "¡Increíble! $_currentStreak días de dedicación 🏆";
    } else {
      return "¡Eres una leyenda! $_currentStreak días seguidos 👑";
    }
  }
  
  // Obtener color del streak basado en la duración
  Color getStreakColor() {
    if (_currentStreak == 0) {
      return Colors.grey;
    } else if (_currentStreak < 3) {
      return Colors.orange;
    } else if (_currentStreak < 7) {
      return Colors.red;
    } else if (_currentStreak < 30) {
      return Colors.deepOrange;
    } else {
      return Colors.purple;
    }
  }
  
  // Obtener icono del streak
  IconData getStreakIcon() {
    if (_currentStreak == 0) {
      return Icons.schedule;
    } else if (_currentStreak < 7) {
      return Icons.local_fire_department;
    } else if (_currentStreak < 30) {
      return Icons.whatshot;
    } else {
      return Icons.emoji_events;
    }
  }
  
  // Verificar si es elegible para recordatorio de streak
  bool shouldShowStreakReminder() {
    final madrid = StreakDayHelper.toMadrid(DateTime.now());
    return !hasCompletedToday &&
        _currentStreak > 0 &&
        madrid.hour >= 18;
  }

  /// Obtener progreso de la semana (array de 7 elementos para cada día)
  List<bool> getWeekProgress() {
    final today = StreakDayHelper.currentStreakDay();
    final startOfWeekDay = today - (StreakDayHelper.madridWeekday() - 1);

    return List.generate(7, (i) {
      return _activeStreakDays.contains(startOfWeekDay + i);
    });
  }

  /// Align in-memory streak with persisted [AppProvider] data.
  void syncFromApp({required int streakDays, int? lastStreakDay}) {
    _currentStreak = streakDays;
    _lastStreakDay = lastStreakDay;
    if (streakDays > _maxStreak) _maxStreak = streakDays;
    if (lastStreakDay != null && !_activeStreakDays.contains(lastStreakDay)) {
      _activeStreakDays.add(lastStreakDay);
    }
    checkStreakStatus();
  }
  
  // Resetear el streak (para testing o casos especiales)
  void resetStreak() {
    _currentStreak = 0;
    _todayActive = false;
    _lastStreakDay = null;
    _saveData();
  }
  
  // Resetear estadísticas completas
  void resetAllStats() {
    _currentStreak = 0;
    _maxStreak = 0;
    _todayActive = false;
    _lastStreakDay = null;
    _activeStreakDays.clear();
    _saveData();
  }
  
  // Simular datos de demo
  void initDemoData() {
    final today = StreakDayHelper.currentStreakDay();
    
    for (int i = 1; i <= 5; i++) {
      _activeStreakDays.add(today - i);
    }
    
    _currentStreak = 5;
    _maxStreak = 12;
    _lastStreakDay = today - 1;
    
    _saveData();
  }
  
  // Guardar datos (en implementación real usaría SharedPreferences)
  void _saveData() {
    // Implementar persistencia de datos
    // Por ahora solo mantiene en memoria
  }
  
  // Cargar datos (en implementación real usaría SharedPreferences)
  void _loadData() {
    // Implementar carga de datos
    // Por ahora usa datos demo
  }
  
  // Obtener estadísticas completas
  Map<String, dynamic> getStats() {
    return {
      'currentStreak': _currentStreak,
      'maxStreak': _maxStreak,
      'todayActive': _todayActive,
      'lastStreakDay': _lastStreakDay,
      'activeThisWeek': getActiveThisWeek(),
      'activeThisMonth': getActiveThisMonth(),
      'totalActiveDays': _activeStreakDays.length,
      'streakAtRisk': streakAtRisk,
      'daysSinceLastActive': daysSinceLastActive,
    };
  }
} 