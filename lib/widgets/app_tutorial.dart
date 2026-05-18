import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
// Data
// ──────────────────────────────────────────────

class _StepData {
  final String emoji;
  final String title;
  final String description;

  /// If not null, switches to this bottom-nav tab when the step is shown.
  final int? navTabIndex;

  /// If not null, draws a spotlight on that bottom-nav item (0–4).
  final int? spotlightNavTab;

  /// If true, draws a spotlight on the top-right menu (⋮) area.
  final bool spotlightMenu;

  const _StepData({
    required this.emoji,
    required this.title,
    required this.description,
    this.navTabIndex,
    this.spotlightNavTab,
    this.spotlightMenu = false,
  });
}

const List<_StepData> _steps = [
  _StepData(
    emoji: '👋',
    title: '¡Bienvenido a Finance4U!',
    description:
        'Te vamos a guiar por todas las secciones de la app para que '
        'puedas sacarle el máximo partido desde el primer momento. '
        '¡Solo te llevará un minuto!',
  ),
  _StepData(
    emoji: '📚',
    title: 'Contenido',
    description:
        'Aprende finanzas con lecciones organizadas por temas: ahorros, '
        'inversiones, presupuesto, deudas y más. Completa píldoras de '
        'conocimiento y mini-quizzes para ganar XP.',
    navTabIndex: 0,
    spotlightNavTab: 0,
  ),
  _StepData(
    emoji: '🎮',
    title: 'Juegos',
    description:
        'Practica lo aprendido con juegos financieros interactivos. '
        'Simula presupuestos, invierte en bolsa, gestiona deudas y '
        'desbloquea nuevos retos ganando XP.',
    navTabIndex: 1,
    spotlightNavTab: 1,
  ),
  _StepData(
    emoji: '📰',
    title: 'Noticias',
    description:
        'Mantente al día con artículos del mundo financiero '
        'seleccionados para ayudarte a entender la economía actual.',
    navTabIndex: 2,
    spotlightNavTab: 2,
  ),
  _StepData(
    emoji: '👥',
    title: 'Comunidad',
    description:
        'Conéctate con otros estudiantes de finanzas. Comparte tus '
        'avances, haz preguntas y aprende de las experiencias de otros.',
    navTabIndex: 3,
    spotlightNavTab: 3,
  ),
  _StepData(
    emoji: '🏆',
    title: 'Clase',
    description:
        'Compite en el ranking semanal con otros usuarios y acepta '
        'desafíos especiales. ¿Puedes llegar al número 1?',
    navTabIndex: 4,
    spotlightNavTab: 4,
  ),
  _StepData(
    emoji: '⚙️',
    title: 'Más opciones',
    description:
        'Desde Contenido, toca el menú (⋮) en la esquina superior '
        'derecha para acceder a tus Logros, Estadísticas, Práctica '
        'rápida y Ajustes.',
    navTabIndex: 0,
    spotlightMenu: true,
  ),
  _StepData(
    emoji: '🚀',
    title: '¡Todo listo!',
    description:
        'Ya conoces Finance4U. Empieza tu primera lección, juega un '
        'poco y sigue creciendo. ¡Las finanzas nunca habían sido tan '
        'divertidas!',
  ),
];

// ──────────────────────────────────────────────
// Main widget
// ──────────────────────────────────────────────

class AppTutorial extends StatefulWidget {
  final VoidCallback onComplete;
  final ValueChanged<int> onTabChange;

  const AppTutorial({
    super.key,
    required this.onComplete,
    required this.onTabChange,
  });

  @override
  State<AppTutorial> createState() => _AppTutorialState();
}

class _AppTutorialState extends State<AppTutorial>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep >= _steps.length - 1) {
      widget.onComplete();
      return;
    }
    _fadeCtrl.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _currentStep++;
        final tab = _steps[_currentStep].navTabIndex;
        if (tab != null) widget.onTabChange(tab);
      });
      _fadeCtrl.forward();
    });
  }

  void _skip() => widget.onComplete();

  Rect _spotlightRect(BuildContext context, _StepData step) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;

    if (step.spotlightNavTab != null) {
      const navH = kBottomNavigationBarHeight;
      final itemW = size.width / 5;
      final left = itemW * step.spotlightNavTab!;
      final top = size.height - pad.bottom - navH;
      return Rect.fromLTWH(left, top, itemW, navH + pad.bottom);
    }

    if (step.spotlightMenu) {
      return Rect.fromLTWH(
        size.width - 60,
        pad.top,
        60,
        kToolbarHeight,
      );
    }

    return Rect.zero;
  }

  double _cardTop(BuildContext context, _StepData step) {
    final pad = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;

    if (step.spotlightNavTab != null) {
      return pad.top + 36;
    }
    if (step.spotlightMenu) {
      return pad.top + kToolbarHeight + 16;
    }
    return size.height * 0.22;
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final spotlight = _spotlightRect(context, step);
    final cardTop = _cardTop(context, step);
    final isLast = _currentStep == _steps.length - 1;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        children: [
          // Background touch absorber
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: const SizedBox.expand(),
          ),

          // Dimmed overlay with spotlight cutout
          IgnorePointer(
            child: CustomPaint(
              painter: _OverlayPainter(spotlight),
              child: const SizedBox.expand(),
            ),
          ),

          // Pulsing border around spotlight
          if (spotlight != Rect.zero)
            IgnorePointer(
              child: Positioned(
                left: spotlight.left - 3,
                top: spotlight.top - 3,
                width: spotlight.width + 6,
                height: spotlight.height + 6,
                child: const _PulsingBorder(),
              ),
            ),

          // Tutorial card
          Positioned(
            left: 20,
            right: 20,
            top: cardTop,
            child: _TutorialCard(
              step: step,
              current: _currentStep,
              total: _steps.length,
              isLast: isLast,
              onNext: _next,
              onSkip: isLast ? null : _skip,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Spotlight painter
// ──────────────────────────────────────────────

class _OverlayPainter extends CustomPainter {
  final Rect spotlight;
  const _OverlayPainter(this.spotlight);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black.withValues(alpha: 0.76),
    );

    if (spotlight != Rect.zero) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(spotlight.inflate(2), const Radius.circular(10)),
        Paint()..blendMode = BlendMode.clear,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_OverlayPainter old) => old.spotlight != spotlight;
}

// ──────────────────────────────────────────────
// Pulsing border
// ──────────────────────────────────────────────

class _PulsingBorder extends StatefulWidget {
  const _PulsingBorder();

  @override
  State<_PulsingBorder> createState() => _PulsingBorderState();
}

class _PulsingBorderState extends State<_PulsingBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.4 + 0.6 * _anim.value),
            width: 3,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Tutorial card
// ──────────────────────────────────────────────

class _TutorialCard extends StatelessWidget {
  final _StepData step;
  final int current;
  final int total;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const _TutorialCard({
    required this.step,
    required this.current,
    required this.total,
    required this.isLast,
    required this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress dots
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(total, (i) {
                  final active = i == current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFDDE0D8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 18),

            // Emoji
            Text(step.emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 6),

            // Title
            Text(
              step.title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B5E20),
                height: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              step.description,
              style: const TextStyle(
                fontSize: 14.5,
                color: Color(0xFF424242),
                height: 1.55,
              ),
            ),

            const SizedBox(height: 22),

            // Buttons
            Row(
              children: [
                if (onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9E9E9E),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    child: const Text(
                      'Saltar',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isLast ? '¡Empezar! 🚀' : 'Siguiente →',
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
