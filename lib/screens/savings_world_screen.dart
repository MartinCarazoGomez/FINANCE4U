import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import 'content_screen.dart';
import 'savings_world_art.dart';

// ── World anchors ─────────────────────────────────────────────────────────────

class _BuildingAnchor {
  final int pillIndex;
  final Offset footPos; // world pixel coords (foot of building)
  final BuildingKind kind;
  final String label;
  final Size size;

  const _BuildingAnchor({
    required this.pillIndex,
    required this.footPos,
    required this.kind,
    required this.label,
    required this.size,
  });

  Rect get hitRect => Rect.fromCenter(
        center: Offset(footPos.dx, footPos.dy - size.height / 2 + 8),
        width: size.width + 16,
        height: size.height + 8,
      );

  double get sortY => footPos.dy;
}

const _kBuildings = [
  // Hub central — lecciones básicas
  _BuildingAnchor(
    pillIndex: 0,
    footPos: Offset(700, 320),
    kind: BuildingKind.cottage,
    label: '50/30/20',
    size: Size(88, 96),
  ),
  _BuildingAnchor(
    pillIndex: 1,
    footPos: Offset(840, 320),
    kind: BuildingKind.vault,
    label: 'Emergencia',
    size: Size(88, 96),
  ),
  // Dificultades progresivas hacia el oeste
  _BuildingAnchor(
    pillIndex: 2,
    footPos: Offset(520, 340),
    kind: BuildingKind.bank,
    label: 'Automático',
    size: Size(96, 104),
  ),
  _BuildingAnchor(
    pillIndex: 3,
    footPos: Offset(300, 340),
    kind: BuildingKind.shop,
    label: 'Hormiga',
    size: Size(88, 88),
  ),
  _BuildingAnchor(
    pillIndex: 4,
    footPos: Offset(120, 340),
    kind: BuildingKind.tower,
    label: '30 días',
    size: Size(80, 112),
  ),
];

class _BarrierDef {
  final Offset pos;
  final int beforePill;
  final bool vertical;
  final Size size;

  const _BarrierDef({
    required this.pos,
    required this.beforePill,
    this.vertical = false,
    this.size = const Size(64, 48),
  });
}

const _kBarriers = [
  // Puerta rústica antes de la zona Automático (pill 2)
  _BarrierDef(
    pos: Offset(660, 340),
    beforePill: 2,
    vertical: true,
    size: Size(56, 140),
  ),
  // Puerta rústica antes de la zona Hormiga (pill 3)
  _BarrierDef(
    pos: Offset(420, 340),
    beforePill: 3,
    vertical: true,
    size: Size(56, 140),
  ),
  // Puerta rústica antes de la zona 30 días (pill 4)
  _BarrierDef(
    pos: Offset(260, 340),
    beforePill: 4,
    vertical: true,
    size: Size(56, 140),
  ),
];

const _kSpawn = Offset(720, 460);

/// Hitbox del héroe (centro en los pies) — más pequeña para pasillos anchos.
const _kHeroHitW = 18.0;
const _kHeroHitH = 16.0;

// ── Screen ────────────────────────────────────────────────────────────────────

class SavingsWorldScreen extends StatefulWidget {
  final Topic topic;
  const SavingsWorldScreen({super.key, required this.topic});

  @override
  State<SavingsWorldScreen> createState() => _SavingsWorldScreenState();
}

class _SavingsWorldScreenState extends State<SavingsWorldScreen>
    with TickerProviderStateMixin {
  Offset _heroPos = _kSpawn;
  Facing _facing = Facing.down;
  bool _walking = false;
  int _walkFrame = 0;

  late AnimationController _walkCtrl;
  late AnimationController _ambientCtrl;
  late AnimationController _walkFrameCtrl;

  VoidCallback? _walkListener;
  Offset _walkFrom = _kSpawn;
  Offset _walkDest = _kSpawn;
  Offset? _tapRipple;
  int _walkGeneration = 0;
  int? _walkBlockedPill;
  Offset _walkRequestedDest = _kSpawn;
  Set<String> _walkCompleted = const {};

  final WorldTileMap _tileMap = WorldTileMap();
  final List<AmbientParticle> _particles = [];
  final math.Random _rng = math.Random(99);

  @override
  void initState() {
    super.initState();
    _walkCtrl = AnimationController(vsync: this);
    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _walkFrameCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _walkFrameCtrl.addListener(() {
      if (_walking && mounted) {
        setState(() => _walkFrame = (_walkFrameCtrl.value * 4).floor() % 4);
      }
    });

    _walkListener = () {
      if (!mounted) return;
      var pos = Offset.lerp(_walkFrom, _walkDest, _walkCtrl.value)!;
      if (!_canHeroStandAt(pos, _walkCompleted)) {
        pos = _furthestSafePoint(_walkFrom, pos, _walkCompleted);
        _walkCtrl.stop();
      }
      setState(() => _heroPos = pos);
    };
    _walkCtrl.addListener(_walkListener!);

    _initParticles();
    _ambientCtrl.addListener(_tickParticles);
    _heroPos = _findNearestWalkable(_kSpawn, const {});
  }

  void _initParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(_spawnParticle());
    }
  }

  AmbientParticle _spawnParticle() {
    return AmbientParticle(
      pos: Offset(
        _rng.nextDouble() * WorldTileMap.width,
        _rng.nextDouble() * WorldTileMap.height,
      ),
      vel: Offset(_rng.nextDouble() * 0.3 - 0.15, _rng.nextDouble() * 0.2 + 0.05),
      life: _rng.nextDouble(),
      color: [
        const Color(0xFF88FF88),
        const Color(0xFFFFFF88),
        const Color(0xFFFFD700),
      ][_rng.nextInt(3)],
      size: 1.5 + _rng.nextDouble() * 2,
    );
  }

  void _tickParticles() {
    for (int i = 0; i < _particles.length; i++) {
      final p = _particles[i];
      p.pos += p.vel;
      p.life -= 0.003;
      if (p.life <= 0 ||
          p.pos.dx < 0 ||
          p.pos.dx > WorldTileMap.width ||
          p.pos.dy < 0 ||
          p.pos.dy > WorldTileMap.height) {
        _particles[i] = _spawnParticle();
      }
    }
  }

  @override
  void dispose() {
    if (_walkListener != null) {
      _walkCtrl.removeListener(_walkListener!);
    }
    _walkCtrl.dispose();
    _ambientCtrl.dispose();
    _walkFrameCtrl.dispose();
    super.dispose();
  }

  bool _isPillUnlocked(int index, Set<String> completed) {
    if (index <= 1) return true;
    return completed.contains(savingsPills[index - 1].title);
  }

  bool _isBarrierOpen(int beforePill, Set<String> completed) =>
      _isPillUnlocked(beforePill, completed);

  Rect _heroHitRect(Offset center) => Rect.fromCenter(
        center: center,
        width: _kHeroHitW,
        height: _kHeroHitH,
      );

  Offset _findNearestWalkable(Offset origin, Set<String> completed) {
    if (_canHeroStandAt(origin, completed)) return origin;
    for (var radius = 20.0; radius <= 200; radius += 20) {
      for (var i = 0; i < 16; i++) {
        final angle = i * math.pi / 8;
        final candidate = origin +
            Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        if (_canHeroStandAt(candidate, completed)) return candidate;
      }
    }
    return origin;
  }

  Offset _resolveWalkTarget(Offset raw, Set<String> completed) {
    final clamped = Offset(
      raw.dx.clamp(24.0, WorldTileMap.width - 24),
      raw.dy.clamp(24.0, WorldTileMap.height - 24),
    );
    return _findNearestWalkable(clamped, completed);
  }

  /// Caja sólida de la puerta cerrada.
  Rect _barrierBlockRect(_BarrierDef barrier) {
    if (barrier.vertical) {
      return Rect.fromCenter(
        center: barrier.pos,
        width: barrier.size.width,
        height: barrier.size.height,
      );
    }
    return Rect.fromCenter(
      center: barrier.pos,
      width: barrier.size.width,
      height: barrier.size.height,
    );
  }

  bool Function(int) _gateOpenFn(Set<String> completed) =>
      (beforePill) => _isBarrierOpen(beforePill, completed);

  bool _canHeroStandAt(Offset feet, Set<String> completed) {
    if (_overlapsAnyBarrier(feet, _closedBarrierRects(completed))) {
      return false;
    }
    return _tileMap.isPositionWalkable(feet, _gateOpenFn(completed));
  }

  List<Rect> _closedBarrierRects(Set<String> completed) => [
        for (final barrier in _kBarriers)
          if (!_isBarrierOpen(barrier.beforePill, completed))
            _barrierBlockRect(barrier),
      ];

  bool _overlapsAnyBarrier(Offset pos, List<Rect> blocks) =>
      blocks.any((rect) => _heroHitRect(pos).overlaps(rect));

  int? _barrierBlockingMove(Offset from, Offset to, Set<String> completed) {
    for (final barrier in _kBarriers) {
      if (_isBarrierOpen(barrier.beforePill, completed)) continue;
      final rect = _barrierBlockRect(barrier);
      const steps = 24;
      for (var i = 0; i <= steps; i++) {
        final p = Offset.lerp(from, to, i / steps)!;
        if (_heroHitRect(p).overlaps(rect)) return barrier.beforePill;
      }
    }
    return null;
  }

  Offset _furthestSafePoint(Offset from, Offset to, Set<String> completed) {
    final dist = (to - from).distance;
    if (dist < 2) return from;
    final steps = (dist / 4).ceil().clamp(8, 120);
    var lastSafe = from;
    for (var i = 1; i <= steps; i++) {
      final p = Offset.lerp(from, to, i / steps)!;
      if (!_canHeroStandAt(p, completed)) break;
      lastSafe = p;
    }
    return lastSafe;
  }

  ({Offset target, int? blockedBeforePill}) _clipWalkTarget(
    Offset from,
    Offset to,
    Set<String> completed,
  ) {
    final safe = _furthestSafePoint(from, to, completed);
    if ((safe - to).distance < 2) {
      final pill = _barrierBlockingMove(from, to, completed);
      return (target: safe, blockedBeforePill: pill);
    }

    final blockedPill = _barrierBlockingMove(from, to, completed);
    return (target: safe, blockedBeforePill: blockedPill);
  }

  void _showBarrierHint(int beforePill) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔒 Completa "${savingsPills[beforePill - 1].title}" para abrir el camino.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Offset _cameraOffset(Size viewport, double worldScale) {
    final visibleW = viewport.width / worldScale;
    final visibleH = viewport.height / worldScale;
    final ox = (_heroPos.dx - visibleW / 2)
        .clamp(0.0, math.max(0.0, WorldTileMap.width - visibleW))
        .toDouble();
    final oy = (_heroPos.dy - visibleH / 2)
        .clamp(0.0, math.max(0.0, WorldTileMap.height - visibleH))
        .toDouble();
    return Offset(ox, oy);
  }

  double _worldScale(Size viewport) =>
      viewport.height / WorldTileMap.height;

  int? _getNearBuilding(Set<String> completed) {
    int? nearest;
    double nearestDist = 70;
    for (final b in _kBuildings) {
      if (!_isPillUnlocked(b.pillIndex, completed)) continue;
      final d = (_heroPos - b.footPos).distance;
      if (d < nearestDist) {
        nearestDist = d;
        nearest = b.pillIndex;
      }
    }
    return nearest;
  }

  Future<void> _walkTo(
    Offset target,
    Set<String> completed, {
    VoidCallback? onArrive,
  }) async {
    final resolved = _resolveWalkTarget(target, completed);
    final clip = _clipWalkTarget(_heroPos, resolved, completed);
    final dest = clip.target;
    final delta = dest - _heroPos;
    final dist = delta.distance;
    if (dist < 2) {
      if (clip.blockedBeforePill != null &&
          (resolved - _heroPos).distance > 12) {
        _showBarrierHint(clip.blockedBeforePill!);
      }
      onArrive?.call();
      return;
    }

    // Facing — hacia el destino pedido, no solo el recortado
    final faceDelta = resolved - _heroPos;
    if (faceDelta.dx.abs() > faceDelta.dy.abs()) {
      _facing = faceDelta.dx > 0 ? Facing.right : Facing.left;
    } else {
      _facing = faceDelta.dy > 0 ? Facing.down : Facing.up;
    }

    _walkCtrl.stop();
    _walkFrom = _heroPos;
    _walkDest = dest;
    _walkRequestedDest = resolved;
    _walkCompleted = completed;
    _walkBlockedPill = clip.blockedBeforePill;
    final gen = ++_walkGeneration;

    _walkCtrl.duration =
        Duration(milliseconds: (dist * 7).clamp(200, 1800).round());

    setState(() {
      _walking = true;
      _tapRipple = resolved;
    });
    _walkFrameCtrl.repeat();

    await _walkCtrl.forward(from: 0);

    if (!mounted || gen != _walkGeneration) return;

    _walkFrameCtrl.stop();
    setState(() {
      _walking = false;
      _heroPos = _walkDest;
    });
    onArrive?.call();

    if (_walkBlockedPill != null &&
        (_walkRequestedDest - _walkFrom).distance >
            (_walkDest - _walkFrom).distance + 12) {
      _showBarrierHint(_walkBlockedPill!);
    }
    _walkBlockedPill = null;
    _walkCompleted = const {};

    // Fade tap ripple
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _tapRipple = null);
    });
  }

  Offset _viewportToWorld(
    Offset viewportPos,
    double worldScale,
    Offset cam,
  ) =>
      Offset(
        viewportPos.dx / worldScale + cam.dx,
        viewportPos.dy / worldScale + cam.dy,
      );

  void _onViewportTap(
    Offset viewportPos,
    Size viewport,
    double worldScale,
    Offset cam,
    Set<String> completed,
  ) {
    _onWorldTap(_viewportToWorld(viewportPos, worldScale, cam), completed);
  }

  void _onWorldTap(Offset worldPos, Set<String> completed) {
    // Check building hit
    for (final b in _kBuildings) {
      if (b.hitRect.contains(worldPos)) {
        _interactBuilding(b, completed);
        return;
      }
    }

    // Check barrier tap (show hint)
    for (final barrier in _kBarriers) {
      final rect = Rect.fromCenter(
        center: barrier.pos,
        width: barrier.size.width + 20,
        height: barrier.size.height + 20,
      );
      if (rect.contains(worldPos) && !_isBarrierOpen(barrier.beforePill, completed)) {
        _showBarrierHint(barrier.beforePill);
        return;
      }
    }

    _walkTo(worldPos, completed);
  }

  Future<void> _interactBuilding(_BuildingAnchor b, Set<String> completed) async {
    final unlocked = _isPillUnlocked(b.pillIndex, completed);

    await _walkTo(
      Offset(b.footPos.dx, b.footPos.dy + 28),
      completed,
      onArrive: () => _enterBuilding(b, unlocked),
    );
  }

  Future<void> _enterBuilding(_BuildingAnchor b, bool unlocked) async {
    if (!mounted) return;

    if (!unlocked) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 Completa "${savingsPills[b.pillIndex - 1].title}" primero.',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    await openPillLesson(context, savingsPills[b.pillIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;

    return Scaffold(
      backgroundColor: const Color(0xFF1A2E1A),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          final completed = appProvider.completedLessons;
          final doneCount =
              savingsPills.where((p) => completed.contains(p.title)).length;
          final nearBuilding = _getNearBuilding(completed);

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Viewport with camera ────────────────────────────────────
              LayoutBuilder(
                builder: (context, constraints) {
                  final viewport = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final worldScale = _worldScale(viewport);
                  final cam = _cameraOffset(viewport, worldScale);
                  final time = _ambientCtrl.value * 8;

                  return ClipRect(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Fondo (visible solo en los márgenes laterales al hacer pan)
                        IgnorePointer(
                          child: ColoredBox(
                            color: const Color(0xFF3A7A28),
                            child: CustomPaint(
                              painter: SkyPainter(time: time),
                              size: viewport,
                            ),
                          ),
                        ),

                        // Mundo escalado — visual only; taps handled at viewport level
                        IgnorePointer(
                          child: Transform.translate(
                            offset: Offset(
                              -cam.dx * worldScale,
                              -cam.dy * worldScale,
                            ),
                            child: Transform.scale(
                              scale: worldScale,
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: WorldTileMap.width,
                                height: WorldTileMap.height,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _ambientCtrl,
                                      builder: (_, __) => CustomPaint(
                                        painter: TileMapPainter(
                                          map: _tileMap,
                                          waterPhase: _ambientCtrl.value * 8,
                                        ),
                                        size: const Size(
                                          WorldTileMap.width,
                                          WorldTileMap.height,
                                        ),
                                      ),
                                    ),
                                    AnimatedBuilder(
                                      animation: _ambientCtrl,
                                      builder: (_, __) => CustomPaint(
                                        painter: AmbientPainter(
                                          particles: _particles,
                                        ),
                                        size: const Size(
                                          WorldTileMap.width,
                                          WorldTileMap.height,
                                        ),
                                      ),
                                    ),
                                    ...List.generate(_treePositions.length, (i) {
                                      final t = _treePositions[i];
                                      final sc = _treeScales[i];
                                      final isPine = _treeIsPine[i];
                                      final sz = (isPine ? 40.0 : 44.0) * sc;
                                      final h = (isPine ? 72.0 : 62.0) * sc;
                                      return Positioned(
                                        left: t.dx - sz / 2,
                                        top: t.dy - h + 8,
                                        child: CustomPaint(
                                          painter: isPine
                                              ? PineTreePainter(
                                                  sway: time + t.dx * 0.01,
                                                  scale: sc,
                                                )
                                              : TreePainter(
                                                  sway: time + t.dx * 0.01,
                                                  scale: sc,
                                                ),
                                          size: Size(sz, h),
                                        ),
                                      );
                                    }),
                                    AnimatedBuilder(
                                      animation: _ambientCtrl,
                                      builder: (_, __) => Stack(
                                        clipBehavior: Clip.none,
                                        children: _buildSortedEntities(
                                          completed,
                                          _ambientCtrl.value * 8,
                                          cam,
                                          viewport,
                                        ),
                                      ),
                                    ),
                                    if (_tapRipple != null)
                                      Positioned(
                                        left: _tapRipple!.dx - 14,
                                        top: _tapRipple!.dy - 14,
                                        child: TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.4, end: 1.0),
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          builder: (_, v, __) => Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withAlpha(
                                                  (180 * v).round(),
                                                ),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Tap layer at viewport coords (reliable on mobile)
                        Positioned.fill(
                          child: Listener(
                            behavior: HitTestBehavior.translucent,
                            onPointerDown: (event) => _onViewportTap(
                              event.localPosition,
                              viewport,
                              worldScale,
                              cam,
                              completed,
                            ),
                          ),
                        ),

                        // Vignette
                        IgnorePointer(
                          child: CustomPaint(
                            painter: VignettePainter(),
                            size: viewport,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ── HUD (solo ocupa la barra superior; no bloquea el mapa) ─────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: _buildHud(topic, doneCount, completed),
                ),
              ),
              if (nearBuilding != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: _buildInteractPrompt(nearBuilding, completed),
                      ),
                    ),
                  ),
                ),
              // ── Minimap ───────────────────────────────────────────────
              Positioned(
                right: 12,
                bottom: 12,
                child: SafeArea(
                  top: false,
                  child: IgnorePointer(
                    child: _MiniMap(
                      map: _tileMap,
                      heroPos: _heroPos,
                      completed: completed,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static const _treePositions = [
    Offset(980, 520),
    Offset(980, 180),
    Offset(60, 180),
    Offset(60, 520),
    Offset(180, 80),
    Offset(380, 80),
    Offset(580, 80),
    Offset(60, 580),
    Offset(180, 580),
    Offset(380, 580),
    Offset(580, 580),
    Offset(900, 80),
  ];

  static const _treeScales = [
    1.0, 1.05, 0.95, 1.0, 0.9, 1.1, 0.95, 1.0, 1.05, 0.9, 1.0, 1.05,
  ];

  static const _treeIsPine = [
    false, true, false, false, true, false, true, false, false, true, false, true,
  ];

  List<Widget> _buildSortedEntities(
    Set<String> completed,
    double time,
    Offset cam,
    Size viewport,
  ) {
    final entities = <({double sortY, Widget widget})>[];

    // Barriers
    for (final barrier in _kBarriers) {
      final open = _isBarrierOpen(barrier.beforePill, completed);
      entities.add((
        sortY: barrier.pos.dy,
        widget: Positioned(
          left: barrier.pos.dx - barrier.size.width / 2,
          top: barrier.pos.dy - barrier.size.height / 2,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: open ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (_, progress, __) => CustomPaint(
              painter: RusticGatePainter(
                isOpen: open,
                openProgress: progress,
                time: time,
              ),
              size: barrier.size,
            ),
          ),
        ),
      ));
    }

    // Buildings
    for (final b in _kBuildings) {
      final pill = savingsPills[b.pillIndex];
      final unlocked = _isPillUnlocked(b.pillIndex, completed);
      final isDone = completed.contains(pill.title);

      entities.add((
        sortY: b.sortY,
        widget: Positioned(
          left: b.footPos.dx - b.size.width / 2,
          top: b.footPos.dy - b.size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                painter: BuildingPainter(
                  kind: b.kind,
                  locked: !unlocked,
                  completed: isDone,
                  time: time,
                ),
                size: b.size,
              ),
              const SizedBox(height: 2),
              _BuildingLabel(label: b.label, unlocked: unlocked, done: isDone),
            ],
          ),
        ),
      ));
    }

    // Hero
    entities.add((
      sortY: _heroPos.dy,
      widget: Positioned(
        left: _heroPos.dx - 28,
        top: _heroPos.dy - 58,
        child: CustomPaint(
          painter: HeroPainter(
            facing: _facing,
            walkFrame: _walkFrame,
            walking: _walking,
          ),
          size: const Size(56, 64),
        ),
      ),
    ));

    entities.sort((a, b) => a.sortY.compareTo(b.sortY));
    return entities.map((e) => e.widget).toList();
  }

  Widget _buildHud(Topic topic, int doneCount, Set<String> completed) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A0A).withAlpha(210),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF8B6914), width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF8B6914),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 10),
          Icon(topic.icon, color: topic.pillColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reino de la Aventura',
                  style: const TextStyle(
                    color: Color(0xFFFFD848),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: List.generate(savingsPills.length, (i) {
                    final done = completed.contains(savingsPills[i].title);
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        done ? Icons.favorite : Icons.favorite_border,
                        color: done
                            ? const Color(0xFFFF4444)
                            : const Color(0xFF664444),
                        size: 14,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: topic.pillColor.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: topic.pillColor.withAlpha(120)),
            ),
            child: Text(
              '$doneCount/${savingsPills.length}',
              style: TextStyle(
                color: topic.pillColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractPrompt(int pillIndex, Set<String> completed) {
    final b = _kBuildings.firstWhere((x) => x.pillIndex == pillIndex);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: GestureDetector(
        onTap: () => _interactBuilding(b, completed),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1A0A).withAlpha(220),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFD848), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD848).withAlpha(60),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.castle, color: Color(0xFFFFD848), size: 18),
              const SizedBox(width: 8),
              Text(
                'Entrar · ${b.label}',
                style: const TextStyle(
                  color: Color(0xFFFFD848),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Minimap ───────────────────────────────────────────────────────────────────

class _MiniMap extends StatelessWidget {
  final WorldTileMap map;
  final Offset heroPos;
  final Set<String> completed;

  const _MiniMap({
    required this.map,
    required this.heroPos,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    const w = 120.0;
    const h = 96.0;
    const scaleX = w / WorldTileMap.width;
    const scaleY = h / WorldTileMap.height;

    Offset toMini(Offset p) => Offset(p.dx * scaleX, p.dy * scaleY);

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A0A).withAlpha(200),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8B6914), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          painter: _MiniMapPainter(
            map: map,
            heroPos: toMini(heroPos),
            buildings: _kBuildings,
            completed: completed,
            scaleX: scaleX,
            scaleY: scaleY,
          ),
          size: const Size(w, h),
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  final WorldTileMap map;
  final Offset heroPos;
  final List<_BuildingAnchor> buildings;
  final Set<String> completed;
  final double scaleX;
  final double scaleY;

  const _MiniMapPainter({
    required this.map,
    required this.heroPos,
    required this.buildings,
    required this.completed,
    required this.scaleX,
    required this.scaleY,
  });

  Color _miniTileColor(Tile t) => switch (t) {
        Tile.water => const Color(0xFF3888F0),
        Tile.marsh => const Color(0xFF3A6858),
        Tile.sand => const Color(0xFFD4A858),
        Tile.path || Tile.plaza || Tile.bridge => const Color(0xFFC89858),
        Tile.farm => const Color(0xFF7A5828),
        Tile.cliff || Tile.rock => const Color(0xFF686878),
        Tile.flowers => const Color(0xFF58A838),
        Tile.bush => const Color(0xFF388028),
        _ => const Color(0xFF489820),
      };

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / WorldTileMap.cols;
    final cellH = size.height / WorldTileMap.rows;

    for (int r = 0; r < WorldTileMap.rows; r++) {
      for (int c = 0; c < WorldTileMap.cols; c++) {
        canvas.drawRect(
          Rect.fromLTWH(c * cellW, r * cellH, cellW + 0.5, cellH + 0.5),
          Paint()..color = _miniTileColor(map.grid[r][c]),
        );
      }
    }

    // Buildings
    for (final b in buildings) {
      final p = Offset(b.footPos.dx * scaleX, b.footPos.dy * scaleY);
      final done = completed.contains(savingsPills[b.pillIndex].title);
      canvas.drawRect(
        Rect.fromCenter(center: p, width: 7, height: 7),
        Paint()..color = done ? const Color(0xFF7ED957) : const Color(0xFF8B6914),
      );
      canvas.drawRect(
        Rect.fromCenter(center: p, width: 7, height: 7),
        Paint()
          ..color = Colors.black26
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }

    // Hero dot
    canvas.drawCircle(
      heroPos,
      4.5,
      Paint()..color = const Color(0xFF28A848),
    );
    canvas.drawCircle(
      heroPos,
      4.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_MiniMapPainter old) =>
      old.heroPos != heroPos ||
      old.completed != completed ||
      old.map != map;
}

// ── Building label ────────────────────────────────────────────────────────────

class _BuildingLabel extends StatelessWidget {
  final String label;
  final bool unlocked;
  final bool done;

  const _BuildingLabel({
    required this.label,
    required this.unlocked,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: done
            ? const Color(0xFF2E7D32).withAlpha(200)
            : unlocked
                ? Colors.black.withAlpha(170)
                : Colors.grey.shade800.withAlpha(170),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: done
              ? const Color(0xFF7ED957)
              : unlocked
                  ? const Color(0xFFFFD848).withAlpha(120)
                  : Colors.grey.shade600,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!unlocked)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.lock, color: Colors.white54, size: 10),
            ),
          if (done)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.check, color: Color(0xFF7ED957), size: 10),
            ),
          Text(
            label,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
