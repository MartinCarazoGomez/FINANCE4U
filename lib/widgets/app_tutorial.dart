import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
// Public API
// ──────────────────────────────────────────────

/// Shows the onboarding tutorial in an isolated full-screen route so taps are
/// not affected by the scaffold or Provider rebuilds underneath.
Future<void> showAppTutorial(
  BuildContext context, {
  required ValueChanged<int> onTabChange,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (dialogContext, _, __) {
      return PopScope(
        canPop: false,
        child: AppTutorial(
          onComplete: () => Navigator.of(dialogContext).pop(),
          onTabChange: onTabChange,
        ),
      );
    },
  );
}

// ──────────────────────────────────────────────
// Data
// ──────────────────────────────────────────────

class _StepData {
  final String emoji;
  final String title;
  final String description;
  final int? navTabIndex;
  final int? spotlightNavTab;
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

class _AppTutorialState extends State<AppTutorial> {
  int _currentStep = 0;

  void _next() {
    if (_currentStep >= _steps.length - 1) {
      widget.onComplete();
      return;
    }

    final nextStep = _currentStep + 1;
    final tab = _steps[nextStep].navTabIndex;
    if (tab != null) widget.onTabChange(tab);

    setState(() => _currentStep = nextStep);
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

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final spotlight = _spotlightRect(context, step);
    final isLast = _currentStep == _steps.length - 1;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen tap blocker + dim overlay (visual hole only).
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: CustomPaint(
                painter: _OverlayPainter(spotlight),
                child: const SizedBox.expand(),
              ),
            ),
          ),

          if (spotlight != Rect.zero)
            Positioned(
              left: spotlight.left - 3,
              top: spotlight.top - 3,
              width: spotlight.width + 6,
              height: spotlight.height + 6,
              child: IgnorePointer(
                child: const _PulsingBorder(),
              ),
            ),

          SafeArea(
            child: Align(
              alignment: step.spotlightNavTab != null || step.spotlightMenu
                  ? Alignment.topCenter
                  : const Alignment(0, -0.35),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  step.spotlightNavTab != null || step.spotlightMenu ? 12 : 0,
                  20,
                  20,
                ),
                child: _TutorialCard(
                  key: ValueKey(_currentStep),
                  step: step,
                  current: _currentStep,
                  total: _steps.length,
                  isLast: isLast,
                  onNext: _next,
                  onSkip: isLast ? null : _skip,
                ),
              ),
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
    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.76);
    final fullRect = Offset.zero & size;

    if (spotlight == Rect.zero) {
      canvas.drawRect(fullRect, dimPaint);
      return;
    }

    final overlay = Path()..addRect(fullRect);
    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          spotlight.inflate(2),
          const Radius.circular(10),
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, overlay, hole),
      dimPaint,
    );
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
            color: const Color(0xFF66BB6A)
                .withValues(alpha: 0.4 + 0.6 * _anim.value),
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
    super.key,
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
      elevation: 16,
      shadowColor: Colors.black54,
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(step.emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 6),
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
            Text(
              step.description,
              style: const TextStyle(
                fontSize: 14.5,
                color: Color(0xFF424242),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                if (onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9E9E9E),
                      minimumSize: const Size(64, 48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Saltar',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
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
