import 'package:flutter/services.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;
  
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  // Vibración ligera para feedback general
  void lightImpact() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
  }

  // Vibración media para acciones importantes
  void mediumImpact() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
  }

  // Vibración fuerte para eventos muy importantes
  void heavyImpact() {
    if (!_isEnabled) return;
    HapticFeedback.heavyImpact();
  }

  // Feedback de selección (para botones, etc.)
  void selectionClick() {
    if (!_isEnabled) return;
    HapticFeedback.selectionClick();
  }

  // Feedback para respuesta correcta
  void correctAnswer() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isEnabled) HapticFeedback.lightImpact();
    });
  }

  // Feedback para respuesta incorrecta
  void wrongAnswer() {
    if (!_isEnabled) return;
    HapticFeedback.heavyImpact();
  }

  // Feedback para logro desbloqueado
  void achievementUnlocked() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_isEnabled) HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_isEnabled) HapticFeedback.lightImpact();
    });
  }

  // Feedback para subir de nivel
  void levelUp() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isEnabled) HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_isEnabled) HapticFeedback.heavyImpact();
    });
  }

  // Feedback para completar una lección
  void lessonCompleted() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_isEnabled) HapticFeedback.lightImpact();
    });
  }

  // Feedback para error o warning
  void error() {
    if (!_isEnabled) return;
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_isEnabled) HapticFeedback.heavyImpact();
    });
  }

  // Feedback suave para navegación
  void navigationFeedback() {
    if (!_isEnabled) return;
    HapticFeedback.selectionClick();
  }

  // Feedback para botones importantes
  void buttonPress() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
  }

  // Feedback para abrir/cerrar elementos
  void toggle() {
    if (!_isEnabled) return;
    HapticFeedback.selectionClick();
  }

  // Feedback para swipe o gestos
  void swipeGesture() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
  }

  // Feedback para drag and drop
  void dragStart() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
  }

  void dragEnd() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
  }

  // Feedback para notificaciones
  void notification() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
  }

  // Feedback personalizado con patrón de vibración
  void customPattern(List<int> pattern) {
    if (!_isEnabled) return;
    
    for (int i = 0; i < pattern.length; i++) {
      Future.delayed(Duration(milliseconds: pattern[i] * 50), () {
        if (!_isEnabled) return;
        
        switch (i % 3) {
          case 0:
            HapticFeedback.lightImpact();
            break;
          case 1:
            HapticFeedback.mediumImpact();
            break;
          case 2:
            HapticFeedback.heavyImpact();
            break;
        }
      });
    }
  }

  // Patrones predefinidos
  void celebrationPattern() {
    customPattern([1, 2, 1, 3, 1, 2, 1]);
  }

  void warningPattern() {
    customPattern([3, 3, 3]);
  }

  void successPattern() {
    customPattern([1, 1, 2]);
  }

  void failurePattern() {
    customPattern([3, 1, 3]);
  }
} 