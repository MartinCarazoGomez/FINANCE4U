import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'content_screen.dart';

/// Flujo de personalización que se muestra una única vez tras el tutorial:
/// franja de edad → prueba de nivel → intereses → itinerario resultante.
class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

// ── Datos del flujo ──────────────────────────────────────────────────────────

const List<String> kAgeRanges = ['10-13', '14-17', '18-21', '22-25', '26+'];

class InterestOption {
  final String key;
  final String label;
  final IconData icon;
  const InterestOption(this.key, this.label, this.icon);
}

const List<InterestOption> kInterestOptions = [
  InterestOption('ahorro', 'Ahorro', Icons.savings),
  InterestOption('presupuesto', 'Presupuesto', Icons.attach_money),
  InterestOption('inversion', 'Inversión', Icons.trending_up),
  InterestOption('deuda', 'Deuda', Icons.credit_card),
  InterestOption('emprendimiento', 'Emprendimiento', Icons.business),
  InterestOption('fiscalidad', 'Fiscalidad', Icons.receipt_long),
];

class _PlacementQuestion {
  final int level;
  final String question;
  final List<String> options;
  final int correctIndex;
  const _PlacementQuestion({
    required this.level,
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

/// Construye la prueba de nivel reutilizando la primera pregunta de quiz de un
/// tema representativo de cada nivel (3 preguntas por nivel, 9 en total).
List<_PlacementQuestion> _buildPlacementQuestions() {
  final sources = <int, List<List<EduPill>>>{
    1: [savingsPills, budgetPills, planningPills],
    2: [taxesPills, debtPills, psychologyPills],
    3: [investmentPills, entrepreneurshipPills, realEstatePills],
  };

  final questions = <_PlacementQuestion>[];
  sources.forEach((level, pillLists) {
    for (final pills in pillLists) {
      for (final pill in pills) {
        if (pill.quizzes.isEmpty) continue;
        final quiz = pill.quizzes.first;
        final shuffled = quiz.getShuffledOptions();
        questions.add(_PlacementQuestion(
          level: level,
          question: quiz.question,
          options: shuffled,
          correctIndex: quiz.getCorrectIndexAfterShuffle(shuffled),
        ));
        break;
      }
    }
  });
  return questions;
}

// ── Pantalla ─────────────────────────────────────────────────────────────────

enum _Step { age, test, interests, summary }

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  _Step _step = _Step.age;

  String? _ageRange;

  late final List<_PlacementQuestion> _questions = _buildPlacementQuestions();
  int _questionIndex = 0;
  int? _selectedOption;
  final Map<int, int> _correctByLevel = {1: 0, 2: 0, 3: 0};

  final Set<String> _interests = {};

  bool _saving = false;

  static const _green = Color(0xFF2E7D32);
  static const _greenLight = Color(0xFF4CAF50);
  static const _greenDark = Color(0xFF1B6B4B);

  /// 1 Básico · 2 Intermedio · 3 Avanzado, exigiendo 2 de 3 aciertos por nivel.
  int get _placementLevel {
    if ((_correctByLevel[1] ?? 0) < 2) return 1;
    if ((_correctByLevel[2] ?? 0) < 2) return 1;
    if ((_correctByLevel[3] ?? 0) < 2) return 2;
    return 3;
  }

  void _confirmAnswer() {
    final q = _questions[_questionIndex];
    if (_selectedOption == q.correctIndex) {
      _correctByLevel[q.level] = (_correctByLevel[q.level] ?? 0) + 1;
    }
    setState(() {
      _selectedOption = null;
      if (_questionIndex < _questions.length - 1) {
        _questionIndex++;
      } else {
        _step = _Step.interests;
      }
    });
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      await context.read<AuthProvider>().completePersonalization(
            ageRange: _ageRange!,
            interests: _interests.toList(),
            placementLevel: _placementLevel,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar. Comprueba tu conexión e inténtalo de nuevo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBF7),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: switch (_step) {
                    _Step.age => _buildAgeStep(),
                    _Step.test => _buildTestStep(),
                    _Step.interests => _buildInterestsStep(),
                    _Step.summary => _buildSummaryStep(),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const titles = {
      _Step.age: 'Tu franja de edad',
      _Step.test: 'Prueba de nivel',
      _Step.interests: 'Tus intereses',
      _Step.summary: 'Itinerario personalizado',
    };
    const subtitles = {
      _Step.age: 'Determina el registro, los ejemplos y el tono del contenido.',
      _Step.test: 'Sitúa tu punto de partida real, con independencia de la edad.',
      _Step.interests: 'Materias que quieres abordar. Fijan el orden de los contenidos.',
      _Step.summary: 'Así hemos construido tu itinerario.',
    };

    final stepNumber = _Step.values.indexOf(_step) + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_green, _greenLight],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (int i = 1; i <= 4; i++) ...[
                Expanded(
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: i <= stepNumber
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (i < 4) const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 18),
          Text(
            _step == _Step.summary ? titles[_step]! : 'Paso $stepNumber · ${titles[_step]!}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitles[_step]!,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── Paso 1 · Edad ──────────────────────────────────────────────────────────

  Widget _buildAgeStep() {
    return ListView(
      key: const ValueKey('age'),
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '¿Cuántos años tienes?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _greenDark,
          ),
        ),
        const SizedBox(height: 16),
        for (final range in kAgeRanges) ...[
          _SelectableCard(
            selected: _ageRange == range,
            onTap: () => setState(() => _ageRange = range),
            child: Row(
              children: [
                Icon(
                  _ageRange == range
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: _ageRange == range ? _green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  '$range años',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        _PrimaryButton(
          label: 'Continuar',
          enabled: _ageRange != null,
          onPressed: () => setState(() => _step = _Step.test),
        ),
      ],
    );
  }

  // ── Paso 2 · Prueba de nivel ───────────────────────────────────────────────

  Widget _buildTestStep() {
    final q = _questions[_questionIndex];
    return ListView(
      key: ValueKey('test_$_questionIndex'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Pregunta ${_questionIndex + 1} de ${_questions.length}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _greenDark,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_questionIndex + 1) / _questions.length,
          backgroundColor: _green.withValues(alpha: 0.15),
          valueColor: const AlwaysStoppedAnimation<Color>(_green),
          borderRadius: BorderRadius.circular(3),
          minHeight: 6,
        ),
        const SizedBox(height: 20),
        Text(
          q.question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < q.options.length; i++) ...[
          _SelectableCard(
            selected: _selectedOption == i,
            onTap: () => setState(() => _selectedOption = i),
            child: Text(
              q.options[i],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        _PrimaryButton(
          label: _questionIndex < _questions.length - 1
              ? 'Siguiente'
              : 'Terminar prueba',
          enabled: _selectedOption != null,
          onPressed: _confirmAnswer,
        ),
      ],
    );
  }

  // ── Paso 3 · Intereses ─────────────────────────────────────────────────────

  Widget _buildInterestsStep() {
    return ListView(
      key: const ValueKey('interests'),
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '¿Qué materias quieres abordar?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _greenDark,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Elige al menos una. Podrás ver todos los temas igualmente.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        for (final option in kInterestOptions) ...[
          _SelectableCard(
            selected: _interests.contains(option.key),
            onTap: () => setState(() {
              if (!_interests.add(option.key)) _interests.remove(option.key);
            }),
            child: Row(
              children: [
                Icon(
                  option.icon,
                  color: _interests.contains(option.key) ? _green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _interests.contains(option.key)
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: _interests.contains(option.key) ? _green : Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        _PrimaryButton(
          label: 'Continuar',
          enabled: _interests.isNotEmpty,
          onPressed: () => setState(() => _step = _Step.summary),
        ),
      ],
    );
  }

  // ── Paso 4 · Resumen ───────────────────────────────────────────────────────

  Widget _buildSummaryStep() {
    const levelNames = {1: 'Básico', 2: 'Intermedio', 3: 'Avanzado'};
    final level = _placementLevel;
    final interestLabels = kInterestOptions
        .where((o) => _interests.contains(o.key))
        .map((o) => o.label)
        .join(', ');

    return ListView(
      key: const ValueKey('summary'),
      padding: const EdgeInsets.all(20),
      children: [
        _SummaryTile(
          icon: Icons.cake_outlined,
          title: 'Franja de edad',
          value: '$_ageRange años',
          detail: 'Adaptaremos el lenguaje y los ejemplos a tu edad.',
        ),
        _SummaryTile(
          icon: Icons.speed,
          title: 'Nivel de partida',
          value: levelNames[level]!,
          detail: level == 1
              ? 'Empezarás por el nivel Básico y desbloquearás el resto con tu progreso.'
              : 'Has demostrado dominio: el nivel ${levelNames[level]} ya está desbloqueado desde el inicio.',
        ),
        _SummaryTile(
          icon: Icons.star_outline,
          title: 'Intereses',
          value: interestLabels,
          detail: 'Estos temas aparecerán primero dentro de cada nivel.',
        ),
        const SizedBox(height: 16),
        _PrimaryButton(
          label: _saving ? 'Guardando…' : 'Empezar mi itinerario',
          enabled: !_saving,
          onPressed: _finish,
        ),
      ],
    );
  }
}

// ── Widgets auxiliares ───────────────────────────────────────────────────────

class _SelectableCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  const _SelectableCard({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String detail;
  const _SummaryTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD6F5E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1B6B4B)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B6B4B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
