import 'dart:convert';
import 'package:flutter/material.dart';

class StreakService {
  static final StreakService _instance = StreakService._internal();
  factory StreakService() => _instance;
  StreakService._internal();

  // Estado del streak
  int _currentStreak = 0;
  int _maxStreak = 0;
  DateTime? _lastActiveDate;
  bool _todayActive = false;
  List<DateTime> _activeDays = [];
  
  // Getters
  int get currentStreak => _currentStreak;
  int get maxStreak => _maxStreak;
  bool get todayActive => _todayActive;
  DateTime? get lastActiveDate => _lastActiveDate;
  List<DateTime> get activeDays => List.from(_activeDays);
  
  // Verificar si el usuario ha estado activo hoy
  bool get hasCompletedToday {
    if (_lastActiveDate == null) return false;
    final today = DateTime.now();
    final lastActive = _lastActiveDate!;
    return lastActive.year == today.year &&
           lastActive.month == today.month &&
           lastActive.day == today.day;
  }
  
  // Verificar si la racha está en peligro (ayer no estuvo activo)
  bool get streakAtRisk {
    if (_lastActiveDate == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final lastActive = _lastActiveDate!;
    return !(lastActive.year == yesterday.year &&
             lastActive.month == yesterday.month &&
             lastActive.day == yesterday.day) && !hasCompletedToday;
  }
  
  // Días consecutivos desde el último activo
  int get daysSinceLastActive {
    if (_lastActiveDate == null) return 999;
    final now = DateTime.now();
    final difference = now.difference(_lastActiveDate!);
    return difference.inDays;
  }
  
  // Registrar actividad para hoy
  void markTodayAsActive() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Si ya está marcado como activo hoy, no hacer nada
    if (hasCompletedToday) return;
    
    // Verificar si mantiene la racha
    if (_lastActiveDate != null) {
      final daysSince = daysSinceLastActive;
      
      if (daysSince == 1) {
        // Mantiene la racha (ayer estuvo activo)
        _currentStreak++;
      } else if (daysSince == 0) {
        // Ya está activo hoy
        return;
      } else {
        // Perdió la racha
        _currentStreak = 1;
      }
    } else {
      // Primera vez que se registra actividad
      _currentStreak = 1;
    }
    
    // Actualizar máxima racha
    if (_currentStreak > _maxStreak) {
      _maxStreak = _currentStreak;
    }
    
    // Actualizar datos
    _lastActiveDate = todayDate;
    _todayActive = true;
    
    // Agregar a la lista de días activos
    if (!_activeDays.any((date) => 
        date.year == todayDate.year &&
        date.month == todayDate.month &&
        date.day == todayDate.day)) {
      _activeDays.add(todayDate);
    }
    
    // Mantener solo los últimos 365 días
    final cutoffDate = DateTime.now().subtract(const Duration(days: 365));
    _activeDays.removeWhere((date) => date.isBefore(cutoffDate));
    
    _saveData();
  }
  
  // Verificar y actualizar el estado del streak
  void checkStreakStatus() {
    if (_lastActiveDate == null) return;
    
    final daysSince = daysSinceLastActive;
    
    // Si han pasado más de 1 día sin actividad, pierde la racha
    if (daysSince > 1) {
      _currentStreak = 0;
      _todayActive = false;
      _saveData();
    } else if (daysSince == 0) {
      // Está activo hoy
      _todayActive = true;
    } else {
      // Ayer estuvo activo, hoy no
      _todayActive = false;
    }
  }
  
  // Obtener el número de días activos en la semana actual
  int getActiveThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return _activeDays.where((date) => 
        date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)))).length;
  }
  
  // Obtener el número de días activos en el mes actual
  int getActiveThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return _activeDays.where((date) => 
        date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfMonth.add(const Duration(days: 1)))).length;
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
    // Mostrar recordatorio si:
    // 1. No ha estado activo hoy
    // 2. Tiene una racha actual > 0
    // 3. Son después de las 6 PM
    final now = DateTime.now();
    return !hasCompletedToday && 
           _currentStreak > 0 && 
           now.hour >= 18;
  }
  
  // Obtener progreso de la semana (array de 7 elementos para cada día)
  List<bool> getWeekProgress() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    List<bool> progress = [];
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayDate = DateTime(day.year, day.month, day.day);
      final isActive = _activeDays.any((date) => 
          date.year == dayDate.year &&
          date.month == dayDate.month &&
          date.day == dayDate.day);
      progress.add(isActive);
    }
    
    return progress;
  }
  
  // Resetear el streak (para testing o casos especiales)
  void resetStreak() {
    _currentStreak = 0;
    _todayActive = false;
    _lastActiveDate = null;
    _saveData();
  }
  
  // Resetear estadísticas completas
  void resetAllStats() {
    _currentStreak = 0;
    _maxStreak = 0;
    _todayActive = false;
    _lastActiveDate = null;
    _activeDays.clear();
    _saveData();
  }
  
  // Simular datos de demo
  void initDemoData() {
    final now = DateTime.now();
    
    // Simular actividad de los últimos días
    for (int i = 1; i <= 5; i++) {
      final date = now.subtract(Duration(days: i));
      _activeDays.add(DateTime(date.year, date.month, date.day));
    }
    
    _currentStreak = 5;
    _maxStreak = 12;
    _lastActiveDate = DateTime(now.year, now.month, now.day - 1);
    
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
      'lastActiveDate': _lastActiveDate?.toIso8601String(),
      'activeThisWeek': getActiveThisWeek(),
      'activeThisMonth': getActiveThisMonth(),
      'totalActiveDays': _activeDays.length,
      'streakAtRisk': streakAtRisk,
      'daysSinceLastActive': daysSinceLastActive,
    };
  }
} 