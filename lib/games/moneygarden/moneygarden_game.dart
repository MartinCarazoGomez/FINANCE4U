import 'dart:math' show exp, pi, sqrt;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'moneygarden_data.dart';
import 'moneygarden_engine.dart';

/// MoneyGarden — videojuego educativo de finanzas (10-18 años).
/// Mapa navegable con avatar, mentor Coach Kai y tarjetas educativas.
class MoneyGardenGame extends StatefulWidget {
  final VoidCallback? onCompleted;

  const MoneyGardenGame({super.key, this.onCompleted});

  @override
  State<MoneyGardenGame> createState() => _MoneyGardenGameState();
}

class _MoneyGardenGameState extends State<MoneyGardenGame>
    with TickerProviderStateMixin {
  late final MoneyGardenEngine _engine;
  late final TextEditingController _nameCtrl;
  late final AnimationController _idleCtrl;
  late final AnimationController _coinCtrl;
  late final AnimationController _charCtrl;

  late MgSnapshot _snap;
  MgZone? _walkingTo;
  String _coinText = '';
  int _officeTab = 0;
  int _forecastPrice = 0;
  int _lastForecastMonth = 1;

  // Posiciones relativas de las zonas sobre la ilustración del mapa (0..1),
  // alineadas con los cuatro edificios de la imagen.
  static const _zonePos = <MgZone, Offset>{
    MgZone.provider: Offset(0.20, 0.28),
    MgZone.shop: Offset(0.79, 0.26),
    MgZone.bills: Offset(0.21, 0.72),
    MgZone.piggybank: Offset(0.79, 0.70),
    MgZone.office: Offset(0.50, 0.47),
  };
  static const _avatarHome = Offset(0.5, 0.72);

  static const _zoneColor = <MgZone, Color>{
    MgZone.provider: MgColors.cyan,
    MgZone.shop: MgColors.green,
    MgZone.bills: MgColors.magenta,
    MgZone.piggybank: MgColors.yellow,
    MgZone.office: MgColors.violet,
  };

  AvatarOption get _opt =>
      kAvatarOptions[_snap.avatarStyle >= 0 ? _snap.avatarStyle : 0];
  Offset _avatarPos = _avatarHome;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _engine = MoneyGardenEngine(onChanged: _onUpdate);
    _snap = _engine.snapshot;
    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _coinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _charCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
  }

  void _onUpdate(MgSnapshot snap) {
    if (!mounted) return;
    if (snap.month != _lastForecastMonth) {
      _lastForecastMonth = snap.month;
      _forecastPrice = 0;
    }
    setState(() => _snap = snap);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idleCtrl.dispose();
    _coinCtrl.dispose();
    _charCtrl.dispose();
    super.dispose();
  }

  String _c(num coins) {
    final n = coins is int ? coins : (coins as double);
    final rounded = n.abs() < 100 ? n.toStringAsFixed(n == n.roundToDouble() ? 0 : 1) : n.round().toString();
    return '$rounded 🪙';
  }

  void _coinPop(String text) {
    setState(() => _coinText = text);
    _coinCtrl.forward(from: 0);
  }

  // Camina el avatar a una zona y luego abre su panel.
  void _walkTo(MgZone zone) {
    HapticFeedback.selectionClick();
    setState(() {
      _walkingTo = zone;
      _avatarPos = _zonePos[zone]!;
    });
    Future.delayed(const Duration(milliseconds: 550), () {
      if (!mounted) return;
      _walkingTo = null;
      _engine.goToZone(zone);
    });
  }

  void _returnMap() {
    setState(() => _avatarPos = _avatarHome);
    _engine.backToMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MgColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildPhase(),
            ),
            if (_snap.pendingCard != null) _flashcardOverlay(_snap.pendingCard!),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase() {
    switch (_snap.phase) {
      case GamePhase.personalize:
        return _buildPersonalize();
      case GamePhase.onboarding:
        return _buildOnboarding();
      case GamePhase.map:
        return _buildMap();
      case GamePhase.provider:
        return _buildProvider();
      case GamePhase.shop:
        return _buildShop();
      case GamePhase.bills:
        return _buildBills();
      case GamePhase.piggybank:
        return _buildPiggybank();
      case GamePhase.office:
        return _buildOffice();
      case GamePhase.monthSummary:
        return _buildSummary();
      case GamePhase.gameOver:
        return _buildEnd(false);
      case GamePhase.victory:
        return _buildEnd(true);
    }
  }

  // ── Personalización (pantalla de selección estilo AAA) ──────────────────────
  void _selectCharacter(int i) {
    if (_snap.avatarStyle == i) return;
    HapticFeedback.mediumImpact();
    // Si el nombre sigue siendo el de un personaje por defecto, actualízalo.
    final isDefaultName = _nameCtrl.text.isEmpty ||
        kAvatarOptions.any((o) => o.label == _nameCtrl.text);
    _engine.setAvatarStyle(i);
    if (isDefaultName) {
      _nameCtrl.text = kAvatarOptions[i].label;
      _engine.setAvatarName(_nameCtrl.text);
    }
    _charCtrl.forward(from: 0);
  }

  Widget _buildPersonalize() {
    // Siempre hay un personaje en el "escenario": autoselecciona el primero.
    if (_snap.avatarStyle < 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _snap.avatarStyle >= 0) return;
        _engine.setAvatarStyle(0);
        _nameCtrl.text = kAvatarOptions[0].label;
        _engine.setAvatarName(_nameCtrl.text);
        _charCtrl.forward(from: 0);
      });
    }
    final idx = _snap.avatarStyle >= 0 ? _snap.avatarStyle : 0;
    final opt = kAvatarOptions[idx];
    final ready = _snap.avatarName.isNotEmpty;

    return Stack(
      key: const ValueKey('personalize'),
      fit: StackFit.expand,
      children: [
        // Arte del personaje a pantalla completa (estilo CoD / Hogwarts Legacy)
        AnimatedBuilder(
          animation: _charCtrl,
          builder: (_, __) {
            final t = Curves.easeOutCubic.transform(_charCtrl.value);
            return Opacity(
              opacity: t.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 1.08 - t * 0.08,
                child: Image.asset(
                  opt.image,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.6),
                  gaplessPlayback: true,
                ),
              ),
            );
          },
        ),
        // Degradado superior para legibilidad de la cabecera
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.22, 0.45],
              colors: [Colors.black87, Colors.black26, Colors.transparent],
            ),
          ),
        ),
        // Degradado inferior: la información se lee sobre el arte
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.30, 0.62, 1],
              colors: [
                Colors.transparent,
                MgColors.bg.withValues(alpha: 0.88),
                MgColors.bg,
              ],
            ),
          ),
        ),
        // Contenido
        LayoutBuilder(
          builder: (context, cons) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: cons.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cabecera
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'ELIGE TU PERSONAJE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                shadows: [
                                  Shadow(color: Colors.black87, blurRadius: 8),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Placa de información del personaje
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: AnimatedBuilder(
                        animation: _charCtrl,
                        builder: (_, child) {
                          final t =
                              Curves.easeOut.transform(_charCtrl.value);
                          return Opacity(
                            opacity: t,
                            child: Transform.translate(
                              offset: Offset(0, (1 - t) * 24),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (_snap.avatarName.isEmpty
                                      ? opt.label
                                      : _snap.avatarName)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                                height: 1,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 14,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: opt.color.withValues(alpha: 0.8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: opt.color.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Text(
                                opt.title.toUpperCase(),
                                style: TextStyle(
                                  color: opt.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              opt.bio,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                                shadows: const [
                                  Shadow(color: Colors.black87, blurRadius: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _statBars(opt),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Plantel de personajes
                    SizedBox(
                      height: 86,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: kAvatarOptions.length,
                        itemBuilder: (_, i) => _rosterCard(i),
                      ),
                    ),
                    // Nombre + confirmar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameCtrl,
                            onChanged: _engine.setAvatarName,
                            textAlign: TextAlign.center,
                            maxLength: 14,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              isDense: true,
                              hintText: 'NOMBRE DE TU LEYENDA',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3),
                                letterSpacing: 2,
                                fontSize: 12,
                              ),
                              filled: true,
                              fillColor: Colors.black.withValues(alpha: 0.45),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: opt.color.withValues(alpha: 0.4)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    BorderSide(color: opt.color, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _confirmButton(opt, ready),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statBars(AvatarOption opt) {
    Widget bar(String label, int value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            SizedBox(
              width: 74,
              child: Text(label,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  )),
            ),
            Expanded(
              child: Row(
                children: List.generate(5, (i) {
                  final filled = i < value;
                  return Expanded(
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey('$label-$value-$i'),
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 200 + i * 90),
                      curve: Curves.easeOut,
                      builder: (_, t, __) => Container(
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: filled
                              ? opt.color.withValues(alpha: 0.25 + t * 0.75)
                              : Colors.white.withValues(alpha: 0.08),
                          boxShadow: filled && t > 0.8
                              ? [
                                  BoxShadow(
                                    color: opt.color.withValues(alpha: 0.4),
                                    blurRadius: 5,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          bar('VISIÓN', opt.vision),
          bar('CARISMA', opt.carisma),
          bar('AUDACIA', opt.audacia),
        ],
      ),
    );
  }

  Widget _rosterCard(int i) {
    final opt = kAvatarOptions[i];
    final selected = _snap.avatarStyle == i;
    return GestureDetector(
      onTap: () => _selectCharacter(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 62,
        margin: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: selected ? 3 : 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? opt.color : Colors.white24,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: opt.color.withValues(alpha: 0.55),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Retrato encuadrado a la cara
              AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: selected ? 1 : 0.5,
                child: Image.asset(
                  opt.image,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.85),
                ),
              ),
              // Nombre sobre franja inferior
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  color: Colors.black.withValues(alpha: 0.55),
                  child: Text(
                    opt.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? opt.color : Colors.white70,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmButton(AvatarOption opt, bool ready) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: ready
              ? LinearGradient(
                  colors: [opt.color, Color.lerp(opt.color, MgColors.green, 0.6)!],
                )
              : null,
          color: ready ? null : Colors.white10,
          boxShadow: ready
              ? [
                  BoxShadow(
                    color: opt.color.withValues(alpha: 0.5),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: ready
                ? () {
                    HapticFeedback.heavyImpact();
                    FocusScope.of(context).unfocus();
                    _engine.finishPersonalize();
                  }
                : null,
            child: Center(
              child: Text(
                ready ? '⚔  COMENZAR AVENTURA' : 'ESCRIBE TU NOMBRE',
                style: TextStyle(
                  color: ready ? const Color(0xFF10251A) : Colors.white38,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Onboarding narrativo (Coach Kai) ─────────────────────────────────────────
  Widget _buildOnboarding() {
    final line = kOnboarding[_snap.onboardingStep];
    final isLast = _snap.onboardingStep == kOnboarding.length - 1;
    return Container(
      key: ValueKey('onb-${_snap.onboardingStep}'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [MgColors.bgSoft, MgColors.bg],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _engine.skipOnboarding,
              child: const Text('Saltar',
                  style: TextStyle(color: Colors.white54)),
            ),
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _idleCtrl,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, -4 + _idleCtrl.value * 8),
              child: child,
            ),
            child: Container(
              width: 136,
              height: 136,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: MgColors.yellow, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: MgColors.yellow.withValues(alpha: 0.45),
                    blurRadius: 26,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  kCoachKaiImage,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.75),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Coach Kai',
              style: TextStyle(
                color: MgColors.yellow,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: MgColors.cyan.withValues(alpha: 0.4)),
            ),
            child: Text(
              line.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(kOnboarding.length, (i) {
              final active = i == _snap.onboardingStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? MgColors.magenta : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          _btn(isLast ? '¡Empezar el Mes 1! 🚀' : 'Siguiente', MgColors.magenta,
              () {
            HapticFeedback.lightImpact();
            _engine.nextOnboarding();
          }),
        ],
      ),
    );
  }

  // ── Mapa navegable (ilustración con waypoints) ───────────────────────────────
  Widget _buildMap() {
    return Column(
      key: const ValueKey('map'),
      children: [
        _hud(),
        _mentorBanner(),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF10182B), MgColors.bg],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: AspectRatio(
                  // La ilustración es 3:2; recortamos un poco los laterales
                  // para que el mapa llene más pantalla sin perder edificios.
                  aspectRatio: 1.30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final w = box.maxWidth;
                        final h = box.maxHeight;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(kMapImage, fit: BoxFit.cover),
                            ),
                            // Viñeta sutil para integrar los marcadores
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    radius: 1.1,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.35),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _mapZone(MgZone.provider, Icons.warehouse,
                                'Proveedor', w, h,
                                done: _snap.boughtThisMonth),
                            _mapZone(MgZone.shop, Icons.storefront, 'Tienda',
                                w, h,
                                badge: _snap.minSalesMet
                                    ? null
                                    : '${_snap.soldThisMonth}/${_snap.minSales}'),
                            _mapZone(MgZone.bills, Icons.markunread_mailbox,
                                'Facturas', w, h,
                                done: _snap.billsPaidThisMonth,
                                locked:
                                    !_snap.minSalesMet && !_snap.outOfDemand),
                            if (_snap.month >= 2)
                              _mapZone(
                                  MgZone.piggybank, Icons.savings, 'Hucha', w, h),
                            _mapZone(MgZone.office, Icons.computer, 'Oficina',
                                w, h),
                            // Ficha del jugador
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              left: w * _avatarPos.dx - 24,
                              top: h * _avatarPos.dy - 24,
                              child: AnimatedBuilder(
                                animation: _idleCtrl,
                                builder: (_, child) => Transform.translate(
                                  offset: Offset(
                                      0,
                                      _walkingTo != null
                                          ? 0
                                          : -2 + _idleCtrl.value * 4),
                                  child: child,
                                ),
                                child: _faceToken(48),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: _btn(
            _snap.billsPaidThisMonth
                ? '📅 Cerrar el mes ${_snap.month} ▶'
                : (_snap.minSalesMet || _snap.outOfDemand)
                    ? '📬 Ve a Facturas para cerrar el mes'
                    : 'Vende al menos ${_snap.minSales} clientes para avanzar',
            _snap.billsPaidThisMonth ? MgColors.green : Colors.white24,
            _snap.billsPaidThisMonth
                ? () => _engine.closeMonth()
                : null,
          ),
        ),
      ],
    );
  }

  Widget _mapZone(MgZone zone, IconData icon, String label, double w, double h,
      {bool done = false, bool locked = false, String? badge}) {
    final pos = _zonePos[zone]!;
    final color = _zoneColor[zone]!;
    return Positioned(
      left: w * pos.dx - 42,
      top: h * pos.dy - 46,
      child: GestureDetector(
        onTap: locked ? null : () => _walkTo(zone),
        child: Opacity(
          opacity: locked ? 0.55 : 1,
          child: SizedBox(
            width: 84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Waypoint pulsante sobre el edificio
                AnimatedBuilder(
                  animation: _idleCtrl,
                  builder: (_, child) => Transform.scale(
                    scale: locked ? 1 : 1 + _idleCtrl.value * 0.08,
                    child: child,
                  ),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.55),
                      border: Border.all(
                        color: done ? MgColors.green : color,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (done ? MgColors.green : color)
                              .withValues(alpha: locked ? 0.15 : 0.55),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            locked ? Icons.lock : (done ? Icons.check : icon),
                            color: done
                                ? MgColors.green
                                : (locked ? Colors.white60 : color),
                            size: 22,
                          ),
                        ),
                        if (badge != null)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: MgColors.magenta,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(badge,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Etiqueta estilo waypoint
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(9),
                    border:
                        Border.all(color: color.withValues(alpha: 0.5)),
                  ),
                  child: Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Cara circular de Coach Kai para banners y notas.
  Widget _kaiFace(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: MgColors.yellow.withValues(alpha: 0.8), width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          kCoachKaiImage,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.75),
        ),
      ),
    );
  }

  /// Ficha circular con la cara del personaje del jugador.
  Widget _faceToken(double size) {
    final opt = _opt;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: opt.color, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: opt.color.withValues(alpha: 0.55),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          opt.image,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.85),
        ),
      ),
    );
  }

  // ── Zona Proveedor (comprar) ─────────────────────────────────────────────────
  Widget _buildProvider() {
    final canBuy = _snap.coins >= _snap.unitCost;
    return _zoneScaffold(
      key: 'provider',
      title: '🏭 Almacén del proveedor',
      subtitle:
          'Compra camisetas a ${_c(_snap.unitCost)} cada una. Es tu gasto variable.',
      color: MgColors.cyan,
      children: [
        _sceneBanner(kSceneProvider, MgColors.cyan),
        const SizedBox(height: 12),
        _statStrip([
          _stat('👕 Stock', '${_snap.inventory}', MgColors.cyan),
          _stat('🪙 Caja', _c(_snap.coins), MgColors.coin),
          _stat('💰 Venta', _c(_snap.unitPrice), MgColors.green),
        ]),
        const SizedBox(height: 16),
        _btn(
          canBuy ? '📦 Comprar 1 (−${_c(_snap.unitCost)})' : 'Sin monedas',
          MgColors.cyan,
          canBuy
              ? () {
                  if (_engine.buyOne()) {
                    _coinPop('+1 👕');
                    HapticFeedback.selectionClick();
                  }
                }
              : null,
        ),
        const SizedBox(height: 10),
        _btn('📦 Comprar 5', MgColors.magenta, outlined: true,
            _snap.coins >= _snap.unitCost
                ? () {
                    final n = _engine.buyBatch(5);
                    if (n > 0) _coinPop('+$n 👕');
                  }
                : null),
        if (_snap.creditOffered) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MgColors.yellow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: MgColors.yellow.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                const Text('🏦 El proveedor te ofrece crédito',
                    style: TextStyle(
                        color: MgColors.yellow, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Te presta 50 🪙 ahora; devuelves 55 🪙 en 2 meses (10% interés).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                ),
                const SizedBox(height: 10),
                _btn('Aceptar préstamo', MgColors.yellow, () {
                  _engine.takeLoan();
                  _coinPop('+50 🪙');
                }),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        _tip('Te esperan ${_snap.customersRemaining} clientes este mes. '
            'Compra suficiente para no quedarte corto.'),
      ],
    );
  }

  // ── Zona Tienda (vender) ─────────────────────────────────────────────────────
  Widget _buildShop() {
    return _zoneScaffold(
      key: 'shop',
      title: '🏪 Tu tienda',
      subtitle:
          'Atiende a los clientes. Vendes a ${_c(_snap.unitPrice)} cada camiseta.',
      color: MgColors.green,
      children: [
        _sceneBanner(kSceneShop, MgColors.green),
        const SizedBox(height: 12),
        _statStrip([
          _stat('👕 Stock', '${_snap.inventory}', MgColors.cyan),
          _stat('🧑 En cola', '${_snap.customersRemaining}', MgColors.yellow),
          _stat('✅ Vendidas', '${_snap.soldThisMonth}/${_snap.minSales}',
              MgColors.green),
        ]),
        const SizedBox(height: 10),
        _priceSelector(),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _snap.customersTotal > 0
                ? _snap.soldThisMonth / _snap.customersTotal
                : 0,
            minHeight: 10,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(MgColors.green),
          ),
        ),
        const SizedBox(height: 16),
        if (_snap.canServe)
          _btn('💸 Vender (+${_c(_snap.profitPerUnit)} beneficio)',
              MgColors.green, () {
            if (_engine.serveCustomer()) {
              _coinPop('+${_c(_snap.unitPrice)}');
              HapticFeedback.lightImpact();
            }
          })
        else if (_snap.inventory <= 0 && _snap.customersRemaining > 0)
          _tip('¡Sin stock y aún hay ${_snap.customersRemaining} clientes! '
              'Vuelve al proveedor a comprar más.',
              color: MgColors.yellow)
        else
          _tip('🎉 ¡Has atendido a todos los clientes de este mes!',
              color: MgColors.green),
      ],
    );
  }

  Widget _priceSelector({bool forecast = false}) {
    final adjust = forecast ? _forecastPrice : _snap.priceAdjust;
    final locked = !forecast && _snap.priceLocked;
    final basePrice = 10.0;
    final price = basePrice + adjust;
    void change(int delta) {
      if (locked) return;
      setState(() {
        if (forecast) {
          _forecastPrice = (adjust + delta).clamp(-2, 2);
        } else {
          _engine.setPriceAdjust(adjust + delta);
        }
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                forecast ? 'Precio planificado' : 'Precio de venta',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              _roundBtn(Icons.remove, locked ? null : () => change(-1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(_c(price),
                    style: const TextStyle(
                        color: MgColors.coin,
                        fontWeight: FontWeight.w900,
                        fontSize: 15)),
              ),
              _roundBtn(Icons.add, locked ? null : () => change(1)),
            ],
          ),
          if (locked) ...[
            const SizedBox(height: 6),
            Text(
              'Precio bloqueado tras la primera venta del mes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Zona Facturas (pagar gastos fijos) ───────────────────────────────────────
  Widget _buildBills() {
    final tax = _snap.monthRevenue * _snap.taxRate;
    final loan = (_snap.loanOutstanding > 0 && _snap.loanMonthsLeft > 0)
        ? _snap.loanOutstanding / _snap.loanMonthsLeft
        : 0.0;
    final total = _snap.rent + _snap.eventCost + tax + loan;
    return _zoneScaffold(
      key: 'bills',
      title: '📬 Buzón de facturas',
      subtitle: 'El cobrador ha llegado. Estos gastos hay que pagarlos.',
      color: MgColors.magenta,
      children: [
        _sceneBanner(kSceneBills, MgColors.magenta),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MgColors.magenta.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              _billRow('🏠 Alquiler (gasto fijo)', _snap.rent),
              if (_snap.eventCost > 0)
                _billRow('⚡ ${_snap.eventText}', _snap.eventCost),
              if (tax > 0) _billRow('🏛️ Impuesto (10% ventas)', tax),
              if (loan > 0) _billRow('🏦 Cuota del préstamo', loan),
              const Divider(color: Colors.white12, height: 20),
              _billRow('Total a pagar', total, bold: true),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('Tienes ${_c(_snap.coins)}',
            style: TextStyle(
                color: _snap.coins >= total ? MgColors.green : MgColors.magenta,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        if (_snap.billsPaidThisMonth)
          _tip('✅ Ya has pagado tus gastos de este mes.',
              color: MgColors.green)
        else if (!_snap.minSalesMet && !_snap.outOfDemand)
          _tip('Aún no has vendido a ${_snap.minSales} clientes. '
              'Ve a la tienda antes de pagar.',
              color: MgColors.yellow)
        else
          _btn('💵 Pagar al cobrador', MgColors.magenta, () {
            final ok = _engine.payBills();
            if (ok) {
              _coinPop('−${_c(total)}');
              HapticFeedback.mediumImpact();
            }
          }),
      ],
    );
  }

  Widget _billRow(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: bold ? 15 : 13,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w500)),
          ),
          Text(_c(amount),
              style: TextStyle(
                  color: MgColors.magenta,
                  fontSize: bold ? 16 : 14,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // ── Zona Hucha (ahorro, mes 2+) ──────────────────────────────────────────────
  Widget _buildPiggybank() {
    return _zoneScaffold(
      key: 'piggy',
      title: '🐷 Tu hucha',
      subtitle: 'Guarda parte de tu beneficio. Te protege en meses malos.',
      color: MgColors.yellow,
      children: [
        _sceneBanner(kScenePiggy, MgColors.yellow),
        const SizedBox(height: 12),
        _statStrip([
          _stat('🪙 Caja', _c(_snap.coins), MgColors.coin),
          _stat('🐷 Ahorrado', _c(_snap.savings), MgColors.yellow),
          _stat('🎯 Meta', _c(MoneyGardenEngine.victorySavings), MgColors.green),
        ]),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _btn('Guardar 10 🪙', MgColors.yellow,
                  _snap.coins >= 10
                      ? () {
                          _engine.deposit(10);
                          _coinPop('🐷 +10');
                        }
                      : null),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _btn('Sacar 10 🪙', MgColors.cyan, outlined: true,
                  _snap.savings >= 10
                      ? () {
                          _engine.withdraw(10);
                          _coinPop('−10 🪙');
                        }
                      : null),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _tip('Consejo: guarda algo cada mes. En el Mes 12 necesitas '
            '${_c(MoneyGardenEngine.victorySavings)} en la hucha para ganar.'),
      ],
    );
  }

  // ── Zona Oficina (ordenador con pestañas) ────────────────────────────────────
  Widget _buildOffice() {
    return _zoneScaffold(
      key: 'office',
      title: '💻 Tu oficina',
      subtitle:
          'El centro de mando. Estudia tus datos y contrata analistas para '
          'anticipar la demanda.',
      color: MgColors.violet,
      children: [
        _sceneBanner(kSceneOffice, MgColors.violet),
        const SizedBox(height: 12),
        _computer(),
      ],
    );
  }

  Widget _computer() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C1120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MgColors.violet.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: MgColors.violet.withValues(alpha: 0.15),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de título estilo sistema operativo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                for (final c in [
                  const Color(0xFFFF5F57),
                  const Color(0xFFFEBC2E),
                  const Color(0xFF28C840)
                ])
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                const SizedBox(width: 6),
                const Text('MG-OS · Ordenador del negocio',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          // Pestañas
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                _computerTab(0, Icons.ssid_chart, 'Previsión'),
                _computerTab(1, Icons.bar_chart, 'Historial'),
                _computerTab(2, Icons.group, 'Equipo'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: switch (_officeTab) {
                0 => _forecastTab(),
                1 => _statsTab(),
                _ => _teamTab(),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _computerTab(int index, IconData icon, String label) {
    final selected = _officeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _officeTab = index);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? MgColors.violet.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
            border: Border(
              bottom: BorderSide(
                color: selected ? MgColors.violet : Colors.white12,
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: selected ? MgColors.violet : Colors.white38),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      color: selected ? MgColors.violet : Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }

  // Pestaña 1: previsión de demanda (requiere analista)
  Widget _forecastTab() {
    if (_snap.analystLevel == 0) {
      return Column(
        key: const ValueKey('forecast-locked'),
        children: [
          const SizedBox(height: 8),
          Icon(Icons.lock, color: Colors.white24, size: 40),
          const SizedBox(height: 10),
          const Text(
            'Previsión bloqueada',
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
                fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            'Contrata un analista en la pestaña Equipo para ver cuántos '
            'clientes se esperan el próximo mes.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
          ),
          const SizedBox(height: 12),
          _btn('Ir a Equipo', MgColors.violet, () {
            setState(() => _officeTab = 2);
          }),
        ],
      );
    }
    if (!_snap.hasNextMonth) {
      return _tip(
          '🏁 Es tu último mes: ya no queda nada que predecir. ¡Dalo todo!',
          color: MgColors.violet);
    }
    // Mes volátil: el júnior no saca nada en claro; el sénior avisa.
    if (_snap.nextVolatile && _snap.analystLevel < 2) {
      return Column(
        key: const ValueKey('forecast-noise'),
        children: [
          const SizedBox(height: 8),
          const Text('🌪️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          const Text('Datos no concluyentes',
              style: TextStyle(
                  color: MgColors.yellow,
                  fontWeight: FontWeight.w800,
                  fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            'El mercado anda revuelto y tu analista júnior no consigue una '
            'previsión fiable para el mes ${_snap.month + 1}. Un analista '
            'sénior sabría leer estos datos.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
          ),
        ],
      );
    }
    final mean = _snap.forecastMeanShownAt(_forecastPrice);
    final sigma = _snap.forecastSigmaShownAt(_forecastPrice);
    final lo = (mean - sigma).round();
    final hi = (mean + sigma).round();
    final plannedPrice = 10 + _forecastPrice;
    return Column(
      key: ValueKey('forecast-${_snap.month}-${_snap.analystLevel}-$_forecastPrice'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demanda prevista · Mes ${_snap.month + 1}',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          _snap.analystLevel >= 2
              ? 'Previsión del analista sénior'
              : 'Estimación aproximada del analista júnior',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
        ),
        if (_snap.nextVolatile) ...[
          const SizedBox(height: 8),
          _tip(
              '🌪️ Aviso del sénior: se espera un mes volátil. La campana es '
              'mucho más ancha de lo normal: prepárate para cualquier cosa.',
              color: MgColors.yellow),
        ],
        const SizedBox(height: 10),
        _priceSelector(forecast: true),
        const SizedBox(height: 10),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: CustomPaint(
            painter: _BellCurvePainter(
              mean: mean,
              sigma: sigma,
              color: MgColors.violet,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _tip(
          '📈 Con precio de ${_c(plannedPrice)}: lo más probable ~${mean.round()} '
          'clientes. Unas 2 de cada 3 veces caerá entre $lo y $hi.',
          color: MgColors.violet,
        ),
      ],
    );
  }

  // Pestaña 2: historial de demanda y estadísticas
  Widget _statsTab() {
    final h = _snap.history;
    if (h.isEmpty) {
      return _tip(
          '📅 Aún no hay datos. Cierra tu primer mes y aquí verás la demanda, '
          'tus ventas y mucho más.',
          color: MgColors.violet);
    }
    final totalRevenue = h.fold<double>(0, (s, r) => s + r.revenue);
    final totalProfit = h.fold<double>(0, (s, r) => s + r.profit);
    final best = h.reduce((a, b) => a.profit >= b.profit ? a : b);
    final lostClients = h.fold<int>(0, (s, r) => s + (r.demand - r.sold));
    final avgSold =
        (h.fold<int>(0, (s, r) => s + r.sold) / h.length).toStringAsFixed(1);
    final maxDemand =
        h.fold<int>(1, (m, r) => r.demand > m ? r.demand : m);
    return Column(
      key: const ValueKey('stats'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Demanda vs. ventas por mes',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13)),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final r in h)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _histBar(r.demand / maxDemand, MgColors.violet),
                            const SizedBox(width: 2),
                            _histBar(r.sold / maxDemand,
                                r.impago ? MgColors.magenta : MgColors.green),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('M${r.month}',
                            style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _legendDot(MgColors.violet, 'Clientes que vinieron'),
            const SizedBox(width: 12),
            _legendDot(MgColors.green, 'Ventas'),
          ],
        ),
        const SizedBox(height: 14),
        _statStrip([
          _stat('💰 Ingresos', _c(totalRevenue), MgColors.green),
          _stat('📈 Beneficio', _c(totalProfit),
              totalProfit >= 0 ? MgColors.green : MgColors.magenta),
        ]),
        const SizedBox(height: 8),
        _statStrip([
          _stat('🏆 Mejor mes', 'M${best.month}', MgColors.yellow),
          _stat('🛍️ Ventas/mes', avgSold, MgColors.cyan),
          _stat('🚶 Perdidos', '$lostClients', MgColors.magenta),
        ]),
        if (lostClients > 3) ...[
          const SizedBox(height: 10),
          _tip(
              '💡 Has dejado escapar $lostClients clientes por falta de '
              'stock. Cada uno era dinero que se fue a otra tienda.',
              color: MgColors.yellow),
        ],
      ],
    );
  }

  Widget _histBar(double factor, Color color) {
    return Container(
      width: 9,
      height: (96 * factor.clamp(0.04, 1.0)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  // Pestaña 3: contratar analistas
  Widget _teamTab() {
    final level = _snap.analystLevel;
    return Column(
      key: const ValueKey('team'),
      children: [
        _analystCard(
          icon: Icons.query_stats,
          name: 'Analista júnior',
          salary: 10,
          desc: 'Te dibuja la campana de demanda del próximo mes, aunque con '
              'margen de error. En meses revueltos se pierde.',
          active: level >= 1,
          action: level == 0
              ? _btn('Contratar · 10 🪙/mes', MgColors.violet, () {
                  HapticFeedback.lightImpact();
                  _engine.hireAnalyst();
                })
              : null,
        ),
        const SizedBox(height: 10),
        _analystCard(
          icon: Icons.insights,
          name: 'Analista sénior',
          salary: 20,
          desc: 'Previsión precisa, y además te avisa cuando viene un mes '
              'volátil. La mejor información del mercado.',
          active: level >= 2,
          action: level == 1
              ? _btn('Ascender a sénior · 20 🪙/mes', MgColors.violet, () {
                  HapticFeedback.lightImpact();
                  _engine.upgradeAnalyst();
                })
              : (level == 0
                  ? _tip('Necesitas primero un analista júnior.',
                      color: MgColors.yellow)
                  : null),
        ),
        if (level > 0) ...[
          const SizedBox(height: 12),
          _btn('Despedir al equipo (ahorras el salario)', Colors.white24,
              outlined: true, () {
            HapticFeedback.mediumImpact();
            _engine.fireAnalysts();
          }),
        ],
      ],
    );
  }

  Widget _analystCard({
    required IconData icon,
    required String name,
    required int salary,
    required String desc,
    required bool active,
    Widget? action,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active
            ? MgColors.violet.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? MgColors.violet : Colors.white12,
          width: active ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MgColors.violet.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: MgColors.violet, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
              ),
              if (active)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: MgColors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: MgColors.green.withValues(alpha: 0.5)),
                  ),
                  child: const Text('EN PLANTILLA',
                      style: TextStyle(
                          color: MgColors.green,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 12,
                  height: 1.35)),
          if (action != null) ...[
            const SizedBox(height: 10),
            action,
          ],
        ],
      ),
    );
  }

  // ── Resumen de mes ───────────────────────────────────────────────────────────
  Widget _buildSummary() {
    final positive = _snap.lastProfit >= 0;
    return Container(
      key: const ValueKey('summary'),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Text('Resumen del Mes ${_snap.month}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          if (_snap.lastImpago)
            const Text('😟 Este mes no pudiste pagar todo',
                style: TextStyle(color: MgColors.magenta, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: (positive ? MgColors.green : MgColors.magenta)
                          .withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    _sumRow('🛍️ Ingresos por ventas', _snap.monthRevenue,
                        MgColors.green),
                    _sumRow('📦 Coste mercancía (variable)',
                        -_snap.monthGoodsCost, MgColors.yellow),
                    _sumRow('🏠 Alquiler (fijo)', -_snap.rent, MgColors.magenta),
                    if (_snap.eventCost > 0)
                      _sumRow('⚡ Imprevisto', -_snap.eventCost, MgColors.magenta),
                    if (_snap.lastTaxPaid > 0)
                      _sumRow('🏛️ Impuesto', -_snap.lastTaxPaid,
                          MgColors.magenta),
                    const Divider(color: Colors.white12, height: 22),
                    _sumRow(positive ? '✅ Beneficio' : '❌ Pérdidas',
                        _snap.lastProfit,
                        positive ? MgColors.green : MgColors.magenta,
                        bold: true),
                    const SizedBox(height: 16),
                    _kaiNote(_summaryFeedback()),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _statStrip([
            _stat('🪙 Caja', _c(_snap.coins), MgColors.coin),
            _stat('🐷 Hucha', _c(_snap.savings), MgColors.yellow),
            _stat('⭐ Fama', '${_snap.reputation}', MgColors.cyan),
          ]),
          const SizedBox(height: 14),
          _btn(
            _snap.month >= MoneyGardenEngine.totalMonths
                ? '🏁 Ver resultado final'
                : '▶ Empezar Mes ${_snap.month + 1}',
            MgColors.green,
            () {
              setState(() => _avatarPos = _avatarHome);
              _engine.nextMonth();
            },
          ),
        ],
      ),
    );
  }

  String _summaryFeedback() {
    if (_snap.lastImpago) {
      return 'Este mes no llegaste a pagar todo. Baja tu fama. Si vuelve a '
          'pasar el mes que viene, tu negocio cerrará. ¡Vende más!';
    }
    if (_snap.lastProfit < 0) {
      return 'Has perdido dinero. Revisa cuánto compras y a qué precio vendes.';
    }
    if (_snap.month == 1) {
      return 'Has comprado, vendido y pagado tus gastos como un profesional. '
          '¡Buen comienzo!';
    }
    return '¡Buen trabajo! Sigue creciendo poco a poco y no olvides tu hucha.';
  }

  // ── Fin del juego ────────────────────────────────────────────────────────────
  Widget _buildEnd(bool won) {
    return Container(
      key: ValueKey(won ? 'victory' : 'gameover'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(won ? '🏆' : '💤', style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text(
            won ? '¡Lo lograste!' : 'Tu negocio ha cerrado',
            style: TextStyle(
                color: won ? MgColors.green : MgColors.magenta,
                fontSize: 26,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Text(
            won
                ? 'Tu negocio sobrevivió 12 meses y ahorraste '
                    '${_c(_snap.savings)}. Has aprendido a ganar, gastar con '
                    'cabeza y ahorrar. ¡Eres un/a auténtic@ gestor@!'
                : 'Gastaste más de lo que ingresabas de forma sostenida. '
                    'No pasa nada: los mejores emprendedores aprenden de los '
                    'errores. ¡Inténtalo de nuevo!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 15,
                height: 1.5),
          ),
          const SizedBox(height: 28),
          _btn('🔄 Jugar de nuevo', MgColors.cyan, () {
            setState(() => _avatarPos = _avatarHome);
            _engine.restart();
            _charCtrl.forward(from: 0);
          }),
          const SizedBox(height: 10),
          _btn('Salir', Colors.white24, outlined: true,
              () => Navigator.pop(context)),
        ],
      ),
    );
  }

  // ── Componentes reutilizables ────────────────────────────────────────────────
  Widget _hud() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(
            bottom: BorderSide(color: MgColors.magenta.withValues(alpha: 0.35))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
          Expanded(
            child: Wrap(
              spacing: 5,
              runSpacing: 3,
              alignment: WrapAlignment.center,
              children: [
                _avatarChip(),
                _chip(_c(_snap.coins), MgColors.coin),
                _chip('🐷 ${_c(_snap.savings)}', MgColors.yellow),
                _chip('⭐ ${_snap.reputation}', MgColors.cyan),
                _chip('📅 ${_snap.month}/12', MgColors.green),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.white70, size: 20),
            onPressed: _openNotebook,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
        ],
      ),
    );
  }

  /// Chip del HUD con la cara real del personaje y su nombre.
  Widget _avatarChip() {
    final opt = _opt;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: opt.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: opt.color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              opt.image,
              width: 15,
              height: 15,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.85),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _snap.avatarName,
            style: TextStyle(
              color: opt.color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _mentorBanner() {
    if (_snap.mentorFlash == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _engine.clearMentorFlash,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MgColors.yellow.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: MgColors.yellow.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            _kaiFace(38),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_snap.mentorFlash!,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, height: 1.35)),
            ),
            const Icon(Icons.close, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _zoneScaffold({
    required String key,
    required String title,
    required String subtitle,
    required Color color,
    required List<Widget> children,
  }) {
    return Column(
      key: ValueKey(key),
      children: [
        _hud(),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                      height: 1.35)),
            ],
          ),
        ),
        _mentorBanner(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: _btn('🗺️ Volver al mapa', Colors.white24, outlined: true,
              _returnMap),
        ),
      ],
    );
  }

  /// Banner de escena: ilustración del interior de la zona con la ficha
  /// del jugador y el pop de monedas superpuestos.
  Widget _sceneBanner(String image, Color color) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            // Degradado inferior para dar profundidad
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.55, 1],
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: AnimatedBuilder(
                animation: _idleCtrl,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, -2 + _idleCtrl.value * 4),
                  child: child,
                ),
                child: _faceToken(44),
              ),
            ),
            _coinFloat(),
          ],
        ),
      ),
    );
  }

  Widget _coinFloat() {
    return AnimatedBuilder(
      animation: _coinCtrl,
      builder: (_, __) {
        if (_coinCtrl.value == 0 || _coinCtrl.isDismissed) {
          return const SizedBox.shrink();
        }
        return Positioned(
          top: 16 - _coinCtrl.value * 16,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: (1 - _coinCtrl.value).clamp(0.0, 1.0),
            child: Center(
              child: Text(_coinText,
                  style: const TextStyle(
                      color: MgColors.coin,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)])),
            ),
          ),
        );
      },
    );
  }

  Widget _statStrip(List<Widget> items) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: items[i]),
          if (i < items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 10)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w800, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _sumRow(String label, double amount, Color color, {bool bold = false}) {
    final sign = amount > 0 ? '+' : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: bold ? 16 : 13,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w500)),
          ),
          Text('$sign${_c(amount)}',
              style: TextStyle(
                  color: color,
                  fontSize: bold ? 18 : 14,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _kaiNote(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MgColors.cyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _kaiFace(34),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _tip(String text, {Color color = MgColors.cyan}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(text,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              height: 1.4)),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: onTap == null ? 0.04 : 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            color: onTap == null ? Colors.white38 : Colors.white, size: 18),
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback? onTap,
      {bool outlined = false}) {
    final enabled = onTap != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: !enabled
              ? Colors.white10
              : outlined
                  ? Colors.transparent
                  : color.withValues(alpha: 0.22),
          foregroundColor: enabled ? color : Colors.white38,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: enabled ? color : Colors.white24),
          ),
          elevation: enabled && !outlined ? 5 : 0,
          shadowColor: color.withValues(alpha: 0.4),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      ),
    );
  }

  // ── Tarjeta educativa (pop-up) ───────────────────────────────────────────────
  Widget _flashcardOverlay(Flashcard card) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: MgColors.bgSoft,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: MgColors.cyan.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                  color: MgColors.cyan.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(card.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(card.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: MgColors.cyan,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(card.body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, height: 1.45)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('💡 ${card.example}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.4)),
              ),
              const SizedBox(height: 18),
              _btn('Entendido 👍', MgColors.green, _engine.dismissCard),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotebook() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: MgColors.bgSoft,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final ids = _snap.notebook;
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scroll) => Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('📓 Cuaderno de aprendizaje',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
              ),
              Expanded(
                child: ids.isEmpty
                    ? Center(
                        child: Text(
                          'Aún no has aprendido nada.\n¡Juega para descubrir '
                          'tarjetas!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6)),
                        ),
                      )
                    : ListView(
                        controller: scroll,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        children: ids.map((id) {
                          final card = kFlashcards[id]!;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: MgColors.cyan.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(card.emoji,
                                        style: const TextStyle(fontSize: 24)),
                                    const SizedBox(width: 8),
                                    Text(card.title,
                                        style: const TextStyle(
                                            color: MgColors.cyan,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(card.body,
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.85),
                                        fontSize: 13,
                                        height: 1.4)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Campana de Gauss para la pestaña de previsión de demanda.
class _BellCurvePainter extends CustomPainter {
  final double mean;
  final double sigma;
  final Color color;

  const _BellCurvePainter({
    required this.mean,
    required this.sigma,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sigma <= 0) return;

    const padH = 16.0;
    const padTop = 8.0;
    const padBottom = 34.0;
    final plotW = size.width - padH * 2;
    final plotH = size.height - padTop - padBottom;
    final baseline = size.height - padBottom;

    final xMin = mean - 3 * sigma;
    final xMax = mean + 3 * sigma;
    final range = xMax - xMin;
    if (range <= 0) return;

    double pdf(double x) {
      final z = (x - mean) / sigma;
      return exp(-0.5 * z * z) / (sigma * sqrt(2 * pi));
    }

    final peak = pdf(mean);
    if (peak <= 0) return;

    double xToPx(double x) => padH + (x - xMin) / range * plotW;

    // Área bajo la curva
    final fillPath = Path();
    fillPath.moveTo(xToPx(xMin), baseline);
    for (var i = 0; i <= 120; i++) {
      final t = i / 120;
      final x = xMin + t * range;
      final y = baseline - (pdf(x) / peak) * plotH;
      fillPath.lineTo(xToPx(x), y);
    }
    fillPath.lineTo(xToPx(xMax), baseline);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: 0.22)
        ..style = PaintingStyle.fill,
    );

    // Línea de la curva
    final curvePath = Path();
    for (var i = 0; i <= 120; i++) {
      final t = i / 120;
      final x = xMin + t * range;
      final y = baseline - (pdf(x) / peak) * plotH;
      if (i == 0) {
        curvePath.moveTo(xToPx(x), y);
      } else {
        curvePath.lineTo(xToPx(x), y);
      }
    }
    canvas.drawPath(
      curvePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Eje X
    canvas.drawLine(
      Offset(padH, baseline),
      Offset(size.width - padH, baseline),
      Paint()..color = Colors.white24,
    );

    void drawMarker(double x, {bool main = false}) {
      final px = xToPx(x);
      canvas.drawLine(
        Offset(px, baseline),
        Offset(px, baseline - (main ? plotH * 0.92 : plotH * 0.55)),
        Paint()
          ..color = main ? color : color.withValues(alpha: 0.45)
          ..strokeWidth = main ? 2 : 1,
      );
    }

    drawMarker(mean - sigma);
    drawMarker(mean, main: true);
    drawMarker(mean + sigma);

    // Etiquetas del eje X (clientes)
    void drawXLabel(double x, String text, {bool highlight = false}) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: highlight ? color : Colors.white54,
            fontSize: highlight ? 11 : 10,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      var left = xToPx(x) - tp.width / 2;
      left = left.clamp(padH, size.width - padH - tp.width);
      tp.paint(canvas, Offset(left, baseline + 6));
    }

    final tickValues = <double>{
      xMin,
      mean - 2 * sigma,
      mean - sigma,
      mean,
      mean + sigma,
      mean + 2 * sigma,
      xMax,
    }.where((v) => v >= xMin - 0.01 && v <= xMax + 0.01).toList()
      ..sort();

    for (final x in tickValues) {
      final isMean = (x - mean).abs() < 0.01;
      canvas.drawLine(
        Offset(xToPx(x), baseline),
        Offset(xToPx(x), baseline + 4),
        Paint()..color = isMean ? color : Colors.white38,
      );
      drawXLabel(x, x.round().toString(), highlight: isMean);
    }

    // Título del eje
    const axisTitle = 'Clientes';
    final axisTp = TextPainter(
      text: const TextSpan(
        text: axisTitle,
        style: TextStyle(
          color: Colors.white38,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    axisTp.paint(
      canvas,
      Offset(size.width - padH - axisTp.width, baseline + 20),
    );
  }

  @override
  bool shouldRepaint(covariant _BellCurvePainter oldDelegate) =>
      oldDelegate.mean != mean ||
      oldDelegate.sigma != sigma ||
      oldDelegate.color != color;
}
