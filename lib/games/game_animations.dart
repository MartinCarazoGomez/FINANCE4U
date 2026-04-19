import 'package:flutter/material.dart';

class GameAnimations {
  // Animación de respuesta correcta
  static Widget correctAnswerAnimation(Widget child) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (value * 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(value * 0.3),
                  blurRadius: value * 20,
                  spreadRadius: value * 5,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Animación de respuesta incorrecta
  static Widget incorrectAnswerAnimation(Widget child) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        double shake = 0.0;
        if (value < 0.8) {
          shake = (value * 10) % 1.0 > 0.5 ? 5.0 : -5.0;
        }
        
        return Transform.translate(
          offset: Offset(shake, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withOpacity(value),
                width: 2,
              ),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Animación de carga de progreso
  static Widget progressAnimation(double progress, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: progress),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          children: [
            LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        );
      },
    );
  }

  // Animación de puntuación
  static Widget scoreAnimation(int score) {
    return TweenAnimationBuilder<int>(
      duration: const Duration(milliseconds: 1000),
      tween: IntTween(begin: 0, end: score),
      builder: (context, value, child) {
        return Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B6B4B),
              ),
            ),
            const Text(
              'puntos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }

  // Animación de aparición de elementos
  static Widget slideInAnimation(Widget child, {int delayMs = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delayMs),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Animación de botón pulsado
  static Widget buttonPressAnimation(Widget child, bool isPressed) {
    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: child,
      ),
    );
  }

  // Animación de confeti para celebración
  static Widget confettiAnimation() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Stack(
          children: List.generate(20, (index) {
            final random = (index * 123.456) % 1.0;
            final startX = random * MediaQuery.of(context).size.width;
            final endY = MediaQuery.of(context).size.height + 100;
            
            return Positioned(
              left: startX,
              top: -100 + (value * (endY + 200)),
              child: Transform.rotate(
                angle: value * 6.28 * (2 + random),
                child: Container(
                  width: 8 + (random * 4),
                  height: 8 + (random * 4),
                  decoration: BoxDecoration(
                    color: [
                      Colors.yellow,
                      Colors.pink,
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                    ][index % 5],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // Animación de pulso para elementos importantes
  static Widget pulseAnimation(Widget child) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final pulse = (value * 2) % 1.0;
        final scale = 1.0 + (pulse * 0.05);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  // Animación de deslizamiento lateral
  static Widget slideFromSide(Widget child, {bool fromLeft = true}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final offset = fromLeft ? -200.0 * (1 - value) : 200.0 * (1 - value);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
} 