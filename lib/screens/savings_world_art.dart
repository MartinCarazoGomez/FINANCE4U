import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// ── Palette (SNES Zelda-inspired) ─────────────────────────────────────────────

class _P {
  static const grass1 = Color(0xFF58A028);
  static const grass2 = Color(0xFF489820);
  static const grass3 = Color(0xFF68B838);
  static const grass4 = Color(0xFF388018);
  static const path1 = Color(0xFFD4A858);
  static const path2 = Color(0xFFB08038);
  static const pathEdge = Color(0xFF886028);
  static const water1 = Color(0xFF3888F0);
  static const water2 = Color(0xFF58A8FF);
  static const water3 = Color(0xFF2060C0);
  static const treeDark = Color(0xFF186018);
  static const treeMid = Color(0xFF288028);
  static const treeLight = Color(0xFF48A848);
  static const trunk = Color(0xFF603818);
  static const stone1 = Color(0xFF989898);
  static const stone2 = Color(0xFF686868);
  static const stone3 = Color(0xFF484848);
  static const wood1 = Color(0xFFB87838);
  static const wood2 = Color(0xFF885828);
  static const wood3 = Color(0xFF684018);
  static const roof1 = Color(0xFF983828);
  static const roof2 = Color(0xFF702018);
  static const gold1 = Color(0xFFFFD848);
  static const gold2 = Color(0xFFC89818);
  static const sky1 = Color(0xFF88C8F8);
  static const sky2 = Color(0xFFB8E0FF);
  static const cloud = Color(0xFFF8F8FF);
  static const heroGreen = Color(0xFF28A848);
  static const heroGreenDark = Color(0xFF1A7038);
  static const heroGreenLight = Color(0xFF50D070);
  static const heroCap = Color(0xFF38C858);
  static const heroCapDark = Color(0xFF289840);
  static const heroSkin = Color(0xFFFFC888);
  static const heroSkinShadow = Color(0xFFE8A868);
  static const heroHair = Color(0xFF905820);
  static const heroBoot = Color(0xFF482008);
  static const heroBootHi = Color(0xFF684020);
  static const heroPants = Color(0xFF7A5830);
  static const heroBelt = Color(0xFF6B4420);
  static const heroGold = Color(0xFFFFD848);
  static const magic1 = Color(0xFF9B59FF);
  static const magic2 = Color(0xFF7B2FF7);
  static const torchFlame = Color(0xFFFF8833);
  static const torchGlow = Color(0xFFFFAA44);
  static const iron1 = Color(0xFF3A3A48);
  static const iron2 = Color(0xFF5A5A68);
  static const moss = Color(0xFF4A7838);
  static const shadow = Color(0x40000000);
  static const farmSoil = Color(0xFF7A5828);
  static const farmSoilDark = Color(0xFF5A4018);
  static const farmCrop = Color(0xFF58A028);
  static const farmCropLight = Color(0xFF78C848);
  static const marsh1 = Color(0xFF3A6848);
  static const marsh2 = Color(0xFF2A5840);
  static const marshWater = Color(0xFF388868);
  static const cliff1 = Color(0xFF7A7A88);
  static const cliff2 = Color(0xFF505060);
  static const cliff3 = Color(0xFF383848);
}

enum BuildingKind { cottage, vault, bank, shop, tower }

enum Facing { down, up, left, right }

// ── Tile map ──────────────────────────────────────────────────────────────────

enum Tile {
  grassA, grassB, grassC, grassD, path, water, flowers, sand, bush, rock,
  plaza, bridge, farm, marsh, cliff,
}

enum DecorKind {
  rockLarge, rockSmall, bush, tallGrass, mushroom, stump, fencePost,
  lilyPad, clover, pebbleCluster, lantern, well, signPost, banner,
  bench, barrel, hayBale, cart, flowerBed, stoneWall, dock, reeds,
  crate, wheatSheaf, owlStatue, pathStone, bushCluster, logPile,
  scarecrow, shrineStone, vineyardPost,
}

class MapDecoration {
  final double x;
  final double y;
  final DecorKind kind;
  final double scale;
  const MapDecoration(this.x, this.y, this.kind, [this.scale = 1.0]);
}

class WorldTileMap {
  static const tileSize = 40.0;
  static const cols = 26;
  static const rows = 16;
  static const width = cols * tileSize;
  static const height = rows * tileSize;

  /// Columnas de puertas verticales (oeste ← centro).
  static const gateBeforePill2Col = 16;
  static const gateBeforePill3Col = 10;
  static const gateBeforePill4Col = 6;

  /// Pasillo horizontal principal (filas con corredor abierto).
  static const corridorRowStart = 7;
  static const corridorRowEnd = 10;

  late final List<List<Tile>> grid;
  late final List<MapDecoration> decorations;
  final math.Random _rng = math.Random(42);

  WorldTileMap() {
    grid = List.generate(rows, (_) => List.filled(cols, Tile.grassA));
    decorations = [];
    _buildProgressionLayout();
    _addGrassVariety();
    _addFlowers();
    _addBushesAndRocks();
    _addProgressionDecor();
    _scatterDecorations();
  }

  bool inBounds(int c, int r) => c >= 0 && c < cols && r >= 0 && r < rows;

  bool isPath(int c, int r) =>
      inBounds(c, r) && grid[r][c] == Tile.path;

  bool isGrassLike(int c, int r) {
    if (!inBounds(c, r)) return false;
    final t = grid[r][c];
    return t == Tile.grassA ||
        t == Tile.grassB ||
        t == Tile.grassC ||
        t == Tile.grassD ||
        t == Tile.flowers;
  }

  bool isWater(int c, int r) =>
      inBounds(c, r) && grid[r][c] == Tile.water;

  Tile? at(int c, int r) => inBounds(c, r) ? grid[r][c] : null;

  bool isWalkableTile(Tile t) => switch (t) {
        Tile.water || Tile.marsh || Tile.cliff || Tile.rock || Tile.bush =>
          false,
        _ => true,
      };

  /// Solo las puertas cerradas bloquean — sin muros de región enormes.
  bool isRegionBlocked(int c, int r, bool Function(int beforePill) isGateOpen) =>
      false;

  /// Comprueba si el héroe puede estar en [feet] (centro en los pies).
  bool isPositionWalkable(
    Offset feet,
    bool Function(int beforePill) isGateOpen,
  ) {
    final c = (feet.dx / tileSize).floor();
    final r = (feet.dy / tileSize).floor();
    if (!inBounds(c, r)) return false;
    final tile = grid[r][c];
    if (!isWalkableTile(tile)) return false;
    return !isRegionBlocked(c, r, isGateOpen);
  }

  void _buildProgressionLayout() {
    // ── Zonas (este → oeste): centro básico | pill2 | pill3 | pill4 ──
    void plaza(int c0, int c1, int r0, int r1) {
      for (var r = r0; r <= r1; r++) {
        for (var c = c0; c <= c1; c++) {
          if (inBounds(c, r)) grid[r][c] = Tile.plaza;
        }
      }
    }

    void path(int c, int r) {
      if (inBounds(c, r)) grid[r][c] = Tile.path;
    }

    void disk(int c, int r, int radC, int radR) {
      for (var dc = -radC; dc <= radC; dc++) {
        for (var dr = -radR; dr <= radR; dr++) {
          path(c + dc, r + dr);
        }
      }
    }

    // Corredor principal este-oeste
    for (var c = 0; c < cols; c++) {
      for (var r = corridorRowStart; r <= corridorRowEnd; r++) {
        disk(c, r, 0, 0);
      }
    }

    // Hub central (lecciones básicas)
    plaza(17, 25, 5, 12);
    for (var r = 11; r <= 14; r++) {
      for (var c = 18; c <= 23; c++) {
        disk(c, r, 0, 0);
      }
    }

    // Zonas de dificultad
    plaza(11, 15, 6, 11); // pill 2
    plaza(6, 9, 6, 11); // pill 3
    plaza(1, 5, 6, 11); // pill 4

    // Estanque decorativo (no bloquea el camino)
    for (var r = 0; r < 3; r++) {
      for (var c = 20; c < cols; c++) {
        grid[r][c] = Tile.water;
      }
    }
    grid[3][22] = Tile.sand;
    grid[3][23] = Tile.sand;
    grid[3][24] = Tile.sand;

    // Vallas norte/sur en cada puerta (evita rodear por arriba/abajo)
    void gateFences(int gateCol) {
      for (var r = 0; r < rows; r++) {
        if (r >= corridorRowStart && r <= corridorRowEnd) continue;
        if (!inBounds(gateCol, r)) continue;
        grid[r][gateCol] = Tile.bush;
        if (inBounds(gateCol - 1, r)) grid[r][gateCol - 1] = Tile.bush;
        if (inBounds(gateCol + 1, r)) grid[r][gateCol + 1] = Tile.bush;
      }
    }

    gateFences(gateBeforePill2Col);
    gateFences(gateBeforePill3Col);
    gateFences(gateBeforePill4Col);

    // Bordes del mapa
    for (var c = 0; c < cols; c++) {
      grid[0][c] = Tile.cliff;
      grid[rows - 1][c] = Tile.cliff;
    }
    for (var r = 0; r < rows; r++) {
      grid[r][0] = Tile.cliff;
      grid[r][cols - 1] = Tile.cliff;
    }
  }

  void _addProgressionDecor() {
    void gateFlair(int gateCol) {
      final x = gateCol * tileSize + tileSize / 2;
      final corridorY =
          (corridorRowStart + corridorRowEnd) / 2.0 * tileSize;
      decorations.add(MapDecoration(x - 50, corridorY - 120, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x - 30, corridorY - 120, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x + 10, corridorY - 120, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x + 30, corridorY - 120, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x - 50, corridorY + 80, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x - 30, corridorY + 80, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x + 10, corridorY + 80, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x + 30, corridorY + 80, DecorKind.fencePost, 1.1));
      decorations.add(MapDecoration(x - 40, corridorY - 118, DecorKind.stoneWall, 0.9));
      decorations.add(MapDecoration(x + 20, corridorY - 118, DecorKind.stoneWall, 0.9));
      decorations.add(MapDecoration(x - 40, corridorY + 78, DecorKind.stoneWall, 0.9));
      decorations.add(MapDecoration(x + 20, corridorY + 78, DecorKind.stoneWall, 0.9));
    }

    gateFlair(gateBeforePill2Col);
    gateFlair(gateBeforePill3Col);
    gateFlair(gateBeforePill4Col);

    // Hub central
    decorations.add(const MapDecoration(720, 340, DecorKind.well, 1.2));
    decorations.add(const MapDecoration(680, 360, DecorKind.flowerBed, 1.0));
    decorations.add(const MapDecoration(780, 360, DecorKind.flowerBed, 1.0));
    decorations.add(const MapDecoration(700, 480, DecorKind.lantern));
    decorations.add(const MapDecoration(760, 480, DecorKind.lantern));
    decorations.add(const MapDecoration(660, 300, DecorKind.signPost, 1.0));
    decorations.add(const MapDecoration(840, 300, DecorKind.signPost, 1.0));
  }

  void _addGrassVariety() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == Tile.grassA) {
          final v = _rng.nextInt(4);
          grid[r][c] = [Tile.grassA, Tile.grassB, Tile.grassC, Tile.grassD][v];
        }
      }
    }
  }

  void _addFlowers() {
    for (int i = 0; i < 48; i++) {
      final c = _rng.nextInt(cols);
      final r = _rng.nextInt(rows);
      if (isGrassLike(c, r) && grid[r][c] != Tile.flowers) {
        grid[r][c] = Tile.flowers;
      }
    }
  }

  void _addBushesAndRocks() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!isGrassLike(c, r) || grid[r][c] == Tile.flowers) continue;
        final roll = _rng.nextDouble();
        if (roll < 0.025) {
          grid[r][c] = Tile.bush;
        } else if (roll < 0.04) {
          grid[r][c] = Tile.rock;
        }
      }
    }
  }

  void _scatterDecorations() {
    for (int i = 0; i < 120; i++) {
      final c = _rng.nextDouble() * cols;
      final r = _rng.nextDouble() * rows;
      final ci = c.floor();
      final ri = r.floor();
      if (!inBounds(ci, ri)) continue;
      final tile = grid[ri][ci];
      if (tile == Tile.water) {
        decorations.add(MapDecoration(
          c * tileSize + 10,
          r * tileSize + 10,
          DecorKind.lilyPad,
          0.7 + _rng.nextDouble() * 0.6,
        ));
        continue;
      }
      if (tile == Tile.marsh) {
        decorations.add(MapDecoration(
          c * tileSize,
          r * tileSize,
          _rng.nextDouble() < 0.6 ? DecorKind.reeds : DecorKind.pebbleCluster,
          0.7 + _rng.nextDouble() * 0.5,
        ));
        continue;
      }
      if (tile == Tile.farm && _rng.nextDouble() < 0.35) {
        decorations.add(MapDecoration(
          c * tileSize,
          r * tileSize,
          DecorKind.wheatSheaf,
          0.55 + _rng.nextDouble() * 0.4,
        ));
        continue;
      }
      if (tile == Tile.path || tile == Tile.sand) {
        if (_rng.nextDouble() < 0.3) {
          decorations.add(MapDecoration(
            c * tileSize,
            r * tileSize,
            DecorKind.pebbleCluster,
            0.5 + _rng.nextDouble(),
          ));
        }
        continue;
      }
      if (!isGrassLike(ci, ri) && tile != Tile.bush && tile != Tile.rock) {
        continue;
      }
      final kind = [
        DecorKind.tallGrass,
        DecorKind.tallGrass,
        DecorKind.clover,
        DecorKind.mushroom,
        DecorKind.rockSmall,
        DecorKind.stump,
      ][_rng.nextInt(6)];
      decorations.add(MapDecoration(
        c * tileSize,
        r * tileSize,
        kind,
        0.6 + _rng.nextDouble() * 0.8,
      ));
    }

    // Fence posts along some path edges
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!isPath(c, r)) continue;
        if (isGrassLike(c - 1, r) && _rng.nextDouble() < 0.35) {
          decorations.add(MapDecoration(
            c * tileSize + 2,
            r * tileSize + tileSize / 2,
            DecorKind.fencePost,
          ));
        }
        if (isGrassLike(c, r - 1) && _rng.nextDouble() < 0.25) {
          decorations.add(MapDecoration(
            c * tileSize + tileSize / 2,
            r * tileSize + 2,
            DecorKind.fencePost,
          ));
        }
      }
    }
  }

  Color tileColor(Tile t) {
    return switch (t) {
      Tile.grassA => _P.grass1,
      Tile.grassB => _P.grass2,
      Tile.grassC => _P.grass3,
      Tile.grassD => _P.grass4,
      Tile.path => _P.path1,
      Tile.water => _P.water1,
      Tile.flowers => _P.grass2,
      Tile.sand => _P.path2,
      Tile.bush => _P.grass3,
      Tile.rock => _P.grass2,
      Tile.plaza => const Color(0xFFC8B898),
      Tile.bridge => _P.wood2,
      Tile.farm => _P.farmSoil,
      Tile.marsh => _P.marsh1,
      Tile.cliff => _P.cliff1,
    };
  }
}

// ── Sky layer ─────────────────────────────────────────────────────────────────

class SkyPainter extends CustomPainter {
  final double time;
  const SkyPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_P.sky1, _P.sky2, _P.grass1],
          stops: [0.0, 0.55, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Drifting clouds (más capas)
    for (int i = 0; i < 9; i++) {
      final baseX = ((i * 130.0 + time * (8 + i)) % (size.width + 260)) - 130;
      final y = 18.0 + i * 22 + (i % 3) * 8;
      _drawCloud(canvas, Offset(baseX, y), 0.65 + i * 0.1);
    }

    // Sol con rayos
    canvas.drawCircle(
      const Offset(72, 52),
      38,
      Paint()
        ..color = const Color(0xFFFFEE88).withAlpha(45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
    canvas.drawCircle(const Offset(72, 52), 22, Paint()..color = const Color(0xFFFFDD44));
    canvas.drawCircle(const Offset(72, 52), 22, Paint()
      ..color = const Color(0xFFFFAA00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4 + time * 0.15;
      canvas.drawLine(
        const Offset(72, 52),
        Offset(72 + math.cos(a) * 52, 52 + math.sin(a) * 52),
        Paint()
          ..color = const Color(0xFFFFEE88).withAlpha(25)
          ..strokeWidth = 3,
      );
    }

    // Montañas lejanas
    final farMount = Paint()..color = const Color(0xFF689878).withAlpha(90);
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.68)
        ..lineTo(size.width * 0.15, size.height * 0.52)
        ..lineTo(size.width * 0.32, size.height * 0.64)
        ..lineTo(size.width * 0.5, size.height * 0.48)
        ..lineTo(size.width * 0.68, size.height * 0.6)
        ..lineTo(size.width * 0.85, size.height * 0.5)
        ..lineTo(size.width, size.height * 0.62)
        ..lineTo(size.width, size.height * 0.75)
        ..lineTo(0, size.height * 0.75)
        ..close(),
      farMount,
    );

    // Pájaros lejanos (más)
    for (int i = 0; i < 6; i++) {
      final bx = (i * 90.0 + time * (14 + i * 2)) % (size.width + 100);
      final by = 48.0 + i * 14 + math.sin(time + i) * 4;
      canvas.drawLine(
        Offset(bx, by),
        Offset(bx + 5, by - 2),
        Paint()..color = Colors.black26..strokeWidth = 1.2,
      );
      canvas.drawLine(
        Offset(bx + 5, by - 2),
        Offset(bx + 10, by),
        Paint()..color = Colors.black26..strokeWidth = 1.2,
      );
    }

    // Distant hills (foreground)
    final hillPaint = Paint()..color = _P.grass3.withAlpha(120);
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.72)
        ..quadraticBezierTo(size.width * 0.25, size.height * 0.62,
            size.width * 0.5, size.height * 0.72)
        ..quadraticBezierTo(size.width * 0.75, size.height * 0.82, size.width,
            size.height * 0.70)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      hillPaint,
    );
  }

  void _drawCloud(Canvas c, Offset o, double scale) {
    final p = Paint()..color = _P.cloud.withAlpha(220);
    c.drawCircle(o, 18 * scale, p);
    c.drawCircle(o + Offset(16 * scale, 4), 14 * scale, p);
    c.drawCircle(o + Offset(-14 * scale, 6), 12 * scale, p);
    c.drawCircle(o + Offset(6 * scale, -8), 10 * scale, p);
  }

  @override
  bool shouldRepaint(SkyPainter old) => old.time != time;
}

// ── Tile map painter ──────────────────────────────────────────────────────────

class TileMapPainter extends CustomPainter {
  final WorldTileMap map;
  final double waterPhase;

  const TileMapPainter({required this.map, required this.waterPhase});

  @override
  void paint(Canvas canvas, Size size) {
    final ts = WorldTileMap.tileSize;

    // Pass 1 — base tiles
    for (int r = 0; r < WorldTileMap.rows; r++) {
      for (int c = 0; c < WorldTileMap.cols; c++) {
        final tile = map.grid[r][c];
        final rect = Rect.fromLTWH(c * ts, r * ts, ts, ts);
        _drawBaseTile(canvas, rect, tile, c, r);
      }
    }

    // Pass 2 — edge blending & borders
    for (int r = 0; r < WorldTileMap.rows; r++) {
      for (int c = 0; c < WorldTileMap.cols; c++) {
        final rect = Rect.fromLTWH(c * ts, r * ts, ts, ts);
        _drawEdgeBlend(canvas, rect, c, r);
      }
    }

    // Pass 3 — surface detail
    for (int r = 0; r < WorldTileMap.rows; r++) {
      for (int c = 0; c < WorldTileMap.cols; c++) {
        final tile = map.grid[r][c];
        final rect = Rect.fromLTWH(c * ts, r * ts, ts, ts);
        _drawSurfaceDetail(canvas, rect, tile, c, r);
      }
    }

    // Pass 4 — scattered decorations
    for (final d in map.decorations) {
      _drawDecoration(canvas, d);
    }

    // Pass 5 — ambient occlusion & contact shadows
    for (int r = 0; r < WorldTileMap.rows; r++) {
      for (int c = 0; c < WorldTileMap.cols; c++) {
        final rect = Rect.fromLTWH(c * ts, r * ts, ts, ts);
        _drawContactShadows(canvas, rect, c, r);
      }
    }

    // Pass 6 — macro vignette (depth)
    _drawMapVignette(canvas, size);
  }

  void _drawContactShadows(Canvas canvas, Rect rect, int c, int r) {
    final tile = map.grid[r][c];
    if (tile == Tile.water || tile == Tile.path || tile == Tile.plaza) return;

    void darkenCorner(Alignment a, double amount) {
      final corner = a == Alignment.topLeft
          ? rect.topLeft
          : a == Alignment.topRight
              ? rect.topRight
              : a == Alignment.bottomLeft
                  ? rect.bottomLeft
                  : rect.bottomRight;
      canvas.drawCircle(
        corner,
        10,
        Paint()
          ..color = Colors.black.withAlpha((amount * 255).round())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    if (map.isWater(c - 1, r) || map.isWater(c, r - 1)) darkenCorner(Alignment.topLeft, 0.06);
    if (map.isWater(c + 1, r) || map.isWater(c, r - 1)) darkenCorner(Alignment.topRight, 0.06);
    if (map.inBounds(c, r + 1) &&
        (map.isPath(c, r + 1) || map.grid[r + 1][c] == Tile.plaza)) {
      canvas.drawRect(
        Rect.fromLTWH(rect.left, rect.bottom - 8, rect.width, 8),
        Paint()..color = Colors.black.withAlpha(18),
      );
    }
  }

  void _drawMapVignette(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [Colors.transparent, Colors.black.withAlpha(28)],
          stops: const [0.55, 1.0],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawBaseTile(Canvas canvas, Rect rect, Tile tile, int c, int r) {
    final base = map.tileColor(tile);

    // Subtle 2×2 micro-variation for organic look
    final micro = math.Random(c * 997 + r * 131);
    for (int my = 0; my < 2; my++) {
      for (int mx = 0; mx < 2; mx++) {
        final patch = Rect.fromLTWH(
          rect.left + mx * 20,
          rect.top + my * 20,
          20,
          20,
        );
        final shift = micro.nextInt(3) - 1;
        canvas.drawRect(
          patch,
          Paint()..color = Color.lerp(base, Colors.black, shift * 0.04)!,
        );
      }
    }

    if (tile == Tile.water) {
      final depth = _shoreDistance(c, r);
      final deep = Color.lerp(_P.water3, _P.water1, (depth / 3).clamp(0.0, 1.0))!;
      canvas.drawRect(rect, Paint()..color = deep);
    }

    if (tile == Tile.bush) {
      canvas.drawRect(rect, Paint()..color = _P.grass2);
      _drawBush(canvas, rect.center, 16);
    }

    if (tile == Tile.rock) {
      canvas.drawRect(rect, Paint()..color = _P.grass2);
      _drawRock(canvas, rect.center, 14);
    }

    if (tile == Tile.farm) {
      canvas.drawRect(rect, Paint()..color = _P.farmSoil);
      for (int row = 0; row < 4; row++) {
        canvas.drawRect(
          Rect.fromLTWH(rect.left, rect.top + row * 10, rect.width, 4),
          Paint()..color = Color.lerp(_P.farmSoil, _P.farmSoilDark, row * 0.18)!,
        );
      }
    }

    if (tile == Tile.marsh) {
      canvas.drawRect(rect, Paint()..color = _P.marsh1);
      canvas.drawRect(
        rect,
        Paint()..color = _P.marsh2.withAlpha(80),
      );
    }

    if (tile == Tile.cliff) {
      canvas.drawRect(rect, Paint()..color = _P.cliff1);
      for (int band = 0; band < 3; band++) {
        canvas.drawRect(
          Rect.fromLTWH(rect.left, rect.top + band * 13, rect.width, 8),
          Paint()..color = Color.lerp(_P.cliff2, _P.cliff3, band * 0.35)!,
        );
      }
    }
  }

  int _shoreDistance(int c, int r) {
    int min = 99;
    for (int dr = -3; dr <= 3; dr++) {
      for (int dc = -3; dc <= 3; dc++) {
        if (!map.isWater(c + dc, r + dr)) {
          min = math.min(min, dc.abs() + dr.abs());
        }
      }
    }
    return min;
  }

  void _drawEdgeBlend(Canvas canvas, Rect rect, int c, int r) {
    final tile = map.grid[r][c];
    final ts = WorldTileMap.tileSize;

    void fringe(int nc, int nr, Alignment align) {
      if (!map.inBounds(nc, nr)) return;
      final neighbor = map.grid[nr][nc];
      if (tile == Tile.path && map.isGrassLike(nc, nr)) {
        final fringeRect = Rect.fromLTWH(
          rect.left + (align == Alignment.centerRight ? ts * 0.55 : 0),
          rect.top + (align == Alignment.bottomCenter ? ts * 0.55 : 0),
          align == Alignment.centerLeft || align == Alignment.centerRight
              ? ts * 0.45
              : ts,
          align == Alignment.topCenter || align == Alignment.bottomCenter
              ? ts * 0.45
              : ts,
        );
        canvas.drawRect(
          fringeRect,
          Paint()..color = _P.grass2.withAlpha(90),
        );
        // Grass blades poking onto path
        final rng = math.Random(c * 50 + nr * 7 + nc);
        for (int i = 0; i < 4; i++) {
          _drawGrassBlade(
            canvas,
            Offset(
              fringeRect.left + rng.nextDouble() * fringeRect.width,
              fringeRect.top + rng.nextDouble() * fringeRect.height,
            ),
            rng.nextDouble() * 0.5 + 0.5,
            _P.grass3,
          );
        }
      }
      if (map.isGrassLike(c, r) && neighbor == Tile.path) {
        canvas.drawRect(
          rect.deflate(2),
          Paint()
            ..color = _P.pathEdge.withAlpha(25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
      if (tile == Tile.sand && neighbor == Tile.water) {
        // Foam line
        canvas.drawLine(
          Offset(rect.left, rect.top + 4),
          Offset(rect.right, rect.top + 4),
          Paint()
            ..color = Colors.white.withAlpha(140)
            ..strokeWidth = 2,
        );
      }
      if (tile == Tile.marsh && (neighbor == Tile.water || neighbor == Tile.marsh)) {
        canvas.drawRect(
          rect.deflate(3),
          Paint()..color = _P.marshWater.withAlpha(70),
        );
      }
      if (tile == Tile.cliff &&
          (neighbor == Tile.grassA ||
              neighbor == Tile.grassB ||
              neighbor == Tile.grassC ||
              neighbor == Tile.grassD ||
              neighbor == Tile.flowers)) {
        canvas.drawRect(
          Rect.fromLTWH(rect.left, rect.bottom - 8, rect.width, 8),
          Paint()..color = _P.grass2.withAlpha(100),
        );
      }
    }

    fringe(c - 1, r, Alignment.centerLeft);
    fringe(c + 1, r, Alignment.centerRight);
    fringe(c, r - 1, Alignment.topCenter);
    fringe(c, r + 1, Alignment.bottomCenter);
  }

  void _drawSurfaceDetail(Canvas canvas, Rect rect, Tile tile, int c, int r) {
    final rng = math.Random(c * 313 + r * 97);

    if (tile.name.startsWith('grass') || tile == Tile.flowers) {
      // Rich grass tufts
      final bladeCount = 12 + rng.nextInt(8);
      for (int i = 0; i < bladeCount; i++) {
        _drawGrassBlade(
          canvas,
          Offset(
            rect.left + 2 + rng.nextDouble() * 36,
            rect.top + 2 + rng.nextDouble() * 36,
          ),
          0.5 + rng.nextDouble() * 1.4,
          [_P.grass3, _P.grass4, _P.grass1, _P.grass2][rng.nextInt(4)],
        );
      }
      // Tiny pebbles & clover dots
      if (rng.nextDouble() < 0.35) {
        canvas.drawCircle(
          Offset(rect.left + rng.nextDouble() * 36, rect.top + rng.nextDouble() * 36),
          1.2,
          Paint()..color = _P.stone2.withAlpha(120),
        );
      }
      if (rng.nextDouble() < 0.2) {
        for (int i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(rect.left + 8 + i * 5, rect.top + rng.nextDouble() * 30),
            2,
            Paint()..color = _P.grass3.withAlpha(160),
          );
        }
      }
    }

    if (tile == Tile.path) {
      // Cobblestone grid
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          final cx = rect.left + 6 + col * 12 + (row.isOdd ? 3 : 0);
          final cy = rect.top + 6 + row * 12;
          final stoneRect = RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: 10, height: 9),
            const Radius.circular(3),
          );
          final variation = rng.nextDouble();
          canvas.drawRRect(
            stoneRect,
            Paint()
              ..color = Color.lerp(_P.path1, _P.path2, variation)!,
          );
          canvas.drawRRect(
            stoneRect,
            Paint()
              ..color = _P.pathEdge.withAlpha(50)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.8,
          );
          // Highlight dot
          canvas.drawCircle(
            Offset(cx - 2, cy - 2),
            1,
            Paint()..color = Colors.white.withAlpha(40),
          );
        }
      }
      // Worn cracks
      if (rng.nextDouble() < 0.4) {
        canvas.drawLine(
          Offset(rect.left + rng.nextDouble() * 36, rect.top + rng.nextDouble() * 36),
          Offset(rect.left + rng.nextDouble() * 36, rect.top + rng.nextDouble() * 36),
          Paint()
            ..color = _P.pathEdge.withAlpha(60)
            ..strokeWidth = 0.8,
        );
      }
    }

    if (tile == Tile.water) {
      final shimmer = math.sin(waterPhase + c * 0.9 + r * 0.7) * 0.5 + 0.5;
      // Multiple wave bands
      for (int w = 0; w < 4; w++) {
        final wy = rect.top + 6 + w * 9 + shimmer * 6;
        canvas.drawLine(
          Offset(rect.left + 2, wy),
          Offset(rect.right - 2, wy + math.sin(waterPhase + w + c * 0.3) * 2.5),
          Paint()
            ..color = _P.water2.withAlpha(70 + w * 18)
            ..strokeWidth = 1.5,
        );
      }
      // Ripple rings
      if (rng.nextDouble() < 0.12) {
        final rx = rect.left + rng.nextDouble() * 36;
        final ry = rect.top + rng.nextDouble() * 36;
        final ripple = (waterPhase + c + r) % 1.0;
        canvas.drawCircle(
          Offset(rx, ry),
          4 + ripple * 8,
          Paint()
            ..color = _P.water2.withAlpha((80 * (1 - ripple)).round())
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
      // Sparkle
      if (rng.nextDouble() < 0.2) {
        canvas.drawCircle(
          Offset(rect.left + rng.nextDouble() * 36, rect.top + rng.nextDouble() * 36),
          1.5,
          Paint()..color = Colors.white.withAlpha(180),
        );
      }
      // Depth caustics
      canvas.drawCircle(
        rect.center + Offset(math.sin(waterPhase + r) * 4, math.cos(waterPhase + c) * 4),
        6,
        Paint()..color = _P.water2.withAlpha(25),
      );
    }

    if (tile == Tile.flowers) {
      final colors = [
        const Color(0xFFFF6B8A),
        const Color(0xFFFFD848),
        const Color(0xFF88AAFF),
        const Color(0xFFFF8844),
        const Color(0xFFFF88DD),
        const Color(0xFFFFFFFF),
      ];
      for (int i = 0; i < 5; i++) {
        final cx = rect.left + 6 + rng.nextDouble() * 28;
        final cy = rect.top + 6 + rng.nextDouble() * 28;
        final col = colors[rng.nextInt(colors.length)];
        // Stem
        canvas.drawLine(
          Offset(cx, cy),
          Offset(cx, cy + 5),
          Paint()..color = _P.grass4..strokeWidth = 1.2,
        );
        // Petals
        for (int p = 0; p < 4; p++) {
          final a = p * math.pi / 2;
          canvas.drawCircle(
            Offset(cx + math.cos(a) * 3, cy + math.sin(a) * 3),
            2,
            Paint()..color = col,
          );
        }
        canvas.drawCircle(Offset(cx, cy), 1.5, Paint()..color = _P.gold1);
      }
    }

    if (tile == Tile.sand) {
      for (int i = 0; i < 20; i++) {
        canvas.drawCircle(
          Offset(rect.left + rng.nextDouble() * 38, rect.top + rng.nextDouble() * 38),
          0.6 + rng.nextDouble(),
          Paint()..color = _P.pathEdge.withAlpha(50 + rng.nextInt(60)),
        );
      }
    }

    if (tile == Tile.plaza) {
      // Mosaico solar en el centro del hub
      if ((c == 10 || c == 11) && (r == 9 || r == 10)) {
        for (int i = 0; i < 12; i++) {
          final a = i * math.pi / 6 + 0.1;
          canvas.drawLine(
            rect.center,
            rect.center + Offset(math.cos(a) * 14, math.sin(a) * 14),
            Paint()
              ..color = _P.gold2.withAlpha(90)
              ..strokeWidth = 1.2,
          );
        }
        canvas.drawCircle(rect.center, 7, Paint()..color = _P.gold1.withAlpha(160));
        canvas.drawCircle(
          rect.center,
          7,
          Paint()
            ..color = _P.gold2
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
      // Losas radiales en la plaza — patrón elaborado
      for (int ring = 1; ring <= 3; ring++) {
        canvas.drawCircle(
          rect.center,
          6.0 + ring * 5,
          Paint()
            ..color = const Color(0xFFB0A080).withAlpha(35 + ring * 8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8,
        );
      }
      for (int i = 0; i < 8; i++) {
        final a = i * math.pi / 4 + 0.15;
        canvas.drawLine(
          rect.center,
          rect.center + Offset(math.cos(a) * 18, math.sin(a) * 18),
          Paint()..color = const Color(0xFF988868).withAlpha(45)..strokeWidth = 0.8,
        );
      }
      // Losas cuadradas con variación
      for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 2; col++) {
          final slab = Rect.fromLTWH(
            rect.left + 4 + col * 18,
            rect.top + 4 + row * 18,
            16,
            16,
          );
          canvas.drawRect(
            slab,
            Paint()
              ..color = Color.lerp(
                const Color(0xFFC8B898),
                const Color(0xFFA89878),
                rng.nextDouble(),
              )!
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.6,
          );
        }
      }
      // Musgo en juntas
      if (rng.nextDouble() < 0.3) {
        canvas.drawCircle(
          rect.center + Offset(rng.nextDouble() * 8 - 4, rng.nextDouble() * 8 - 4),
          3,
          Paint()..color = _P.moss.withAlpha(100),
        );
      }
    }

    if (tile == Tile.bridge) {
      // Tablones de madera con clavos
      for (int i = 0; i < 4; i++) {
        final plankTop = rect.top + 3 + i * 9.0;
        canvas.drawRect(
          Rect.fromLTWH(rect.left + 2, plankTop, rect.width - 4, 7),
          Paint()..color = Color.lerp(_P.wood1, _P.wood3, i * 0.22)!,
        );
        canvas.drawLine(
          Offset(rect.left + 2, plankTop),
          Offset(rect.right - 2, plankTop),
          Paint()..color = _P.wood3.withAlpha(90)..strokeWidth = 0.8,
        );
        // Clavos
        canvas.drawCircle(Offset(rect.left + 6, plankTop + 3.5), 1, Paint()..color = _P.stone3);
        canvas.drawCircle(Offset(rect.right - 6, plankTop + 3.5), 1, Paint()..color = _P.stone3);
      }
      // Barandillas y cuerdas
      canvas.drawLine(
        Offset(rect.left + 2, rect.top + 2),
        Offset(rect.right - 2, rect.top + 2),
        Paint()..color = _P.wood3..strokeWidth = 2.5,
      );
      canvas.drawLine(
        Offset(rect.left + 2, rect.bottom - 3),
        Offset(rect.right - 2, rect.bottom - 3),
        Paint()..color = _P.wood2..strokeWidth = 2,
      );
      for (int i = 0; i < 3; i++) {
        final x = rect.left + 8 + i * 12.0;
        canvas.drawLine(
          Offset(x, rect.top + 2),
          Offset(x, rect.bottom - 3),
          Paint()..color = _P.wood3.withAlpha(80)..strokeWidth = 1,
        );
      }
      // Postes verticales en extremos
      canvas.drawRect(
        Rect.fromLTWH(rect.left, rect.top, 3, rect.height),
        Paint()..color = _P.wood3,
      );
      canvas.drawRect(
        Rect.fromLTWH(rect.right - 3, rect.top, 3, rect.height),
        Paint()..color = _P.wood3,
      );
    }

    if (tile == Tile.farm) {
      // Surcos y cultivos
      for (int row = 0; row < 3; row++) {
        final y = rect.top + 8 + row * 11.0;
        canvas.drawLine(
          Offset(rect.left + 2, y),
          Offset(rect.right - 2, y + 1),
          Paint()..color = _P.farmSoilDark.withAlpha(140)..strokeWidth = 1.5,
        );
        for (int sprout = 0; sprout < 5; sprout++) {
          final sx = rect.left + 5 + sprout * 7.0;
          _drawGrassBlade(
            canvas,
            Offset(sx, y + 2),
            0.35 + rng.nextDouble() * 0.25,
            rng.nextBool() ? _P.farmCrop : _P.farmCropLight,
          );
        }
      }
      if (rng.nextDouble() < 0.25) {
        canvas.drawCircle(
          Offset(rect.left + rng.nextDouble() * 30, rect.top + rng.nextDouble() * 30),
          2,
          Paint()..color = const Color(0xFFFF8844).withAlpha(120),
        );
      }
    }

    if (tile == Tile.marsh) {
      for (int i = 0; i < 8; i++) {
        final bx = rect.left + rng.nextDouble() * 34;
        final by = rect.top + rng.nextDouble() * 34;
        canvas.drawLine(
          Offset(bx, by + 8),
          Offset(bx + rng.nextDouble() * 2 - 1, by - 6 - rng.nextDouble() * 8),
          Paint()
            ..color = _P.moss.withAlpha(160)
            ..strokeWidth = 1.4,
        );
      }
      if (rng.nextDouble() < 0.35) {
        canvas.drawCircle(
          Offset(rect.left + rng.nextDouble() * 36, rect.top + rng.nextDouble() * 36),
          2 + rng.nextDouble() * 2,
          Paint()..color = _P.marshWater.withAlpha(100),
        );
      }
      final shimmer = math.sin(waterPhase + c + r * 0.7) * 0.5 + 0.5;
      canvas.drawLine(
        Offset(rect.left + 4, rect.top + 12 + shimmer * 4),
        Offset(rect.right - 4, rect.top + 14 + shimmer * 3),
        Paint()..color = _P.water2.withAlpha(45)..strokeWidth = 1,
      );
    }

    if (tile == Tile.cliff) {
      for (int i = 0; i < 6; i++) {
        final y = rect.top + 4 + i * 6.0;
        canvas.drawLine(
          Offset(rect.left + 2, y),
          Offset(rect.right - 2 - rng.nextDouble() * 6, y + 2),
          Paint()..color = _P.cliff3.withAlpha(120)..strokeWidth = 1.2,
        );
      }
      if (rng.nextDouble() < 0.4) {
        _drawRock(canvas, rect.center + Offset(rng.nextDouble() * 8 - 4, 4), 6);
      }
      // Musgo en la base
      canvas.drawRect(
        Rect.fromLTWH(rect.left, rect.bottom - 6, rect.width, 6),
        Paint()..color = _P.moss.withAlpha(70),
      );
    }
  }

  void _drawGrassBlade(Canvas canvas, Offset base, double h, Color col) {
    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(
        base.dx + 2,
        base.dy - h * 8,
        base.dx + 1,
        base.dy - h * 12,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = col.withAlpha(180)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawBush(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(center, r, Paint()..color = _P.treeDark);
    canvas.drawCircle(center + const Offset(-6, -4), r * 0.7, Paint()..color = _P.treeMid);
    canvas.drawCircle(center + const Offset(6, -3), r * 0.65, Paint()..color = _P.treeLight);
    canvas.drawCircle(center + const Offset(0, -8), r * 0.55, Paint()..color = _P.treeLight);
  }

  void _drawRock(Canvas canvas, Offset center, double r) {
    final path = Path()
      ..moveTo(center.dx - r, center.dy + 4)
      ..lineTo(center.dx - r * 0.5, center.dy - r * 0.6)
      ..lineTo(center.dx + r * 0.3, center.dy - r * 0.8)
      ..lineTo(center.dx + r, center.dy + 2)
      ..close();
    canvas.drawPath(path, Paint()..color = _P.stone2);
    canvas.drawPath(
      path,
      Paint()
        ..color = _P.stone3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(center.dx - 4, center.dy - 2),
      Offset(center.dx + 2, center.dy - 6),
      Paint()..color = _P.stone1.withAlpha(120)..strokeWidth = 1.5,
    );
  }

  void _drawDecoration(Canvas canvas, MapDecoration d) {
    switch (d.kind) {
      case DecorKind.bush:
        _drawBush(canvas, Offset(d.x + 16, d.y + 24), 12 * d.scale);
      case DecorKind.tallGrass:
        for (int i = 0; i < 5; i++) {
          _drawGrassBlade(
            canvas,
            Offset(d.x + 8 + i * 5, d.y + 30),
            d.scale * (0.8 + i * 0.1),
            _P.grass4,
          );
        }
      case DecorKind.clover:
        for (int i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(d.x + 10 + i * 6, d.y + 28),
            3,
            Paint()..color = _P.grass3,
          );
        }
      case DecorKind.mushroom:
        canvas.drawRect(
          Rect.fromCenter(
              center: Offset(d.x + 12, d.y + 32), width: 4, height: 6),
          Paint()..color = _P.wood1,
        );
        canvas.drawArc(
          Rect.fromCenter(
              center: Offset(d.x + 12, d.y + 26), width: 14 * d.scale, height: 10),
          math.pi,
          math.pi,
          true,
          Paint()..color = const Color(0xFFE05050),
        );
      case DecorKind.rockSmall:
        _drawRock(canvas, Offset(d.x + 12, d.y + 28), 6 * d.scale);
      case DecorKind.rockLarge:
        _drawRock(canvas, Offset(d.x + 16, d.y + 26), 12 * d.scale);
      case DecorKind.stump:
        canvas.drawOval(
          Rect.fromCenter(
              center: Offset(d.x + 12, d.y + 32), width: 16, height: 8),
          Paint()..color = _P.trunk,
        );
        canvas.drawCircle(
          Offset(d.x + 12, d.y + 28),
          8,
          Paint()..color = _P.wood2,
        );
        canvas.drawCircle(
          Offset(d.x + 12, d.y + 28),
          4,
          Paint()..color = _P.wood3.withAlpha(100),
        );
      case DecorKind.fencePost:
        canvas.drawRect(
          Rect.fromCenter(
              center: Offset(d.x + 4, d.y + 10), width: 4, height: 16),
          Paint()..color = _P.wood2,
        );
        canvas.drawRect(
          Rect.fromLTWH(d.x, d.y + 4, 12, 3),
          Paint()..color = _P.wood3,
        );
      case DecorKind.lilyPad:
        canvas.drawOval(
          Rect.fromCenter(
              center: Offset(d.x, d.y), width: 18 * d.scale, height: 12 * d.scale),
          Paint()..color = _P.grass3.withAlpha(200),
        );
        canvas.drawArc(
          Rect.fromCenter(
              center: Offset(d.x, d.y), width: 18 * d.scale, height: 12 * d.scale),
          -0.3,
          1.2,
          false,
          Paint()
            ..color = _P.grass4
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
        );
      case DecorKind.pebbleCluster:
        for (int i = 0; i < 4; i++) {
          canvas.drawCircle(
            Offset(d.x + 6 + i * 5, d.y + 28),
            1.5,
            Paint()..color = _P.stone2.withAlpha(140),
          );
        }
      case DecorKind.lantern:
        _drawLantern(canvas, Offset(d.x + 8, d.y + 20), waterPhase);
      case DecorKind.well:
        _drawWell(canvas, Offset(d.x, d.y));
      case DecorKind.signPost:
        _drawSignPost(canvas, Offset(d.x, d.y), '→');
      case DecorKind.banner:
        _drawBanner(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.bench:
        _drawBench(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.barrel:
        _drawBarrel(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.hayBale:
        _drawHayBale(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.cart:
        _drawCart(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.flowerBed:
        _drawFlowerBed(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.stoneWall:
        _drawStoneWall(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.dock:
        _drawDock(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.reeds:
        _drawReeds(canvas, Offset(d.x, d.y), d.scale, waterPhase);
      case DecorKind.crate:
        _drawCrate(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.wheatSheaf:
        _drawWheatSheaf(canvas, Offset(d.x, d.y), d.scale, waterPhase);
      case DecorKind.owlStatue:
        _drawOwlStatue(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.pathStone:
        _drawPathStone(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.bushCluster:
        _drawBushCluster(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.logPile:
        _drawLogPile(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.scarecrow:
        _drawScarecrow(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.shrineStone:
        _drawShrineStone(canvas, Offset(d.x, d.y), d.scale);
      case DecorKind.vineyardPost:
        _drawVineyardPost(canvas, Offset(d.x, d.y), d.scale, waterPhase);
    }
  }

  void _drawBench(Canvas canvas, Offset pos, double scale) {
    final s = scale;
    canvas.drawRect(
      Rect.fromCenter(center: pos + Offset(16 * s, 28 * s), width: 36 * s, height: 4 * s),
      Paint()..color = _P.wood2,
    );
    canvas.drawRect(
      Rect.fromCenter(center: pos + Offset(16 * s, 22 * s), width: 32 * s, height: 3 * s),
      Paint()..color = _P.wood1,
    );
    for (final dx in [-12.0, 12.0]) {
      canvas.drawRect(
        Rect.fromCenter(center: pos + Offset((16 + dx) * s, 32 * s), width: 4 * s, height: 12 * s),
        Paint()..color = _P.wood3,
      );
    }
  }

  void _drawBarrel(Canvas canvas, Offset pos, double scale) {
    final c = pos + Offset(12 * scale, 26 * scale);
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 22 * scale, height: 26 * scale),
      Paint()..color = _P.wood2,
    );
    canvas.drawLine(
      Offset(c.dx - 10 * scale, c.dy - 8 * scale),
      Offset(c.dx + 10 * scale, c.dy - 8 * scale),
      Paint()..color = _P.wood3..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(c.dx - 10 * scale, c.dy + 8 * scale),
      Offset(c.dx + 10 * scale, c.dy + 8 * scale),
      Paint()..color = _P.wood3..strokeWidth = 2,
    );
  }

  void _drawHayBale(Canvas canvas, Offset pos, double scale) {
    final r = Rect.fromCenter(
      center: pos + Offset(14 * scale, 28 * scale),
      width: 28 * scale,
      height: 18 * scale,
    );
    canvas.drawOval(r, Paint()..color = _P.gold2);
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(r.left + 4, r.top + 4 + i * 3.0),
        Offset(r.right - 4, r.top + 4 + i * 3.0),
        Paint()..color = _P.gold1.withAlpha(100)..strokeWidth = 0.8,
      );
    }
    canvas.drawOval(r, Paint()..color = _P.wood3.withAlpha(80)..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }

  void _drawCart(Canvas canvas, Offset pos, double scale) {
    final s = scale;
    canvas.drawRect(
      Rect.fromCenter(center: pos + Offset(20 * s, 24 * s), width: 32 * s, height: 16 * s),
      Paint()..color = _P.wood1,
    );
    canvas.drawCircle(pos + Offset(10 * s, 34 * s), 5 * s, Paint()..color = _P.stone3);
    canvas.drawCircle(pos + Offset(30 * s, 34 * s), 5 * s, Paint()..color = _P.stone3);
    canvas.drawLine(
      pos + Offset(36 * s, 20 * s),
      pos + Offset(44 * s, 12 * s),
      Paint()..color = _P.wood3..strokeWidth = 2,
    );
    _drawHayBale(canvas, pos + Offset(4 * s, -4 * s), s * 0.7);
  }

  void _drawFlowerBed(Canvas canvas, Offset pos, double scale) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos + Offset(16 * scale, 28 * scale), width: 40 * scale, height: 16 * scale),
        Radius.circular(4 * scale),
      ),
      Paint()..color = _P.wood3.withAlpha(120),
    );
    const cols = [Color(0xFFFF6B8A), Color(0xFFFFD848), Color(0xFF88AAFF), Color(0xFFFF8844)];
    for (var i = 0; i < 8; i++) {
      final fx = pos.dx + 4 + i * 4.5 * scale;
      final fy = pos.dy + 24 + (i % 2) * 3;
      canvas.drawCircle(Offset(fx, fy), 2.5 * scale, Paint()..color = cols[i % cols.length]);
    }
  }

  void _drawStoneWall(Canvas canvas, Offset pos, double scale) {
    for (var i = 0; i < 4; i++) {
      final r = Rect.fromLTWH(pos.dx + i * 9 * scale, pos.dy + 18, 10 * scale, 8 * scale);
      canvas.drawRect(r, Paint()..color = i.isEven ? _P.stone1 : _P.stone2);
      canvas.drawRect(r, Paint()..color = _P.stone3.withAlpha(60)..style = PaintingStyle.stroke..strokeWidth = 0.8);
    }
  }

  void _drawDock(Canvas canvas, Offset pos, double scale) {
    final s = scale;
    for (var i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(pos.dx + i * 14 * s, pos.dy + 20, 12 * s, 6 * s),
        Paint()..color = Color.lerp(_P.wood1, _P.wood3, i * 0.15)!,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(pos.dx, pos.dy + 14, 6 * s, 22 * s),
      Paint()..color = _P.wood3,
    );
    canvas.drawCircle(pos + Offset(70 * s, 32 * s), 4 * s, Paint()..color = _P.wood2);
    canvas.drawLine(
      pos + Offset(70 * s, 32 * s),
      pos + Offset(90 * s, 20 * s),
      Paint()..color = _P.wood2..strokeWidth = 1.5,
    );
  }

  void _drawReeds(Canvas canvas, Offset pos, double scale, double t) {
    for (var i = 0; i < 7; i++) {
      final sway = math.sin(t * 2 + i) * 3;
      final base = Offset(pos.dx + 6 + i * 5 * scale, pos.dy + 34);
      canvas.drawLine(
        base,
        base + Offset(sway, -18 - i * 2.0),
        Paint()
          ..color = _P.grass4
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawCrate(Canvas canvas, Offset pos, double scale) {
    final r = Rect.fromCenter(center: pos + Offset(12 * scale, 26 * scale), width: 22 * scale, height: 20 * scale);
    canvas.drawRect(r, Paint()..color = _P.wood1);
    canvas.drawLine(r.topLeft, r.bottomRight, Paint()..color = _P.wood3..strokeWidth = 1);
    canvas.drawLine(Offset(r.right, r.top), Offset(r.left, r.bottom), Paint()..color = _P.wood3..strokeWidth = 1);
  }

  void _drawWheatSheaf(Canvas canvas, Offset pos, double scale, double t) {
    final sway = math.sin(t + pos.dx * 0.01) * 2;
    for (var i = 0; i < 6; i++) {
      final base = Offset(pos.dx + 8 + i * 2.5, pos.dy + 32);
      canvas.drawLine(
        base,
        base + Offset(sway + i * 0.3, -22 - i * 1.5),
        Paint()..color = _P.gold2..strokeWidth = 1.5..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawOval(
      Rect.fromCenter(center: pos + Offset(12 * scale, 30 * scale), width: 16 * scale, height: 8 * scale),
      Paint()..color = _P.gold1,
    );
  }

  void _drawOwlStatue(Canvas canvas, Offset pos, double scale) {
    final c = pos + Offset(14 * scale, 24 * scale);
    canvas.drawOval(
      Rect.fromCenter(center: c + Offset(0, 10 * scale), width: 20 * scale, height: 10 * scale),
      Paint()..color = _P.stone2,
    );
    canvas.drawCircle(c, 10 * scale, Paint()..color = _P.stone1);
    canvas.drawCircle(c + Offset(-4 * scale, -2 * scale), 3 * scale, Paint()..color = _P.gold1);
    canvas.drawCircle(c + Offset(4 * scale, -2 * scale), 3 * scale, Paint()..color = _P.gold1);
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy + 2 * scale)
        ..lineTo(c.dx - 3 * scale, c.dy + 6 * scale)
        ..lineTo(c.dx + 3 * scale, c.dy + 6 * scale)
        ..close(),
      Paint()..color = _P.stone3,
    );
  }

  void _drawPathStone(Canvas canvas, Offset pos, double scale) {
    final path = Path()
      ..moveTo(pos.dx + 4, pos.dy + 28)
      ..lineTo(pos.dx + 10, pos.dy + 20)
      ..lineTo(pos.dx + 18, pos.dy + 22)
      ..lineTo(pos.dx + 14, pos.dy + 30)
      ..close();
    canvas.drawPath(path, Paint()..color = _P.stone2);
    canvas.drawPath(path, Paint()..color = _P.stone1.withAlpha(80)..style = PaintingStyle.stroke..strokeWidth = 0.8);
  }

  void _drawBushCluster(Canvas canvas, Offset pos, double scale) {
    _drawBush(canvas, pos + Offset(12, 22), 14 * scale);
    _drawBush(canvas, pos + Offset(24, 26), 10 * scale);
    _drawBush(canvas, pos + Offset(4, 26), 9 * scale);
  }

  void _drawLogPile(Canvas canvas, Offset pos, double scale) {
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: pos + Offset(14 * scale + i * 2, 28 + i * 2.0),
            width: 28 * scale,
            height: 10 * scale,
          ),
          Radius.circular(4 * scale),
        ),
        Paint()..color = Color.lerp(_P.wood2, _P.wood1, i * 0.2)!,
      );
      canvas.drawCircle(
        pos + Offset(24 * scale + i, 26 + i * 2.0),
        4 * scale,
        Paint()..color = _P.wood3.withAlpha(100),
      );
    }
  }

  void _drawScarecrow(Canvas canvas, Offset pos, double scale) {
    final s = scale;
    final base = pos + Offset(14 * s, 38 * s);
    canvas.drawLine(
      Offset(base.dx, base.dy),
      Offset(base.dx, base.dy - 34 * s),
      Paint()..color = _P.wood3..strokeWidth = 3 * s,
    );
    canvas.drawLine(
      Offset(base.dx - 14 * s, base.dy - 22 * s),
      Offset(base.dx + 14 * s, base.dy - 22 * s),
      Paint()..color = _P.wood2..strokeWidth = 2.5 * s,
    );
    canvas.drawCircle(
      base + Offset(0, -36 * s),
      7 * s,
      Paint()..color = _P.path1,
    );
    canvas.drawRect(
      Rect.fromCenter(center: base + Offset(0, -24 * s), width: 18 * s, height: 20 * s),
      Paint()..color = const Color(0xFF8B4513),
    );
    canvas.drawRect(
      Rect.fromCenter(center: base + Offset(0, -14 * s), width: 16 * s, height: 14 * s),
      Paint()..color = const Color(0xFF6B3010),
    );
  }

  void _drawShrineStone(Canvas canvas, Offset pos, double scale) {
    final s = scale;
    final c = pos + Offset(12 * s, 28 * s);
    canvas.drawRect(
      Rect.fromCenter(center: c, width: 16 * s, height: 22 * s),
      Paint()..color = _P.stone2,
    );
    canvas.drawRect(
      Rect.fromCenter(center: c + Offset(0, -14 * s), width: 12 * s, height: 8 * s),
      Paint()..color = _P.stone1,
    );
    canvas.drawCircle(
      c + Offset(0, -4 * s),
      3 * s,
      Paint()..color = _P.gold1.withAlpha(180),
    );
    canvas.drawLine(
      c + Offset(-5 * s, 2 * s),
      c + Offset(5 * s, 2 * s),
      Paint()..color = _P.stone3..strokeWidth = 1,
    );
  }

  void _drawVineyardPost(Canvas canvas, Offset pos, double scale, double phase) {
    final s = scale;
    final base = pos + Offset(8 * s, 34 * s);
    canvas.drawRect(
      Rect.fromCenter(center: base, width: 5 * s, height: 28 * s),
      Paint()..color = _P.wood3,
    );
    for (var i = 0; i < 3; i++) {
      final y = base.dy - 18 * s + i * 8 * s;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(base.dx + 10 * s, y), width: 18 * s, height: 10 * s),
        -math.pi * 0.2,
        math.pi * 0.9,
        false,
        Paint()
          ..color = _P.farmCrop.withAlpha(150 + (math.sin(phase + i) * 30).round())
          ..strokeWidth = 2 * s,
      );
    }
  }

  void _drawLantern(Canvas canvas, Offset pos, double flicker) {
    final pulse = 0.75 + math.sin(flicker * 10) * 0.25;
    // Post
    canvas.drawRect(
      Rect.fromCenter(center: pos + const Offset(0, 14), width: 4, height: 18),
      Paint()..color = _P.wood3,
    );
    // Housing
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: 14, height: 16),
        const Radius.circular(3),
      ),
      Paint()..color = _P.iron1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: 14, height: 16),
        const Radius.circular(3),
      ),
      Paint()..color = _P.iron2..style = PaintingStyle.stroke..strokeWidth = 1,
    );
    // Glass
    canvas.drawRect(
      Rect.fromCenter(center: pos, width: 8, height: 10),
      Paint()..color = _P.torchGlow.withAlpha((160 * pulse).round()),
    );
    // Flame glow
    canvas.drawCircle(
      pos + const Offset(0, -8),
      8 * pulse,
      Paint()
        ..color = _P.torchFlame.withAlpha((70 * pulse).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(pos + const Offset(0, -6), 3 * pulse, Paint()..color = _P.torchFlame);
  }

  void _drawWell(Canvas canvas, Offset pos) {
    canvas.drawOval(
      Rect.fromCenter(center: pos + const Offset(20, 38), width: 44, height: 14),
      Paint()..color = _P.shadow,
    );
    // Stone ring — doble
    canvas.drawOval(
      Rect.fromCenter(center: pos + const Offset(20, 30), width: 38, height: 24),
      Paint()..color = _P.stone2,
    );
    canvas.drawOval(
      Rect.fromCenter(center: pos + const Offset(20, 30), width: 32, height: 20),
      Paint()..color = _P.stone1,
    );
    canvas.drawOval(
      Rect.fromCenter(center: pos + const Offset(20, 30), width: 24, height: 14),
      Paint()..color = _P.water3,
    );
    // Agua con brillo
    canvas.drawCircle(
      pos + const Offset(16, 28),
      3,
      Paint()..color = _P.water2.withAlpha(120),
    );
    // Roof posts
    canvas.drawLine(
      pos + const Offset(4, 18),
      pos + const Offset(4, 2),
      Paint()..color = _P.wood3..strokeWidth = 3.5,
    );
    canvas.drawLine(
      pos + const Offset(36, 18),
      pos + const Offset(36, 2),
      Paint()..color = _P.wood3..strokeWidth = 3.5,
    );
    canvas.drawLine(
      pos + const Offset(2, 4),
      pos + const Offset(38, 4),
      Paint()..color = _P.wood2..strokeWidth = 5,
    );
    // Tejas
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(pos.dx + 4 + i * 7, pos.dy + 4),
        Offset(pos.dx + 8 + i * 7, pos.dy + 10),
        Paint()..color = _P.roof1.withAlpha(180)..strokeWidth = 2,
      );
    }
    // Cubo
    canvas.drawRect(
      Rect.fromCenter(center: pos + const Offset(28, 22), width: 8, height: 10),
      Paint()..color = _P.wood2,
    );
    canvas.drawLine(
      pos + const Offset(28, 12),
      pos + const Offset(28, 22),
      Paint()..color = _P.wood3..strokeWidth = 1.5,
    );
  }

  void _drawSignPost(Canvas canvas, Offset pos, String arrow) {
    canvas.drawRect(
      Rect.fromCenter(center: pos + const Offset(8, 28), width: 5, height: 22),
      Paint()..color = _P.wood3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos + const Offset(8, 10), width: 22, height: 16),
        const Radius.circular(4),
      ),
      Paint()..color = _P.wood1,
    );
  }

  void _drawBanner(Canvas canvas, Offset pos, double scale) {
    canvas.drawRect(
      Rect.fromCenter(center: pos + Offset(8, 24), width: 4, height: 28),
      Paint()..color = _P.wood3,
    );
    canvas.drawRect(
      Rect.fromLTWH(pos.dx + 10, pos.dy + 4, 18 * scale, 22),
      Paint()..color = const Color(0xFF7ED957),
    );
    canvas.drawLine(
      Offset(pos.dx + 10, pos.dy + 8),
      Offset(pos.dx + 10 + 18 * scale, pos.dy + 8),
      Paint()..color = _P.gold1..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(TileMapPainter old) =>
      old.waterPhase != waterPhase;
}

// ── Tree ──────────────────────────────────────────────────────────────────────

class TreePainter extends CustomPainter {
  final double sway;
  final double scale;
  const TreePainter({required this.sway, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final base = size.height - 4;
    final s = scale;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, base + 2), width: 42 * s, height: 12 * s),
      Paint()..color = _P.shadow,
    );

    // Trunk with bark texture & roots
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, base - 16 * s), width: 12 * s, height: 26 * s),
      Paint()..color = _P.trunk,
    );
    for (double y = base - 28 * s; y < base; y += 5 * s) {
      canvas.drawLine(
        Offset(cx - 5 * s, y),
        Offset(cx + 5 * s, y + 1),
        Paint()..color = _P.wood3.withAlpha(90)..strokeWidth = 0.9,
      );
    }
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, base - 2), width: 20 * s, height: 8 * s),
      math.pi,
      math.pi,
      false,
      Paint()..color = _P.wood3.withAlpha(120)..strokeWidth = 3,
    );

    // Canopy layers (swaying) — más volumen
    final sw = math.sin(sway) * 3 * s;
    void canopy(Offset c, double r, Color col) {
      canvas.drawCircle(c + Offset(sw, 0), r, Paint()..color = col);
    }

    canopy(Offset(cx, base - 44 * s), 28 * s, _P.treeDark);
    canopy(Offset(cx - 18 * s + sw, base - 34 * s), 20 * s, _P.treeMid);
    canopy(Offset(cx + 18 * s + sw, base - 34 * s), 20 * s, _P.treeLight);
    canopy(Offset(cx, base - 56 * s), 18 * s, _P.treeLight);
    canopy(Offset(cx - 10 * s + sw * 0.5, base - 50 * s), 14 * s, _P.treeMid);
    canopy(Offset(cx + 8 * s + sw * 0.5, base - 48 * s), 12 * s, _P.treeLight);
    // Highlights
    canvas.drawCircle(
      Offset(cx - 8 * s + sw, base - 50 * s),
      5 * s,
      Paint()..color = Colors.white.withAlpha(35),
    );
    // Bird nest (occasional detail via sway phase)
    if (math.sin(sway * 0.3) > 0.6) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + 12 * s, base - 30 * s), width: 10 * s, height: 6 * s),
        math.pi,
        math.pi,
        false,
        Paint()..color = _P.wood2..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(TreePainter old) => old.sway != sway || old.scale != scale;
}

// ── Pine tree ─────────────────────────────────────────────────────────────────

class PineTreePainter extends CustomPainter {
  final double sway;
  final double scale;
  const PineTreePainter({required this.sway, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final base = size.height - 4;
    final s = scale;
    final sw = math.sin(sway) * 2 * s;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, base + 2), width: 36 * s, height: 10 * s),
      Paint()..color = _P.shadow,
    );

    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, base - 12 * s), width: 10 * s, height: 22 * s),
      Paint()..color = _P.trunk,
    );

    void layer(double yOff, double w, double h, Color col) {
      final path = Path()
        ..moveTo(cx + sw, base - yOff)
        ..lineTo(cx - w / 2 + sw, base - yOff + h)
        ..lineTo(cx + w / 2 + sw, base - yOff + h)
        ..close();
      canvas.drawPath(path, Paint()..color = col);
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.black.withAlpha(25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    layer(28 * s, 38 * s, 18 * s, _P.treeDark);
    layer(42 * s, 32 * s, 16 * s, _P.treeMid);
    layer(54 * s, 26 * s, 14 * s, _P.treeLight);
    canvas.drawCircle(
      Offset(cx + sw * 0.5, base - 58 * s),
      4 * s,
      Paint()..color = Colors.white.withAlpha(40),
    );
  }

  @override
  bool shouldRepaint(PineTreePainter old) => old.sway != sway || old.scale != scale;
}

// ── World landmarks overlay ───────────────────────────────────────────────────

class WorldLandmarksPainter extends CustomPainter {
  final double time;
  const WorldLandmarksPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    _drawWindmill(canvas, const Offset(798, 82));
    _drawWaterfall(canvas, const Offset(242, 198));
    _drawRuinedArch(canvas, const Offset(22, 288));
    _drawCampfire(canvas, const Offset(408, 578));
    _drawBeacon(canvas, const Offset(132, 68));
    _drawShrineCircle(canvas, const Offset(338, 218));
  }

  void _drawWindmill(Canvas canvas, Offset base) {
    canvas.drawRect(
      Rect.fromLTWH(base.dx, base.dy + 18, 38, 54),
      Paint()..color = _P.stone2,
    );
    canvas.drawRect(
      Rect.fromLTWH(base.dx + 4, base.dy + 52, 30, 20),
      Paint()..color = _P.stone3,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: base + const Offset(19, 58),
        width: 14,
        height: 18,
      ),
      0,
      math.pi,
      true,
      Paint()..color = _P.stone1,
    );
    final hub = base + const Offset(19, 32);
    canvas.drawCircle(hub, 5, Paint()..color = _P.wood3);
    final angle = time * 1.4;
    for (var i = 0; i < 4; i++) {
      final a = angle + i * math.pi / 2;
      final tip = hub + Offset(math.cos(a) * 38, math.sin(a) * 38);
      canvas.drawLine(hub, tip, Paint()..color = _P.wood1..strokeWidth = 4);
      canvas.drawLine(
        hub + Offset(math.cos(a) * 12, math.sin(a) * 12),
        tip,
        Paint()..color = const Color(0xFFF0E8D0)..strokeWidth = 2.5,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: hub + Offset(math.cos(a) * 28, math.sin(a) * 28),
          width: 8,
          height: 22,
        ),
        Paint()..color = _P.wood2.withAlpha(200),
      );
    }
    canvas.drawCircle(hub, 6, Paint()..color = _P.iron1);
  }

  void _drawWaterfall(Canvas canvas, Offset top) {
    canvas.drawRect(
      Rect.fromLTWH(top.dx, top.dy, 48, 72),
      Paint()..color = _P.cliff2,
    );
    for (var i = 0; i < 5; i++) {
      final x = top.dx + 8 + i * 8.0;
      final flow = math.sin(time * 3 + i) * 3;
      canvas.drawLine(
        Offset(x, top.dy + 8),
        Offset(x + flow, top.dy + 68),
        Paint()
          ..color = _P.water2.withAlpha(180)
          ..strokeWidth = 3,
      );
    }
    canvas.drawOval(
      Rect.fromCenter(center: top + const Offset(24, 78), width: 56, height: 16),
      Paint()..color = _P.water1.withAlpha(120),
    );
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        top + Offset(10 + i * 12.0, 74 + math.sin(time * 4 + i) * 2),
        2,
        Paint()..color = Colors.white.withAlpha(140),
      );
    }
  }

  void _drawRuinedArch(Canvas canvas, Offset base) {
    canvas.drawRect(
      Rect.fromLTWH(base.dx, base.dy + 28, 14, 36),
      Paint()..color = _P.stone2,
    );
    canvas.drawRect(
      Rect.fromLTWH(base.dx + 46, base.dy + 28, 14, 36),
      Paint()..color = _P.stone2,
    );
    canvas.drawArc(
      Rect.fromLTWH(base.dx, base.dy, 60, 44),
      math.pi,
      math.pi,
      false,
      Paint()..color = _P.stone1..strokeWidth = 10,
    );
    canvas.drawLine(
      base + const Offset(8, 20),
      base + const Offset(52, 36),
      Paint()..color = _P.stone3.withAlpha(100)..strokeWidth = 2,
    );
    canvas.drawCircle(
      base + const Offset(30, 18),
      3,
      Paint()..color = _P.moss.withAlpha(160),
    );
  }

  void _drawCampfire(Canvas canvas, Offset center) {
    final flicker = 0.7 + math.sin(time * 8) * 0.3;
    for (final dx in [-8.0, 0.0, 8.0]) {
      canvas.drawRect(
        Rect.fromCenter(
          center: center + Offset(dx, 14),
          width: 6,
          height: 16,
        ),
        Paint()..color = _P.wood3,
      );
    }
    canvas.drawCircle(
      center + const Offset(0, 4),
      14 * flicker,
      Paint()..color = _P.torchGlow.withAlpha(40),
    );
    final flamePath = Path()
      ..moveTo(center.dx - 6, center.dy + 4)
      ..quadraticBezierTo(center.dx, center.dy - 18 * flicker, center.dx + 6, center.dy + 4)
      ..close();
    canvas.drawPath(flamePath, Paint()..color = _P.torchFlame);
    canvas.drawPath(
      flamePath.shift(const Offset(0, -2)),
      Paint()..color = const Color(0xFFFFEE88).withAlpha(180),
    );
  }

  void _drawBeacon(Canvas canvas, Offset base) {
    canvas.drawRect(
      Rect.fromLTWH(base.dx, base.dy + 12, 12, 28),
      Paint()..color = _P.stone2,
    );
    canvas.drawRect(
      Rect.fromLTWH(base.dx - 2, base.dy, 16, 14),
      Paint()..color = _P.wood2,
    );
    final pulse = 0.6 + math.sin(time * 5) * 0.4;
    canvas.drawCircle(
      base + const Offset(6, 6),
      10 * pulse,
      Paint()..color = const Color(0xFFFFAA44).withAlpha(50),
    );
    canvas.drawCircle(
      base + const Offset(6, 6),
      4,
      Paint()..color = const Color(0xFFFFDD66),
    );
  }

  void _drawShrineCircle(Canvas canvas, Offset center) {
    for (var i = 0; i < 5; i++) {
      final a = i * math.pi * 2 / 5 - math.pi / 2;
      final p = center + Offset(math.cos(a) * 22, math.sin(a) * 14);
      canvas.drawRect(
        Rect.fromCenter(center: p, width: 8, height: 14),
        Paint()..color = _P.stone2,
      );
      canvas.drawCircle(
        p + const Offset(0, -6),
        2,
        Paint()..color = _P.gold1.withAlpha(140),
      );
    }
    canvas.drawCircle(
      center,
      6,
      Paint()..color = _P.gold1.withAlpha(100),
    );
    canvas.drawCircle(
      center,
      6,
      Paint()
        ..color = _P.gold2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(WorldLandmarksPainter old) => old.time != time;
}

// ── Building painters ─────────────────────────────────────────────────────────

class BuildingPainter extends CustomPainter {
  final BuildingKind kind;
  final bool locked;
  final bool completed;
  final double time;

  const BuildingPainter({
    required this.kind,
    required this.locked,
    required this.completed,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (locked) {
      canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = Colors.white.withAlpha(locked ? 0 : 255));
    }

    switch (kind) {
      case BuildingKind.cottage:
        _paintCottage(canvas, size);
      case BuildingKind.vault:
        _paintVault(canvas, size);
      case BuildingKind.bank:
        _paintBank(canvas, size);
      case BuildingKind.shop:
        _paintShop(canvas, size);
      case BuildingKind.tower:
        _paintTower(canvas, size);
    }

    if (locked) {
      canvas.restore();
      // Desaturate overlay
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.grey.withAlpha(100),
      );
      // Chain
      _paintLock(canvas, size);
    }

    if (completed) {
      _paintCompletedGlow(canvas, size);
    }
  }

  void _paintCottage(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h - 4), width: w * 0.8, height: 14),
      Paint()..color = _P.shadow,
    );

    // Foundation
    canvas.drawRect(
      Rect.fromLTWH(8, h - 28, w - 16, 10),
      Paint()..color = _P.stone2,
    );

    // Walls
    canvas.drawRect(
      Rect.fromLTWH(12, h - 78, w - 24, 52),
      Paint()..color = _P.wood1,
    );
    // Planks
    for (double y = h - 74; y < h - 30; y += 8) {
      canvas.drawLine(
        Offset(12, y),
        Offset(w - 12, y),
        Paint()..color = _P.wood2.withAlpha(80)..strokeWidth = 1,
      );
    }

    // Door
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 14, h - 42, 28, 36),
      Paint()..color = _P.wood3,
    );
    canvas.drawCircle(
      Offset(w / 2 + 8, h - 24),
      3,
      Paint()..color = _P.gold1,
    );

    // Windows
    for (final dx in [22.0, w - 38.0]) {
      canvas.drawRect(
        Rect.fromLTWH(dx, h - 62, 16, 16),
        Paint()..color = const Color(0xFF88CCFF),
      );
      canvas.drawLine(
        Offset(dx + 8, h - 62),
        Offset(dx + 8, h - 46),
        Paint()..color = _P.wood3..strokeWidth = 1.5,
      );
      canvas.drawLine(
        Offset(dx, h - 54),
        Offset(dx + 16, h - 54),
        Paint()..color = _P.wood3..strokeWidth = 1.5,
      );
    }

    // Roof
    final roof = Path()
      ..moveTo(w / 2, h - 108)
      ..lineTo(w - 6, h - 72)
      ..lineTo(6, h - 72)
      ..close();
    canvas.drawPath(roof, Paint()..color = _P.roof1);
    // Shingles
    for (double y = h - 100; y < h - 74; y += 6) {
      canvas.drawLine(
        Offset(14 + (y - h + 100) * 0.3, y),
        Offset(w - 14 - (y - h + 100) * 0.3, y),
        Paint()..color = _P.roof2.withAlpha(80)..strokeWidth = 1,
      );
    }

    // Chimney
    canvas.drawRect(
      Rect.fromLTWH(w - 28, h - 100, 12, 24),
      Paint()..color = _P.stone2,
    );
    // Smoke puffs
    final smokePhase = time % 3;
    for (int i = 0; i < 3; i++) {
      final t = (smokePhase + i * 0.8) % 3 / 3;
      canvas.drawCircle(
        Offset(w - 22 + t * 8, h - 108 - t * 20),
        4 + t * 6,
        Paint()..color = Colors.white.withAlpha((80 * (1 - t)).round()),
      );
    }
  }

  void _paintVault(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h - 4), width: w * 0.85, height: 14),
      Paint()..color = _P.shadow,
    );

    // Stone base
    canvas.drawRect(
      Rect.fromLTWH(6, h - 32, w - 12, 14),
      Paint()..color = _P.stone3,
    );
    canvas.drawRect(
      Rect.fromLTWH(10, h - 70, w - 20, 42),
      Paint()..color = _P.stone1,
    );
    // Stone blocks
    for (double y = h - 68; y < h - 32; y += 10) {
      for (double x = 12; x < w - 12; x += 14) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, 12, 8),
          Paint()
            ..color = _P.stone2.withAlpha(60)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    // Dome
    canvas.drawArc(
      Rect.fromLTWH(8, h - 108, w - 16, 52),
      math.pi,
      math.pi,
      true,
      Paint()..color = _P.stone2,
    );

    // Shield emblem
    final shield = Path()
      ..moveTo(w / 2, h - 88)
      ..lineTo(w / 2 + 18, h - 72)
      ..lineTo(w / 2 + 14, h - 52)
      ..lineTo(w / 2, h - 46)
      ..lineTo(w / 2 - 14, h - 52)
      ..lineTo(w / 2 - 18, h - 72)
      ..close();
    canvas.drawPath(shield, Paint()..color = const Color(0xFF4A90A4));
    canvas.drawPath(
      shield,
      Paint()
        ..color = _P.gold1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Cross on shield
    canvas.drawLine(
      Offset(w / 2, h - 84),
      Offset(w / 2, h - 50),
      Paint()..color = _P.gold1..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(w / 2 - 8, h - 68),
      Offset(w / 2 + 8, h - 68),
      Paint()..color = _P.gold1..strokeWidth = 2,
    );

    // Door (arched)
    canvas.drawArc(
      Rect.fromLTWH(w / 2 - 16, h - 48, 32, 32),
      0,
      math.pi,
      true,
      Paint()..color = _P.stone3,
    );
  }

  void _paintBank(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h - 4), width: w * 0.9, height: 14),
      Paint()..color = _P.shadow,
    );

    // Steps
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(8 + i * 4.0, h - 18 - i * 6.0, w - 16 - i * 8, 6),
        Paint()..color = _P.stone1,
      );
    }

    // Main body
    canvas.drawRect(
      Rect.fromLTWH(10, h - 80, w - 20, 52),
      Paint()..color = const Color(0xFFE8E0D0),
    );

    // Columns
    for (final dx in [20.0, w / 2 - 8, w - 36.0]) {
      canvas.drawRect(
        Rect.fromLTWH(dx, h - 76, 16, 44),
        Paint()..color = _P.stone1,
      );
      canvas.drawRect(
        Rect.fromLTWH(dx - 2, h - 80, 20, 6),
        Paint()..color = _P.stone2,
      );
    }

    // Pediment
    final ped = Path()
      ..moveTo(6, h - 80)
      ..lineTo(w / 2, h - 108)
      ..lineTo(w - 6, h - 80)
      ..close();
    canvas.drawPath(ped, Paint()..color = _P.stone2);

    // Coin symbol on pediment
    canvas.drawCircle(
      Offset(w / 2, h - 92),
      10,
      Paint()..color = _P.gold1,
    );
    canvas.drawCircle(
      Offset(w / 2, h - 92),
      10,
      Paint()
        ..color = _P.gold2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(color: _P.gold2, fontSize: 12, fontWeight: FontWeight.w900),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(w / 2 - tp.width / 2, h - 98));
  }

  void _paintShop(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h - 4), width: w * 0.85, height: 14),
      Paint()..color = _P.shadow,
    );

    // Base
    canvas.drawRect(
      Rect.fromLTWH(10, h - 36, w - 20, 12),
      Paint()..color = _P.stone2,
    );
    canvas.drawRect(
      Rect.fromLTWH(12, h - 68, w - 24, 36),
      Paint()..color = _P.wood1,
    );

    // Awning stripes
    const stripeW = 12.0;
    for (int i = 0; i < ((w - 16) / stripeW).ceil(); i++) {
      final awningPath = Path()
        ..moveTo(8 + i * stripeW, h - 68)
        ..lineTo(8 + i * stripeW + stripeW / 2, h - 88)
        ..lineTo(8 + (i + 1) * stripeW, h - 68)
        ..close();
      canvas.drawPath(
        awningPath,
        Paint()..color = i.isEven ? const Color(0xFFE07050) : Colors.white,
      );
    }

    // Counter window
    canvas.drawRect(
      Rect.fromLTWH(16, h - 58, w - 32, 18),
      Paint()..color = const Color(0xFF88CCFF).withAlpha(180),
    );

    // Coffee cup sign
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 10, h - 52, 20, 14),
      Paint()..color = Colors.white,
    );
    canvas.drawArc(
      Rect.fromLTWH(w / 2 + 8, h - 50, 8, 10),
      -math.pi / 2,
      math.pi,
      false,
      Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke,
    );

    // Door
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 12, h - 38, 24, 26),
      Paint()..color = _P.wood3,
    );
  }

  void _paintTower(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h - 4), width: w * 0.7, height: 14),
      Paint()..color = _P.shadow,
    );

    // Tower body (circular-ish)
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 28, h - 90, 56, 72),
      Paint()..color = _P.stone1,
    );
    canvas.drawArc(
      Rect.fromLTWH(w / 2 - 28, h - 118, 56, 40),
      math.pi,
      math.pi,
      true,
      Paint()..color = _P.stone2,
    );

    // Bricks
    for (double y = h - 88; y < h - 22; y += 12) {
      for (double x = w / 2 - 24; x < w / 2 + 24; x += 16) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, 14, 10),
          Paint()
            ..color = _P.stone3.withAlpha(40)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }

    // Golden top
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - 8, h - 128, 16, 16),
      Paint()..color = _P.gold1,
    );
    canvas.drawCircle(
      Offset(w / 2, h - 136),
      6,
      Paint()..color = _P.gold2,
    );

    // Flag
    final flagWave = math.sin(time * 4) * 4;
    canvas.drawLine(
      Offset(w / 2, h - 142),
      Offset(w / 2, h - 122),
      Paint()..color = _P.wood3..strokeWidth = 2,
    );
    canvas.drawRect(
      Rect.fromLTWH(w / 2, h - 140 + flagWave * 0.2, 18 + flagWave, 10),
      Paint()..color = const Color(0xFFE04040),
    );

    // Trophy emblem
    canvas.drawCircle(
      Offset(w / 2, h - 60),
      12,
      Paint()..color = _P.gold1,
    );
    canvas.drawCircle(
      Offset(w / 2, h - 60),
      12,
      Paint()
        ..color = _P.gold2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _paintLock(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2 - 10),
      18,
      Paint()..color = _P.stone3,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2 - 10),
      18,
      Paint()
        ..color = _P.gold1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Lock body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2 + 2), width: 16, height: 14),
        const Radius.circular(3),
      ),
      Paint()..color = _P.gold1,
    );
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 - 4), width: 12, height: 12),
      math.pi,
      math.pi,
      false,
      Paint()..color = _P.gold1..strokeWidth = 3..style = PaintingStyle.stroke,
    );
  }

  void _paintCompletedGlow(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.55,
      Paint()
        ..color = const Color(0xFF7ED957).withAlpha(30 + (math.sin(time * 3) * 15).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    // Star badge
    canvas.drawCircle(
      Offset(size.width - 12, 12),
      12,
      Paint()..color = const Color(0xFF7ED957),
    );
    final star = Path();
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / 5;
      final pt = Offset(
        size.width - 12 + math.cos(angle) * 7,
        12 + math.sin(angle) * 7,
      );
      i == 0 ? star.moveTo(pt.dx, pt.dy) : star.lineTo(pt.dx, pt.dy);
    }
    star.close();
    canvas.drawPath(star, Paint()..color = _P.gold1);
  }

  @override
  bool shouldRepaint(BuildingPainter old) =>
      old.locked != locked ||
      old.completed != completed ||
      old.time != time ||
      old.kind != kind;
}

// ── Rustic gate (vertical + vallas) ───────────────────────────────────────────

class RusticGatePainter extends CustomPainter {
  final bool isOpen;
  final double openProgress;
  final double time;

  const RusticGatePainter({
    required this.isOpen,
    required this.openProgress,
    this.time = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final slide = openProgress * h * 0.45;
    final flicker = math.sin(time * 9) * 0.5 + 0.5;

    // Valla superior
    _fenceRail(canvas, Rect.fromLTWH(0, 4, w, 14));
    for (var i = 0; i < 5; i++) {
      _fencePost(canvas, Offset(8 + i * (w - 16) / 4, 10));
    }

    // Valla inferior
    _fenceRail(canvas, Rect.fromLTWH(0, h - 18, w, 14));
    for (var i = 0; i < 5; i++) {
      _fencePost(canvas, Offset(8 + i * (w - 16) / 4, h - 12));
    }

    // Postes del marco de la puerta
    canvas.drawRect(
      Rect.fromLTWH(10, 22, 10, h - 44),
      Paint()..color = _P.wood3,
    );
    canvas.drawRect(
      Rect.fromLTWH(w - 20, 22, 10, h - 44),
      Paint()..color = _P.wood3,
    );

    // Arco de madera
    canvas.drawArc(
      Rect.fromLTWH(8, 18, w - 16, 32),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = _P.wood2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Puerta de madera (sube al abrir)
    if (openProgress < 0.95) {
      final doorTop = h * 0.42 - slide;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(22, doorTop, w - 44, h * 0.38),
          const Radius.circular(3),
        ),
        Paint()..color = _P.wood1,
      );
      for (var y = doorTop + 8; y < doorTop + h * 0.38 - 4; y += 10) {
        canvas.drawLine(
          Offset(26, y),
          Offset(w - 26, y),
          Paint()..color = _P.wood3.withAlpha(90)..strokeWidth = 1,
        );
      }
      // Cerrojo
      canvas.drawCircle(
        Offset(cx, doorTop + h * 0.2),
        4,
        Paint()..color = _P.iron1,
      );
    }

    // Candado / brillo
    if (!isOpen || openProgress < 0.35) {
      canvas.drawCircle(
        Offset(cx, h * 0.55),
        10 + flicker * 2,
        Paint()..color = _P.gold1.withAlpha((60 + flicker * 40).round()),
      );
      canvas.drawCircle(
        Offset(cx, h * 0.55),
        5,
        Paint()..color = _P.gold2,
      );
    } else {
      canvas.drawCircle(
        Offset(cx, h * 0.5),
        8 * openProgress,
        Paint()..color = const Color(0xFF7ED957).withAlpha(100),
      );
    }
  }

  void _fenceRail(Canvas canvas, Rect r) {
    canvas.drawRect(r, Paint()..color = _P.wood2);
    canvas.drawRect(
      r,
      Paint()
        ..color = _P.wood3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _fencePost(Canvas canvas, Offset base) {
    canvas.drawRect(
      Rect.fromCenter(center: base, width: 5, height: 16),
      Paint()..color = _P.wood3,
    );
    canvas.drawRect(
      Rect.fromCenter(center: base + const Offset(0, -6), width: 7, height: 3),
      Paint()..color = _P.wood1,
    );
  }

  @override
  bool shouldRepaint(RusticGatePainter old) =>
      old.isOpen != isOpen ||
      old.openProgress != openProgress ||
      old.time != time;
}

// ── Epic gate barrier ─────────────────────────────────────────────────────────

class StoneGatePainter extends CustomPainter {
  final bool isOpen;
  final double openProgress;
  final bool vertical;
  final double time;

  const StoneGatePainter({
    required this.isOpen,
    required this.openProgress,
    this.vertical = false,
    this.time = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final slide = openProgress * (vertical ? h * 0.55 : w * 0.38);
    final pulse = math.sin(time * 5) * 0.5 + 0.5;
    final flicker = math.sin(time * 12) * 2;

    // Sombra en el suelo
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, h - 2), width: w * 0.95, height: 14),
      Paint()..color = _P.shadow,
    );

    // Base de piedra (platform)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, h - 14, w - 4, 12),
        const Radius.circular(2),
      ),
      Paint()..color = _P.stone3,
    );
    for (double x = 6; x < w - 6; x += 14) {
      canvas.drawLine(
        Offset(x, h - 14),
        Offset(x, h - 2),
        Paint()..color = _P.stone2.withAlpha(80)..strokeWidth = 0.8,
      );
    }

    if (vertical) {
      _paintVerticalGate(canvas, w, h, cx, slide, pulse, flicker);
    } else {
      _paintHorizontalGate(canvas, w, h, cx, slide, pulse, flicker);
    }
  }

  void _paintHorizontalGate(
    Canvas canvas, double w, double h, double cx, double slide, double pulse, double flicker) {
    // Pilares monumentales
    _drawMonumentPillar(canvas, Rect.fromLTWH(4, 8, 22, h - 20), flicker, isOpen);
    _drawMonumentPillar(canvas, Rect.fromLTWH(w - 26, 8, 22, h - 20), flicker, isOpen);

    // Arco de piedra
    final archPath = Path()
      ..moveTo(26, h - 18)
      ..quadraticBezierTo(cx, 2, w - 26, h - 18);
    canvas.drawPath(
      archPath,
      Paint()
        ..color = _P.stone2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      archPath,
      Paint()
        ..color = _P.stone1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    // Keystone (piedra angular central)
    canvas.drawPath(
      Path()
        ..moveTo(cx - 10, 14)
        ..lineTo(cx, 4)
        ..lineTo(cx + 10, 14)
        ..close(),
      Paint()..color = _P.stone1,
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx - 10, 14)
        ..lineTo(cx, 4)
        ..lineTo(cx + 10, 14)
        ..close(),
      Paint()
        ..color = _P.gold2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Emblema en keystone
    canvas.drawCircle(Offset(cx, 10), 4, Paint()..color = _P.gold1);

    // Reja de hierro (portón doble)
    if (openProgress < 0.95) {
      _drawIronGatePanel(canvas, Rect.fromLTWH(28 - slide, 20, w / 2 - 32, h - 34));
      _drawIronGatePanel(canvas, Rect.fromLTWH(w / 2 + slide, 20, w / 2 - 32, h - 34));
    }

    // Sello mágico o luz sagrada
    if (!isOpen || openProgress < 0.4) {
      _drawMagicSeal(canvas, Offset(cx, h * 0.52), 20, pulse);
    } else {
      _drawHolyLight(canvas, Offset(cx, h * 0.5), openProgress);
    }

    // Cadenas colgando cuando cerrado
    if (openProgress < 0.3) {
      _drawChain(canvas, Offset(32, 22), Offset(32, h - 24));
      _drawChain(canvas, Offset(w - 32, 22), Offset(w - 32, h - 24));
    }
  }

  void _paintVerticalGate(
    Canvas canvas, double w, double h, double cx, double slide, double pulse, double flicker) {
    _drawMonumentPillar(canvas, Rect.fromLTWH(6, 6, 18, h - 16), flicker, isOpen);
    _drawMonumentPillar(canvas, Rect.fromLTWH(w - 24, 6, 18, h - 16), flicker, isOpen);

    // Arco vertical (más estrecho)
    canvas.drawArc(
      Rect.fromLTWH(10, 4, w - 20, 36),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = _P.stone2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    );

    // Reja que sube
    if (openProgress < 0.95) {
      _drawIronGatePanel(
        canvas,
        Rect.fromLTWH(26, h / 2 - 20 - slide, w - 52, 38),
      );
    }

    if (!isOpen || openProgress < 0.4) {
      _drawMagicSeal(canvas, Offset(cx, h * 0.55), 18, pulse);
    } else {
      _drawHolyLight(canvas, Offset(cx, h * 0.5), openProgress);
    }

    if (openProgress < 0.3) {
      _drawChain(canvas, Offset(18, 40), Offset(18, h - 20));
      _drawChain(canvas, Offset(w - 18, 40), Offset(w - 18, h - 20));
    }
  }

  void _drawMonumentPillar(Canvas canvas, Rect r, double flicker, bool lit) {
    // Cuerpo del pilar
    canvas.drawRect(r, Paint()..color = _P.stone2);
    // Bloques de piedra
    for (double y = r.top + 4; y < r.bottom - 4; y += 10) {
      canvas.drawLine(
        Offset(r.left, y),
        Offset(r.right, y),
        Paint()..color = _P.stone3.withAlpha(70)..strokeWidth = 1,
      );
    }
    // Musgo
    canvas.drawRect(
      Rect.fromLTWH(r.left, r.bottom - 14, r.width, 10),
      Paint()..color = _P.moss.withAlpha(100),
    );
    // Capitel
    canvas.drawRect(
      Rect.fromLTWH(r.left - 3, r.top, r.width + 6, 8),
      Paint()..color = _P.stone1,
    );
    canvas.drawRect(
      Rect.fromLTWH(r.left - 5, r.top - 4, r.width + 10, 6),
      Paint()..color = _P.stone1,
    );

    // Antorcha
    final torchX = r.center.dx;
    final torchY = r.top + 16;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(torchX, torchY + 8), width: 6, height: 10),
      Paint()..color = _P.iron1,
    );
    final flameColor = lit ? const Color(0xFF7ED957) : _P.torchFlame;
    // Glow
    canvas.drawCircle(
      Offset(torchX, torchY + flicker),
      10,
      Paint()
        ..color = flameColor.withAlpha(50)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Flame layers
    canvas.drawCircle(Offset(torchX, torchY + flicker), 5, Paint()..color = flameColor);
    canvas.drawCircle(
      Offset(torchX, torchY - 2 + flicker),
      3,
      Paint()..color = Colors.white.withAlpha(200),
    );
  }

  void _drawIronGatePanel(Canvas canvas, Rect r) {
    if (r.width <= 0 || r.height <= 0) return;
    // Marco
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(2)),
      Paint()..color = _P.iron1,
    );
    // Barrotes verticales
    for (double x = r.left + 6; x < r.right - 4; x += 7) {
      canvas.drawLine(
        Offset(x, r.top + 4),
        Offset(x, r.bottom - 4),
        Paint()..color = _P.iron2..strokeWidth = 2.5,
      );
    }
    // Barrotes horizontales (punta de lanza)
    for (double y = r.top + 8; y < r.bottom - 4; y += 12) {
      canvas.drawLine(
        Offset(r.left + 4, y),
        Offset(r.right - 4, y),
        Paint()..color = _P.iron2.withAlpha(180)..strokeWidth = 1.5,
      );
    }
    // Púas superiores
    for (double x = r.left + 8; x < r.right - 4; x += 14) {
      final spike = Path()
        ..moveTo(x, r.top + 2)
        ..lineTo(x + 4, r.top - 4)
        ..lineTo(x + 8, r.top + 2)
        ..close();
      canvas.drawPath(spike, Paint()..color = _P.iron2);
    }
  }

  void _drawMagicSeal(Canvas canvas, Offset center, double r, double pulse) {
    // Aura púrpura pulsante
    canvas.drawCircle(
      center,
      r + 8 + pulse * 6,
      Paint()
        ..color = _P.magic1.withAlpha((40 + pulse * 40).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Círculo exterior
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = _P.magic2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      center,
      r - 4,
      Paint()
        ..color = _P.gold1.withAlpha(180)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Runas (cruz + puntos cardinales)
    canvas.drawLine(
      Offset(center.dx, center.dy - r + 4),
      Offset(center.dx, center.dy + r - 4),
      Paint()..color = _P.gold1..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(center.dx - r + 4, center.dy),
      Offset(center.dx + r - 4, center.dy),
      Paint()..color = _P.gold1..strokeWidth = 2,
    );
    // Candado central
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center + const Offset(0, 2), width: 12, height: 10),
        const Radius.circular(2),
      ),
      Paint()..color = _P.gold1,
    );
    canvas.drawArc(
      Rect.fromCenter(center: center + const Offset(0, -4), width: 10, height: 10),
      math.pi,
      math.pi,
      false,
      Paint()..color = _P.gold1..strokeWidth = 2.5..style = PaintingStyle.stroke,
    );
    // Destellos en las runas
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2 + time * 2;
      canvas.drawCircle(
        center + Offset(math.cos(a) * (r - 2), math.sin(a) * (r - 2)),
        2,
        Paint()..color = _P.gold1.withAlpha((150 + pulse * 100).round()),
      );
    }
  }

  void _drawHolyLight(Canvas canvas, Offset center, double progress) {
    final alpha = ((progress - 0.3) / 0.7 * 255).clamp(0, 255).round();
    // Rayos de luz
    canvas.drawCircle(
      center,
      28 * progress,
      Paint()
        ..color = _P.gold1.withAlpha(alpha ~/ 3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    for (int i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      canvas.drawLine(
        center,
        center + Offset(math.cos(a) * 30 * progress, math.sin(a) * 30 * progress),
        Paint()
          ..color = _P.gold1.withAlpha(alpha ~/ 2)
          ..strokeWidth = 2,
      );
    }
    // Partículas doradas
    for (int i = 0; i < 8; i++) {
      final a = i * 0.8 + time * 3;
      canvas.drawCircle(
        center + Offset(math.cos(a) * 16 * progress, math.sin(a) * 12 * progress),
        2,
        Paint()..color = _P.gold1.withAlpha(alpha),
      );
    }
  }

  void _drawChain(Canvas canvas, Offset from, Offset to) {
    final links = ((to.dy - from.dy) / 8).ceil();
    for (int i = 0; i < links; i++) {
      final y = from.dy + i * 8.0;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(from.dx, y), width: 6, height: 8),
        0,
        math.pi,
        false,
        Paint()..color = _P.iron2..strokeWidth = 2..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(StoneGatePainter old) =>
      old.isOpen != isOpen ||
      old.openProgress != openProgress ||
      old.time != time;
}

// ── Hero character (Link-inspired adventurer) ─────────────────────────────────

/// Sprite lógico 56×64 px — aventurero con capa verde, mucho más detalle.
class HeroPainter extends CustomPainter {
  final Facing facing;
  final int walkFrame;
  final bool walking;

  const HeroPainter({
    required this.facing,
    required this.walkFrame,
    required this.walking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final footY = size.height - 4;

    // Sombra suave
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, footY + 2), width: 34, height: 10),
      Paint()..color = _P.shadow,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, footY + 1), width: 26, height: 6),
      Paint()..color = Colors.black.withAlpha(25),
    );

    final anim = _WalkAnim.fromFrame(walkFrame, walking);

    switch (facing) {
      case Facing.down:
        _drawFront(canvas, cx, footY, anim);
      case Facing.up:
        _drawBack(canvas, cx, footY, anim);
      case Facing.left:
        _drawSide(canvas, cx, footY, anim, flip: true);
      case Facing.right:
        _drawSide(canvas, cx, footY, anim, flip: false);
    }
  }

  // ── FRONT ─────────────────────────────────────────────────────────────────

  void _drawFront(Canvas canvas, double cx, double footY, _WalkAnim a) {
    // Piernas / pantalones
    _drawLegFront(canvas, cx - 7, footY - 2 + a.legL, flip: false);
    _drawLegFront(canvas, cx + 7, footY - 2 + a.legR, flip: false);

    // Capa / túnica (cuerpo)
    final bodyPath = Path()
      ..moveTo(cx - 14, footY - 18)
      ..lineTo(cx - 16, footY - 34)
      ..lineTo(cx - 6, footY - 40)
      ..lineTo(cx, footY - 42)
      ..lineTo(cx + 6, footY - 40)
      ..lineTo(cx + 16, footY - 34)
      ..lineTo(cx + 14, footY - 18)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = _P.heroGreen);
    // Sombreado lateral
    canvas.drawPath(
      Path()
        ..moveTo(cx - 14, footY - 18)
        ..lineTo(cx - 16, footY - 34)
        ..lineTo(cx - 6, footY - 40)
        ..lineTo(cx, footY - 42)
        ..lineTo(cx, footY - 18)
        ..close(),
      Paint()..color = _P.heroGreenDark.withAlpha(90),
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx + 14, footY - 18)
        ..lineTo(cx + 16, footY - 34)
        ..lineTo(cx + 6, footY - 40)
        ..lineTo(cx, footY - 42)
        ..lineTo(cx, footY - 18)
        ..close(),
      Paint()..color = _P.heroGreenLight.withAlpha(50),
    );
    // Cuello en V
    canvas.drawPath(
      Path()
        ..moveTo(cx - 5, footY - 40)
        ..lineTo(cx, footY - 36)
        ..lineTo(cx + 5, footY - 40)
        ..close(),
      Paint()..color = _P.heroGreenLight,
    );

    // Cinturón
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, footY - 26), width: 20, height: 5),
      Paint()..color = _P.heroBelt,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, footY - 26), width: 6, height: 5),
      Paint()..color = _P.heroGold,
    );

    // Brazos
    _drawArmFront(canvas, cx - 18 + a.armL, footY - 30, swing: a.armL);
    _drawArmFront(canvas, cx + 18 + a.armR, footY - 30, swing: a.armR, mirror: true);

    // Espada en la espalda (visible sobre el hombro)
    _drawSwordBack(canvas, cx + 10, footY - 38);

    // Cabeza
    _drawHeadFront(canvas, cx, footY - 48);
  }

  void _drawLegFront(Canvas canvas, double cx, double footY, {required bool flip}) {
    // Pantalón
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, footY - 10), width: 9, height: 14),
        const Radius.circular(3),
      ),
      Paint()..color = _P.heroPants,
    );
    // Bota
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 6, footY - 8, 12, 9),
        const Radius.circular(2),
      ),
      Paint()..color = _P.heroBoot,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - 6, footY - 2, 12, 3),
      Paint()..color = _P.heroBootHi,
    );
    // Suela
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 7, footY - 1, 14, 3),
        const Radius.circular(1),
      ),
      Paint()..color = _P.stone3,
    );
  }

  void _drawArmFront(Canvas canvas, double cx, double cy, {required double swing, bool mirror = false}) {
    final dir = mirror ? 1.0 : -1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + swing * 0.3), width: 8, height: 14),
        const Radius.circular(3),
      ),
      Paint()..color = _P.heroGreen,
    );
    // Mano
    canvas.drawCircle(
      Offset(cx + dir * 1, cy + 8 + swing * 0.5),
      4,
      Paint()..color = _P.heroSkin,
    );
    canvas.drawCircle(
      Offset(cx + dir * 1, cy + 8 + swing * 0.5),
      4,
      Paint()..color = _P.heroSkinShadow.withAlpha(60)..style = PaintingStyle.stroke..strokeWidth = 1,
    );
  }

  void _drawHeadFront(Canvas canvas, double cx, double cy) {
    // Orejas
    canvas.drawCircle(Offset(cx - 11, cy + 1), 3, Paint()..color = _P.heroSkin);
    canvas.drawCircle(Offset(cx + 11, cy + 1), 3, Paint()..color = _P.heroSkin);

    // Cara
    canvas.drawCircle(Offset(cx, cy), 11, Paint()..color = _P.heroSkin);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy + 2), radius: 11),
      0.2, math.pi - 0.4, false,
      Paint()..color = _P.heroSkinShadow.withAlpha(50)..style = PaintingStyle.stroke..strokeWidth = 3,
    );

    // Pelo (mechones laterales)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy - 2), radius: 10),
      math.pi + 0.3, math.pi - 0.6, false,
      Paint()..color = _P.heroHair..strokeWidth = 5..style = PaintingStyle.stroke,
    );

    // Gorra — parte trasera puntiaguda
    canvas.drawPath(
      Path()
        ..moveTo(cx - 12, cy - 4)
        ..lineTo(cx - 10, cy - 14)
        ..lineTo(cx, cy - 20)
        ..lineTo(cx + 10, cy - 14)
        ..lineTo(cx + 12, cy - 4)
        ..close(),
      Paint()..color = _P.heroCap,
    );
    // Visera / ala frontal
    canvas.drawPath(
      Path()
        ..moveTo(cx - 14, cy - 2)
        ..lineTo(cx + 14, cy - 2)
        ..lineTo(cx + 10, cy + 4)
        ..lineTo(cx - 10, cy + 4)
        ..close(),
      Paint()..color = _P.heroCapDark,
    );
    // Brillo en gorra
    canvas.drawCircle(Offset(cx - 4, cy - 10), 2, Paint()..color = _P.heroGreenLight.withAlpha(80));

    // Ojos
    _drawEye(canvas, cx - 5, cy - 1);
    _drawEye(canvas, cx + 5, cy - 1);

    // Nariz y boca
    canvas.drawCircle(Offset(cx, cy + 3), 1.5, Paint()..color = _P.heroSkinShadow.withAlpha(100));
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + 5), width: 6, height: 3),
      0.1, math.pi - 0.2, false,
      Paint()..color = _P.heroSkinShadow..strokeWidth = 1..style = PaintingStyle.stroke,
    );
  }

  void _drawEye(Canvas canvas, double x, double y) {
    canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(x, y + 0.5), 2, Paint()..color = const Color(0xFF2244AA));
    canvas.drawCircle(Offset(x, y + 0.5), 1, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(x + 0.8, y - 0.5), 0.6, Paint()..color = Colors.white);
    // Cejas
    canvas.drawLine(
      Offset(x - 3, y - 4),
      Offset(x + 3, y - 3),
      Paint()..color = _P.heroHair..strokeWidth = 1.5..strokeCap = StrokeCap.round,
    );
  }

  void _drawSwordBack(Canvas canvas, double cx, double cy) {
    // Hoja
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy - 8), width: 4, height: 22),
      Paint()..color = _P.stone1,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx - 1, cy - 8), width: 1, height: 20),
      Paint()..color = Colors.white.withAlpha(100),
    );
    // Guarda
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + 4), width: 10, height: 3),
      Paint()..color = _P.heroGold,
    );
    // Empuñadura
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + 8), width: 4, height: 6),
      Paint()..color = _P.heroBoot,
    );
    canvas.drawCircle(Offset(cx, cy + 12), 2, Paint()..color = _P.heroGold);
  }

  // ── BACK ──────────────────────────────────────────────────────────────────

  void _drawBack(Canvas canvas, double cx, double footY, _WalkAnim a) {
    _drawLegFront(canvas, cx - 7, footY - 2 + a.legL, flip: false);
    _drawLegFront(canvas, cx + 7, footY - 2 + a.legR, flip: false);

    // Capa / espalda túnica
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, footY - 28), width: 28, height: 26),
        const Radius.circular(6),
      ),
      Paint()..color = _P.heroGreenDark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, footY - 28), width: 22, height: 20),
        const Radius.circular(4),
      ),
      Paint()..color = _P.heroGreen,
    );
    // Capa baja (dobladillo)
    canvas.drawPath(
      Path()
        ..moveTo(cx - 14, footY - 18)
        ..lineTo(cx - 16, footY - 14)
        ..lineTo(cx, footY - 12)
        ..lineTo(cx + 16, footY - 14)
        ..lineTo(cx + 14, footY - 18)
        ..close(),
      Paint()..color = _P.heroGreenDark,
    );

    // Espada completa en espalda
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx + 4, footY - 32), width: 5, height: 28),
      Paint()..color = _P.stone2,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx + 4, footY - 14), width: 12, height: 3),
      Paint()..color = _P.heroGold,
    );

    // Gorra vista trasera
    canvas.drawPath(
      Path()
        ..moveTo(cx - 12, footY - 44)
        ..lineTo(cx, footY - 58)
        ..lineTo(cx + 12, footY - 44)
        ..close(),
      Paint()..color = _P.heroCap,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, footY - 46), width: 22, height: 10),
      Paint()..color = _P.heroCapDark,
    );
    // Cola de capa/gorra
    canvas.drawPath(
      Path()
        ..moveTo(cx - 4, footY - 56)
        ..lineTo(cx, footY - 62)
        ..lineTo(cx + 4, footY - 56)
        ..close(),
      Paint()..color = _P.heroCapDark,
    );
  }

  // ── SIDE ──────────────────────────────────────────────────────────────────

  void _drawSide(Canvas canvas, double cx, double footY, _WalkAnim a, {required bool flip}) {
    final dir = flip ? -1.0 : 1.0;

    // Pierna trasera
    _drawLegSide(canvas, cx - dir * 3, footY - 2 - a.legL * 0.3, depth: true);
    // Cuerpo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, footY - 28), width: 16, height: 24),
        const Radius.circular(5),
      ),
      Paint()..color = flip ? _P.heroGreenDark : _P.heroGreen,
    );
    // Cinturón lateral
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, footY - 24), width: 14, height: 4),
      Paint()..color = _P.heroBelt,
    );
    // Brazo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + dir * 10 + a.armR, footY - 30),
          width: 7,
          height: 13,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = _P.heroGreen,
    );
    canvas.drawCircle(
      Offset(cx + dir * 12 + a.armR, footY - 20),
      3.5,
      Paint()..color = _P.heroSkin,
    );
    // Pierna delantera
    _drawLegSide(canvas, cx + dir * 4, footY - 2 + a.legR, depth: false);

    // Cabeza perfil
    canvas.drawCircle(
      Offset(cx + dir * 2, footY - 46),
      10,
      Paint()..color = _P.heroSkin,
    );
    // Nariz
    canvas.drawCircle(
      Offset(cx + dir * 9, footY - 46),
      2.5,
      Paint()..color = _P.heroSkin,
    );
    canvas.drawCircle(
      Offset(cx + dir * 9, footY - 46),
      2.5,
      Paint()..color = _P.heroSkinShadow.withAlpha(40)..style = PaintingStyle.stroke..strokeWidth = 1,
    );
    // Gorra perfil
    canvas.drawPath(
      Path()
        ..moveTo(cx - dir * 8, footY - 50)
        ..lineTo(cx + dir * 6, footY - 58)
        ..lineTo(cx + dir * 10, footY - 48)
        ..lineTo(cx + dir * 4, footY - 42)
        ..close(),
      Paint()..color = _P.heroCap,
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx + dir * 4, footY - 42)
        ..lineTo(cx + dir * 14, footY - 40)
        ..lineTo(cx + dir * 10, footY - 36)
        ..close(),
      Paint()..color = _P.heroCapDark,
    );
    // Ojo perfil
    canvas.drawCircle(
      Offset(cx + dir * 5, footY - 47),
      2,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx + dir * 5.5, footY - 46.5),
      1,
      Paint()..color = Colors.black,
    );
    // Pelo
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, footY - 48), radius: 9),
      flip ? 0.5 : math.pi + 0.5,
      math.pi * 0.7,
      false,
      Paint()..color = _P.heroHair..strokeWidth = 4..style = PaintingStyle.stroke,
    );

    // Espada en el costado
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx - dir * 8, footY - 28),
        width: 4,
        height: 22,
      ),
      Paint()..color = _P.stone1,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx - dir * 8, footY - 14),
        width: dir * 8,
        height: 3,
      ),
      Paint()..color = _P.heroGold,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx - dir * 8, footY - 10),
        width: 3,
        height: 5,
      ),
      Paint()..color = _P.heroBoot,
    );
  }

  void _drawLegSide(Canvas canvas, double cx, double footY, {required bool depth}) {
    final alpha = depth ? 180 : 255;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, footY - 10), width: 8, height: 13),
        const Radius.circular(3),
      ),
      Paint()..color = _P.heroPants.withAlpha(alpha),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 5, footY - 7, 10, 8),
        const Radius.circular(2),
      ),
      Paint()..color = _P.heroBoot.withAlpha(alpha),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - 6, footY - 1, 12, 3),
      Paint()..color = _P.stone3.withAlpha(alpha),
    );
  }

  @override
  bool shouldRepaint(HeroPainter old) =>
      old.facing != facing ||
      old.walkFrame != walkFrame ||
      old.walking != walking;
}

class _WalkAnim {
  final double legL;
  final double legR;
  final double armL;
  final double armR;

  const _WalkAnim(this.legL, this.legR, this.armL, this.armR);

  factory _WalkAnim.fromFrame(int frame, bool walking) {
    if (!walking) return const _WalkAnim(0, 0, 0, 0);
    return switch (frame % 4) {
      0 => const _WalkAnim(-6, 4, 4, -4),
      1 => const _WalkAnim(-2, 1, 1, -1),
      2 => const _WalkAnim(6, -4, -4, 4),
      _ => const _WalkAnim(2, -1, -1, 1),
    };
  }
}

// ── Sign post ─────────────────────────────────────────────────────────────────

class SignPostPainter extends CustomPainter {
  final String text;
  const SignPostPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.width / 2, size.height - 4), width: 6, height: 20),
      Paint()..color = _P.wood3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(size.width / 2, 8), width: size.width - 4, height: 18),
        const Radius.circular(4),
      ),
      Paint()..color = _P.wood1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(size.width / 2, 8), width: size.width - 4, height: 18),
        const Radius.circular(4),
      ),
      Paint()
        ..color = _P.wood3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(SignPostPainter old) => old.text != text;
}

// ── Ambient particles ─────────────────────────────────────────────────────────

class AmbientParticle {
  Offset pos;
  Offset vel;
  double life;
  final Color color;
  final double size;

  AmbientParticle({
    required this.pos,
    required this.vel,
    required this.life,
    required this.color,
    required this.size,
  });
}

class AmbientPainter extends CustomPainter {
  final List<AmbientParticle> particles;

  const AmbientPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(
        p.pos,
        p.size,
        Paint()..color = p.color.withAlpha((p.life * 180).round()),
      );
    }
  }

  @override
  bool shouldRepaint(AmbientPainter old) => true;
}

// ── Vignette ──────────────────────────────────────────────────────────────────

class VignettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [Colors.transparent, Colors.black.withAlpha(60)],
          stops: const [0.5, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
