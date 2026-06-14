import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/currency_helper.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// UN MES DE TU VIDA — Simulador de gastos del día a día
///
/// A realistic, hour-by-hour life simulator styled like a banking app. Each
/// month the salary lands and fixed bills are paid; then you live a work week
/// (Mon–Sun). Through each day the clock advances and you make real micro
/// decisions — commute, coffee, lunch, weekend trips — that quietly add up.
/// At the end you allocate what's left to your emergency fund / savings.
///
/// Teaches: the "latte factor" (small daily costs add up), needs vs wants,
/// emergency fund, overdraft/debt, and savings rate — all from real choices.
/// ─────────────────────────────────────────────────────────────────────────

class BudgetMasterGame extends StatefulWidget {
  final VoidCallback? onCompleted;

  const BudgetMasterGame({super.key, this.onCompleted});

  @override
  State<BudgetMasterGame> createState() => _BudgetMasterGameState();
}

enum _Phase { intro, payday, day, dayEnd, allocate, summary }

class _Choice {
  final String emoji;
  final String label;
  final double cost;
  final String cat;
  final String kind; // 'normal' | 'transit' | 'gym' | 'streaming' | 'laundry' | 'weekend_trip' | 'income'
  final String? note;

  const _Choice(
    this.emoji,
    this.label,
    this.cost,
    this.cat, {
    this.kind = 'normal',
    this.note,
  });
}

class _Moment {
  final String time;
  final String icon;
  final String title;
  final String text;
  final List<_Choice> choices; // empty => flavor "continue" step

  const _Moment({
    required this.time,
    required this.icon,
    required this.title,
    required this.text,
    this.choices = const [],
  });
}

class _BudgetMasterGameState extends State<BudgetMasterGame>
    with TickerProviderStateMixin {
  // ── config ────────────────────────────────────────────────────────────────
  static const double _salary = 1600;
  static const Color _brand = Color(0xFF12796E);
  static const Color _brandDark = Color(0xFF0C5249);
  static const List<String> _dayNames = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  // monthly fixed costs (paid at payday)
  double _currentRent = 550;
  static const double _utilities = 90;
  static const double _phone = 35;
  static const double _groceries = 220;
  double get _fixedTotal => _currentRent + _utilities + _phone + _groceries;
  double get _emergencyTarget => _fixedTotal * 2;

  static const Map<String, List<String>> _catMeta = {
    'fijos': ['🏠', 'Gastos fijos'],
    'transporte': ['🚌', 'Transporte'],
    'café': ['☕', 'Cafés'],
    'comida': ['🍽️', 'Comidas'],
    'snacks': ['🍪', 'Snacks y meriendas'],
    'suscripciones': ['📺', 'Suscripciones'],
    'imprevistos': ['⚡', 'Imprevistos'],
    'viajes': ['✈️', 'Viajes y escapadas'],
    'ocio': ['🌆', 'Ocio'],
  };

  // ── account state (persists across months in a run) ─────────────────────
  _Phase _phase = _Phase.intro;
  int _introStep = 0;
  int _month = 1;

  double _checking = 0;
  double _savings = 0;
  double _emergency = 0;
  double _debt = 0;
  double _health = 60;

  // month/week state
  bool _passBought = false;
  bool _gymJoined = false;
  bool _streamingSub = false;
  bool _laundryDone = false;
  bool _weekendTripBooked = false;
  int _dayIndex = 0;
  List<_Moment> _moments = const [];
  int _momentIndex = 0;
  double _daySpent = 0;
  final Map<String, double> _spentByCat = {};

  // allocation
  double _toEmergency = 0;
  double _toSavings = 0;

  // tracking for summary
  bool _overdraftMonth = false;
  double _savedThisMonth = 0;
  double _earnedThisMonth = 0;
  double _healthDelta = 0;
  double _balanceAnimFrom = 0;

  bool _awarded = false;
  String _grade = '';

  late final AnimationController _fade;

  static const List<Map<String, String>> _introCards = [
    {
      'icon': '🌅',
      'title': 'Un mes de tu vida',
      'text':
          'Vivirás la semana hora a hora — laboral y finde. Cada decisión, del café a una escapada, afecta a tu bolsillo.',
    },
    {
      'icon': '🐜',
      'title': 'Los gastos hormiga',
      'text':
          'Un café aquí, una comida fuera allá… parecen poco, pero al final del mes suman mucho. ¡Vas a verlo!',
    },
    {
      'icon': '🛟',
      'title': 'Tu colchón',
      'text':
          'Lo que no gastes puede ir a tu fondo de emergencia. La meta: 2 meses de gastos fijos.',
    },
    {
      'icon': '🧳',
      'title': 'El finde también cuenta',
      'text':
          'Escapadas, viajes y planes de sábado y domingo pueden costar más que toda la semana laboral. ¡Elige con cabeza!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  String _m(double eur) => context.money(eur, compact: false);

  // ── intro ──────────────────────────────────────────────────────────────────
  void _nextIntro() {
    HapticFeedback.selectionClick();
    if (_introStep >= _introCards.length - 1) {
      _startMonth();
    } else {
      setState(() => _introStep++);
      _fade
        ..reset()
        ..forward();
    }
  }

  // ── month / payday ──────────────────────────────────────────────────────
  void _startMonth() {
    if (_debt > 0) _debt = (_debt * 1.03).roundToDouble();
    if (_month > 1 && (_month - 1) % 4 == 0) _currentRent += 25;
    _passBought = false;
    _laundryDone = false;
    _weekendTripBooked = false;
    _overdraftMonth = false;
    _savedThisMonth = 0;
    _earnedThisMonth = 0;
    _daySpent = 0;
    _spentByCat.clear();
    _balanceAnimFrom = _checking;
    setState(() => _phase = _Phase.payday);
  }

  double get _subscriptionRenewals {
    var total = 0.0;
    if (_gymJoined) total += 50;
    if (_streamingSub) total += 12.99;
    return total;
  }

  double get _variablePaydayCost => _month.isEven ? 48 : 0; // seguro coche meses pares

  void _collectAndPayFixed() {
    HapticFeedback.mediumImpact();
    _balanceAnimFrom = _checking;
    final subs = _subscriptionRenewals;
    final variable = _variablePaydayCost;
    setState(() {
      _checking += _salary;
      _checking -= _fixedTotal;
      _checking -= subs;
      _checking -= variable;
      _spentByCat['fijos'] = _fixedTotal;
      if (subs > 0) _spentByCat['suscripciones'] = subs;
      if (variable > 0) _spentByCat['imprevistos'] = variable;
      _dayIndex = 0;
      _moments = _buildDay(0);
      _momentIndex = 0;
      _phase = _Phase.day;
    });
  }

  // ── day generation ─────────────────────────────────────────────────────────
  String _randTime(math.Random rng, int hMin, int hMax) {
    final hour = hMin + rng.nextInt(hMax - hMin + 1);
    final mins = ['00', '15', '30', '45'][rng.nextInt(4)];
    return '$hour:$mins';
  }

  List<_Moment> _buildDay(int i) {
    if (i == 5) return _buildSaturday();
    if (i == 6) return _buildSunday();
    return _buildWeekday(i, math.Random(_month * 31 + i * 7));
  }

  List<_Moment> _buildWeekday(int i, math.Random rng) {
    final day = _dayNames[i];
    final isFriday = i == 4;
    final moments = <_Moment>[
      _Moment(
        time: '07:30',
        icon: '⏰',
        title: '$day por la mañana',
        text: 'Suena el despertador. Te duchas y sales con prisa.',
      ),
      const _Moment(
        time: '07:50',
        icon: '🥐',
        title: 'Desayuno',
        text: '¿Qué haces antes de salir?',
        choices: [
          _Choice('🏠', 'En casa', 0, 'comida',
              note: 'incluido en la compra del mes'),
          _Choice('🥖', 'Panadería de camino', 2.20, 'comida'),
          _Choice('☕', 'Bar rápido', 3.50, 'comida'),
          _Choice('⏭️', 'Salir sin desayunar', 0, 'comida'),
        ],
      ),
      const _Moment(
        time: '08:15',
        icon: '🚪',
        title: 'Ir al trabajo',
        text: '¿Cómo vas hoy a la oficina?',
        choices: [
          _Choice('🚌', 'Transporte público', 0, 'transporte', kind: 'transit'),
          _Choice('🚗', 'Coche', 4, 'transporte', note: 'gasolina y parking'),
          _Choice('🛴', 'Patinete eléctrico', 1.5, 'transporte',
              note: 'alquiler por trayecto'),
          _Choice('🚶', 'Andar o bici', 0, 'transporte',
              note: 'gratis y saludable'),
        ],
      ),
    ];

    if (i == 0 && !_laundryDone) {
      moments.add(const _Moment(
        time: '09:00',
        icon: '👕',
        title: 'Ropa para la semana',
        text: '¿Cómo te organizas con la colada?',
        choices: [
          _Choice('🏠', 'Lavar en casa', 0, 'imprevistos', note: 'gratis, pero lleva tiempo'),
          _Choice('🧺', 'Lavandería express', 0, 'imprevistos', kind: 'laundry'),
        ],
      ));
    }

    if (i == 0 && (_streamingSub || _gymJoined)) {
      moments.add(_Moment(
        time: '09:15',
        icon: '📋',
        title: 'Revisar suscripciones',
        text: 'Empieza el mes. ¿Mantienes todo o recortas algo?',
        choices: [
          const _Choice('✅', 'Mantener todo', 0, 'suscripciones'),
          if (_streamingSub)
            const _Choice('📺', 'Cancelar streaming', 0, 'suscripciones',
                kind: 'cancel_streaming', note: 'ahorras €12,99/mes'),
          if (_gymJoined)
            const _Choice('💪', 'Dar de baja el gym', 0, 'suscripciones',
                kind: 'cancel_gym', note: 'ahorras €50/mes'),
        ],
      ));
    }

    // Martes: comida de networking
    if (i == 1 && rng.nextDouble() < 0.55) {
      moments.add(_Moment(
        time: _randTime(rng, 13, 13),
        icon: '🤝',
        title: 'Comida con un contacto',
        text: 'Un contacto te invita a comer fuera para hablar de trabajo.',
        choices: const [
          _Choice('🍽️', 'Aceptar (comida de networking)', 22, 'comida',
              note: 'inversión en contactos'),
          _Choice('☕', 'Quedar solo por un café', 3.5, 'café'),
          _Choice('📞', 'Proponer videollamada', 0, 'ocio'),
        ],
      ));
    }

    // Jueves: horas extra
    if (i == 3 && rng.nextDouble() < 0.50) {
      moments.add(_Moment(
        time: '18:30',
        icon: '⏱️',
        title: 'Horas extra',
        text: 'Te piden quedarte una hora más. ¿Aceptas?',
        choices: const [
          _Choice('💼', 'Sí, horas extra', 85, 'ingresos', kind: 'income'),
          _Choice('🏠', 'No, me voy a casa', 0, 'ocio'),
        ],
      ));
    }

    // coffee — random moment between 10:00 and 12:00, 75% chance
    if (rng.nextDouble() < 0.75) {
      moments.add(_Moment(
        time: _randTime(rng, 10, 11),
        icon: '☕',
        title: 'Pausa para el café',
        text: 'Te apetece un café. ¿Cuál eliges?',
        choices: const [
          _Choice('🏢', 'Máquina de la oficina', 0.75, 'café'),
          _Choice('🥐', 'Cafetería de la ofi', 1.50, 'café'),
          _Choice('🏠', 'Traído de casa', 0.40, 'café'),
          _Choice('🚫', 'Hoy sin café', 0, 'café'),
        ],
      ));
    }

    // mid-morning snack — 40% chance
    if (rng.nextDouble() < 0.40) {
      moments.add(_Moment(
        time: _randTime(rng, 11, 12),
        icon: '🍪',
        title: 'Antojo de media mañana',
        text: 'Te entran ganas de picar algo.',
        choices: const [
          _Choice('🤖', 'Máquina de snacks', 1.40, 'snacks'),
          _Choice('🍎', 'Fruta de casa', 0, 'snacks'),
          _Choice('🚫', 'Aguantar hasta comer', 0, 'snacks'),
        ],
      ));
    }

    if (isFriday) {
      moments.add(const _Moment(
        time: '14:00',
        icon: '🎉',
        title: 'Comida de viernes',
        text: 'Los compañeros proponen salir a celebrar el fin de semana.',
        choices: [
          _Choice('🥡', 'Quedarte con el tupper', 0, 'comida',
              note: 'ahorras y comes lo de casa'),
          _Choice('🍽️', 'Menú con el equipo', 16, 'comida'),
          _Choice('🍔', 'Burger rápida', 9, 'comida'),
          _Choice('🍱', 'Comedor de la ofi', 5, 'comida'),
        ],
      ));
    } else {
      moments.add(const _Moment(
        time: '14:00',
        icon: '🍽️',
        title: 'Hora de comer',
        text: '¿Dónde comes hoy?',
        choices: [
          _Choice('🥡', 'Tupper de casa', 0, 'comida',
              note: 'ya lo pagaste en la compra'),
          _Choice('🍱', 'Comedor de la oficina', 5, 'comida'),
          _Choice('🥪', 'Bocata rápido', 3.5, 'comida'),
          _Choice('🍝', 'Restaurante de fuera', 12, 'comida'),
          _Choice('🥗', 'Ensalada preparada', 4.5, 'comida',
              note: 'del super de la esquina'),
        ],
      ));
    }

    _maybeAddRandomEvent(moments, rng);

    // afternoon snack — 50% chance
    if (rng.nextDouble() < 0.50) {
      moments.add(_Moment(
        time: _randTime(rng, 16, 17),
        icon: '🧃',
        title: 'Merienda de la tarde',
        text: 'La tarde se hace larga. ¿Picas algo?',
        choices: const [
          _Choice('🥤', 'Zumo y galletas', 1.80, 'snacks'),
          _Choice('🍫', 'Chocolate de máquina', 1.20, 'snacks'),
          _Choice('🏠', 'Algo de casa', 0, 'snacks'),
          _Choice('🚫', 'Nada, gracias', 0, 'snacks'),
        ],
      ));
    }

    moments.add(const _Moment(
      time: '18:00',
      icon: '🏠',
      title: 'Volver a casa',
      text: 'Acaba la jornada. ¿Cómo vuelves?',
      choices: [
        _Choice('🚌', 'Transporte público', 0, 'transporte', kind: 'transit'),
        _Choice('🚗', 'Coche', 4, 'transporte'),
        _Choice('🛴', 'Patinete eléctrico', 1.5, 'transporte'),
        _Choice('🚶', 'Andar o bici', 0, 'transporte'),
      ],
    ));

    if (isFriday) {
      moments.add(const _Moment(
        time: '19:30',
        icon: '🌆',
        title: 'Plan de viernes',
        text: '¡Fin de semana! ¿Qué haces esta tarde?',
        choices: [
          _Choice('🛋️', 'Quedarte en casa', 0, 'ocio', note: 'descanso gratis'),
          _Choice('🍻', 'Afterwork con compañeros', 22, 'ocio',
              note: 'cena y copas incluidas'),
          _Choice('💪', 'Ir al gym', 0, 'ocio', kind: 'gym'),
          _Choice('🎬', 'Cine', 7.5, 'ocio'),
          _Choice('🍺', 'Una caña', 3.5, 'ocio'),
          _Choice('🍤', 'Unas tapas', 10, 'ocio'),
          _Choice('🏨', 'Reservar escapada del finde', 0, 'viajes',
              kind: 'weekend_trip', note: 'hotel + tren ~€165'),
        ],
      ));
    } else {
      moments.add(_Moment(
        time: '19:30',
        icon: '💻',
        title: 'Plan de la tarde',
        text: i == 2
            ? 'Miércoles: te llega una oferta de streaming. ¿Te apuntas?'
            : '¿Qué te apetece hacer hoy?',
        choices: [
          const _Choice('🛋️', 'Quedarte en casa', 0, 'ocio',
              note: 'descanso gratis'),
          const _Choice('💪', 'Ir al gym', 0, 'ocio', kind: 'gym'),
          const _Choice('🎬', 'Cine', 7.5, 'ocio'),
          const _Choice('🍺', 'Una caña', 3.5, 'ocio'),
          const _Choice('🍻', 'Dos cañas', 7, 'ocio'),
          const _Choice('🍤', 'Unas tapas', 10, 'ocio'),
          if (i == 2)
            const _Choice('📺', 'Streaming (Netflix/Spotify)', 0, 'suscripciones',
                kind: 'streaming', note: '€12,99/mes la primera vez'),
          const _Choice('📚', 'Biblioteca o parque', 0, 'ocio',
              note: 'ocio gratis'),
        ],
      ));
    }

    moments.add(const _Moment(
      time: '21:00',
      icon: '🌙',
      title: 'Cena',
      text: 'Llega la noche. ¿Qué cenar?',
      choices: [
        _Choice('🍳', 'Cocinar en casa', 0, 'comida',
            note: 'con lo de la compra'),
        _Choice('📦', 'Pedir delivery', 13, 'comida'),
        _Choice('🍕', 'Pizza compartida', 8, 'comida'),
        _Choice('🥗', 'Ensalada del super', 4.5, 'comida'),
        _Choice('🥪', 'Bocata y dormir', 3, 'comida'),
      ],
    ));

    return moments;
  }

  void _maybeAddRandomEvent(List<_Moment> moments, math.Random rng) {
    if (rng.nextDouble() > 0.30) return;

    final events = <_Moment>[
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '🎂',
        title: 'Cumpleaños en la ofi',
        text: 'Organizan una colecta para un compañero. ¿Te sumas?',
        choices: const [
          _Choice('🎁', 'Aportar €5', 5, 'imprevistos'),
          _Choice('🙏', 'Felicitación sin aporte', 0, 'imprevistos'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '🛍️',
        title: 'Oferta flash',
        text: 'Te llega una notificación: "Solo hoy, -40 % en zapatillas".',
        choices: const [
          _Choice('👟', 'Comprar ahora', 42, 'imprevistos'),
          _Choice('⏳', 'Esperar 24 h', 0, 'imprevistos',
              note: 'la oferta caduca y ahorras'),
          _Choice('🚫', 'Ignorar', 0, 'imprevistos'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '🚕',
        title: 'Lluvia torrencial',
        text: 'Sales y empieza a llover. ¿Qué haces?',
        choices: const [
          _Choice('🚕', 'Pedir un Uber', 12, 'imprevistos'),
          _Choice('☔', 'Aguantar con paraguas', 0, 'imprevistos'),
          _Choice('🏢', 'Esperar en la ofi', 0, 'imprevistos',
              note: 'media hora extra, pero gratis'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '💊',
        title: 'No te encuentras bien',
        text: 'Te duele la cabeza. ¿Qué haces?',
        choices: const [
          _Choice('💊', 'Paracetamol en farmacia', 5.5, 'imprevistos'),
          _Choice('🏠', 'Lo que tienes en casa', 0, 'imprevistos'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '📱',
        title: 'Datos móviles agotados',
        text: 'Se te acabaron los GB. ¿Recargas?',
        choices: const [
          _Choice('📶', 'Bonos extra (+2 GB)', 6, 'imprevistos'),
          _Choice('📡', 'Buscar WiFi', 0, 'imprevistos'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '💒',
        title: 'Boda de un amigo',
        text: 'Te invitan a una boda el mes que viene. ¿Qué haces con el regalo?',
        choices: const [
          _Choice('🎁', 'Regalo de calidad', 60, 'imprevistos'),
          _Choice('🌹', 'Detalle sencillo', 25, 'imprevistos'),
          _Choice('💌', 'Solo tarjeta', 0, 'imprevistos'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '🔧',
        title: 'Avería del coche',
        text: 'El coche hace un ruido raro. ¿Lo revisas?',
        choices: const [
          _Choice('🔧', 'Revisión en taller', 95, 'imprevistos'),
          _Choice('🛠️', 'Arreglo mínimo', 45, 'imprevistos'),
          _Choice('🚶', 'Dejarlo y usar transporte', 0, 'imprevistos',
              note: 'arriesgado pero gratis'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '📲',
        title: 'Pantalla rota',
        text: 'Se te cae el móvil. La pantalla tiene una grieta.',
        choices: const [
          _Choice('🛠️', 'Reparar ya', 79, 'imprevistos'),
          _Choice('📱', 'Móvil reacondicionado', 180, 'imprevistos'),
          _Choice('⏳', 'Aguantar así', 0, 'imprevistos'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '🦷',
        title: 'Cita con el dentista',
        text: 'Te toca revisión dental anual.',
        choices: const [
          _Choice('🦷', 'Ir a la cita', 35, 'imprevistos'),
          _Choice('⏭️', 'Posponer', 0, 'imprevistos',
              note: 'gratis ahora, pero no es lo ideal'),
        ],
      ),
      _Moment(
        time: _randTime(rng, 15, 16),
        icon: '💰',
        title: 'Vendes algo en Wallapop',
        text: 'Publicas unas cosas que no usas. ¿Te las quitan?',
        choices: const [
          _Choice('📦', 'Vender varias cosas', 45, 'ingresos', kind: 'income'),
          _Choice('👕', 'Vender solo una prenda', 18, 'ingresos', kind: 'income'),
          _Choice('🗑️', 'No vendo nada', 0, 'ingresos'),
        ],
      ),
    ];

    moments.add(events[rng.nextInt(events.length)]);
  }

  List<_Moment> _buildSaturday() {
    final rng = math.Random(_month * 31 + 50);
    final moments = <_Moment>[
      const _Moment(
        time: '09:30',
        icon: '😴',
        title: 'Sábado por la mañana',
        text: 'Sin despertador. Te levantas tarde y abres la ventana.',
      ),
      const _Moment(
        time: '10:30',
        icon: '🥞',
        title: 'Brunch',
        text: '¿Cómo empiezas el finde?',
        choices: [
          _Choice('🏠', 'En casa', 0, 'comida', note: 'tostadas y café'),
          _Choice('☕', 'Cafetería del barrio', 6.5, 'comida'),
          _Choice('🥂', 'Brunch completo', 14, 'comida'),
          _Choice('⏭️', 'Saltar y salir ya', 0, 'comida'),
        ],
      ),
    ];

    if (_weekendTripBooked) {
      moments.addAll(const [
        _Moment(
          time: '11:00',
          icon: '🚄',
          title: 'Salida de viaje',
          text:
              'Maleta lista. Tomas el tren hacia la ciudad que reservaste el viernes.',
        ),
        _Moment(
          time: '13:30',
          icon: '🏨',
          title: 'Llegada al hotel',
          text: 'Check-in hecho. Dejas la mochila y sales a explorar.',
        ),
      ]);
    } else {
      moments.add(const _Moment(
        time: '11:30',
        icon: '🗺️',
        title: 'Plan del sábado',
        text: '¿Qué te apetece hacer hoy?',
        choices: [
          _Choice('🏠', 'Día tranquilo en casa', 0, 'ocio',
              note: 'series, limpiar, descanso'),
          _Choice('🏪', 'Mercadillo y paseo', 12, 'ocio',
              note: 'comida callejera incluida'),
          _Choice('🏖️', 'Playa en tren', 38, 'viajes',
              note: 'billetes + tinto de verano'),
          _Choice('🏔️', 'Montaña en coche', 32, 'viajes',
              note: 'gasolina a medias con amigos'),
          _Choice('🚄', 'Ciudad cercana (1 día)', 52, 'viajes',
              note: 'AVE + comida allí'),
          _Choice('🏨', 'Fin de semana fuera', 0, 'viajes',
              kind: 'weekend_trip', note: 'hotel + tren ~€165'),
          _Choice('🎢', 'Parque de atracciones', 42, 'ocio'),
          _Choice('🏕️', 'Camping con amigos', 35, 'viajes',
              note: 'parcela + comida compartida'),
        ],
      ));
    }

    moments.add(_Moment(
      time: '14:30',
      icon: '🍽️',
      title: 'Comida de sábado',
      text: _weekendTripBooked
          ? 'Estás de viaje. ¿Dónde comes?'
          : 'Hora de comer. ¿Qué tal?',
      choices: [
        const _Choice('🍳', 'Cocinar / picnic', 0, 'comida'),
        const _Choice('🍔', 'Hamburguesería', 11, 'comida'),
        const _Choice('🍝', 'Restaurante', 18, 'comida'),
        const _Choice('🥙', 'Comida callejera', 7, 'comida'),
        if (_weekendTripBooked)
          const _Choice('🦐', 'Marisquería turística', 28, 'comida'),
      ],
    ));

    if (rng.nextDouble() < 0.45) {
      moments.add(_Moment(
        time: _randTime(rng, 16, 17),
        icon: '🎡',
        title: 'Tarde de sábado',
        text: 'La tarde es tuya. ¿Algún extra?',
        choices: const [
          _Choice('🚫', 'Nada más, gracias', 0, 'ocio'),
          _Choice('🎫', 'Entrada museo / expo', 12, 'ocio'),
          _Choice('🍦', 'Helado y paseo', 4.5, 'snacks'),
          _Choice('🛍️', 'Recuerdo / souvenir', 15, 'imprevistos'),
        ],
      ));
    }

    moments.add(const _Moment(
      time: '21:00',
      icon: '🌙',
      title: 'Noche de sábado',
      text: 'Cierra el día. ¿Qué haces?',
      choices: [
        _Choice('🛋️', 'A casa a descansar', 0, 'ocio'),
        _Choice('🍻', 'Copas con amigos', 16, 'ocio'),
        _Choice('🎤', 'Concierto / local', 25, 'ocio'),
        _Choice('📦', 'Pedir cena a casa', 14, 'comida'),
        _Choice('🍽️', 'Cena fuera', 22, 'comida'),
      ],
    ));

    return moments;
  }

  List<_Moment> _buildSunday() {
    if (_weekendTripBooked) return _buildSundayOnTrip();
    final rng = math.Random(_month * 31 + 60);
    final moments = <_Moment>[
      const _Moment(
        time: '10:00',
        icon: '☀️',
        title: 'Domingo por la mañana',
        text: 'Último día del finde. Sin prisas.',
      ),
      const _Moment(
        time: '11:00',
        icon: '🥐',
        title: 'Desayuno tardío',
        text: '¿Cómo arrancas el domingo?',
        choices: [
          _Choice('🏠', 'En casa', 0, 'comida'),
          _Choice('☕', 'Bar de la esquina', 4.5, 'comida'),
          _Choice('🥞', 'Brunch con amigos', 13, 'comida'),
        ],
      ),
      const _Moment(
        time: '12:30',
        icon: '👨‍👩‍👧',
        title: 'Plan de domingo',
        text: '¿Qué haces hoy?',
        choices: [
          _Choice('🏠', 'Quedarte en casa', 0, 'ocio',
              note: 'preparar la semana'),
          _Choice('🍽️', 'Comida en casa de familia', 28, 'ocio',
              note: 'llevas postre y vino'),
          _Choice('🥾', 'Senderismo local', 0, 'ocio', note: 'gratis y sano'),
          _Choice('💪', 'Gym tranquilo', 0, 'ocio', kind: 'gym'),
          _Choice('🚗', 'Visitar pueblo cercano', 24, 'viajes',
              note: 'gasolina + bocata'),
          _Choice('🎬', 'Cine de domingo', 6.5, 'ocio'),
        ],
      ),
    ];

    if (rng.nextDouble() < 0.35) {
      moments.add(_Moment(
        time: _randTime(rng, 16, 17),
        icon: '🛒',
        title: 'Compras del domingo',
        text: 'Te das cuenta de que falta algo para la semana.',
        choices: const [
          _Choice('🚫', 'Apañármelas', 0, 'imprevistos'),
          _Choice('🛒', 'Super exprés', 12, 'imprevistos'),
          _Choice('🥬', 'Mercado ecológico', 18, 'imprevistos'),
        ],
      ));
    }

    moments.add(const _Moment(
      time: '19:00',
      icon: '🥘',
      title: 'Preparar la semana',
      text: 'Mañana es lunes. ¿Cómo te organizas?',
      choices: [
        _Choice('🍱', 'Meal prep en casa', 0, 'comida',
            note: 'tuppers gratis toda la semana'),
        _Choice('📦', 'Kit comidas preparadas', 28, 'comida',
            note: 'cómodo pero caro'),
        _Choice('🍕', 'Pedir algo y listo', 14, 'comida'),
        _Choice('⏭️', 'Ya veré entre semana', 0, 'comida'),
      ],
    ));

    moments.add(const _Moment(
      time: '20:30',
      icon: '🍲',
      title: 'Cena dominical',
      text: 'Última comida del finde antes del lunes.',
      choices: [
        _Choice('🍳', 'Lo que hay en la nevera', 0, 'comida'),
        _Choice('🥘', 'Asado / guiso en casa', 8, 'comida',
            note: 'compras extra'),
        _Choice('📦', 'Pedir delivery', 14, 'comida'),
        _Choice('🍕', 'Pizza para cerrar el finde', 10, 'comida'),
      ],
    ));

    return moments;
  }

  List<_Moment> _buildSundayOnTrip() {
    return const [
      _Moment(
        time: '10:00',
        icon: '🏨',
        title: 'Desayuno en el hotel',
        text: 'Última mañana fuera. ¿Cómo desayunas?',
        choices: [
          _Choice('🥐', 'Buffet del hotel', 0, 'comida', note: 'incluido'),
          _Choice('☕', 'Cafetería de la calle', 7, 'comida'),
          _Choice('🥡', 'Algo rápido para irte', 3.5, 'comida'),
        ],
      ),
      _Moment(
        time: '11:30',
        icon: '📸',
        title: 'Último paseo',
        text: 'Antes de volver, un rato más por la ciudad.',
        choices: [
          _Choice('🚶', 'Caminar sin gastar', 0, 'ocio'),
          _Choice('🏛️', 'Entrada a un museo', 12, 'ocio'),
          _Choice('🛍️', 'Souvenir para casa', 16, 'imprevistos'),
          _Choice('🚴', 'Tour en bici', 18, 'ocio'),
        ],
      ),
      _Moment(
        time: '14:00',
        icon: '🍽️',
        title: 'Comida antes de volver',
        text: 'Hay que comer algo antes del tren.',
        choices: [
          _Choice('🥪', 'Bocata para el viaje', 5, 'comida'),
          _Choice('🍝', 'Menú del día', 14, 'comida'),
          _Choice('🍱', 'Comida para llevar', 9, 'comida'),
        ],
      ),
      _Moment(
        time: '17:00',
        icon: '🚄',
        title: 'Vuelta a casa',
        text: 'Fin del viaje. ¿Cómo vuelves?',
        choices: [
          _Choice('🚄', 'Tren reservado', 0, 'viajes', note: 'ya pagado'),
          _Choice('🚗', 'BlaBlaCar', 14, 'viajes'),
          _Choice('🚕', 'Taxi a la estación', 22, 'viajes'),
        ],
      ),
      _Moment(
        time: '20:00',
        icon: '🛋️',
        title: 'Noche en casa',
        text: 'Llegas cansado pero contento. Cena sencilla y a dormir.',
      ),
    ];
  }

  // ── choice handling ─────────────────────────────────────────────────────
  double _effCost(_Choice c) {
    if (c.kind == 'income') return 0;
    if (c.kind == 'transit') return _passBought ? 0 : 20;
    if (c.kind == 'gym') return _gymJoined ? 0 : 50;
    if (c.kind == 'streaming') return _streamingSub ? 0 : 12.99;
    if (c.kind == 'laundry') return _laundryDone ? 0 : 8;
    if (c.kind == 'weekend_trip') return _weekendTripBooked ? 0 : 165;
    return c.cost;
  }

  double _incomeAmount(_Choice c) =>
      c.kind == 'income' ? c.cost : 0;

  String _effLabel(_Choice c) {
    if (c.kind == 'transit') {
      return _passBought
          ? '${c.label} · abono ya pagado'
          : '${c.label} · abono mensual';
    }
    if (c.kind == 'gym') {
      return _gymJoined ? '${c.label} · ya inscrito' : '${c.label} · alta mensual';
    }
    if (c.kind == 'streaming') {
      return _streamingSub
          ? '${c.label} · ya suscrito'
          : '${c.label} · suscripción mensual';
    }
    if (c.kind == 'laundry') {
      return _laundryDone ? '${c.label} · ya pagado' : '${c.label} · este mes';
    }
    if (c.kind == 'weekend_trip') {
      return _weekendTripBooked
          ? '${c.label} · reserva confirmada'
          : '${c.label} · reserva fin de semana';
    }
    return c.label;
  }

  void _choose(_Choice c) {
    HapticFeedback.selectionClick();
    if (c.kind == 'cancel_streaming') {
      setState(() => _streamingSub = false);
      _advanceMoment();
      return;
    }
    if (c.kind == 'cancel_gym') {
      setState(() => _gymJoined = false);
      _advanceMoment();
      return;
    }
    if (c.kind == 'income') {
      final amount = _incomeAmount(c);
      if (amount > 0) {
        _checking += amount;
        _earnedThisMonth += amount;
        _spentByCat['ingresos'] = (_spentByCat['ingresos'] ?? 0) + amount;
      }
      _advanceMoment();
      return;
    }
    final cost = _effCost(c);
    if (c.kind == 'transit') _passBought = true;
    if (c.kind == 'gym') _gymJoined = true;
    if (c.kind == 'streaming') _streamingSub = true;
    if (c.kind == 'laundry') _laundryDone = true;
    if (c.kind == 'weekend_trip') _weekendTripBooked = true;
    _checking -= cost;
    _daySpent += cost;
    _spentByCat[c.cat] = (_spentByCat[c.cat] ?? 0) + cost;
    _advanceMoment();
  }

  void _advanceMoment() {
    if (_momentIndex >= _moments.length - 1) {
      setState(() => _phase = _Phase.dayEnd);
    } else {
      setState(() => _momentIndex++);
    }
  }

  void _nextDay() {
    HapticFeedback.selectionClick();
    if (_dayIndex >= _dayNames.length - 1) {
      _goToAllocate();
    } else {
      setState(() {
        _dayIndex++;
        _daySpent = 0;
        _moments = _buildDay(_dayIndex);
        _momentIndex = 0;
        _phase = _Phase.day;
      });
    }
  }

  // ── allocate ─────────────────────────────────────────────────────────────
  void _goToAllocate() {
    if (_checking < 0) {
      _debt += -_checking;
      _checking = 0;
      _overdraftMonth = true;
    }
    final available = _checking.clamp(0, double.infinity).toDouble();
    final needed =
        (_emergencyTarget - _emergency).clamp(0, double.infinity).toDouble();
    setState(() {
      _toEmergency = math.min(available, needed).toDouble();
      _toSavings = 0;
      _phase = _Phase.allocate;
    });
  }

  void _payDebt() {
    HapticFeedback.mediumImpact();
    final pay = math.min(_checking, _debt);
    setState(() {
      _checking -= pay;
      _debt -= pay;
      final available = _checking.clamp(0, double.infinity).toDouble();
      _toEmergency = _toEmergency.clamp(0, available).toDouble();
      _toSavings = _toSavings.clamp(0, available - _toEmergency).toDouble();
    });
  }

  void _confirmAllocate() {
    HapticFeedback.mediumImpact();
    _checking -= (_toEmergency + _toSavings);
    _emergency += _toEmergency;
    _savings += _toSavings;
    _savedThisMonth = _toEmergency + _toSavings;

    double d = 0;
    if (_overdraftMonth) {
      d -= 18;
    } else {
      d += 4;
    }
    final rate = _savedThisMonth / _salary;
    if (rate >= 0.2) {
      d += 6;
    } else if (rate <= 0.0001) {
      d -= 5;
    }
    if (_emergency >= _emergencyTarget) d += 3;
    if (_debt > 0) d -= 5;
    _healthDelta = d;
    _health = (_health + d).clamp(0, 100);

    _computeGradeAndReward();
    setState(() => _phase = _Phase.summary);
  }

  void _computeGradeAndReward() {
    final emergencyPct = (_emergency / _emergencyTarget).clamp(0.0, 1.0);
    final rate = _savedThisMonth / _salary;
    final score = emergencyPct * 40 +
        (_health / 100) * 30 +
        (_debt <= 0 ? 12 : 0) +
        rate.clamp(0, 0.4) / 0.4 * 18;
    String grade;
    int xp;
    if (score >= 78) {
      grade = 'A';
      xp = 140;
    } else if (score >= 60) {
      grade = 'B';
      xp = 100;
    } else if (score >= 42) {
      grade = 'C';
      xp = 70;
    } else {
      grade = 'D';
      xp = 40;
    }
    _grade = grade;

    final app = context.read<AppProvider>();
    app.addXP(xp);
    final prev = app.getGameData('budget_master');
    final best = _rank(grade) > _rank((prev?['bestGrade'] as String?) ?? 'F')
        ? grade
        : (prev?['bestGrade'] as String?) ?? grade;
    app.saveGameData('budget_master', {
      'bestGrade': best,
      'bestEmergency': math.max(
          _emergency, ((prev?['bestEmergency'] as num?)?.toDouble()) ?? 0),
      'months': ((prev?['months'] as int?) ?? 0) + 1,
    });
    if (!_awarded) {
      _awarded = true;
      widget.onCompleted?.call();
    }
  }

  int _rank(String g) => {'A': 4, 'B': 3, 'C': 2, 'D': 1}[g] ?? 0;

  void _nextMonth() {
    setState(() => _month++);
    _startMonth();
  }

  void _restart() {
    HapticFeedback.mediumImpact();
    setState(() {
      _month = 1;
      _currentRent = 550;
      _checking = 0;
      _savings = 0;
      _emergency = 0;
      _debt = 0;
      _health = 60;
      _gymJoined = false;
      _streamingSub = false;
      _awarded = false;
    });
    _startMonth();
  }

  // ── build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F3),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: _buildPhase(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _topLabel {
    if (_phase == _Phase.day) {
      return '${_dayNames[_dayIndex]} · ${_moments[_momentIndex].time}';
    }
    if (_phase == _Phase.dayEnd) return '${_dayNames[_dayIndex]} · noche';
    return 'Mes $_month';
  }

  Widget _header() {
    final showStats = _phase != _Phase.intro;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_brandDark, _brand],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const Text('Un mes de tu vida',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              if (showStats)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_topLabel,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5)),
                ),
            ],
          ),
          if (showStats) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _HealthRing(value: _health / 100, size: 54),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo en cuenta',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: _balanceAnimFrom, end: _checking),
                          duration: const Duration(milliseconds: 550),
                          builder: (_, v, __) {
                            _balanceAnimFrom = _checking;
                            return Text(
                              _m(v),
                              style: TextStyle(
                                  color: v < 0
                                      ? const Color(0xFFFFCDD2)
                                      : Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _miniStat('🛟', _m(_emergency)),
                      const SizedBox(height: 2),
                      _miniStat('💰', _m(_savings)),
                      if (_debt > 0) ...[
                        const SizedBox(height: 2),
                        _miniStat('⚠️', '-${_m(_debt)}', danger: true),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniStat(String emoji, String value, {bool danger = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(value,
            style: TextStyle(
                color: danger ? const Color(0xFFFFCDD2) : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12.5)),
      ],
    );
  }

  Widget _buildPhase() {
    switch (_phase) {
      case _Phase.intro:
        return _introView();
      case _Phase.payday:
        return _paydayView();
      case _Phase.day:
        return _dayView();
      case _Phase.dayEnd:
        return _dayEndView();
      case _Phase.allocate:
        return _allocateView();
      case _Phase.summary:
        return _summaryView();
    }
  }

  // ── intro ──────────────────────────────────────────────────────────────────
  Widget _introView() {
    final card = _introCards[_introStep];
    return Padding(
      key: ValueKey('intro$_introStep'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _fade,
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: _brand.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child:
                      Text(card['icon']!, style: const TextStyle(fontSize: 46)),
                ),
                const SizedBox(height: 22),
                Text(card['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A2E2B))),
                const SizedBox(height: 12),
                Text(card['text']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.4,
                        color: Color(0xFF55635F))),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_introCards.length, (i) {
              final active = i == _introStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? _brand : const Color(0xFFCBD6D3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 26),
          _primaryButton(
            _introStep >= _introCards.length - 1 ? 'Empezar el mes' : 'Siguiente',
            _nextIntro,
          ),
        ],
      ),
    );
  }

  // ── payday ──────────────────────────────────────────────────────────────────
  Widget _paydayView() {
    final subs = _subscriptionRenewals;
    final variable = _variablePaydayCost;
    final rentUp = _month > 1 && (_month - 1) % 4 == 0;
    final totalOut = _fixedTotal + subs + variable;
    return Center(
      key: const ValueKey('payday'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💼', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text('Mes $_month — Día de cobro',
                style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A2E2B))),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: _cardDeco(),
              child: Column(
                children: [
                  _rowLabel('💼 Nómina', '+${_m(_salary)}',
                      valueColor: const Color(0xFF1B5E20)),
                  const Divider(height: 22),
                  _rowLabel('🏠 Alquiler', '-${_m(_currentRent)}'),
                  if (rentUp)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('↑ Subida de alquiler este mes',
                          style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w600)),
                    ),
                  _rowLabel('⚡ Luz y agua', '-${_m(_utilities)}'),
                  _rowLabel('📱 Móvil e internet', '-${_m(_phone)}'),
                  _rowLabel('🛒 Compra del mes', '-${_m(_groceries)}'),
                  if (subs > 0) ...[
                    const Divider(height: 22),
                    if (_gymJoined)
                      _rowLabel('💪 Gym (renovación)', '-${_m(50)}'),
                    if (_streamingSub)
                      _rowLabel('📺 Streaming (renovación)', '-${_m(12.99)}'),
                  ],
                  if (variable > 0)
                    _rowLabel('🚗 Seguro del coche', '-${_m(variable)}'),
                  const Divider(height: 22),
                  _rowLabel('Te queda para la semana y el finde',
                      _m(_salary - totalOut),
                      valueColor: _brand),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _coach(subs > 0
                ? 'Tus suscripciones se renuevan solas cada mes. El lunes podrás cancelar las que no uses.'
                : 'El finde trae escapadas y viajes: no hace falta gastar mucho para disfrutarlo.'),
            const SizedBox(height: 16),
            _primaryButton('Empezar el lunes', _collectAndPayFixed),
          ],
        ),
      ),
    );
  }

  // ── day (moment player) ────────────────────────────────────────────────────
  Widget _dayView() {
    final mom = _moments[_momentIndex];
    return Column(
      key: ValueKey('day${_dayIndex}_$_momentIndex'),
      children: [
        // day progress
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
          child: Row(
            children: List.generate(_moments.length, (i) {
              final done = i <= _momentIndex;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 5,
                  decoration: BoxDecoration(
                    color: done ? _brand : const Color(0xFFD7E0DD),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 92,
                  height: 92,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(mom.icon, style: const TextStyle(fontSize: 44)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _brand.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('🕐 ${mom.time}',
                      style: const TextStyle(
                          color: _brandDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                ),
                const SizedBox(height: 12),
                Text(mom.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A2E2B))),
                const SizedBox(height: 8),
                Text(mom.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, height: 1.35, color: Color(0xFF55635F))),
                const SizedBox(height: 18),
                if (mom.choices.isEmpty)
                  _primaryButton('Continuar', _advanceMoment)
                else
                  ...mom.choices.map(_choiceTile),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _choiceTile(_Choice c) {
    final isIncome = c.kind == 'income';
    final isCancel =
        c.kind == 'cancel_streaming' || c.kind == 'cancel_gym';
    final income = _incomeAmount(c);
    final cost = isIncome ? 0.0 : _effCost(c);
    final free = !isIncome && cost <= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1.5,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _choose(c),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Text(c.emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_effLabel(c),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              color: Color(0xFF223330))),
                      if (c.note != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(c.note!,
                              style: const TextStyle(
                                  fontSize: 11.5, color: Color(0xFF8A9894))),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? const Color(0xFFE8F5E9)
                        : free
                            ? const Color(0xFFE5F5EF)
                            : const Color(0xFFFDECEC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isIncome && income > 0
                        ? '+${_m(income)}'
                        : isCancel
                            ? 'Cancelar'
                            : free
                                ? 'Gratis'
                                : '-${_m(cost)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: isIncome
                          ? const Color(0xFF1B7A52)
                          : free
                              ? const Color(0xFF1B7A52)
                              : const Color(0xFFC0392B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── day end ─────────────────────────────────────────────────────────────
  Widget _dayEndView() {
    final lastDay = _dayIndex >= _dayNames.length - 1;
    return Center(
      key: ValueKey('dayEnd$_dayIndex'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌙', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 10),
            Text('${_dayNames[_dayIndex]} terminado',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A2E2B))),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: _cardDeco(),
              child: Column(
                children: [
                  _rowLabel('Gastado hoy', _m(_daySpent),
                      valueColor: _daySpent > 0
                          ? const Color(0xFFC0392B)
                          : const Color(0xFF1B7A52)),
                  _rowLabel('Saldo en cuenta', _m(_checking),
                      valueColor: _checking < 0
                          ? const Color(0xFFC0392B)
                          : const Color(0xFF1A2E2B)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _primaryButton(
                lastDay
                    ? 'Cerrar semana y finde'
                    : 'Pasar al ${_dayNames[_dayIndex + 1]}',
                _nextDay),
          ],
        ),
      ),
    );
  }

  // ── allocate ─────────────────────────────────────────────────────────────
  Widget _allocateView() {
    final available = _checking;
    final emTo = _toEmergency.clamp(0, available).toDouble();
    final maxSav = (available - emTo).clamp(0, available).toDouble();
    final savTo = _toSavings.clamp(0, maxSav).toDouble();
    final keep = available - emTo - savTo;
    final emPct = (_emergency / _emergencyTarget).clamp(0.0, 1.0);

    return ListView(
      key: const ValueKey('allocate'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _coach(
            'Semana y finde cerrados. Lo que sobra, ponlo a trabajar: prioriza el fondo de emergencia (meta ${_m(_emergencyTarget)}).'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDeco(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🛟 Fondo de emergencia',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2E2B))),
                  const Spacer(),
                  Text('${_m(_emergency)} / ${_m(_emergencyTarget)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: _brand)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: emPct,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE0E8E6),
                  valueColor: const AlwaysStoppedAnimation<Color>(_brand),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDeco(),
          child: Column(
            children: [
              _rowLabel('Disponible para repartir', _m(available)),
              const Divider(height: 22),
              _allocSlider('🛟 Al fondo de emergencia', emTo, _brand, available,
                  (v) => setState(() {
                        _toEmergency = v;
                        if (_toEmergency + _toSavings > available) {
                          _toSavings = (available - _toEmergency)
                              .clamp(0, available)
                              .toDouble();
                        }
                      })),
              _allocSlider('💰 Al ahorro', savTo, const Color(0xFFEF9A1E),
                  maxSav, (v) => setState(() => _toSavings = v)),
              const SizedBox(height: 6),
              _rowLabel('Queda en la cuenta', _m(keep),
                  valueColor: const Color(0xFF607D8B)),
            ],
          ),
        ),
        if (_debt > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDeco(color: const Color(0xFFFFF3F3)),
            child: Row(
              children: [
                Expanded(
                  child: Text('⚠️ Deuda de ${_m(_debt)} (3 %/mes).',
                      style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: _checking > 0 ? _payDebt : null,
                  child: const Text('Pagar'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        _primaryButton('Cerrar el mes', _confirmAllocate),
      ],
    );
  }

  Widget _allocSlider(String label, double value, Color color, double max,
      ValueChanged<double> onChanged) {
    final safeMax = max <= 0 ? 1.0 : max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF2A3A37))),
            ),
            Text(_m(value),
                style: TextStyle(fontWeight: FontWeight.w900, color: color)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withOpacity(0.2),
            overlayColor: color.withOpacity(0.15),
            trackHeight: 6,
          ),
          child: Slider(
            value: value.clamp(0, safeMax).toDouble(),
            min: 0,
            max: safeMax,
            divisions: (safeMax / 10).round().clamp(1, 300),
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
          ),
        ),
      ],
    );
  }

  // ── month summary ─────────────────────────────────────────────────────────
  Widget _summaryView() {
    final daily = (_spentByCat['transporte'] ?? 0) +
        (_spentByCat['café'] ?? 0) +
        (_spentByCat['comida'] ?? 0) +
        (_spentByCat['snacks'] ?? 0) +
        (_spentByCat['suscripciones'] ?? 0) +
        (_spentByCat['imprevistos'] ?? 0) +
        (_spentByCat['viajes'] ?? 0) +
        (_spentByCat['ocio'] ?? 0);
    final gradeColor = {
          'A': const Color(0xFF2E7D32),
          'B': const Color(0xFF558B2F),
          'C': const Color(0xFFEF6C00),
          'D': const Color(0xFFC62828),
        }[_grade] ??
        Colors.grey;

    return ListView(
      key: const ValueKey('summary'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: gradeColor, width: 3),
            ),
            alignment: Alignment.center,
            child: Text(_grade,
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: gradeColor)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text('Resumen del mes $_month',
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A2E2B))),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDeco(),
          child: Column(
            children: [
              for (final entry in _catMeta.entries)
                _rowLabel(
                  '${entry.value[0]} ${entry.value[1]}',
                  _m(_spentByCat[entry.key] ?? 0),
                ),
              const Divider(height: 22),
              _rowLabel('🐜 Gastos del día a día', _m(daily),
                  valueColor: const Color(0xFFEF6C00)),
              _rowLabel('🛟+💰 Ahorrado este mes', _m(_savedThisMonth),
                  valueColor: const Color(0xFF1B5E20)),
              if (_earnedThisMonth > 0)
                _rowLabel('💵 Ingresos extra', '+${_m(_earnedThisMonth)}',
                    valueColor: const Color(0xFF1B5E20)),
              _rowLabel(
                '❤️ Salud financiera',
                '${_healthDelta >= 0 ? '+' : ''}${_healthDelta.toStringAsFixed(0)} · ${_health.toStringAsFixed(0)}%',
                valueColor: _healthDelta >= 0
                    ? const Color(0xFF1B5E20)
                    : const Color(0xFFC62828),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _cardDeco(color: const Color(0xFFEFF7F5)),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_tip(daily),
                    style: const TextStyle(
                        fontSize: 13.5, color: Color(0xFF37474F))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _primaryButton('Vivir otro mes', _nextMonth),
        const SizedBox(height: 10),
        _secondaryButton('Reiniciar', _restart),
        const SizedBox(height: 8),
        _secondaryButton('Salir', () => Navigator.of(context).maybePop()),
      ],
    );
  }

  String _tip(double daily) {
    final cafe = _spentByCat['café'] ?? 0;
    final delivery = (_spentByCat['comida'] ?? 0);
    final subs = _spentByCat['suscripciones'] ?? 0;
    final impulse = _spentByCat['imprevistos'] ?? 0;
    final travel = _spentByCat['viajes'] ?? 0;
    if (_debt > 0) {
      return 'Acabaste en números rojos. Recorta gastos del día a día y evita el descubierto.';
    }
    if (travel >= 80) {
      return 'Viajes y escapadas sumaron ${_m(travel)}. Planificar con antelación suele salir más barato que decidir el viernes noche.';
    }
    if (_earnedThisMonth >= 50) {
      return 'Ingresaste ${_m(_earnedThisMonth)} extra este mes. ¿Lo ahorraste o se fue en gastos?';
    }
    if (impulse >= 20) {
      return 'Los imprevistos e impulsos sumaron ${_m(impulse)}. Esperar 24 h antes de comprar suele ahorrar.';
    }
    if (subs > 0) {
      return 'Las suscripciones parecen poco, pero son ${_m(subs)} al mes que se renuevan solas.';
    }
    if (cafe >= 5) {
      return 'Solo en cafés gastaste ${_m(cafe)} esta semana. ¡Cuidado con los gastos hormiga!';
    }
    if (_emergency >= _emergencyTarget) {
      return '¡Fondo de emergencia completo! Ahora ese dinero te da tranquilidad ante imprevistos.';
    }
    if (daily < 50) {
      return 'Semana y finde muy contenidos. Así crece rápido tu colchón.';
    }
    if (delivery >= 30) {
      return 'Cocinar en casa y evitar delivery ahorra más de lo que parece. Esta semana comiste fuera bastante.';
    }
    return 'Un finde en casa o una escapada cercana pueden ser tan gratificantes como un viaje caro. ¡Equilibra!';
  }

  // ── shared widgets ──────────────────────────────────────────────────────
  Widget _coach(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCDE6E0)),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, height: 1.3, color: Color(0xFF2F4F49))),
          ),
        ],
      ),
    );
  }

  Widget _rowLabel(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child:
                Text(label, style: const TextStyle(color: Color(0xFF55635F))),
          ),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? const Color(0xFF1A2E2B))),
        ],
      ),
    );
  }

  BoxDecoration _cardDeco({Color color = Colors.white}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      );

  Widget _primaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _brand,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _secondaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _brand,
          side: const BorderSide(color: _brand, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(text,
            style:
                const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// Circular financial-health gauge.
class _HealthRing extends StatelessWidget {
  final double value; // 0..1
  final double size;
  const _HealthRing({required this.value, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HealthRingPainter(value),
        child: Center(
          child: Text(
            (value * 100).toStringAsFixed(0),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: size * 0.3),
          ),
        ),
      ),
    );
  }
}

class _HealthRingPainter extends CustomPainter {
  final double value;
  _HealthRingPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white24;
    canvas.drawCircle(center, radius, bg);

    final color = value >= 0.66
        ? const Color(0xFF66E0A3)
        : value >= 0.4
            ? const Color(0xFFFFD54F)
            : const Color(0xFFFF8A80);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value.clamp(0.0, 1.0),
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _HealthRingPainter old) => old.value != value;
}
