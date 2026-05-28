import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'savings_world_art.dart';

BuildingKind savingsBuildingForPill(int index) => switch (index) {
      0 => BuildingKind.cottage,
      1 => BuildingKind.vault,
      2 => BuildingKind.bank,
      3 => BuildingKind.shop,
      _ => BuildingKind.tower,
    };

class SavingsPillMeta {
  final String subtitle;
  final IconData icon;
  const SavingsPillMeta(this.subtitle, this.icon);

  static SavingsPillMeta forIndex(int index) => switch (index) {
        0 => const SavingsPillMeta('Tu hogar financiero', Icons.pie_chart_rounded),
        1 => const SavingsPillMeta('La bóveda del tesoro', Icons.shield_rounded),
        2 => const SavingsPillMeta('El banco del pueblo', Icons.account_balance_rounded),
        3 => const SavingsPillMeta('La tienda del camino', Icons.local_cafe_rounded),
        _ => const SavingsPillMeta('La torre del reto', Icons.flag_rounded),
      };

  static String sceneTitle(int pillIndex, int slideIndex) => switch (pillIndex) {
        0 => switch (slideIndex % 4) {
            0 => 'Distribuye tu oro',
            1 => 'Tres cofres del hogar',
            2 => 'El camino del presupuesto',
            _ => 'La cabaña del equilibrio',
          },
        1 => switch (slideIndex % 4) {
            0 => 'Guardián del tesoro',
            1 => 'Escudo contra imprevistos',
            2 => 'Monedas de reserva',
            _ => 'La bóveda sagrada',
          },
        2 => switch (slideIndex % 4) {
            0 => 'Río de monedas',
            1 => 'Engranaje del hábito',
            2 => 'Transferencia al amanecer',
            _ => 'El banco del pueblo',
          },
        3 => switch (slideIndex % 4) {
            0 => 'El café del camino',
            1 => 'Rastro de monedas',
            2 => 'La lupa del ahorrador',
            _ => 'Monedero con fugas',
          },
        _ => switch (slideIndex % 4) {
            0 => 'Escalera al cielo',
            1 => '30 días de gloria',
            2 => 'Bandera de victoria',
            _ => 'Tesoro acumulado',
          },
      };
}

// ── Palette ───────────────────────────────────────────────────────────────────

class _SP {
  static const sky1 = Color(0xFF88C8F8);
  static const sky2 = Color(0xFFB8E0FF);
  static const grass1 = Color(0xFF58A028);
  static const grass2 = Color(0xFF489820);
  static const grass3 = Color(0xFF68B838);
  static const grass4 = Color(0xFF388018);
  static const path1 = Color(0xFFD4A858);
  static const path2 = Color(0xFFB08038);
  static const wood1 = Color(0xFFB87838);
  static const wood2 = Color(0xFF885828);
  static const wood3 = Color(0xFF684018);
  static const gold1 = Color(0xFFFFD848);
  static const gold2 = Color(0xFFC89818);
  static const stone1 = Color(0xFF989898);
  static const stone2 = Color(0xFF686868);
  static const trunk = Color(0xFF603818);
  static const treeDark = Color(0xFF186018);
  static const treeMid = Color(0xFF288028);
  static const treeLight = Color(0xFF48A848);
  static const water1 = Color(0xFF3888F0);
  static const water2 = Color(0xFF58A8FF);
  static const parchment = Color(0xFFFFF8E8);
  static const shadow = Color(0x40000000);
}

// ── Animated sky + grass background ───────────────────────────────────────────

class SavingsPillSkyBackground extends StatelessWidget {
  final Animation<double> time;
  final Widget child;

  const SavingsPillSkyBackground({
    super.key,
    required this.time,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: time,
          builder: (_, __) => CustomPaint(
            painter: _SavingsSkyPainter(time.value),
            size: Size.infinite,
          ),
        ),
        AnimatedBuilder(
          animation: time,
          builder: (_, __) => CustomPaint(
            painter: _SavingsAmbientPainter(time.value),
            size: Size.infinite,
          ),
        ),
        child,
      ],
    );
  }
}

class _SavingsSkyPainter extends CustomPainter {
  final double t;
  const _SavingsSkyPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_SP.sky1, _SP.sky2, Color(0xFF78B848), _SP.grass2, _SP.grass1],
          stops: [0.0, 0.42, 0.62, 0.78, 1.0],
        ).createShader(rect),
    );

    final sunPulse = 1.0 + math.sin(t * 2 * math.pi) * 0.04;
    final sun = Offset(size.width * 0.82, size.height * 0.12);
    canvas.drawCircle(sun, 48 * sunPulse, Paint()..color = _SP.gold1.withAlpha(50));
    canvas.drawCircle(sun, 30 * sunPulse, Paint()..color = _SP.gold1);
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3 + t * 0.5;
      canvas.drawLine(
        sun,
        sun + Offset(math.cos(a) * 44, math.sin(a) * 44),
        Paint()..color = _SP.gold1.withAlpha(40)..strokeWidth = 2,
      );
    }

    for (var i = 0; i < 5; i++) {
      final cx = ((t * 0.06 + i * 0.22) % 1.25) * size.width - size.width * 0.12;
      _SceneKit.cloud(canvas, Offset(cx, size.height * (0.06 + i * 0.04)), 32 + i * 8.0);
    }

    final hill = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.82, size.width, size.height * 0.68)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = _SP.grass4.withAlpha(130));
  }

  @override
  bool shouldRepaint(_SavingsSkyPainter old) => old.t != t;
}

class _SavingsAmbientPainter extends CustomPainter {
  final double t;
  const _SavingsAmbientPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 28; i++) {
      final phase = t + i * 0.11;
      final x = (math.sin(phase * 1.3 + i) * 0.5 + 0.5) * size.width;
      final y = size.height * 0.45 + math.sin(phase * 2.1 + i * 0.8) * size.height * 0.22;
      final alpha = (100 + math.sin(phase * 4) * 90).round().clamp(30, 220);
      canvas.drawCircle(
        Offset(x, y),
        1.2 + (i % 4) * 0.6,
        Paint()..color = Color.lerp(const Color(0xFF88FF88), _SP.gold1, (i % 5) / 5)!.withAlpha(alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_SavingsAmbientPainter old) => old.t != t;
}

class SavingsAmbientOverlay extends StatelessWidget {
  final Animation<double> time;
  const SavingsAmbientOverlay({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: time,
      builder: (_, __) => CustomPaint(
        painter: _SavingsAmbientPainter(time.value),
        size: Size.infinite,
      ),
    );
  }
}

// ── Slide art widgets (top + bottom) ──────────────────────────────────────────

class SavingsSlideTopArt extends StatelessWidget {
  final int pillIndex;
  final int slideIndex;
  final Animation<double> time;

  const SavingsSlideTopArt({
    super.key,
    required this.pillIndex,
    required this.slideIndex,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: time,
      builder: (_, __) => CustomPaint(
        painter: _SavingsSlideTopPainter(
          pillIndex: pillIndex,
          slideIndex: slideIndex,
          time: time.value,
        ),
        size: const Size(double.infinity, 240),
      ),
    );
  }
}

class SavingsSlideBottomArt extends StatelessWidget {
  final int pillIndex;
  final int slideIndex;
  final Animation<double> time;

  const SavingsSlideBottomArt({
    super.key,
    required this.pillIndex,
    required this.slideIndex,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: time,
      builder: (_, __) => CustomPaint(
        painter: _SavingsSlideBottomPainter(
          pillIndex: pillIndex,
          slideIndex: slideIndex,
          time: time.value,
        ),
        size: const Size(double.infinity, 210),
      ),
    );
  }
}

// ── Shared scene kit ────────────────────────────────────────────────────────────

class _SceneKit {
  static void skyBand(Canvas canvas, Size size, {double groundFrom = 0.62}) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * groundFrom),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_SP.sky1, _SP.sky2, const Color(0xFF98D878)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * groundFrom)),
    );
  }

  static void ground(Canvas canvas, Size size, {double from = 0.58}) {
    final top = size.height * from;
    canvas.drawRect(
      Rect.fromLTWH(0, top, size.width, size.height - top),
      Paint()
        ..shader = LinearGradient(
          colors: [_SP.grass1, _SP.grass2, _SP.grass4],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, top, size.width, size.height - top)),
    );
    for (var i = 0; i < size.width / 10; i++) {
      final gx = i * 10.0 + 3;
      final gy = top + 4;
      canvas.drawLine(
        Offset(gx, gy),
        Offset(gx + 1.5, gy - 6 - (i % 3)),
        Paint()
          ..color = _SP.grass3
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  static void path(Canvas canvas, Size size, double t) {
    final p = Path()
      ..moveTo(size.width * 0.08, size.height * 0.95)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.72, size.width * 0.52, size.height * 0.62)
      ..quadraticBezierTo(size.width * 0.72, size.height * 0.52, size.width * 0.92, size.height * 0.58);
    canvas.drawPath(
      p,
      Paint()
        ..color = _SP.path2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      p,
      Paint()
        ..color = _SP.path1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < 8; i++) {
      final pt = _pointOnPath(size, i / 7.0);
      canvas.drawCircle(pt, 2, Paint()..color = _SP.path2.withAlpha(120));
    }
  }

  static Offset _pointOnPath(Size size, double u) {
    final a = Offset(size.width * 0.08, size.height * 0.95);
    final b = Offset(size.width * 0.52, size.height * 0.62);
    final c = Offset(size.width * 0.92, size.height * 0.58);
    final ab = Offset.lerp(a, b, u)!;
    final bc = Offset.lerp(b, c, u)!;
    return Offset.lerp(ab, bc, u)!;
  }

  static void cloud(Canvas canvas, Offset c, double r) {
    final p = Paint()..color = const Color(0xFFF8F8FF).withAlpha(220);
    canvas.drawCircle(c, r * 0.55, p);
    canvas.drawCircle(Offset(c.dx - r * 0.55, c.dy + 3), r * 0.42, p);
    canvas.drawCircle(Offset(c.dx + r * 0.5, c.dy + 4), r * 0.48, p);
    canvas.drawCircle(Offset(c.dx - r * 0.1, c.dy - r * 0.2), r * 0.35, p);
  }

  static void tree(Canvas canvas, Offset base, double scale, double sway) {
    final w = 36.0 * scale;
    final h = 52.0 * scale;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(base.dx, base.dy - h * 0.15), width: w * 0.22, height: h * 0.35),
      Paint()..color = _SP.trunk,
    );
    for (var layer = 0; layer < 3; layer++) {
      final r = w * (0.55 - layer * 0.08);
      final cy = base.dy - h * (0.38 + layer * 0.18) + sway * layer;
      canvas.drawCircle(Offset(base.dx + sway, cy), r, Paint()..color = _SP.treeDark);
      canvas.drawCircle(Offset(base.dx - r * 0.3 + sway, cy + 2), r * 0.75, Paint()..color = _SP.treeMid);
      canvas.drawCircle(Offset(base.dx + r * 0.25 + sway, cy + 3), r * 0.7, Paint()..color = _SP.treeLight);
    }
  }

  static void hero(Canvas canvas, Offset feet, Facing facing, double t) {
    canvas.save();
    canvas.translate(feet.dx - 22, feet.dy - 46);
    HeroPainter(
      facing: facing,
      walkFrame: (t * 4).floor() % 4,
      walking: true,
    ).paint(canvas, const Size(44, 50));
    canvas.restore();
  }

  static void signPost(Canvas canvas, Offset base, String text) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset(base.dx, base.dy - 14), width: 5, height: 28),
      Paint()..color = _SP.wood3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(base.dx, base.dy - 32), width: 72, height: 22),
        const Radius.circular(4),
      ),
      Paint()..color = _SP.wood1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(base.dx, base.dy - 32), width: 72, height: 22),
        const Radius.circular(4),
      ),
      Paint()
        ..color = _SP.wood3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 66);
    tp.paint(canvas, Offset(base.dx - tp.width / 2, base.dy - 32 - tp.height / 2));
  }

  static void lantern(Canvas canvas, Offset pos, double t) {
    final flicker = 0.7 + math.sin(t * 12) * 0.3;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(pos.dx, pos.dy + 8), width: 4, height: 16),
      Paint()..color = _SP.wood3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: 12, height: 14),
        const Radius.circular(2),
      ),
      Paint()..color = _SP.wood1,
    );
    canvas.drawCircle(
      pos,
      8 * flicker,
      Paint()..color = const Color(0xFFFF8833).withAlpha(80),
    );
    canvas.drawCircle(pos, 4, Paint()..color = const Color(0xFFFFAA44));
  }

  static void fence(Canvas canvas, double x1, double x2, double y) {
    for (var x = x1; x < x2; x += 14) {
      canvas.drawRect(Rect.fromLTWH(x, y - 18, 4, 18), Paint()..color = _SP.wood2);
    }
    canvas.drawRect(Rect.fromLTWH(x1, y - 14, x2 - x1, 3), Paint()..color = _SP.wood1);
    canvas.drawRect(Rect.fromLTWH(x1, y - 6, x2 - x1, 3), Paint()..color = _SP.wood1);
  }

  static void flowers(Canvas canvas, Rect area, int seed) {
    for (var i = 0; i < 12; i++) {
      final fx = area.left + ((seed * 17 + i * 43) % 100) / 100 * area.width;
      final fy = area.top + ((seed * 31 + i * 29) % 100) / 100 * area.height;
      final color = [const Color(0xFFFF6688), const Color(0xFFFFDD44), const Color(0xFFAA88FF)][i % 3];
      canvas.drawCircle(Offset(fx, fy), 3, Paint()..color = color);
      canvas.drawCircle(Offset(fx, fy), 1.2, Paint()..color = _SP.gold1);
    }
  }

  static void coin(Canvas canvas, Offset c, double r, {int alpha = 255}) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.35), width: r * 2.4, height: r * 0.9),
      Paint()..color = _SP.wood3.withAlpha((alpha * 0.45).round()),
    );
    canvas.drawCircle(c, r, Paint()..color = _SP.gold1.withAlpha(alpha));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = _SP.gold2.withAlpha(alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
    canvas.drawCircle(Offset(c.dx - r * 0.25, c.dy - r * 0.25), r * 0.18, Paint()..color = Colors.white.withAlpha((alpha * 0.5).round()));
  }

  static void coinStack(Canvas canvas, Offset base, int n, double t, {double r = 11}) {
    for (var i = 0; i < n; i++) {
      final bob = math.sin(t * 2.5 + i * 0.5) * 1.5;
      coin(canvas, Offset(base.dx, base.dy - i * (r * 0.65) + bob), r);
    }
  }

  static void bird(Canvas canvas, Offset c, double t, int id) {
    final wing = math.sin(t * 8 + id) * 4;
    canvas.drawLine(c, c + Offset(-8, wing), Paint()..color = const Color(0xFF2A4020)..strokeWidth = 2);
    canvas.drawLine(c, c + Offset(8, wing), Paint()..color = const Color(0xFF2A4020)..strokeWidth = 2);
  }

  static void building(Canvas canvas, Offset foot, BuildingKind kind, double t) {
    canvas.save();
    canvas.translate(foot.dx - 44, foot.dy - 96);
    BuildingPainter(kind: kind, locked: false, completed: false, time: t).paint(canvas, const Size(88, 96));
    canvas.restore();
  }

  static void mushroom(Canvas canvas, Offset c, double scale) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 14 * scale, height: 8 * scale), const Radius.circular(4)),
      Paint()..color = const Color(0xFF983828),
    );
    canvas.drawCircle(Offset(c.dx, c.dy - 4 * scale), 8 * scale, Paint()..color = const Color(0xFF983828));
    canvas.drawCircle(Offset(c.dx - 3, c.dy - 6 * scale), 2, Paint()..color = Colors.white.withAlpha(180));
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 2 * scale), width: 6 * scale, height: 6 * scale), Paint()..color = _SP.parchment);
  }

  static void well(Canvas canvas, Offset c) {
    canvas.drawCircle(c, 22, Paint()..color = _SP.stone2);
    canvas.drawCircle(c, 18, Paint()..color = _SP.stone1);
    canvas.drawArc(Rect.fromCircle(center: c, radius: 14), math.pi, math.pi, true, Paint()..color = _SP.water1);
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy - 26), width: 40, height: 4), Paint()..color = _SP.wood2);
  }
}

// ── TOP scene painter ───────────────────────────────────────────────────────────

class _SavingsSlideTopPainter extends CustomPainter {
  final int pillIndex;
  final int slideIndex;
  final double time;

  const _SavingsSlideTopPainter({
    required this.pillIndex,
    required this.slideIndex,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _SceneKit.skyBand(canvas, size);
    _SceneKit.ground(canvas, size);

    for (var i = 0; i < 3; i++) {
      final cx = ((time * 0.04 + i * 0.35) % 1.15) * size.width;
      _SceneKit.cloud(canvas, Offset(cx, 18 + i * 12.0), 24 + i * 4);
    }
    for (var i = 0; i < 3; i++) {
      _SceneKit.bird(canvas, Offset(size.width * (0.15 + i * 0.28), 28 + math.sin(time + i) * 6), time, i);
    }

    _SceneKit.path(canvas, size, time);
    _SceneKit.tree(canvas, Offset(size.width * 0.12, size.height * 0.72), 1.0, math.sin(time * 2) * 2);
    _SceneKit.tree(canvas, Offset(size.width * 0.88, size.height * 0.68), 0.85, math.sin(time * 2 + 1) * 2);
    _SceneKit.fence(canvas, size.width * 0.04, size.width * 0.22, size.height * 0.78);
    _SceneKit.lantern(canvas, Offset(size.width * 0.24, size.height * 0.55), time);
    _SceneKit.signPost(canvas, Offset(size.width * 0.18, size.height * 0.82), SavingsPillMeta.sceneTitle(pillIndex, slideIndex));

    _SceneKit.building(canvas, Offset(size.width * 0.62, size.height * 0.78), savingsBuildingForPill(pillIndex), time);
    _SceneKit.hero(canvas, Offset(size.width * 0.38, size.height * 0.84), Facing.right, time);

    final scene = slideIndex % 4;
    switch (pillIndex) {
      case 0:
        _topBudget(canvas, size, scene);
      case 1:
        _topEmergency(canvas, size, scene);
      case 2:
        _topAutoSave(canvas, size, scene);
      case 3:
        _topAntExpense(canvas, size, scene);
      default:
        _topChallenge(canvas, size, scene);
    }

    // Vignette frame
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withAlpha(25), Colors.transparent, Colors.black.withAlpha(35)],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  void _topBudget(Canvas canvas, Size size, int scene) {
    final cx = size.width * 0.42;
    final cy = size.height * 0.48;
    switch (scene) {
      case 0:
        _drawPieDetailed(canvas, Offset(cx, cy), 48, ['50%', '30%', '20%']);
      case 1:
        _drawThreeChests(canvas, Offset(cx, cy + 10), time);
      case 2:
        _drawBudgetScroll(canvas, Offset(cx, cy), time);
      default:
        _drawBalanceScale(canvas, Offset(cx, cy + 8), time);
    }
  }

  void _topEmergency(Canvas canvas, Size size, int scene) {
    final cx = size.width * 0.4;
    final cy = size.height * 0.5;
    switch (scene) {
      case 0:
        _drawVaultDoor(canvas, Offset(cx, cy), time);
      case 1:
        _drawShieldMonument(canvas, Offset(cx, cy), time);
      case 2:
        _SceneKit.coinStack(canvas, Offset(cx - 20, cy + 20), 6, time);
        _SceneKit.coinStack(canvas, Offset(cx + 24, cy + 16), 4, time);
      default:
        _drawUmbrella(canvas, Offset(cx, cy - 10), time);
    }
  }

  void _topAutoSave(Canvas canvas, Size size, int scene) {
    final cx = size.width * 0.4;
    final cy = size.height * 0.5;
    switch (scene) {
      case 0:
        _drawCoinRiver(canvas, Rect.fromLTWH(cx - 50, cy - 20, 100, 50), time);
      case 1:
        _drawBigGear(canvas, Offset(cx, cy), 28, time);
      case 2:
        _drawPaydayCalendar(canvas, Offset(cx, cy), time);
      default:
        _drawAutoTransfer(canvas, Offset(cx - 40, cy), Offset(cx + 40, cy), time);
    }
  }

  void _topAntExpense(Canvas canvas, Size size, int scene) {
    final cx = size.width * 0.4;
    final cy = size.height * 0.5;
    switch (scene) {
      case 0:
        _drawCoffeeStand(canvas, Offset(cx, cy + 10), time);
      case 1:
        _drawAntParade(canvas, Offset(cx - 45, cy + 24), time);
      case 2:
        _drawMagnifierBig(canvas, Offset(cx, cy), time);
      default:
        _drawLeakyBag(canvas, Offset(cx, cy + 10), time);
    }
  }

  void _topChallenge(Canvas canvas, Size size, int scene) {
    final cx = size.width * 0.4;
    final cy = size.height * 0.48;
    switch (scene) {
      case 0:
        _drawStoneStairs(canvas, Offset(cx, cy + 30), time);
      case 1:
        _drawBigCalendar(canvas, Offset(cx - 30, cy - 10), time);
      case 2:
        _drawVictoryFlag(canvas, Offset(cx, cy - 20), time);
      default:
        _drawTreasureChest(canvas, Offset(cx, cy + 16), time);
    }
  }

  // ── top detail helpers ──────────────────────────────────────────────────────

  void _drawPieDetailed(Canvas canvas, Offset c, double r, List<String> labels) {
    const parts = [0.5, 0.3, 0.2];
    const colors = [Color(0xFF58A028), Color(0xFFFFB300), Color(0xFF3888F0)];
    var start = -math.pi / 2;
    for (var i = 0; i < 3; i++) {
      final sweep = parts[i] * 2 * math.pi;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, true, Paint()..color = colors[i]);
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start,
        sweep,
        true,
        Paint()
          ..color = Colors.black.withAlpha(30)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      final mid = start + sweep / 2;
      final lp = c + Offset(math.cos(mid) * r * 0.72, math.sin(mid) * r * 0.72);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
      start += sweep;
    }
    canvas.drawCircle(c, r * 0.38, Paint()..color = _SP.parchment);
    canvas.drawCircle(c, r * 0.38, Paint()..color = _SP.wood3..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawThreeChests(Canvas canvas, Offset c, double t) {
    for (var i = 0; i < 3; i++) {
      final x = c.dx - 36 + i * 36;
      final bob = math.sin(t * 2 + i) * 2;
      _drawChest(canvas, Offset(x, c.dy + bob), [0.5, 0.3, 0.2][i], ['50%', '30%', '20%'][i]);
    }
  }

  void _drawChest(Canvas canvas, Offset c, double fill, String label) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, c.dy + 6), width: 28, height: 18), const Radius.circular(3)),
      Paint()..color = _SP.wood2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, c.dy - 4), width: 30, height: 16), const Radius.circular(3)),
      Paint()..color = _SP.wood1,
    );
    canvas.drawRect(Rect.fromLTWH(c.dx - 14, c.dy - 10, 28 * fill, 8), Paint()..color = _SP.gold1);
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 2), width: 30, height: 3), Paint()..color = _SP.gold2);
    final tp = TextPainter(
      text: TextSpan(text: label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - 22));
  }

  void _drawBudgetScroll(Canvas canvas, Offset c, double t) {
    final wave = math.sin(t * 3) * 3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 54 + wave, height: 38), const Radius.circular(4)),
      Paint()..color = _SP.parchment,
    );
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(c.dx - 20, c.dy - 10 + i * 8),
        Offset(c.dx + 18, c.dy - 10 + i * 8),
        Paint()..color = _SP.wood3.withAlpha(100)..strokeWidth = 2,
      );
    }
    canvas.drawCircle(Offset(c.dx + 24, c.dy), 6, Paint()..color = _SP.gold1);
  }

  void _drawBalanceScale(Canvas canvas, Offset c, double t) {
    final tilt = math.sin(t * 2) * 0.08;
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 18), width: 4, height: 36), Paint()..color = _SP.wood3);
    canvas.save();
    canvas.translate(c.dx, c.dy - 2);
    canvas.rotate(tilt);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 70, height: 4), Paint()..color = _SP.wood2);
    _drawChest(canvas, const Offset(-28, 8), 0.5, '50%');
    _drawChest(canvas, const Offset(28, 8), 0.2, '20%');
    canvas.restore();
  }

  void _drawVaultDoor(Canvas canvas, Offset c, double t) {
    final pulse = 1 + math.sin(t * 4) * 0.03;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 64 * pulse, height: 52 * pulse), const Radius.circular(8)),
      Paint()..color = _SP.stone2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 52 * pulse, height: 42 * pulse), const Radius.circular(6)),
      Paint()..color = _SP.stone1,
    );
    for (var i = 0; i < 6; i++) {
      canvas.drawCircle(Offset(c.dx - 20 + i * 8, c.dy - 14), 2, Paint()..color = _SP.stone2);
      canvas.drawCircle(Offset(c.dx - 20 + i * 8, c.dy + 14), 2, Paint()..color = _SP.stone2);
    }
    canvas.drawCircle(c, 10, Paint()..color = _SP.gold1);
    canvas.drawCircle(c, 10, Paint()..color = _SP.gold2..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(
      c,
      16 + math.sin(t * 5) * 4,
      Paint()..color = _SP.gold1.withAlpha(40),
    );
  }

  void _drawShieldMonument(Canvas canvas, Offset c, double t) {
    final glow = (math.sin(t * 3) * 0.5 + 0.5);
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 28), width: 36, height: 12), Paint()..color = _SP.stone2);
    final path = Path()
      ..moveTo(c.dx, c.dy - 34)
      ..lineTo(c.dx + 30, c.dy - 14)
      ..lineTo(c.dx + 22, c.dy + 22)
      ..lineTo(c.dx, c.dy + 32)
      ..lineTo(c.dx - 22, c.dy + 22)
      ..lineTo(c.dx - 30, c.dy - 14)
      ..close();
    canvas.drawPath(path, Paint()..color = Color.lerp(const Color(0xFF58A028), _SP.gold1, glow * 0.35)!);
    canvas.drawPath(path, Paint()..color = const Color(0xFF1A7038)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    canvas.drawCircle(c, 8, Paint()..color = _SP.gold1.withAlpha((120 + glow * 100).round()));
  }

  void _drawUmbrella(Canvas canvas, Offset c, double t) {
    canvas.drawLine(Offset(c.dx, c.dy - 10), Offset(c.dx, c.dy + 30), Paint()..color = _SP.wood3..strokeWidth = 3);
    canvas.drawArc(Rect.fromCenter(center: Offset(c.dx, c.dy - 10), width: 56, height: 30), math.pi, math.pi, false, Paint()..color = const Color(0xFF3888F0));
    for (var i = 0; i < 5; i++) {
      final drop = (time + i * 0.2) % 1.0;
      canvas.drawLine(
        Offset(c.dx - 24 + i * 12, c.dy - 20),
        Offset(c.dx - 22 + i * 12, c.dy - 20 + drop * 28),
        Paint()..color = _SP.water2.withAlpha(180)..strokeWidth = 2,
      );
    }
  }

  void _drawCoinRiver(Canvas canvas, Rect area, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(area.inflate(8), const Radius.circular(12)),
      Paint()..color = _SP.water1.withAlpha(60),
    );
    for (var i = 0; i < 8; i++) {
      final p = ((t * 0.5 + i * 0.12) % 1.0);
      _SceneKit.coin(canvas, Offset(area.left + area.width * p, area.top + area.height * 0.5 + math.sin(p * 6) * 6), 8);
    }
  }

  void _drawBigGear(Canvas canvas, Offset c, double r, double t) {
    final teeth = 10;
    final path = Path();
    for (var i = 0; i < teeth; i++) {
      final a = t * 1.5 + i * 2 * math.pi / teeth;
      final r1 = r + (i.isEven ? 8 : 0);
      path.lineTo(c.dx + math.cos(a) * r1, c.dy + math.sin(a) * r1);
      final a2 = a + math.pi / teeth;
      path.lineTo(c.dx + math.cos(a2) * r, c.dy + math.sin(a2) * r);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = _SP.stone1);
    canvas.drawPath(path, Paint()..color = _SP.stone2..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(c, r * 0.42, Paint()..color = _SP.stone2);
    canvas.drawCircle(c, r * 0.18, Paint()..color = _SP.wood3);
  }

  void _drawPaydayCalendar(Canvas canvas, Offset c, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 64, height: 56), const Radius.circular(8)),
      Paint()..color = _SP.parchment,
    );
    canvas.drawRect(Rect.fromLTWH(c.dx - 32, c.dy - 28, 64, 16), Paint()..color = const Color(0xFF983828));
    final day = (t * 8).floor() % 28 + 1;
    final tp = TextPainter(
      text: TextSpan(text: '$day', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2A4020))),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - 6));
    _SceneKit.coin(canvas, Offset(c.dx + 28, c.dy - 20), 7);
  }

  void _drawAutoTransfer(Canvas canvas, Offset from, Offset to, double t) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: from, width: 36, height: 28), const Radius.circular(4)), Paint()..color = _SP.wood1);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: to, width: 36, height: 28), const Radius.circular(4)), Paint()..color = _SP.stone1);
    canvas.drawLine(from, to, Paint()..color = _SP.grass1..strokeWidth = 4);
    final p = (math.sin(t * 2) * 0.5 + 0.5);
    _SceneKit.coin(canvas, Offset.lerp(from, to, p)!, 10);
  }

  void _drawCoffeeStand(Canvas canvas, Offset c, double t) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 48, height: 34), const Radius.circular(4)), Paint()..color = _SP.wood1);
    canvas.drawRect(Rect.fromLTWH(c.dx - 24, c.dy - 22, 48, 10), Paint()..color = const Color(0xFF983828));
    _drawCoffeeCup(canvas, Offset(c.dx - 8, c.dy + 2));
    for (var i = 0; i < 3; i++) {
      final steam = math.sin(t * 4 + i) * 3;
      canvas.drawLine(
        Offset(c.dx + 8 + i * 4, c.dy - 8),
        Offset(c.dx + 8 + i * 4 + steam, c.dy - 18),
        Paint()..color = Colors.white.withAlpha(120)..strokeWidth = 2,
      );
    }
  }

  void _drawCoffeeCup(Canvas canvas, Offset c) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, c.dy + 4), width: 22, height: 24), const Radius.circular(3)), Paint()..color = _SP.parchment);
    canvas.drawArc(Rect.fromCenter(center: Offset(c.dx + 14, c.dy + 4), width: 12, height: 16), -math.pi / 2, math.pi, false, Paint()..color = _SP.wood3..style = PaintingStyle.stroke..strokeWidth = 2.5);
    canvas.drawRect(Rect.fromLTWH(c.dx - 8, c.dy - 12, 16, 7), Paint()..color = const Color(0xFF482008));
  }

  void _drawAntParade(Canvas canvas, Offset start, double t) {
    for (var i = 0; i < 10; i++) {
      final x = start.dx + i * 9 + math.sin(t * 5 + i * 0.7) * 4;
      final y = start.dy - math.sin(i * 0.9) * 5;
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 8, height: 5), Paint()..color = const Color(0xFF482008));
      canvas.drawCircle(Offset(x + 4, y - 1), 2, Paint()..color = const Color(0xFF482008));
      if (i % 3 == 0) _SceneKit.coin(canvas, Offset(x, y + 6), 4, alpha: 200);
    }
  }

  void _drawMagnifierBig(Canvas canvas, Offset c, double t) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.sin(t) * 0.12);
    canvas.drawCircle(Offset.zero, 24, Paint()..color = const Color(0xFF88CCFF).withAlpha(80));
    canvas.drawCircle(Offset.zero, 24, Paint()..color = _SP.wood3..style = PaintingStyle.stroke..strokeWidth = 5);
    canvas.drawLine(const Offset(16, 16), const Offset(32, 32), Paint()..color = _SP.wood3..strokeWidth = 6..strokeCap = StrokeCap.round);
    _SceneKit.coin(canvas, const Offset(-4, 2), 6);
    canvas.restore();
  }

  void _drawLeakyBag(Canvas canvas, Offset c, double t) {
    final path = Path()
      ..moveTo(c.dx - 22, c.dy - 8)
      ..quadraticBezierTo(c.dx, c.dy - 22, c.dx + 22, c.dy - 8)
      ..lineTo(c.dx + 18, c.dy + 12)
      ..quadraticBezierTo(c.dx, c.dy + 20, c.dx - 18, c.dy + 12)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF983828));
    canvas.drawPath(path, Paint()..color = _SP.wood3..style = PaintingStyle.stroke..strokeWidth = 2);
    for (var i = 0; i < 4; i++) {
      final drip = (time + i * 0.25) % 1.0;
      _SceneKit.coin(canvas, Offset(c.dx - 12 + i * 8, c.dy + 14 + drip * 22), 5, alpha: 210);
    }
  }

  void _drawStoneStairs(Canvas canvas, Offset base, double t) {
    for (var i = 0; i < 6; i++) {
      final w = 24.0 + i * 10;
      final y = base.dy - i * 11;
      final lit = i == (time * 2).floor() % 6;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(base.dx, y), width: w, height: 10), const Radius.circular(2)),
        Paint()..color = lit ? _SP.gold1 : _SP.stone1,
      );
    }
  }

  void _drawBigCalendar(Canvas canvas, Offset topLeft, double t) {
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 6; col++) {
        final day = row * 6 + col + 1;
        final x = topLeft.dx + col * 13;
        final y = topLeft.dy + row * 13;
        final lit = day <= ((time * 12).floor() % 30 + 1);
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 11, 11), const Radius.circular(2)),
          Paint()..color = lit ? const Color(0xFF58A028) : const Color(0xFFE8E0D0),
        );
      }
    }
  }

  void _drawVictoryFlag(Canvas canvas, Offset poleTop, double t) {
    canvas.drawLine(poleTop, Offset(poleTop.dx, poleTop.dy + 56), Paint()..color = _SP.wood3..strokeWidth = 4);
    final wave = math.sin(t * 6) * 5;
    canvas.drawPath(
      Path()
        ..moveTo(poleTop.dx, poleTop.dy + 6)
        ..lineTo(poleTop.dx + 38 + wave, poleTop.dy + 16)
        ..lineTo(poleTop.dx + 32 + wave, poleTop.dy + 32)
        ..lineTo(poleTop.dx, poleTop.dy + 24)
        ..close(),
      Paint()..color = const Color(0xFF58A028),
    );
    canvas.drawCircle(Offset(poleTop.dx, poleTop.dy - 4), 6, Paint()..color = _SP.gold1);
  }

  void _drawTreasureChest(Canvas canvas, Offset c, double t) {
    final open = (math.sin(t * 2) * 0.5 + 0.5) * 0.4;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, c.dy + 8), width: 44, height: 24), const Radius.circular(4)), Paint()..color = _SP.wood2);
    canvas.drawArc(Rect.fromCenter(center: Offset(c.dx, c.dy - 4), width: 44, height: 28), math.pi + open, math.pi - open * 2, false, Paint()..color = _SP.wood1);
    for (var i = 0; i < 5; i++) {
      _SceneKit.coin(canvas, Offset(c.dx - 16 + i * 8, c.dy - 8 - math.sin(t * 3 + i) * 4), 7);
    }
  }

  @override
  bool shouldRepaint(_SavingsSlideTopPainter old) =>
      old.pillIndex != pillIndex || old.slideIndex != slideIndex || old.time != time;
}

// ── BOTTOM scene painter ────────────────────────────────────────────────────────

class _SavingsSlideBottomPainter extends CustomPainter {
  final int pillIndex;
  final int slideIndex;
  final double time;

  const _SavingsSlideBottomPainter({
    required this.pillIndex,
    required this.slideIndex,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Ground close-up
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_SP.grass1, _SP.grass2, _SP.grass4],
        ).createShader(Offset.zero & size),
    );

    // Stone border at top
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 8),
      Paint()..color = _SP.stone2,
    );
    for (var x = 0.0; x < size.width; x += 16) {
      canvas.drawLine(Offset(x, 0), Offset(x + 8, 8), Paint()..color = _SP.stone1..strokeWidth = 1);
    }

    _SceneKit.flowers(canvas, Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.4), pillIndex * 4 + slideIndex);
    _SceneKit.fence(canvas, 8, size.width - 8, size.height * 0.35);

    final scene = slideIndex % 4;
    switch (pillIndex) {
      case 0:
        _bottomBudget(canvas, size, scene);
      case 1:
        _bottomEmergency(canvas, size, scene);
      case 2:
        _bottomAutoSave(canvas, size, scene);
      case 3:
        _bottomAntExpense(canvas, size, scene);
      default:
        _bottomChallenge(canvas, size, scene);
    }

    // Fireflies
    for (var i = 0; i < 10; i++) {
      final ph = time + i * 0.23;
      final fx = size.width * ((math.sin(ph * 1.1 + i) + 1) / 2);
      final fy = size.height * 0.3 + math.sin(ph * 2.3 + i) * size.height * 0.25;
      canvas.drawCircle(
        Offset(fx, fy),
        2,
        Paint()..color = Color.lerp(const Color(0xFF88FF88), _SP.gold1, (i % 3) / 3)!.withAlpha((100 + math.sin(ph * 6) * 80).round()),
      );
    }
  }

  void _bottomBudget(Canvas canvas, Size size, int scene) {
    switch (scene) {
      case 0:
        _drawGroundPie(canvas, Offset(size.width * 0.5, size.height * 0.42), 55);
        _SceneKit.mushroom(canvas, Offset(size.width * 0.15, size.height * 0.72), 1.1);
        _SceneKit.mushroom(canvas, Offset(size.width * 0.82, size.height * 0.68), 0.9);
      case 1:
        _drawGroundBars(canvas, size.width * 0.5, size.height * 0.48);
        _SceneKit.well(canvas, Offset(size.width * 0.78, size.height * 0.55));
      case 2:
        _drawGroundPath(canvas, size);
        _SceneKit.coinStack(canvas, Offset(size.width * 0.72, size.height * 0.58), 7, time);
      default:
        _drawGroundScale(canvas, Offset(size.width * 0.48, size.height * 0.45), time);
        _SceneKit.hero(canvas, Offset(size.width * 0.22, size.height * 0.78), Facing.up, time);
    }
  }

  void _bottomEmergency(Canvas canvas, Size size, int scene) {
    switch (scene) {
      case 0:
        _drawGroundVault(canvas, Offset(size.width * 0.5, size.height * 0.48), time);
        _SceneKit.lantern(canvas, Offset(size.width * 0.18, size.height * 0.42), time);
        _SceneKit.lantern(canvas, Offset(size.width * 0.82, size.height * 0.42), time);
      case 1:
        _drawGroundShield(canvas, Offset(size.width * 0.5, size.height * 0.44), time);
      case 2:
        _drawCoinField(canvas, size, time);
      default:
        _drawGroundCalendar(canvas, Offset(size.width * 0.5, size.height * 0.46), '3-6 meses');
        _SceneKit.coinStack(canvas, Offset(size.width * 0.2, size.height * 0.65), 5, time);
        _SceneKit.coinStack(canvas, Offset(size.width * 0.8, size.height * 0.62), 5, time);
    }
  }

  void _bottomAutoSave(Canvas canvas, Size size, int scene) {
    switch (scene) {
      case 0:
        _drawGroundRiver(canvas, size, time);
      case 1:
        _drawGroundGears(canvas, size, time);
      case 2:
        _drawGroundPayroll(canvas, size, time);
      default:
        _drawGroundBanks(canvas, size, time);
    }
  }

  void _bottomAntExpense(Canvas canvas, Size size, int scene) {
    switch (scene) {
      case 0:
        _drawGroundCafe(canvas, size, time);
      case 1:
        _drawGroundTrail(canvas, size, time);
      case 2:
        _drawGroundInspect(canvas, size, time);
      default:
        _drawGroundLeaks(canvas, size, time);
    }
  }

  void _bottomChallenge(Canvas canvas, Size size, int scene) {
    switch (scene) {
      case 0:
        _drawGroundTower(canvas, size, time);
      case 1:
        _drawGroundDayGrid(canvas, size, time);
      case 2:
        _drawGroundFlag(canvas, size, time);
      default:
        _drawGroundTreasure(canvas, size, time);
    }
  }

  // ── bottom detail helpers ───────────────────────────────────────────────────

  void _drawGroundPie(Canvas canvas, Offset c, double r) {
    const parts = [0.5, 0.3, 0.2];
    const colors = [Color(0xFF58A028), Color(0xFFFFB300), Color(0xFF3888F0)];
    var start = -math.pi / 2;
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.3), width: r * 2.2, height: r * 0.5), Paint()..color = _SP.shadow);
    for (var i = 0; i < 3; i++) {
      final sweep = parts[i] * 2 * math.pi;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, true, Paint()..color = colors[i]);
      start += sweep;
    }
    canvas.drawCircle(c, r * 0.35, Paint()..color = _SP.parchment);
    canvas.drawCircle(c, 6, Paint()..color = _SP.gold1);
  }

  void _drawGroundBars(Canvas canvas, double cx, double cy) {
    const labels = ['Necesidades 50%', 'Deseos 30%', 'Ahorro 20%'];
    const heights = [70.0, 48.0, 32.0];
    const colors = [Color(0xFF58A028), Color(0xFFFFB300), Color(0xFF3888F0)];
    for (var i = 0; i < 3; i++) {
      final x = cx - 52 + i * 38;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, cy - heights[i] / 2, 24, heights[i]), const Radius.circular(4)),
        Paint()..color = colors[i],
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, cy - heights[i] / 2, 24, heights[i]), const Radius.circular(4)),
        Paint()..color = Colors.black.withAlpha(25)..style = PaintingStyle.stroke..strokeWidth = 1.5,
      );
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: Color(0xFF2A4020))),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 50);
      tp.paint(canvas, Offset(x + 12 - tp.width / 2, cy + heights[i] / 2 + 4));
    }
  }

  void _drawGroundPath(Canvas canvas, Size size) {
    final p = Path()
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.55, size.width, size.height * 0.75);
    canvas.drawPath(p, Paint()..color = _SP.path2..style = PaintingStyle.stroke..strokeWidth = 18);
    canvas.drawPath(p, Paint()..color = _SP.path1..style = PaintingStyle.stroke..strokeWidth = 12);
    _SceneKit.signPost(canvas, Offset(size.width * 0.5, size.height * 0.62), '50/30/20');
  }

  void _drawGroundScale(Canvas canvas, Offset c, double t) {
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 30), width: 50, height: 10), Paint()..color = _SP.stone2);
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 10), width: 6, height: 40), Paint()..color = _SP.wood3);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.sin(t * 2) * 0.1);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 90, height: 5), Paint()..color = _SP.wood2);
    canvas.drawCircle(const Offset(-36, 10), 14, Paint()..color = const Color(0xFF58A028).withAlpha(180));
    canvas.drawCircle(const Offset(36, 10), 14, Paint()..color = const Color(0xFF3888F0).withAlpha(180));
    canvas.restore();
  }

  void _drawGroundVault(Canvas canvas, Offset c, double t) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 80, height: 64), const Radius.circular(8)), Paint()..color = _SP.stone2);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 66, height: 52), const Radius.circular(6)), Paint()..color = _SP.stone1);
    canvas.drawCircle(c, 14, Paint()..color = _SP.gold1);
    final spark = 18 + math.sin(t * 6) * 6;
    canvas.drawCircle(c, spark, Paint()..color = _SP.gold1.withAlpha(35));
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4 + time;
      canvas.drawCircle(c + Offset(math.cos(a) * 28, math.sin(a) * 28), 2, Paint()..color = _SP.gold1.withAlpha(160));
    }
  }

  void _drawGroundShield(Canvas canvas, Offset c, double t) {
    final glow = (math.sin(t * 3) * 0.5 + 0.5);
    final path = Path()
      ..moveTo(c.dx, c.dy - 38)
      ..lineTo(c.dx + 34, c.dy - 16)
      ..lineTo(c.dx + 26, c.dy + 26)
      ..lineTo(c.dx, c.dy + 38)
      ..lineTo(c.dx - 26, c.dy + 26)
      ..lineTo(c.dx - 34, c.dy - 16)
      ..close();
    canvas.drawPath(path, Paint()..color = Color.lerp(const Color(0xFF58A028), _SP.gold1, glow * 0.4)!);
    canvas.drawPath(path, Paint()..color = const Color(0xFF1A7038)..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawCircle(c, 10, Paint()..color = _SP.gold1);
  }

  void _drawCoinField(Canvas canvas, Size size, double t) {
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 7; col++) {
        final bob = math.sin(t * 2 + row + col * 0.3) * 2;
        _SceneKit.coin(
          canvas,
          Offset(24 + col * (size.width - 48) / 6, size.height * 0.38 + row * 18 + bob),
          8,
        );
      }
    }
  }

  void _drawGroundCalendar(Canvas canvas, Offset c, String label) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: 90, height: 70), const Radius.circular(10)), Paint()..color = _SP.parchment);
    canvas.drawRect(Rect.fromLTWH(c.dx - 45, c.dy - 35, 90, 18), Paint()..color = const Color(0xFF983828));
    final tp = TextPainter(
      text: TextSpan(text: label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2A4020))),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - 4));
  }

  void _drawGroundRiver(Canvas canvas, Size size, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(16, size.height * 0.38, size.width - 32, 44), const Radius.circular(16)),
      Paint()..color = _SP.water1.withAlpha(100),
    );
    for (var i = 0; i < 12; i++) {
      final p = ((t * 0.4 + i * 0.08) % 1.0);
      _SceneKit.coin(canvas, Offset(20 + (size.width - 40) * p, size.height * 0.52 + math.sin(p * 8 + i) * 8), 9);
    }
  }

  void _drawGroundGears(Canvas canvas, Size size, double t) {
    _drawGearSmall(canvas, Offset(size.width * 0.35, size.height * 0.48), 26, t);
    _drawGearSmall(canvas, Offset(size.width * 0.58, size.height * 0.52), 18, -t * 1.3);
    _drawGearSmall(canvas, Offset(size.width * 0.72, size.height * 0.42), 14, t * 1.8);
  }

  void _drawGearSmall(Canvas canvas, Offset c, double r, double t) {
    final teeth = 8;
    final path = Path();
    for (var i = 0; i < teeth; i++) {
      final a = t * 2 + i * 2 * math.pi / teeth;
      final r1 = r + (i.isEven ? 5 : 0);
      path.lineTo(c.dx + math.cos(a) * r1, c.dy + math.sin(a) * r1);
      path.lineTo(c.dx + math.cos(a + math.pi / teeth) * r, c.dy + math.sin(a + math.pi / teeth) * r);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = _SP.stone1);
    canvas.drawCircle(c, r * 0.4, Paint()..color = _SP.stone2);
  }

  void _drawGroundPayroll(Canvas canvas, Size size, double t) {
    _drawGroundCalendar(canvas, Offset(size.width * 0.4, size.height * 0.46), 'Día de nómina');
    _SceneKit.coinStack(canvas, Offset(size.width * 0.72, size.height * 0.55), 6, time);
    canvas.drawLine(
      Offset(size.width * 0.52, size.height * 0.48),
      Offset(size.width * 0.65, size.height * 0.52),
      Paint()..color = _SP.grass1..strokeWidth = 3,
    );
    _SceneKit.coin(canvas, Offset.lerp(Offset(size.width * 0.52, size.height * 0.48), Offset(size.width * 0.65, size.height * 0.52), (math.sin(t * 2) * 0.5 + 0.5))!, 10);
  }

  void _drawGroundBanks(Canvas canvas, Size size, double t) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width * 0.32, size.height * 0.52), width: 56, height: 44), const Radius.circular(4)), Paint()..color = _SP.wood1);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width * 0.68, size.height * 0.52), width: 56, height: 44), const Radius.circular(4)), Paint()..color = _SP.stone1);
    for (var i = 0; i < 4; i++) {
      final p = ((t * 0.35 + i * 0.2) % 1.0);
      _SceneKit.coin(canvas, Offset.lerp(Offset(size.width * 0.32, size.height * 0.48), Offset(size.width * 0.68, size.height * 0.48), p)!, 8);
    }
  }

  void _drawGroundCafe(Canvas canvas, Size size, double t) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.52), width: 100, height: 50), const Radius.circular(6)), Paint()..color = _SP.wood1);
    for (var i = 0; i < 4; i++) {
      _drawCoffeeCup(canvas, Offset(size.width * 0.32 + i * 22, size.height * 0.54));
    }
    for (var i = 0; i < 8; i++) {
      _SceneKit.coin(canvas, Offset(20 + i * (size.width - 40) / 7, size.height * 0.72), 5, alpha: 190);
    }
  }

  void _drawCoffeeCup(Canvas canvas, Offset c) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, c.dy + 3), width: 16, height: 18), const Radius.circular(2)), Paint()..color = _SP.parchment);
    canvas.drawRect(Rect.fromLTWH(c.dx - 6, c.dy - 10, 12, 5), Paint()..color = const Color(0xFF482008));
  }

  void _drawGroundTrail(Canvas canvas, Size size, double t) {
    for (var i = 0; i < 14; i++) {
      final x = 20 + i * (size.width - 40) / 13 + math.sin(t * 4 + i) * 3;
      final y = size.height * 0.55 - math.sin(i * 0.7) * 8;
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 9, height: 6), Paint()..color = const Color(0xFF482008));
      if (i.isEven) _SceneKit.coin(canvas, Offset(x, y + 10), 4, alpha: 200);
    }
  }

  void _drawGroundInspect(Canvas canvas, Size size, double t) {
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.48);
    canvas.rotate(math.sin(t) * 0.1);
    canvas.drawCircle(Offset.zero, 30, Paint()..color = const Color(0xFF88CCFF).withAlpha(60));
    canvas.drawCircle(Offset.zero, 30, Paint()..color = _SP.wood3..style = PaintingStyle.stroke..strokeWidth = 6);
    canvas.drawLine(const Offset(20, 20), const Offset(40, 40), Paint()..color = _SP.wood3..strokeWidth = 7..strokeCap = StrokeCap.round);
    canvas.restore();
    for (var i = 0; i < 6; i++) {
      _SceneKit.coin(canvas, Offset(size.width * 0.2 + i * 18, size.height * 0.68), 6);
    }
  }

  void _drawGroundLeaks(Canvas canvas, Size size, double t) {
    final c = Offset(size.width * 0.5, size.height * 0.5);
    final path = Path()
      ..moveTo(c.dx - 30, c.dy - 10)
      ..quadraticBezierTo(c.dx, c.dy - 28, c.dx + 30, c.dy - 10)
      ..lineTo(c.dx + 24, c.dy + 16)
      ..quadraticBezierTo(c.dx, c.dy + 26, c.dx - 24, c.dy + 16)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF983828));
    for (var i = 0; i < 6; i++) {
      final drip = (time + i * 0.18) % 1.0;
      _SceneKit.coin(canvas, Offset(c.dx - 20 + i * 8, c.dy + 18 + drip * 30), 6, alpha: 220);
    }
  }

  void _drawGroundTower(Canvas canvas, Size size, double t) {
    for (var i = 0; i < 7; i++) {
      final w = 28.0 + i * 12;
      final y = size.height * 0.72 - i * 14;
      final lit = i == (time * 2.5).floor() % 7;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width * 0.5, y), width: w, height: 12), const Radius.circular(2)),
        Paint()..color = lit ? _SP.gold1 : _SP.stone1,
      );
    }
  }

  void _drawGroundDayGrid(Canvas canvas, Size size, double t) {
    final left = size.width * 0.22;
    final top = size.height * 0.28;
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 7; col++) {
        final day = row * 7 + col + 1;
        final lit = day <= ((time * 15).floor() % 30 + 1);
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(left + col * 15, top + row * 15, 13, 13), const Radius.circular(2)),
          Paint()..color = lit ? const Color(0xFF58A028) : const Color(0xFFE8E0D0),
        );
      }
    }
  }

  void _drawGroundFlag(Canvas canvas, Size size, double t) {
    final pole = Offset(size.width * 0.5, size.height * 0.25);
    canvas.drawLine(pole, Offset(pole.dx, size.height * 0.72), Paint()..color = _SP.wood3..strokeWidth = 5);
    final wave = math.sin(t * 5) * 6;
    canvas.drawPath(
      Path()
        ..moveTo(pole.dx, pole.dy + 8)
        ..lineTo(pole.dx + 48 + wave, pole.dy + 22)
        ..lineTo(pole.dx + 40 + wave, pole.dy + 44)
        ..lineTo(pole.dx, pole.dy + 32)
        ..close(),
      Paint()..color = const Color(0xFF58A028),
    );
    _SceneKit.coinStack(canvas, Offset(size.width * 0.22, size.height * 0.68), 5, time);
    _SceneKit.coinStack(canvas, Offset(size.width * 0.78, size.height * 0.66), 5, time);
  }

  void _drawGroundTreasure(Canvas canvas, Size size, double t) {
    final c = Offset(size.width * 0.5, size.height * 0.52);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(c.dx, c.dy + 10), width: 64, height: 32), const Radius.circular(5)), Paint()..color = _SP.wood2);
    canvas.drawArc(Rect.fromCenter(center: Offset(c.dx, c.dy - 6), width: 64, height: 36), math.pi * 0.9, math.pi * 1.2, false, Paint()..color = _SP.wood1);
    for (var i = 0; i < 8; i++) {
      _SceneKit.coin(canvas, Offset(c.dx - 28 + i * 8, c.dy - 12 - math.sin(time * 3 + i * 0.6) * 5), 8);
    }
    for (var i = 0; i < 12; i++) {
      final a = i * 0.5 + time * 2;
      canvas.drawCircle(
        Offset(c.dx + math.cos(a) * 40, c.dy - 20 + math.sin(a) * 20),
        2,
        Paint()..color = _SP.gold1.withAlpha(140),
      );
    }
  }

  @override
  bool shouldRepaint(_SavingsSlideBottomPainter old) =>
      old.pillIndex != pillIndex || old.slideIndex != slideIndex || old.time != time;
}

// ── Themed card frame ─────────────────────────────────────────────────────────

BoxDecoration savingsSlideCardDecoration() => BoxDecoration(
      color: const Color(0xFFFFFDF5),
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: _SP.wood3, width: 3),
      boxShadow: [
        BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 24, offset: const Offset(0, 10)),
        BoxShadow(color: _SP.grass1.withAlpha(40), blurRadius: 18, spreadRadius: -4),
      ],
    );

BoxDecoration savingsTextPanelDecoration() => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _SP.parchment.withAlpha(240),
          const Color(0xFFF5EDD8).withAlpha(250),
          _SP.parchment.withAlpha(240),
        ],
      ),
      border: Border.symmetric(
        horizontal: BorderSide(color: _SP.wood3.withAlpha(120), width: 2),
      ),
      boxShadow: [
        BoxShadow(color: _SP.wood3.withAlpha(30), blurRadius: 12, offset: const Offset(0, 4)),
      ],
    );

BoxDecoration savingsQuizPeekDecoration() => BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A5030), Color(0xFF0D2840)],
      ),
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: _SP.gold1, width: 2.5),
      boxShadow: [
        BoxShadow(color: _SP.grass1.withAlpha(120), blurRadius: 28, offset: const Offset(0, 10)),
      ],
    );
