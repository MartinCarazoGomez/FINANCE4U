import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/progress_service.dart';
import 'achievements_screen.dart';
import 'statistics_screen.dart';
import 'quick_practice_screen.dart';
import 'settings_screen.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      // ── Nivel 1: Básico ──────────────────────────────────────────────
      Topic(
        title: 'Ahorros',
        icon: Icons.savings,
        iconBg: const Color(0xFFD6F5E3),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Métodos para ahorrar dinero y construir un fondo de emergencia.',
        shortDescription: 'Técnicas de ahorro y fondos de emergencia.',
        pillColor: const Color(0xFF7ED957),
        pills: savingsPills,
        level: 1,
      ),
      Topic(
        title: 'Presupuesto',
        icon: Icons.attach_money,
        iconBg: const Color(0xFFFFF5D6),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Crear y mantener un presupuesto personal o familiar.',
        shortDescription: 'Gestiona tu presupuesto personal.',
        pillColor: const Color(0xFFFFE066),
        pills: budgetPills,
        level: 1,
      ),
      Topic(
        title: 'Planificación Financiera',
        icon: Icons.flag_outlined,
        iconBg: const Color(0xFFE1F5FE),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Define tus metas, crea un plan y simula tu futuro financiero.',
        shortDescription: 'Metas y plan financiero personal.',
        pillColor: const Color(0xFF4FC3F7),
        pills: planningPills,
        level: 1,
      ),
      // ── Nivel 2: Intermedio ──────────────────────────────────────────
      Topic(
        title: 'Impuestos',
        icon: Icons.receipt_long,
        iconBg: const Color(0xFFFFE6E6),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Entender los impuestos en España y cómo afectan a tus finanzas.',
        shortDescription: 'Impuestos en España y tus finanzas.',
        pillColor: const Color(0xFFFF6B6B),
        pills: taxesPills,
        level: 2,
      ),
      Topic(
        title: 'Deudas y Crédito',
        icon: Icons.credit_card,
        iconBg: const Color(0xFFF5E6E6),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Cómo manejar deudas y mejorar tu historial crediticio.',
        shortDescription: 'Maneja deudas y mejora tu crédito.',
        pillColor: const Color(0xFFFFA07A),
        pills: debtPills,
        level: 2,
      ),
      Topic(
        title: 'Seguros y Protección',
        icon: Icons.shield,
        iconBg: const Color(0xFFE6F5F2),
        iconColor: const Color(0xFF1B6B4B),
        description: 'La importancia de los seguros y cómo elegirlos.',
        shortDescription: 'Elige los seguros correctos.',
        pillColor: const Color(0xFF7ED9C2),
        pills: insurancePills,
        level: 2,
      ),
      Topic(
        title: 'Psicología del Dinero',
        icon: Icons.psychology_outlined,
        iconBg: const Color(0xFFF3E5F5),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Entiende por qué tomamos malas decisiones y cómo corregirlas.',
        shortDescription: 'Sesgos, hábitos y emociones financieras.',
        pillColor: const Color(0xFFCE93D8),
        pills: psychologyPills,
        level: 2,
      ),
      // ── Nivel 3: Avanzado ────────────────────────────────────────────
      Topic(
        title: 'Inversiones',
        icon: Icons.trending_up,
        iconBg: const Color(0xFFD6E8F5),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Diferentes tipos de inversiones y cómo empezar.',
        shortDescription: 'Tipos de inversión y cómo empezar.',
        pillColor: const Color(0xFF7EC6F5),
        pills: investmentPills,
        level: 3,
      ),
      Topic(
        title: 'Emprendimiento',
        icon: Icons.business,
        iconBg: const Color(0xFFE8D6F5),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Conceptos básicos para crear y administrar un negocio.',
        shortDescription: 'Crea y gestiona tu negocio.',
        pillColor: const Color(0xFFB57EDC),
        pills: entrepreneurshipPills,
        level: 3,
      ),
      Topic(
        title: 'Bienes Raíces',
        icon: Icons.home_work_outlined,
        iconBg: const Color(0xFFFBE9E7),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Compra, hipotecas e inversión inmobiliaria en España.',
        shortDescription: 'Hipotecas e inversión inmobiliaria.',
        pillColor: const Color(0xFFFFAB91),
        pills: realEstatePills,
        level: 3,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width < 1200 ? 16 : 20, 
                20, 
                MediaQuery.of(context).size.width < 1200 ? 16 : 20, 
                0
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: MediaQuery.of(context).size.width < 1200 ? 32 : 40),
                  SizedBox(width: MediaQuery.of(context).size.width < 1200 ? 8 : 12),
                  Expanded(
                    child: Text(
                      'Lecciones Financieras',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 1200 ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B6B4B),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        icon: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.menu,
                            color: Color(0xFF1B6B4B),
                            size: MediaQuery.of(context).size.width < 1200 ? 24 : 28,
                          ),
                        ),
                        padding: MediaQuery.of(context).size.width < 1200 ? EdgeInsets.all(4) : EdgeInsets.all(8),
                        constraints: MediaQuery.of(context).size.width < 1200 ? BoxConstraints(minWidth: 32, minHeight: 32) : null,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        onSelected: (value) {
                          switch (value) {
                            case 'achievements':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const AchievementsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                            case 'statistics':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const StatisticsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                            case 'quick_practice':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const QuickPracticeScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                            case 'settings':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'achievements',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.stars, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Logros', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'statistics',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.analytics, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Estadísticas', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'quick_practice',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.flash_on, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Práctica Rápida', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'settings',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Ajustes', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tarjetas de progreso
            Consumer<AppProvider>(
              builder: (context, appProvider, _) {
                final totalPills = topics.fold<int>(0, (sum, t) => sum + t.pills.length);
                final completed = appProvider.completedLessons.length;
                final streak = appProvider.streakDays;
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width < 1200 ? 16 : 20,
                    16,
                    MediaQuery.of(context).size.width < 1200 ? 16 : 20,
                    0,
                  ),
                  child: Row(
                    children: [
                      _ProgressCard(
                        title: 'Completadas',
                        value: '$completed/$totalPills',
                        color: const Color(0xFF1B6B4B),
                        progress: totalPills > 0 ? completed / totalPills : 0,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width < 1200 ? 12 : 16),
                      _ProgressCard(
                        title: 'Racha',
                        value: '$streak ${streak == 1 ? 'día' : 'días'}',
                        color: const Color(0xFF1B6B4B),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Lista de categorías agrupadas por nivel
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, appProvider, _) {
                  final completed = appProvider.completedLessons;

                  // A level is "done enough" to unlock the next when at least
                  // half its topics have all their pills completed.
                  bool isLevelHalfDone(int lvl) {
                    final lvlTopics = topics.where((t) => t.level == lvl).toList();
                    final doneCount = lvlTopics
                        .where((t) => t.pills.every((p) => completed.contains(p.title)))
                        .length;
                    return doneCount >= (lvlTopics.length / 2).ceil();
                  }

                  bool isLevelFullyDone(int lvl) => topics
                      .where((t) => t.level == lvl)
                      .every((t) => t.pills.every((p) => completed.contains(p.title)));

                  // Group topics by level and build flat list with headers
                  final int maxLevel = topics.map((t) => t.level).reduce((a, b) => a > b ? a : b);
                  final List<Widget> items = [];

                  for (int lvl = 1; lvl <= maxLevel; lvl++) {
                    final lvlTopics = topics.where((t) => t.level == lvl).toList();
                    final levelUnlocked = lvl == 1 || isLevelHalfDone(lvl - 1);
                    final levelDone = isLevelFullyDone(lvl);

                    // Level banner
                    items.add(_LevelBanner(level: lvl, unlocked: levelUnlocked, completed: levelDone));

                    for (final t in lvlTopics) {
                      final completedCount = t.pills
                          .where((p) => completed.contains(p.title))
                          .length;
                      items.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _LessonCard(
                            icon: t.icon,
                            iconBg: t.iconBg,
                            iconColor: t.iconColor,
                            title: t.title,
                            description: t.description,
                            shortDescription: t.shortDescription,
                            pillColor: t.pillColor,
                            completedCount: completedCount,
                            totalCount: t.pills.length,
                            isLocked: !levelUnlocked,
                            onTap: levelUnlocked
                                ? () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => TopicDetailScreen(topic: t),
                                      ),
                                    )
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '🔒 Completa al menos la mitad de las lecciones del Nivel ${lvl - 1} para desbloquear este nivel.',
                                        ),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                          ),
                        ),
                      );
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    children: items,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double? progress;
  const _ProgressCard({
    required this.title,
    required this.value,
    required this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 1200;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 12 : 16,
          horizontal: isSmall ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: isSmall ? 13 : 15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 18 : 20,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            if (progress != null)
              LayoutBuilder(
                builder: (context, constraints) => Stack(
                  children: [
                    Container(
                      height: 4,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      height: 4,
                      width: constraints.maxWidth * progress!.clamp(0.0, 1.0),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Level banner ─────────────────────────────────────────────────────────────

class _LevelBanner extends StatelessWidget {
  final int level;
  final bool unlocked;
  final bool completed;

  const _LevelBanner({
    required this.level,
    required this.unlocked,
    required this.completed,
  });

  static const _labels = {1: 'Básico', 2: 'Intermedio', 3: 'Avanzado'};
  static const _colors = {
    1: Color(0xFF7ED957),
    2: Color(0xFFFFB347),
    3: Color(0xFFFF6B6B),
  };
  static const _icons = {
    1: Icons.emoji_nature_outlined,
    2: Icons.auto_awesome_outlined,
    3: Icons.local_fire_department_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? (_colors[level] ?? Colors.grey) : Colors.grey.shade400;
    final label = _labels[level] ?? 'Nivel $level';
    final icon = _icons[level] ?? Icons.school_outlined;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle_rounded : (unlocked ? icon : Icons.lock_rounded),
            color: color,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            'Nivel $level — $label',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          if (completed) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '¡Completado!',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ] else if (!unlocked) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Bloqueado',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;
  final String shortDescription;
  final Color pillColor;
  final int completedCount;
  final int totalCount;
  final bool isLocked;
  final VoidCallback onTap;

  const _LessonCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.pillColor,
    required this.completedCount,
    required this.totalCount,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFullyDone = !isLocked && completedCount == totalCount;
    final hasProgress = !isLocked && completedCount > 0 && !isFullyDone;
    final pct = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

    return AnimatedOpacity(
      opacity: isLocked ? 0.55 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.grey.shade100
            : isFullyDone
                ? Colors.green.withOpacity(0.06)
                : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isLocked
            ? Border.all(color: Colors.grey.shade300, width: 1.2)
            : isFullyDone
                ? Border.all(color: Colors.green.withOpacity(0.4), width: 1.5)
                : null,
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: isLocked
                  ? Colors.grey.shade200
                  : isFullyDone
                      ? Colors.green.withOpacity(0.15)
                      : iconBg,
              child: Icon(
                isLocked ? Icons.lock_outline : icon,
                color: isLocked
                    ? Colors.grey.shade400
                    : isFullyDone
                        ? Colors.green
                        : iconColor,
                size: 28,
              ),
            ),
            if (isFullyDone)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isLocked
                ? Colors.grey.shade400
                : isFullyDone
                    ? Colors.green.shade700
                    : const Color(0xFF1B6B4B),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                const style = TextStyle(fontSize: 15, color: Colors.black87);
                final tp = TextPainter(
                  text: TextSpan(text: description, style: style),
                  maxLines: 2,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);
                final displayText = tp.didExceedMaxLines ? shortDescription : description;
                return Text(
                  displayText,
                  style: style,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            const SizedBox(height: 8),
            if (isFullyDone)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '¡Tema completado!',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else if (hasProgress)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pillColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$pct% completado',
                      style: TextStyle(
                        color: pillColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: completedCount / totalCount,
                        backgroundColor: pillColor.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(pillColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              )
            else if (isLocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Bloqueada',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: pillColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$totalCount píldoras educativas',
                  style: TextStyle(
                    color: pillColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
          ],
        ),
        trailing: isLocked
            ? Icon(Icons.lock, color: Colors.grey.shade400, size: 22)
            : isFullyDone
                ? const Icon(Icons.check_circle, color: Colors.green, size: 26)
                : const Icon(Icons.chevron_right, color: Color(0xFF1B6B4B)),
        onTap: onTap,
      ),
    )); // closes AnimatedContainer + AnimatedOpacity
  }
}

// Modelos de datos
class Topic {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String description;
  final String shortDescription;
  final Color pillColor;
  final List<EduPill> pills;
  /// 1 = Básico · 2 = Intermedio · 3 = Avanzado
  final int level;
  Topic({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.description,
    required this.shortDescription,
    required this.pillColor,
    required this.pills,
    this.level = 1,
  });
}

class EduPill {
  final String type;
  final Color typeColor;
  final String title;
  final String shortDesc;
  final String content;
  final List<PillQuiz> quizzes;
  /// 1 = Básico · 2 = Intermedio · 3 = Avanzado
  final int difficulty;
  EduPill({
    required this.type,
    required this.typeColor,
    required this.title,
    required this.shortDesc,
    required this.content,
    required this.quizzes,
    this.difficulty = 1,
  });
}

class PillQuiz {
  final String question;
  final List<String> options;
  final int correctIndex;
  PillQuiz({required this.question, required this.options, required this.correctIndex});
  
  // Método para obtener las opciones en orden aleatorio
  List<String> getShuffledOptions() {
    final shuffled = List<String>.from(options);
    shuffled.shuffle();
    return shuffled;
  }
  
  // Método para obtener el índice correcto después del shuffle
  int getCorrectIndexAfterShuffle(List<String> shuffledOptions) {
    final correctAnswer = options[correctIndex];
    return shuffledOptions.indexOf(correctAnswer);
  }
}

// --- PÍLDORAS POR TEMA (EJEMPLO REALISTA) ---
final List<EduPill> savingsPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED957),
    title: 'Regla 50/30/20',
    shortDesc: 'Aprende a distribuir tus ingresos para ahorrar de forma efectiva.',
    difficulty: 1,
    content: '''La regla 50/30/20 es una estrategia sencilla y popular en España para organizar tu presupuesto mensual:

- 50% de tus ingresos netos se destinan a necesidades básicas: alquiler o hipoteca (700-1.200 € en ciudades grandes), suministros (100 €), alimentación (250 €), transporte (50-100 €), salud.
- 30% a deseos: ocio, restaurantes, viajes, compras no esenciales.
- 20% a ahorro e inversión: fondo de emergencia, ahorro para objetivos, aportaciones a planes de pensiones, etc.

**¿Por qué es útil?**
Esta regla te ayuda a evitar el sobreendeudamiento y a crear el hábito del ahorro, muy importante en el contexto español donde la tasa de ahorro es baja respecto a Europa. Además, te permite tener un control claro de tus finanzas y priorizar lo realmente importante.

**Ejemplo práctico:**
Si cobras 1.600 € al mes (cerca del salario medio neto en España), deberías destinar 800€ a necesidades, 480€ a deseos y 320€ a ahorro. Si tus gastos fijos superan el 50%, revisa si puedes reducir alguno (por ejemplo, cambiando de compañía eléctrica o renegociando el alquiler).

**Consejos para aplicarla en España:**
- Automatiza el 20% de ahorro con una transferencia periódica a una cuenta de ahorro separada. Puedes hacerlo en bancos como Santander, BBVA, ING, CaixaBank o Sabadell, que ofrecen cuentas sin comisiones y permiten programar transferencias automáticas.
- Si tienes ingresos variables (por ejemplo, autónomos), calcula el porcentaje sobre tu ingreso medio de los últimos 6 meses.
- Revisa y ajusta los porcentajes según tu situación personal, pero nunca bajes del 10% de ahorro si es posible.

**Errores comunes:**
- No incluir todos los gastos en el cálculo (olvidar seguros, suscripciones, etc.).
- Usar el ahorro para gastos imprevistos no urgentes (vacaciones, tecnología).

**Recuerda:** La clave es la constancia y la revisión periódica de tu presupuesto.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué porcentaje recomienda la regla 50/30/20 para el ahorro?',
        options: ['10%', '20%', '30%', '50%'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué porcentaje se destina a necesidades básicas según la regla 50/30/20?',
        options: ['20%', '30%', '50%', '70%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: 'Si cobras 2.000€/mes, ¿cuánto deberías ahorrar según la regla 50/30/20?',
        options: ['200€', '400€', '600€', '1.000€'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED957),
    title: 'Fondo de emergencia',
    shortDesc: 'Por qué necesitas un fondo de emergencia y cómo crearlo.',
    difficulty: 1,
    content: '''Un fondo de emergencia es la base de la seguridad financiera personal. En España, donde la temporalidad laboral es alta y los imprevistos (avería del coche, electrodomésticos, salud, etc.) pueden suponer un gran impacto, disponer de un fondo de emergencia es fundamental.

**¿Por qué es importante?**
Si pierdes tu empleo, el paro puede tardar semanas en llegar. Si tienes una avería en casa, el seguro puede no cubrirlo todo. Un fondo de emergencia te permite afrontar estos gastos sin recurrir a préstamos o tarjetas de crédito, evitando así el sobreendeudamiento.

**¿Cuánto ahorrar?**
Los expertos recomiendan entre 3 y 6 meses de gastos básicos (alquiler, suministros, comida, transporte). Si tus gastos son 1.000€/mes, deberías tener entre 3.000€ y 6.000€.

**¿Dónde guardarlo?**
Lo ideal es una cuenta separada, de fácil acceso pero que no uses para el día a día. Puedes abrir una cuenta de ahorro en Santander, BBVA, ING, CaixaBank o Openbank, todas ellas permiten separar el fondo y programar transferencias automáticas.

**Consejos prácticos:**
- Empieza poco a poco, aunque solo puedas ahorrar 20€ al mes.
- No uses el fondo para vacaciones o compras.
- Revisa tu fondo cada año y ajústalo si cambian tus gastos.

**Errores comunes:**
- Guardar el fondo en efectivo en casa (riesgo de robo/incendio).
- Invertirlo en productos con riesgo o sin liquidez (fondos, bolsa).

**Recuerda:** Un fondo de emergencia es tranquilidad y libertad.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuántos meses de gastos recomienda tener en el fondo de emergencia en España?',
        options: ['1-2 meses', '3-6 meses', '12 meses', 'No es necesario'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Dónde es recomendable guardar el fondo de emergencia?',
        options: ['En efectivo en casa', 'En bolsa', 'En una cuenta separada de fácil acceso', 'En un plan de pensiones'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Para qué sirve principalmente el fondo de emergencia?',
        options: ['Para hacer vacaciones', 'Para afrontar imprevistos sin endeudarse', 'Para invertir en bolsa', 'Para pagar impuestos'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED957),
    title: 'Ahorro automático',
    shortDesc: 'Automatiza tus ahorros para no olvidarte.',
    difficulty: 2,
    content: '''El ahorro automático consiste en programar una transferencia periódica (por ejemplo, el día después de cobrar la nómina) desde tu cuenta corriente a una cuenta de ahorro. Así, ahorras antes de gastar y evitas la tentación de gastar ese dinero.

**Ventajas en España:**
- Todos los grandes bancos (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) permiten programar transferencias automáticas gratis.
- Puedes usar cuentas de ahorro online que ofrecen rentabilidad y disponibilidad inmediata.
- El ahorro automático es clave para crear el hábito y no depender de la fuerza de voluntad.

**Consejo:** Empieza con una cantidad pequeña y ve aumentándola según tus posibilidades. Compara las condiciones de las cuentas de ahorro en varios bancos para elegir la que más te convenga.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es la mejor forma de asegurar que ahorras cada mes?',
        options: ['Ahorrar lo que sobre', 'Automatizar el ahorro', 'No gastar nada', 'Pedir prestado'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuándo es mejor programar la transferencia automática de ahorro?',
        options: ['A fin de mes', 'El día de cobrar la nómina', 'Cuando sobre dinero', 'Una vez al año'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué ventaja principal tiene el ahorro automático?',
        options: ['Genera intereses altos', 'No requiere fuerza de voluntad', 'Es obligatorio por ley', 'Evita pagar impuestos'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED957),
    title: 'Evita gastos hormiga',
    shortDesc: 'Identifica y reduce pequeños gastos innecesarios.',
    difficulty: 2,
    content: '''Los gastos hormiga son pequeñas compras diarias que, sumadas, pueden suponer cientos de euros al año: cafés fuera de casa, snacks, apps, lotería, etc.

**Ejemplo español:** Si gastas 1,50€ en café cada día laboral, al mes son unos 30€ y al año más de 350€. Llevar café de casa o reducir estos gastos puede aumentar tu capacidad de ahorro.

**Consejo:** Revisa tus movimientos bancarios y anota estos pequeños gastos. Si eres cliente de Santander, BBVA, ING, CaixaBank o Sabadell, puedes usar la app de tu banco para categorizar tus gastos y detectar fácilmente estos importes. Así podrás identificar patrones y reducir gastos innecesarios.

**Errores comunes:**
- No revisar los movimientos bancarios con frecuencia.
- Pensar que los pequeños gastos no afectan al ahorro.

**Recuerda:** El primer paso para ahorrar es identificar en qué se va tu dinero.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué son los "gastos hormiga"?',
        options: ['Grandes compras', 'Pequeños gastos frecuentes', 'Impuestos', 'Ahorros automáticos'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuánto puede suponer tomar un café fuera cada día laborable durante un año?',
        options: ['Menos de 50€', 'Unos 100€', 'Más de 350€', 'Más de 1.000€'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cuál es el primer paso para reducir gastos innecesarios?',
        options: ['Pedir un préstamo', 'Identificar en qué se va tu dinero', 'Cancelar todos los gastos', 'Cambiar de banco'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF7ED957),
    title: 'Reto de 30 días',
    shortDesc: 'Ahorra una pequeña cantidad cada día durante un mes.',
    difficulty: 3,
    content: '''El reto de 30 días consiste en ahorrar una cantidad fija o creciente cada día durante un mes. Por ejemplo, empieza ahorrando 1€ el primer día, 2€ el segundo, y así sucesivamente. Al final del mes, habrás ahorrado 465€.

**Variante española:** Puedes usar la funcionalidad "Mis Metas" de la app de Santander, BBVA, ING o Openbank para crear un objetivo de ahorro y seguir tu progreso día a día.

**Beneficio:** Este reto te ayuda a crear el hábito del ahorro y a ver resultados rápidamente. Puedes adaptar el reto a tu capacidad de ahorro y compartirlo con amigos o familiares para motivaros mutuamente.

**Errores comunes:**
- No mantener la constancia durante los 30 días.
- Usar el dinero ahorrado para gastos no planificados.

**Consejo:** Al terminar el reto, transfiere el dinero a tu fondo de emergencia o a una cuenta de ahorro para no gastarlo impulsivamente.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es el objetivo principal del reto de 30 días?',
        options: ['Gastar más', 'Crear el hábito de ahorrar', 'Invertir en bolsa', 'Pagar deudas'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: 'Si ahorras 1€ el día 1, 2€ el día 2... ¿cuánto habrás ahorrado al acabar 30 días?',
        options: ['30€', '150€', '465€', '900€'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué debes hacer con el dinero del reto al terminar el mes?',
        options: ['Gastarlo en ocio', 'Transferirlo al fondo de emergencia o ahorro', 'Devolverlo', 'Invertirlo en bolsa directamente'],
        correctIndex: 1,
      ),
    ],
  ),
];

final List<EduPill> taxesPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFF6B6B),
    title: '¿Qué son los impuestos?',
    shortDesc: 'Conceptos básicos del sistema fiscal español.',
    difficulty: 1,
    content: '''Los impuestos son contribuciones obligatorias que pagamos al Estado para financiar servicios públicos como sanidad, educación, pensiones, infraestructuras y seguridad. En España, el sistema fiscal es progresivo, lo que significa que quienes más ganan, más pagan proporcionalmente.

**¿Por qué pagamos impuestos?**
Los impuestos financian servicios esenciales que benefician a toda la sociedad:
- **Sanidad pública:** Hospitales, médicos, medicamentos
- **Educación:** Escuelas, universidades, becas
- **Pensiones:** Jubilación de nuestros mayores
- **Infraestructuras:** Carreteras, transporte público, internet
- **Seguridad:** Policía, bomberos, ejército
- **Servicios sociales:** Ayudas a desempleados, dependencia

**Tipos principales de impuestos en España:**
- **IRPF (Impuesto sobre la Renta de las Personas Físicas):** Se paga por los ingresos del trabajo, rentas de capital, etc.
- **Seguridad Social:** Cotizaciones para pensiones, desempleo, sanidad
- **IVA (Impuesto sobre el Valor Añadido):** Se paga al comprar bienes y servicios
- **IBI (Impuesto sobre Bienes Inmuebles):** Se paga por tener una vivienda
- **Impuesto de Sociedades:** Para empresas
- **Impuestos especiales:** Gasolina, alcohol, tabaco

**¿Cómo funciona la progresividad?**
En España, el IRPF tiene tramos progresivos (totales estatal + autonómico):
- Hasta 12.450€: 19%
- 12.450€ - 20.200€: 24%
- 20.200€ - 35.200€: 30%
- 35.200€ - 60.000€: 37%
- 60.000€ - 300.000€: 45%
- Más de 300.000€: 47%

**Ejemplo práctico:**
María gana 30.000€ al año. Su IRPF se calcula así:
- Primeros 12.450€: 19% = 2.365,50€
- 12.450€ - 20.200€: 24% = 1.860€
- 20.200€ - 30.000€: 30% = 2.940€
- Total IRPF: 7.165,50€ (23,9% de su salario)

**Errores comunes:**
- Pensar que los impuestos son un "robo" sin entender su función social
- No declarar todos los ingresos
- No aprovechar las deducciones fiscales disponibles

**Consejo:** Los impuestos son el precio de vivir en sociedad. Es importante entenderlos para planificar mejor nuestras finanzas.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué significa que el sistema fiscal español es progresivo?',
        options: ['Todos pagan lo mismo', 'Quienes más ganan, más pagan', 'Solo pagan los ricos', 'Los pobres pagan más'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué financian principalmente los impuestos en España?',
        options: ['Salarios de políticos', 'Servicios públicos como sanidad y educación', 'Empresas privadas', 'Vacaciones del Estado'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué impuesto se aplica sobre los ingresos del trabajo en España?',
        options: ['IVA', 'IBI', 'IRPF', 'Impuesto de Sociedades'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFF6B6B),
    title: 'IRPF: El impuesto principal',
    shortDesc: 'Entiende cómo se calcula tu IRPF.',
    difficulty: 2,
    content: '''El IRPF (Impuesto sobre la Renta de las Personas Físicas) es el impuesto más importante que pagas como trabajador en España. Se calcula sobre todos tus ingresos: salario, rentas de capital, ganancias de inversiones, etc.

**¿Cómo se calcula el IRPF?**
1. **Base imponible:** Suma de todos tus ingresos menos las deducciones permitidas
2. **Aplicación de tramos:** Cada tramo de ingresos paga un porcentaje diferente
3. **Deducciones:** Se restan las deducciones autonómicas y estatales

**Tramos del IRPF 2024 (totales estatal + autonómico):**
- Hasta 12.450€: 19%
- 12.450€ - 20.200€: 24%
- 20.200€ - 35.200€: 30%
- 35.200€ - 60.000€: 37%
- 60.000€ - 300.000€: 45%
- Más de 300.000€: 47%

**Ejemplo detallado:**
Carlos gana 45.000€ al año. Su IRPF se calcula así:
- Primeros 12.450€: 19% = 2.365,50€
- 12.450€ - 20.200€: 24% = 1.860€
- 20.200€ - 35.200€: 30% = 4.500€
- 35.200€ - 45.000€: 37% = 3.626€
- Total IRPF: 12.351,50€

**Deducciones importantes:**
- **Deducciones por vivienda:** Hipoteca, alquiler
- **Deducciones por familia:** Hijos, familia numerosa
- **Deducciones por donaciones:** ONGs, fundaciones
- **Deducciones por inversiones:** Planes de pensiones, vivienda

**¿Cuándo se paga?**
- **Retenciones mensuales:** Tu empresa retiene una parte de tu nómina cada mes
- **Declaración anual:** En mayo/junio declaras y ajustas cuentas con Hacienda

**Consejos prácticos:**
- Guarda todos los justificantes de gastos deducibles
- Revisa tu declaración antes de presentarla
- Considera contratar un gestor si tu situación es compleja
- Aprovecha las deducciones disponibles en tu comunidad autónoma

**Errores comunes:**
- No declarar ingresos adicionales (freelance, alquileres)
- Olvidar deducciones importantes
- No revisar las retenciones de la empresa

**Recuerda:** El IRPF es complejo, pero entenderlo te ayudará a optimizar tu situación fiscal.''',
    quizzes: [
      PillQuiz(
        question: '¿En qué mes se presenta normalmente la declaración del IRPF?',
        options: ['Enero', 'Mayo/Junio', 'Diciembre', 'Marzo'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es el tipo mínimo del IRPF en España para los primeros tramos?',
        options: ['5%', '10%', '19%', '30%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cómo se descuenta el IRPF mensualmente de tu nómina?',
        options: ['Lo pagas tú directamente', 'Mediante retenciones que aplica tu empresa', 'Con una transferencia trimestral', 'Solo al final del año'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFF6B6B),
    title: 'Seguridad Social',
    shortDesc: 'Las cotizaciones que financian las pensiones.',
    difficulty: 2,
    content: '''La Seguridad Social es el sistema público que protege a los trabajadores en España. Se financia con las cotizaciones que pagan trabajadores y empresas, y proporciona cobertura en situaciones como jubilación, desempleo, enfermedad o maternidad.

**¿Qué cubre la Seguridad Social?**
- **Pensiones de jubilación:** Ingresos mensuales tras la jubilación
- **Prestación por desempleo:** Ayuda económica cuando pierdes el trabajo
- **Asistencia sanitaria:** Atención médica gratuita
- **Prestaciones por incapacidad:** Si no puedes trabajar temporal o permanentemente
- **Prestaciones por maternidad/paternidad:** Bajas por nacimiento o adopción
- **Prestaciones por muerte y supervivencia:** Pensiones de viudedad y orfandad

**¿Cuánto se paga?**
Las cotizaciones se calculan sobre tu base de cotización (similar al salario bruto):
- **Trabajador:** Aproximadamente 6,35% del salario
- **Empresa:** Aproximadamente 29,9% del salario
- **Total:** Alrededor del 36,25% del salario

**Ejemplo práctico:**
Ana gana 2.000€ brutos al mes:
- Cotización trabajador: 2.000€ × 6,35% = 127€
- Cotización empresa: 2.000€ × 29,9% = 598€
- Total cotizaciones: 725€
- Salario neto: 2.000€ - 127€ = 1.873€

**¿Cómo se calcula la pensión?**
La pensión se calcula con:
- **Años cotizados:** Mínimo 15 años, máximo 35 años
- **Base reguladora:** Media de las bases de cotización de los últimos 25 años
- **Porcentaje:** Depende de los años cotizados (mínimo 50%, máximo 100%)

**Ejemplo de pensión:**
Juan ha cotizado 35 años con una base media de 2.500€:
- Porcentaje: 100% (35 años cotizados)
- Pensión mensual: 2.500€ × 100% = 2.500€

**Situaciones especiales:**
- **Autónomos:** Pagan cuotas mensuales fijas o variables según ingresos
- **Trabajadores a tiempo parcial:** Cotizan proporcionalmente
- **Pluriempleo:** Se suman las cotizaciones de todos los trabajos

**Consejos importantes:**
- Revisa tu vida laboral regularmente en la web de la Seguridad Social
- Guarda todas las nóminas y contratos
- Infórmate sobre las prestaciones disponibles
- Considera complementar con planes de pensiones privados

**Errores comunes:**
- No revisar la vida laboral y detectar errores tarde
- No cotizar suficientes años para tener pensión completa
- No informarse sobre prestaciones disponibles

**Recuerda:** La Seguridad Social es tu red de seguridad. Es importante entender cómo funciona para planificar tu futuro.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es el porcentaje aproximado que paga el trabajador en cotizaciones?',
        options: ['3%', '6,35%', '15%', '30%'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuántos años mínimos de cotización se necesitan para recibir pensión en España?',
        options: ['5 años', '10 años', '15 años', '25 años'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué cubre la prestación por desempleo de la Seguridad Social?',
        options: ['Los gastos de vacaciones', 'Ayuda económica cuando pierdes el trabajo', 'Las facturas del hogar', 'El seguro del coche'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFF6B6B),
    title: 'IVA: El impuesto invisible',
    shortDesc: 'Cómo afecta el IVA a tus compras diarias.',
    difficulty: 2,
    content: '''El IVA (Impuesto sobre el Valor Añadido) es un impuesto indirecto que pagas cada vez que compras un bien o servicio. A diferencia del IRPF, no lo declaras tú directamente, sino que lo pagan las empresas y lo repercuten en el precio final.

**Tipos de IVA en España:**
- **IVA Superreducido (4%):** Productos de primera necesidad como pan, leche, frutas, verduras, libros, medicamentos
- **IVA Reducido (10%):** Alimentos básicos, vivienda de protección oficial, transporte público, servicios culturales
- **IVA General (21%):** La mayoría de bienes y servicios (ropa, tecnología, restaurantes, servicios profesionales)

**¿Cómo funciona?**
Cuando compras algo, el precio que ves ya incluye el IVA. Por ejemplo:
- Precio sin IVA: 100€
- IVA (21%): 21€
- Precio final: 121€

**Ejemplos prácticos:**
- **Pan (4% IVA):** 1€ + 0,04€ IVA = 1,04€ final
- **Leche (4% IVA):** 1,20€ + 0,048€ IVA = 1,25€ final
- **Libro (4% IVA):** 15€ + 0,60€ IVA = 15,60€ final
- **Transporte público (10% IVA):** 10€ + 1€ IVA = 11€ final
- **Ropa (21% IVA):** 50€ + 10,50€ IVA = 60,50€ final
- **Restaurante (10% IVA):** 30€ + 3€ IVA = 33€ final

**¿Cuánto IVA pagas al año?**
En una familia media española, el IVA puede representar entre 3.000€ y 6.000€ anuales, dependiendo del nivel de consumo.

**Estrategias para reducir el impacto del IVA:**
- **Prioriza productos con IVA reducido:** Alimentos básicos, transporte público
- **Compras online:** Algunos productos pueden tener IVA diferente
- **Compras al por mayor:** Puede reducir el impacto del IVA
- **Servicios profesionales:** Compara precios, el IVA es igual en todos

**¿Quién puede recuperar el IVA?**
- **Empresas:** Pueden deducir el IVA de sus compras
- **Exportadores:** IVA 0% en exportaciones
- **Autónomos:** Pueden deducir el IVA de sus gastos profesionales

**Errores comunes:**
- No tener en cuenta el IVA al planificar gastos
- Pensar que el IVA es opcional
- No guardar facturas para deducciones empresariales

**Consejos prácticos:**
- Siempre incluye el IVA en tus presupuestos
- Compara precios finales (con IVA incluido)
- Guarda las facturas importantes
- Considera el IVA al hacer compras grandes

**Recuerda:** El IVA está presente en casi todas tus compras. Entenderlo te ayudará a tomar mejores decisiones de consumo.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué tipo de IVA se aplica a la mayoría de productos en España?',
        options: ['0%', '5%', '21%', '30%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué tipo de IVA se aplica a libros y medicamentos en España?',
        options: ['0%', '4% (superreducido)', '10% (reducido)', '21% (general)'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Quién ingresa directamente el IVA a la Hacienda?',
        options: ['El consumidor final', 'Las empresas y autónomos', 'Los bancos', 'El gobierno autonómico'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFF6B6B),
    title: 'Ejemplo completo: ¿Cuánto se lleva el Estado?',
    shortDesc: 'Cálculo real de impuestos sobre un salario español.',
    difficulty: 3,
    content: '''Vamos a hacer un cálculo completo de cuánto se lleva el Estado de un salario típico español. Este ejemplo te ayudará a entender el impacto real de los impuestos en tus finanzas.

**Ejemplo: María, 35 años, Madrid**
- **Salario bruto anual:** 35.000€
- **Salario bruto mensual:** 2.916,67€

**1. Cálculo de cotizaciones a la Seguridad Social:**
- Base de cotización: 2.916,67€
- Cotización trabajador (6,35%): 185,81€
- Cotización empresa (29,9%): 872,08€
- **Total cotizaciones mensuales:** 1.057,89€

**2. Cálculo del IRPF:**
- Primeros 12.450€: 19% = 2.365,50€
- 12.450€ - 20.200€: 24% = 1.860,00€
- 20.200€ - 35.000€: 30% = 4.440,00€
- **Total IRPF anual:** 8.665,50€
- **IRPF mensual:** 722,13€

**3. Salario neto mensual:**
- Salario bruto: 2.916,67€
- Cotizaciones: -185,81€
- IRPF: -722,13€
- **Salario neto:** 2.008,73€

**4. Impacto del IVA en gastos mensuales:**
María gasta aproximadamente 1.500€ al mes:
- Alimentación (10% IVA): 400€ + 40€ IVA = 440€
- Transporte (10% IVA): 50€ + 5€ IVA = 55€
- Ropa y tecnología (21% IVA): 300€ + 63€ IVA = 363€
- Restaurantes (10% IVA): 200€ + 20€ IVA = 220€
- Otros gastos (21% IVA): 550€ + 115,50€ IVA = 665,50€
- **Total IVA mensual:** 243,50€

**5. Resumen total de impuestos:**
- Cotizaciones mensuales: 185,81€
- IRPF mensual: 722,13€
- IVA mensual: 243,50€
- **Total impuestos mensuales:** 1.151,44€
- **Porcentaje sobre salario bruto:** 39,5%

**6. ¿Qué se queda María realmente?**
- Salario bruto mensual: 2.916,67€
- Total impuestos: -1.151,44€
- **Salario neto real:** 1.765,23€
- **Porcentaje que se queda:** 60,5%

**7. Otros impuestos anuales:**
- IBI (vivienda): 600€/año (50€/mes)
- Impuesto de circulación: 150€/año (12,50€/mes)
- **Total otros impuestos:** 62,50€/mes

**Resumen final:**
- **Salario bruto:** 2.916,67€
- **Total impuestos:** 1.213,94€ (41,6%)
- **Salario neto real:** 1.702,73€ (58,4%)

**¿Qué financia esto?**
- **Sanidad pública:** Atención médica gratuita
- **Educación:** Escuelas y universidades públicas
- **Pensiones:** Jubilación futura
- **Infraestructuras:** Carreteras, transporte público
- **Servicios sociales:** Ayudas, protección social

**Consejos para optimizar:**
- Aprovecha las deducciones fiscales disponibles
- Considera planes de pensiones para reducir IRPF
- Planifica gastos considerando el IVA
- Revisa tu declaración anual

**Recuerda:** Los impuestos son necesarios para mantener los servicios públicos. Entender cuánto pagas te ayuda a planificar mejor tus finanzas.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué porcentaje aproximado se queda un trabajador de su salario bruto en España?',
        options: ['50%', '60%', '70-75%', '90%'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: 'En el ejemplo de María (35.000€ brutos), ¿cuánto paga aproximadamente de IRPF al mes?',
        options: ['100€', '300€', '722€', '1.500€'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué impuesto afecta directamente a tus compras diarias en España?',
        options: ['IRPF', 'Impuesto de Sociedades', 'IVA', 'IBI'],
        correctIndex: 2,
      ),
    ],
  ),
];

final List<EduPill> investmentPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7EC6F5),
    title: '¿Qué es invertir?',
    difficulty: 1,
    shortDesc: 'Conceptos básicos de inversión para principiantes.',
    content: '''Invertir es poner tu dinero a trabajar para ti, buscando obtener un rendimiento superior al de una cuenta corriente. En España, la cultura de la inversión está creciendo, pero aún existe mucho desconocimiento y miedo al riesgo.

**¿Por qué invertir?**
La inflación hace que el dinero pierda valor con el tiempo. Si dejas tus ahorros en una cuenta sin remunerar, cada año podrás comprar menos cosas con ellos. Invertir te permite combatir la inflación y hacer crecer tu patrimonio.

**Instrumentos de inversión en España:**
- **Depósitos a plazo:** Producto tradicional, bajo riesgo, pero actualmente con rentabilidades muy bajas. Disponibles en bancos como Santander, BBVA, CaixaBank, ING y Sabadell.
- **Fondos de inversión:** Permiten diversificar y acceder a mercados globales. Hay fondos de renta fija, variable, mixtos, etc. Bancos como Santander, BBVA, CaixaBank, ING y Openbank ofrecen una amplia gama de fondos adaptados a distintos perfiles. La inversión mínima suele ser de 100€ a 500€.
- **Acciones:** Comprar una parte de una empresa. Más riesgo, pero también más potencial de rentabilidad. Puedes invertir en la Bolsa española (IBEX 35) o internacional a través de bancos y brókers online.
- **Planes de pensiones:** Producto fiscalmente ventajoso para ahorrar a largo plazo para la jubilación. Santander, BBVA, CaixaBank y otros bancos ofrecen planes de pensiones con diferentes estrategias y comisiones.
- **Inmuebles:** Comprar para alquilar o vender. Requiere más capital y gestión, pero es muy habitual en España.

**Consejos prácticos:**
- Antes de invertir, define tu objetivo (comprar casa, jubilación, estudios hijos, etc.).
- Nunca inviertas dinero que puedas necesitar a corto plazo.
- Infórmate bien y compara productos. Consulta con tu banco (Santander, BBVA, ING, CaixaBank, Openbank, etc.) o un asesor financiero independiente.
- Ten en cuenta la fiscalidad: las ganancias de fondos y acciones tributan en el IRPF.

**Errores comunes:**
- Invertir por moda o por recomendaciones de amigos sin entender el producto.
- No diversificar (poner todo el dinero en un solo activo).
- No tener en cuenta las comisiones y la fiscalidad.

**Recuerda:** Invertir no es apostar. Es una estrategia a medio y largo plazo para mejorar tu futuro financiero.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es el objetivo principal de invertir?',
        options: ['Gastar dinero', 'Obtener rendimientos', 'Ahorrar en casa', 'Evitar riesgos'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Por qué es importante combatir la inflación con inversiones?',
        options: ['Para pagar menos impuestos', 'Porque el dinero pierde valor con el tiempo', 'Para tener más deudas', 'No es importante'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál de estos es un instrumento de inversión?',
        options: ['Cuenta corriente sin remunerar', 'Préstamo personal', 'Fondo de inversión', 'Recibo del gas'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Diversificación',
    shortDesc: 'No pongas todos los huevos en la misma canasta.',
    difficulty: 1,
    content: '''Diversificar es repartir tu dinero entre diferentes tipos de activos (acciones, bonos, fondos, depósitos, etc.) y sectores. Así, si uno baja, otros pueden compensar las pérdidas.

**¿Por qué es importante?**
En España, muchos ahorradores concentran todo en vivienda o depósitos. Esto aumenta el riesgo si ese activo baja de valor. Diversificar reduce la volatilidad y protege tu patrimonio.

**Ejemplo práctico:**
Si tienes 10.000€, puedes repartir 4.000€ en fondos de renta fija, 3.000€ en fondos de renta variable, 2.000€ en un depósito a plazo y 1.000€ en acciones españolas. Bancos como Santander, BBVA, CaixaBank, ING y Openbank ofrecen carteras diversificadas y fondos perfilados para facilitar esta tarea.

**Consejos:**
- No inviertas solo en lo que conoces o te resulta cómodo.
- Revisa tu cartera al menos una vez al año y ajusta según tu edad y objetivos.
- Compara comisiones y servicios de varios bancos antes de decidir.

**Errores comunes:**
- Poner todo el dinero en acciones de una sola empresa (por ejemplo, Telefónica o Santander).
- No revisar la cartera y dejar que se descompense con el tiempo.

**Recuerda:** La diversificación es la mejor defensa contra la incertidumbre de los mercados.''',
    quizzes: [
      PillQuiz(
        question: '¿Para qué sirve la diversificación?',
        options: ['Aumentar el riesgo', 'Reducir el riesgo', 'Ganar menos', 'Pagar impuestos'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué ocurre si no diversificas tus inversiones?',
        options: ['Pagas menos impuestos', 'Aumenta el riesgo total de tu cartera', 'Obtienes mejores rendimientos garantizados', 'Nada relevante'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es un ejemplo de cartera diversificada?',
        options: ['Todo en acciones de una empresa', 'Todo en efectivo', 'Fondos de renta fija + variable + depósito', 'Solo criptomonedas'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7EC6F5),
    title: 'Riesgo y rentabilidad',
    difficulty: 2,
    shortDesc: 'Entiende la relación entre riesgo y ganancia.',
    content: '''La relación entre riesgo y rentabilidad es fundamental en el mundo de las inversiones. En España, muchos ahorradores tradicionalmente han preferido productos de bajo riesgo (depósitos, cuentas de ahorro), pero esto ha limitado sus posibilidades de crecimiento patrimonial.

**¿Qué es el riesgo?**
El riesgo es la posibilidad de perder parte o todo el dinero invertido. En España, los productos financieros se clasifican en niveles de riesgo del 1 (muy bajo) al 7 (muy alto), según la normativa europea MiFID.

**Tipos de riesgo:**
- **Riesgo de mercado:** El valor de tu inversión puede bajar por cambios en los mercados. Por ejemplo, si inviertes en acciones del IBEX 35 y la bolsa española cae, tu inversión se devalúa.
- **Riesgo de crédito:** La entidad emisora (banco, empresa, gobierno) puede no devolver tu dinero. En España, los depósitos están garantizados hasta 100.000€ por el Fondo de Garantía de Depósitos.
- **Riesgo de liquidez:** No poder vender tu inversión cuando lo necesites sin perder dinero. Los fondos de inversión suelen ser líquidos, pero algunos productos estructurados pueden tener penalizaciones.
- **Riesgo de inflación:** Que el dinero pierda valor con el tiempo. Con la inflación actual en España (2-3%), si tu inversión no rinde al menos ese porcentaje, estás perdiendo poder adquisitivo.

**Relación riesgo-rentabilidad:**
- **Bajo riesgo (1-2):** Depósitos a plazo, cuentas remuneradas, letras del Tesoro. Rentabilidad: 0-2% anual. Ejemplo: Depósito Santander 12 meses al 2,5% TAE.
- **Riesgo medio-bajo (3-4):** Fondos de renta fija, bonos corporativos, planes de pensiones conservadores. Rentabilidad: 2-5% anual. Ejemplo: Fondo BBVA Renta Fija Euro.
- **Riesgo medio (4-5):** Fondos mixtos, fondos de renta variable europea, algunos ETFs. Rentabilidad: 4-8% anual. Ejemplo: Fondo CaixaBank Mixto Conservador.
- **Alto riesgo (6-7):** Acciones individuales, fondos de mercados emergentes, criptomonedas. Rentabilidad: muy variable, puede ser negativa o superior al 15% anual.

**¿Cómo determinar tu perfil de riesgo?**
Los bancos españoles (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) realizan un test de perfil de inversor que evalúa:
- Tu edad y horizonte temporal
- Tu experiencia en inversiones
- Tu capacidad de asumir pérdidas
- Tus objetivos financieros

**Consejos prácticos:**
- Nunca inviertas dinero que puedas necesitar a corto plazo (menos de 3 años).
- Si eres joven (20-40 años), puedes asumir más riesgo porque tienes tiempo para recuperarte.
- Si te acercas a la jubilación, prioriza la conservación del capital.
- Diversifica para reducir el riesgo total de tu cartera.

**Errores comunes:**
- Invertir solo en productos de bajo riesgo por miedo, perdiendo oportunidades de crecimiento.
- Invertir en productos de alto riesgo sin entenderlos, buscando ganancias rápidas.
- No revisar el perfil de riesgo de tus inversiones cuando cambian tus circunstancias.

**Ejemplo práctico español:**
María, 35 años, quiere ahorrar para la entrada de una casa en 5 años. Tiene 20.000€ y puede ahorrar 500€ al mes. Su perfil de riesgo es medio (4/7). Podría invertir:
- 60% en fondos mixtos (rentabilidad esperada 5-7% anual)
- 30% en fondos de renta fija (rentabilidad esperada 3-4% anual)
- 10% en cuentas remuneradas (liquidez inmediata)

**Recuerda:** El riesgo no es malo en sí mismo, pero debe ser proporcional a tu situación y objetivos.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué suele ocurrir a mayor riesgo en una inversión?',
        options: ['Menor rentabilidad', 'Mayor rentabilidad potencial', 'Menos impuestos', 'Más seguridad'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿En qué escala se clasifican los productos financieros por riesgo en España?',
        options: ['Del 1 al 3', 'Del 1 al 7', 'Del 0 al 10', 'Del 1 al 5'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál de estos productos tiene menor riesgo?',
        options: ['Acciones de empresas emergentes', 'Criptomonedas', 'Depósito a plazo bancario', 'Fondos de mercados emergentes'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Invierte a largo plazo',
    shortDesc: 'La paciencia es clave para invertir.',
    difficulty: 2,
    content: '''Invertir a largo plazo es una de las estrategias más efectivas para construir patrimonio. En España, la cultura del "dinero rápido" y la falta de educación financiera han llevado a muchos a buscar ganancias inmediatas, pero la historia demuestra que la paciencia es rentable.

**¿Por qué invertir a largo plazo?**
- **Reduce la volatilidad:** Los mercados suben y bajan a corto plazo, pero históricamente tienden a subir a largo plazo. El IBEX 35 ha tenido años malos (-25% en 2008), pero ha crecido un 7% anual de media desde su creación.
- **Permite aprovechar el interés compuesto:** Los beneficios se reinvierten y generan más beneficios. 10.000€ invertidos al 7% anual se convierten en 19.671€ en 10 años, 38.697€ en 20 años.
- **Reduce el impacto de las comisiones:** Las comisiones de entrada y salida de fondos (1-3%) tienen menos impacto si mantienes la inversión años.
- **Te da tiempo para recuperarte:** Si el mercado baja, tienes tiempo para esperar a que se recupere sin vender a pérdidas.

**Horizontes temporales recomendados:**
- **Corto plazo (1-3 años):** Cuentas remuneradas, depósitos a plazo, fondos de renta fija de corta duración. Ejemplo: Cuenta remunerada ING al 2,5% TAE.
- **Medio plazo (3-10 años):** Fondos mixtos, fondos de renta variable europea, planes de pensiones. Ejemplo: Fondo Santander Mixto Moderado.
- **Largo plazo (10+ años):** Fondos de renta variable global, ETFs, planes de pensiones agresivos. Ejemplo: Fondo BBVA Renta Variable Global.

**Estrategias para invertir a largo plazo:**
1. **Dollar-cost averaging (media de costes):** Invertir una cantidad fija cada mes, independientemente del precio. Así compras más cuando está barato y menos cuando está caro. Bancos como Santander, BBVA, ING, CaixaBank y Openbank permiten programar aportaciones automáticas a fondos.
2. **Revisión periódica:** Revisar tu cartera cada 6-12 meses para rebalancear (ajustar los porcentajes según tu estrategia).
3. **No dejarse llevar por las emociones:** No vender en pánico cuando el mercado baja ni comprar compulsivamente cuando sube.

**Productos españoles para largo plazo:**
- **Planes de pensiones:** Ventajas fiscales (reducción en la declaración de la renta) y horizonte largo. Santander, BBVA, CaixaBank, ING y otros bancos ofrecen planes con diferentes estrategias.
- **Fondos de inversión:** Amplia variedad de fondos para diferentes perfiles y horizontes temporales.
- **Seguros de ahorro:** Combinan ahorro con protección, aunque suelen tener comisiones más altas.

**Ejemplo práctico:**
Carlos, 28 años, invierte 200€ al mes en un fondo de renta variable global. Aunque algunos meses el fondo baja, mantiene la inversión. En 30 años, con una rentabilidad media del 7% anual, tendrá 227.000€, de los cuales solo 72.000€ serán sus aportaciones.

**Errores comunes:**
- Vender cuando el mercado baja por miedo a perder más dinero.
- No tener un horizonte temporal claro y cambiar de estrategia constantemente.
- Invertir dinero que necesitarás a corto plazo en productos de largo plazo.

**Consejos para mantener la disciplina:**
- Establece objetivos claros (jubilación, compra de vivienda, educación de hijos).
- Automatiza las inversiones para no depender de la fuerza de voluntad.
- No revisar constantemente el valor de tus inversiones (una vez al mes es suficiente).
- Ten un fondo de emergencia para no tener que vender inversiones en momentos inoportunos.

**Recuerda:** El tiempo es tu mejor aliado en las inversiones. Cuanto antes empieces, mejor.''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué es recomendable invertir a largo plazo?',
        options: ['Para ganar dinero rápido', 'Para reducir la volatilidad', 'Para pagar menos impuestos', 'Para gastar más'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cómo se llama la estrategia de invertir una cantidad fija cada mes?',
        options: ['Especulación', 'Dollar-cost averaging', 'Arbitraje', 'Hedging'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: 'Según el ejemplo, ¿en cuánto se convierte 10.000€ al 7% anual después de 20 años?',
        options: ['12.000€', '18.000€', '~38.700€', '~100.000€'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7EC6F5),
    title: 'Fondos de inversión',
    shortDesc: 'Aprende sobre uno de los productos más populares.',
    difficulty: 2,
    content: '''Los fondos de inversión son uno de los productos más populares en España para invertir. Permiten acceder a mercados globales con pequeñas cantidades de dinero y están gestionados por profesionales. En 2023, los españoles tenían más de 300.000 millones de euros invertidos en fondos.

**¿Qué es un fondo de inversión?**
Es un vehículo que reúne el dinero de muchos inversores para comprar una cartera diversificada de activos (acciones, bonos, inmuebles, etc.). Cada inversor posee participaciones del fondo proporcionales a su inversión.

**Tipos de fondos en España:**
- **Fondos de renta fija:** Invierten en bonos y deuda. Menor riesgo, menor rentabilidad esperada. Ejemplos: Fondo Santander Renta Fija Euro, Fondo BBVA Renta Fija España.
- **Fondos de renta variable:** Invierten en acciones. Mayor riesgo, mayor rentabilidad potencial. Ejemplos: Fondo CaixaBank Renta Variable España, Fondo ING Renta Variable Global.
- **Fondos mixtos:** Combinan renta fija y variable. Riesgo y rentabilidad intermedios. Ejemplos: Fondo Santander Mixto Conservador, Fondo BBVA Mixto Moderado.
- **Fondos de gestión pasiva (ETFs):** Replican índices como el IBEX 35 o el S&P 500. Comisiones más bajas. Ejemplos: ETF que replica el IBEX 35, ETF que replica el MSCI World.
- **Fondos temáticos:** Se especializan en sectores (tecnología, energías renovables, etc.). Mayor riesgo por concentración.

**Ventajas de los fondos:**
- **Diversificación:** Con 1.000€ puedes tener exposición a cientos de empresas o bonos.
- **Gestión profesional:** Expertos toman las decisiones de inversión.
- **Liquidez:** Puedes vender tus participaciones en cualquier momento (normalmente en 1-3 días).
- **Fiscalidad favorable:** No pagas impuestos hasta que vendes, y puedes traspasar entre fondos sin tributar.
- **Inversión mínima baja:** Desde 100€ en muchos fondos.

**Comisiones a tener en cuenta:**
- **Comisión de gestión:** Porcentaje anual del patrimonio (0,5-2%). Se descuenta automáticamente.
- **Comisión de suscripción/reembolso:** Al comprar o vender (0-5%). Muchos fondos no las cobran.
- **Comisión de depósito:** Por la custodia de los activos (0,1-0,3% anual).

**Cómo elegir un fondo:**
1. **Define tu perfil de riesgo:** Conservador, moderado o agresivo.
2. **Establece tu horizonte temporal:** Corto, medio o largo plazo.
3. **Compara fondos similares:** Mira la rentabilidad histórica, las comisiones y la volatilidad.
4. **Lee el folleto informativo:** Es obligatorio y contiene toda la información del fondo.

**Dónde comprar fondos:**
- **Bancos tradicionales:** Santander, BBVA, CaixaBank, Sabadell. Ventaja: asesoramiento personalizado. Desventaja: comisiones más altas.
- **Bancos online:** ING, Openbank, MyInvestor. Ventaja: comisiones más bajas. Desventaja: menos asesoramiento.
- **Plataformas independientes:** Renta 4, Self Bank, Indexa Capital. Ventaja: amplia oferta y comisiones competitivas.

**Ejemplo práctico:**
Ana, 35 años, quiere invertir 5.000€ con un perfil moderado. Elige un fondo mixto con 60% renta fija y 40% renta variable. Comisión de gestión: 1,5% anual. Rentabilidad esperada: 5-7% anual. Al cabo de 10 años, podría tener entre 7.500€ y 9.800€ (antes de impuestos).

**Errores comunes:**
- Elegir fondos solo por la rentabilidad pasada (no garantiza rentabilidad futura).
- No tener en cuenta las comisiones, que pueden reducir significativamente la rentabilidad.
- No diversificar (poner todo el dinero en un solo fondo).
- Vender en pánico cuando el fondo baja temporalmente.

**Consejos prácticos:**
- Empieza con fondos de gestión pasiva (ETFs) si quieres comisiones bajas.
- Considera fondos indexados que replican el mercado español o global.
- Revisa tu cartera de fondos al menos una vez al año.
- No inviertas en fondos que no entiendas completamente.

**Recuerda:** Los fondos de inversión son una excelente herramienta para diversificar y acceder a mercados globales, pero requieren tiempo y paciencia.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es la principal ventaja de los fondos de inversión?',
        options: ['Garantía de rentabilidad', 'Diversificación', 'Sin comisiones', 'Liquidez inmediata'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué tipo de fondo suele tener las comisiones más bajas?',
        options: ['Fondos de gestión activa', 'Fondos temáticos', 'Fondos de gestión pasiva (ETFs)', 'Fondos estructurados'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cuándo pagas impuestos por un fondo de inversión en España?',
        options: ['Cada año aunque no vendas', 'Cuando vendes las participaciones', 'Mensualmente', 'Nunca'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Planes de pensiones',
    shortDesc: 'Ahorra para tu jubilación con ventajas fiscales.',
    difficulty: 3,
    content: '''Los planes de pensiones son productos de ahorro a largo plazo diseñados específicamente para la jubilación. En España, ofrecen ventajas fiscales importantes y son una herramienta fundamental para complementar la pensión pública, especialmente considerando que el sistema de pensiones español enfrenta desafíos demográficos.

**¿Qué es un plan de pensiones?**
Es un producto de ahorro que permite acumular capital para la jubilación con ventajas fiscales. El dinero se invierte en diferentes activos (renta fija, renta variable, inmuebles) según el perfil de riesgo elegido.

**Tipos de planes de pensiones en España:**
- **Planes de pensiones individuales:** Los contratas personalmente. Los ofrecen bancos (Santander, BBVA, CaixaBank, ING, Sabadell, Openbank), aseguradoras y gestoras independientes.
- **Planes de pensiones de empleo:** Los ofrece tu empresa a sus trabajadores. Pueden incluir aportaciones de la empresa.
- **Planes de pensiones asociados:** Los ofrecen sindicatos, colegios profesionales y asociaciones.

**Ventajas fiscales:**
- **Reducción en la declaración de la renta:** Puedes desgravar hasta 1.500€ anuales (2.000€ si tienes más de 50 años). Si tributas al 30%, ahorras 450€ en impuestos por cada 1.500€ aportados.
- **Crecimiento sin tributación:** Los beneficios no tributan hasta que rescates el plan.
- **Traspasos sin tributación:** Puedes cambiar de plan sin pagar impuestos.

**Cuándo puedes rescatar el plan:**
- Jubilación (edad legal o anticipada)
- Incapacidad permanente absoluta o gran invalidez
- Fallecimiento del partícipe
- Desempleo de larga duración (después de 2 años)
- Enfermedad grave
- A partir de 2025, en determinadas circunstancias (reforma pendiente)

**Cómo elegir un plan de pensiones:**
1. **Define tu perfil de riesgo:** Conservador, moderado o agresivo.
2. **Compara comisiones:** Gestión (0,5-2% anual), depósito (0,1-0,3% anual), suscripción/reembolso.
3. **Revisa la rentabilidad histórica:** Aunque no garantiza rentabilidad futura, da una idea del comportamiento.
4. **Considera la solvencia de la entidad:** Especialmente importante para planes de aseguradoras.

**Estrategias de aportación:**
- **Aportación mensual:** Ideal para crear el hábito. Puedes programar transferencias automáticas.
- **Aportación anual:** Útil para optimizar fiscalmente (aportar en diciembre para desgravar en ese año).
- **Aportación variable:** Según tus posibilidades económicas.

**Ejemplo práctico:**
Luis, 40 años, tributa al 30% y aporta 1.500€ anuales a un plan de pensiones. Ahorra 450€ en impuestos cada año. Si mantiene esta aportación hasta los 65 años, habrá aportado 37.500€ pero habrá ahorrado 11.250€ en impuestos. Con una rentabilidad del 5% anual, tendrá unos 85.000€ a los 65 años.

**Productos disponibles en España:**
- **Santander:** Plan Santander Futuro, con diferentes perfiles de riesgo.
- **BBVA:** Plan BBVA Jubilación, con estrategias adaptadas a la edad.
- **CaixaBank:** Plan CaixaBank Pensiones, con fondos de gestión activa y pasiva.
- **ING:** Plan ING Direct Pensiones, con comisiones competitivas.
- **Openbank:** Plan Openbank Pensiones, con gestión digital.

**Errores comunes:**
- No aprovechar la desgravación fiscal anual.
- Elegir planes con comisiones muy altas que reducen la rentabilidad.
- No revisar el plan periódicamente y ajustarlo según la edad.
- Rescatar el plan antes de tiempo (pierdes las ventajas fiscales).

**Consejos prácticos:**
- Empieza a aportar cuanto antes: el tiempo es tu mejor aliado.
- Aprovecha la desgravación fiscal máxima cada año.
- Revisa tu plan cada 2-3 años y ajusta el perfil de riesgo según tu edad.
- Considera diversificar entre varios planes o entidades.
- No uses el plan como fondo de emergencia (pierdes las ventajas fiscales).

**Fiscalidad del rescate:**
Cuando rescates el plan, tributarás como rendimientos del trabajo. Las cantidades rescatadas se integran en la base imponible del IRPF. Es importante planificar los rescates para optimizar la tributación.

**Recuerda:** Los planes de pensiones son una excelente herramienta para ahorrar para la jubilación con ventajas fiscales, pero requieren un horizonte de largo plazo.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es la principal ventaja fiscal de los planes de pensiones?',
        options: ['No pagar impuestos', 'Desgravación en la declaración', 'Liquidez inmediata', 'Sin comisiones'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuánto puedes desgravar anualmente con un plan de pensiones en España?',
        options: ['Hasta 500€', 'Hasta 1.500€', 'Hasta 5.000€', 'Sin límite'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿En qué momento puedes rescatar normalmente un plan de pensiones?',
        options: ['Cuando quieras sin penalización', 'Al llegar a la jubilación', 'A los 5 años de apertura', 'Solo en caso de deuda'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Simula una inversión',
    shortDesc: 'Elige un activo y sigue su evolución durante un mes.',
    difficulty: 3,
    content: '''Simular una inversión es una excelente forma de aprender sin arriesgar dinero real. Te permite entender cómo funcionan los mercados, qué factores influyen en los precios y cómo gestionar las emociones que surgen al invertir.

**¿Cómo hacer la simulación?**
1. **Elige un activo:** Puede ser una acción española (Telefónica, Santander, BBVA, Inditex), un fondo de inversión, un ETF que replique el IBEX 35, o incluso una criptomoneda.
2. **Define tu inversión:** Decide cuánto "invertirías" (por ejemplo, 1.000€) y cuándo comprarías.
3. **Registra el seguimiento:** Anota el precio cada semana y analiza los movimientos.
4. **Investiga:** Lee noticias sobre la empresa, el sector o el mercado para entender por qué sube o baja.

**Activos recomendados para principiantes:**
- **Acciones del IBEX 35:** Telefónica, Santander, BBVA, Inditex, Iberdrola. Son empresas grandes y estables.
- **ETFs:** ETF que replique el IBEX 35 (ISIN: ES0000000000) o el MSCI World (mercado global).
- **Fondos de inversión:** Fondo Santander Mixto Moderado, Fondo BBVA Renta Variable España.
- **Criptomonedas:** Bitcoin o Ethereum (solo para entender la volatilidad extrema).

**Herramientas para el seguimiento:**
- **Apps de bancos:** Santander, BBVA, ING, CaixaBank, Sabadell, Openbank tienen apps con cotizaciones en tiempo real.
- **Páginas web:** Investing.com, Yahoo Finance, Morningstar España.
- **Apps especializadas:** TradingView, Investing.com, Yahoo Finance.

**Qué registrar cada semana:**
- Fecha y precio de cierre
- Variación semanal (en euros y porcentaje)
- Noticias relevantes que afecten al activo
- Tu reacción emocional (¿te asustas si baja? ¿te emocionas si sube?)
- Factores que influyen (resultados empresariales, noticias macroeconómicas, etc.)

**Análisis que debes hacer:**
- **Análisis técnico básico:** ¿El precio está subiendo o bajando? ¿Hay tendencias?
- **Análisis fundamental:** ¿Cómo van los resultados de la empresa? ¿Qué dicen las noticias?
- **Análisis emocional:** ¿Cómo te sientes cuando sube o baja? ¿Te tentaría vender o comprar más?

**Ejemplo de seguimiento:**
Semana 1: Compras "acciones" de Santander a 3,50€. Inviertes 1.000€ = 285,7 acciones.
Semana 2: Precio 3,45€. Valor: 985,7€. Pérdida: 14,3€ (-1,43%). Noticia: Santander presenta resultados trimestrales.
Semana 3: Precio 3,60€. Valor: 1.028,6€. Ganancia: 28,6€ (+2,86%). Noticia: Subida general del sector bancario.

**Lecciones que aprenderás:**
- **Volatilidad:** Los precios suben y bajan constantemente, a veces sin razón aparente.
- **Importancia de la información:** Las noticias y resultados empresariales afectan los precios.
- **Emociones:** Es fácil dejarse llevar por el miedo (cuando baja) o la euforia (cuando sube).
- **Horizonte temporal:** A corto plazo hay mucha volatilidad, pero a largo plazo las tendencias son más claras.

**Errores que evitarás en el futuro:**
- Vender en pánico cuando el precio baja temporalmente.
- Comprar compulsivamente cuando el precio sube mucho.
- No investigar antes de invertir.
- No tener un plan de inversión claro.

**Después del mes:**
- Analiza tu comportamiento: ¿fuiste racional o emocional?
- Identifica patrones: ¿qué noticias afectaron más al precio?
- Reflexiona: ¿qué harías diferente con dinero real?
- Decide: ¿te sientes preparado para invertir realmente?

**Consejos para la simulación:**
- Trata la simulación como si fuera dinero real: toma decisiones serias.
- No hagas trampa: si "compras" a un precio, mantén ese precio aunque luego baje.
- Documenta todo: será útil para analizar tu comportamiento.
- Comparte la experiencia: habla con otros sobre lo que aprendes.

**Recuerda:** La simulación es una excelente herramienta de aprendizaje, pero las emociones reales son diferentes cuando hay dinero de por medio. Usa esta experiencia para desarrollar disciplina y conocimiento antes de invertir realmente.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué debes hacer en este desafío?',
        options: ['Invertir dinero real', 'Simular y observar', 'Gastar más', 'No hacer nada'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué es el análisis fundamental en inversiones?',
        options: ['Mirar gráficos de precios', 'Analizar resultados y noticias de la empresa', 'Seguir recomendaciones de amigos', 'Adivinar el precio futuro'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué emoción es más dañina para el inversor según la lección?',
        options: ['La paciencia', 'La disciplina', 'Dejarse llevar por el miedo o la euforia', 'La prudencia'],
        correctIndex: 2,
      ),
    ],
  ),
];

final List<EduPill> budgetPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFE066),
    title: '¿Qué es un presupuesto?',
    shortDesc: 'La base de unas finanzas sanas.',
    difficulty: 1,
    content: '''Un presupuesto es una herramienta fundamental para tomar el control de tus finanzas. En España, muchas familias no llevan un control detallado de sus ingresos y gastos, lo que puede llevar a sorpresas desagradables a final de mes.

**¿Por qué hacer un presupuesto?**
Te permite saber exactamente cuánto dinero entra y sale cada mes, identificar gastos innecesarios y planificar para el futuro (vacaciones, imprevistos, compras importantes).

**Cómo hacerlo:**
- Anota todos tus ingresos (nómina, ayudas, alquileres, etc.). El salario medio neto en España ronda los 1.600€ al mes.
- Enumera todos tus gastos fijos (alquiler o hipoteca: 700-1.200€, suministros: 100€, alimentación: 250€, transporte: 50-100€, seguros, etc.) y variables (ocio, restaurantes, compras).
- Resta los gastos a los ingresos. Si el resultado es negativo, revisa en qué puedes recortar.

**Herramientas útiles:**
- Usa una hoja de cálculo, una app de finanzas (Fintonic, MoneyWiz) o la propia app de tu banco (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank permiten categorizar gastos y ver gráficos).

**Errores comunes:**
- Olvidar gastos anuales o trimestrales (impuestos, seguros, matrículas).
- No revisar el presupuesto cada mes.

**Consejo:** Involucra a toda la familia en la elaboración del presupuesto para que todos sean conscientes de la situación y colaboren en el ahorro.''',
    quizzes: [
      PillQuiz(
        question: '¿Para qué sirve un presupuesto?',
        options: ['Gastar más', 'Organizar ingresos y gastos', 'Pagar impuestos', 'Ahorrar menos'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuánto ronda el salario medio neto en España?',
        options: ['800€/mes', '1.600€/mes', '3.000€/mes', '500€/mes'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué debes hacer si tus gastos superan tus ingresos?',
        options: ['Pedir un préstamo', 'No hacer nada', 'Revisar y recortar gastos', 'Cambiar de trabajo inmediatamente'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFE066),
    title: 'Registra tus gastos',
    shortDesc: 'Llevar un registro ayuda a identificar fugas de dinero.',
    difficulty: 1,
    content: '''Registrar todos tus gastos, por pequeños que sean, es clave para detectar en qué se va tu dinero. En España, los gastos hormiga (cafés, lotería, snacks, apps) pueden sumar más de 500€ al año.

**¿Cómo hacerlo?**
- Guarda los tickets y revisa los movimientos de tu cuenta bancaria.
- Usa apps como Fintonic o la app de tu banco (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) para categorizar automáticamente los gastos.
- Hazlo cada día o al menos una vez por semana para no olvidar nada.

**Ventajas:**
- Descubrirás gastos que puedes eliminar o reducir.
- Te ayudará a negociar mejores tarifas (teléfono, luz, seguros).

**Errores comunes:**
- Dejar de registrar los gastos después de unos días.
- No ser honesto contigo mismo (no apuntar compras "capricho").

**Consejo:** Hazlo un hábito, como lavarte los dientes. ¡La constancia es la clave!''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué es útil registrar tus gastos?',
        options: ['Para gastar más', 'Para identificar fugas', 'Para pagar menos', 'Para invertir'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Con qué frecuencia deberías registrar tus gastos?',
        options: ['Una vez al año', 'Solo en navidades', 'Diariamente o al menos cada semana', 'Nunca'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué tipo de gastos suelen olvidarse más al hacer el registro?',
        options: ['El alquiler o hipoteca', 'Los pequeños gastos frecuentes', 'La nómina', 'Los impuestos anuales'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFE066),
    title: 'Prioriza necesidades',
    shortDesc: 'Diferencia entre necesidades y deseos.',
    difficulty: 2,
    content: '''Una de las claves del éxito financiero es saber distinguir entre necesidades (lo imprescindible para vivir) y deseos (lo que te gustaría tener pero no es esencial).

**Ejemplos de necesidades:**
- Vivienda, comida, suministros, transporte, salud.

**Ejemplos de deseos:**
- Restaurantes, ropa de marca, tecnología, viajes, ocio.

**¿Por qué es importante?**
En épocas de crisis o cuando el dinero escasea, priorizar las necesidades te permite mantener la estabilidad y evitar deudas innecesarias.

**Consejos:**
- Haz una lista de tus gastos y marca cuáles son necesidades y cuáles deseos.
- Si tienes que recortar, empieza por los deseos.

**Errores comunes:**
- Justificar deseos como necesidades ("necesito el último móvil para trabajar").
- Gastar primero en deseos y luego no llegar a fin de mes.

**Recuerda:** Satisfacer primero las necesidades te da tranquilidad y libertad para disfrutar de los deseos cuando sea posible.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué debes cubrir primero en tu presupuesto?',
        options: ['Deseos', 'Necesidades básicas', 'Viajes', 'Tecnología'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál de estos es un ejemplo de deseo (no necesidad)?',
        options: ['Alquiler de vivienda', 'Ropa de marca de lujo', 'Alimentación básica', 'Transporte al trabajo'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué puede ocurrir si gastas primero en deseos?',
        options: ['Ahorras más', 'Puede que no llegues a fin de mes', 'Mejora tu historial crediticio', 'Reduces impuestos'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFE066),
    title: 'Ajusta tu presupuesto',
    shortDesc: 'Revisa y ajusta tu presupuesto cada mes.',
    difficulty: 2,
    content: '''La vida cambia y tu presupuesto también debe hacerlo. Un mes puedes tener un gasto extra (ITV, dentista, comunión) y otro mes un ingreso extra (devolución de Hacienda, paga extra).

**¿Cómo ajustarlo?**
- Revisa tus ingresos y gastos cada mes.
- Si has gastado más de lo previsto, analiza por qué y corrige para el mes siguiente.
- Si has ahorrado más, decide si lo destinas a un objetivo (viaje, fondo de emergencia, inversión).

**Herramientas útiles:**
- Usa la app de tu banco (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) para ver gráficos y tendencias.
- Haz una reunión familiar mensual para revisar el presupuesto.

**Errores comunes:**
- No ajustar el presupuesto y repetir los mismos errores cada mes.
- No tener en cuenta los gastos estacionales (Navidad, vuelta al cole, vacaciones).

**Consejo:** Sé flexible, pero no pierdas de vista tus objetivos a largo plazo.''',
    quizzes: [
      PillQuiz(
        question: '¿Cada cuánto debes revisar tu presupuesto?',
        options: ['Cada año', 'Cada mes', 'Nunca', 'Cada semana'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: 'Si un mes ahorras más de lo planeado, ¿qué deberías hacer?',
        options: ['Gastarlo en caprichos', 'Destinarlo a un objetivo financiero', 'Ignorarlo', 'Devolverlo al banco'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué son los gastos estacionales?',
        options: ['Gastos que ocurren en ciertas épocas del año', 'Gastos de temporada de rebajas', 'Impuestos trimestrales', 'Cuotas de seguros'],
        correctIndex: 0,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFFFE066),
    title: 'Crea tu presupuesto',
    shortDesc: 'Haz tu propio presupuesto mensual.',
    difficulty: 3,
    content: '''El mejor ejercicio para aprender a gestionar tu dinero es crear tu propio presupuesto desde cero.

**¿Cómo hacerlo?**
1. Anota todos tus ingresos y gastos durante un mes.
2. Clasifica los gastos en necesidades y deseos.
3. Busca al menos un gasto que puedas reducir o eliminar.
4. Fija un objetivo de ahorro mensual (aunque sea pequeño).

**Herramientas:**
- Usa una hoja de cálculo, una libreta o una app.
- Bancos como Santander, BBVA, ING, CaixaBank, Sabadell y Openbank ofrecen plantillas y recursos en sus webs para ayudarte.

**Errores comunes:**
- No ser realista (subestimar gastos, sobreestimar ingresos).
- No revisar el presupuesto después de crearlo.

**Consejo:** Comparte tu presupuesto con alguien de confianza para recibir feedback y motivación.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué herramienta puedes usar para hacer tu presupuesto?',
        options: ['Hoja de cálculo', 'Red social', 'Juego', 'Ninguna'],
        correctIndex: 0,
      ),
      PillQuiz(
        question: '¿Cuál es el error más común al crear un presupuesto?',
        options: ['Ser demasiado estricto', 'Subestimar los gastos', 'Usar apps financieras', 'Involucrar a la familia'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es el primer paso para crear tu presupuesto mensual?',
        options: ['Buscar inversiones', 'Anotar todos los ingresos y gastos durante un mes', 'Abrir una cuenta nueva', 'Pedir asesoramiento a un banco'],
        correctIndex: 1,
      ),
    ],
  ),
];

final List<EduPill> entrepreneurshipPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFB57EDC),
    title: '¿Qué es emprender?',
    shortDesc: 'Conceptos básicos de emprendimiento.',
    difficulty: 1,
    content: '''Emprender significa crear un negocio propio, asumir riesgos y buscar oportunidades para ofrecer productos o servicios que resuelvan problemas o satisfagan necesidades. En España, el emprendimiento ha crecido en la última década, aunque sigue habiendo barreras culturales y administrativas.

**¿Por qué emprender?**
- Para ser tu propio jefe y tomar tus propias decisiones.
- Para desarrollar una idea innovadora o mejorar algo que ya existe.
- Para tener flexibilidad y potencial de mayores ingresos a largo plazo.

**Pasos para emprender en España:**
1. Detecta una oportunidad: observa tu entorno, escucha a la gente, identifica problemas sin resolver.
2. Elabora un plan de negocio: define tu propuesta de valor, público objetivo, competencia, modelo de ingresos y gastos.
3. Elige la forma jurídica: autónomo, sociedad limitada, cooperativa, etc. Cada una tiene ventajas e inconvenientes fiscales y legales.
4. Busca financiación: ahorros propios, préstamos bancarios (Santander, BBVA, CaixaBank, Sabadell, ING y Openbank tienen líneas para emprendedores), ayudas públicas (ENISA, ICO, programas autonómicos), inversores privados.
5. Da de alta tu actividad: tramita el alta en Hacienda y Seguridad Social, y cumple con la normativa sectorial.

**Errores comunes:**
- No validar la idea antes de invertir mucho dinero.
- No calcular bien los costes y los impuestos (cuota de autónomos desde 80€ a 294€ según ingresos, IVA, IRPF, etc.).
- No separar las finanzas personales de las del negocio.

**Consejo:** Rodéate de otros emprendedores, busca asesoramiento en cámaras de comercio, asociaciones y bancos, y no temas fracasar: cada error es un aprendizaje.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué significa emprender?',
        options: ['Crear un negocio', 'Gastar dinero', 'Ahorrar', 'Invertir'],
        correctIndex: 0,
      ),
      PillQuiz(
        question: '¿Cuál es el primer paso para emprender en España según la lección?',
        options: ['Pedir un préstamo', 'Detectar una oportunidad', 'Registrar la empresa', 'Contratar empleados'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué forma jurídica es la más habitual para un emprendedor individual en España?',
        options: ['Sociedad Anónima (SA)', 'Autónomo', 'Cooperativa', 'Fundación'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFB57EDC),
    title: 'Detecta oportunidades',
    shortDesc: 'Observa problemas y necesidades a tu alrededor.',
    difficulty: 1,
    content: '''Detectar oportunidades es el primer paso para emprender con éxito. En España, muchos negocios surgen de necesidades locales o cambios en la sociedad (digitalización, envejecimiento, sostenibilidad).

**¿Cómo detectar oportunidades?**
- Escucha a tus amigos, familiares y clientes potenciales: ¿de qué se quejan? ¿Qué les gustaría que existiera?
- Observa tendencias: digitalización, economía verde, envejecimiento de la población, turismo sostenible.
- Analiza la competencia: ¿qué hacen bien y qué podrías mejorar?

**Ejemplo español:** El auge de las apps de reparto, los negocios de comida saludable o los servicios para mayores son respuestas a cambios sociales en España.

**Errores comunes:**
- Emprender solo por moda, sin analizar si hay demanda real.
- No adaptar la idea al contexto local (idioma, cultura, legislación).

**Consejo:** Haz encuestas, prototipos y prueba tu idea con clientes reales antes de invertir mucho dinero. Consulta recursos de bancos como Santander, BBVA, y Openbank, así como cámaras de comercio y asociaciones de emprendedores.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué hace un buen emprendedor?',
        options: ['Ignora problemas', 'Detecta oportunidades', 'Gasta mucho', 'No escucha'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es una buena forma de detectar oportunidades de negocio?',
        options: ['Copiar una idea sin adaptarla', 'Observar tendencias y necesidades del mercado', 'Esperar a que alguien te diga qué hacer', 'Ignorar a la competencia'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué debes hacer antes de invertir mucho dinero en una idea?',
        options: ['Lanzarla directamente al mercado', 'Validarla con clientes reales', 'Registrar la patente', 'Contratar un equipo grande'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFB57EDC),
    title: 'Plan de negocio',
    shortDesc: 'La importancia de planificar antes de empezar.',
    difficulty: 2,
    content: '''Un plan de negocio es el documento que recoge la idea, el análisis de mercado, la estrategia, los recursos necesarios y las previsiones económicas de tu proyecto. En España, es fundamental para solicitar financiación (bancos, ayudas públicas) y para tener claro el camino a seguir.

**¿Qué debe incluir un buen plan de negocio?**
- Descripción de la idea y propuesta de valor.
- Análisis de mercado: clientes, competencia, tendencias.
- Estrategia comercial y de marketing.
- Plan de operaciones: recursos humanos, proveedores, logística.
- Previsión de ingresos, gastos y beneficios.
- Análisis de riesgos y plan de contingencia.

**Consejos prácticos:**
- Usa plantillas gratuitas (Santander, BBVA, CaixaBank).
- Sé realista con las cifras y no sobreestimes los ingresos.
- Pide feedback a otros emprendedores o mentores.

**Errores comunes:**
- No actualizar el plan cuando cambian las circunstancias.
- Hacerlo solo para pedir un préstamo y luego olvidarlo.

**Recuerda:** Un buen plan de negocio es tu hoja de ruta y te ayuda a anticipar problemas antes de que ocurran.''',
    quizzes: [
      PillQuiz(
        question: '¿Para qué sirve un plan de negocio?',
        options: ['Para improvisar', 'Para planificar y guiar el negocio', 'Para gastar más', 'Para evitar clientes'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué elemento es imprescindible en un buen plan de negocio?',
        options: ['Un logo bonito', 'Previsiones de ingresos y gastos', 'Una cuenta de Instagram', 'Un préstamo ya aprobado'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuándo debes actualizar tu plan de negocio?',
        options: ['Nunca, solo se hace una vez', 'Cuando cambien las circunstancias', 'Solo al pedir financiación', 'Cada 10 años'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFB57EDC),
    title: 'Aprende de los errores',
    shortDesc: 'El fracaso es parte del aprendizaje.',
    difficulty: 2,
    content: '''En el mundo del emprendimiento, el error y el fracaso son inevitables y forman parte del proceso de aprendizaje. En España, la cultura del miedo al fracaso está cambiando, pero aún cuesta asumirlo como algo natural.

**¿Por qué es importante aprender de los errores?**
- Cada error te da información valiosa para mejorar tu negocio.
- Los grandes emprendedores han fracasado varias veces antes de tener éxito.
- Compartir tus errores con otros puede ayudarles a no cometer los mismos.

**Consejos prácticos:**
- Analiza cada error: ¿qué salió mal? ¿qué podrías haber hecho diferente?
- No te castigues: céntrate en la solución, no en el problema.
- Rodéate de una red de apoyo (otros emprendedores, asociaciones, mentores, bancos como Santander, BBVA, CaixaBank, ING, Sabadell, Openbank que ofrecen asesoramiento).

**Errores comunes:**
- Ocultar los errores por vergüenza.
- No cambiar nada después de un fracaso.

**Recuerda:** El fracaso no es el final, es una oportunidad para empezar de nuevo con más experiencia.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué debes hacer si fracasas en tu emprendimiento?',
        options: ['Rendirse', 'Aprender y mejorar', 'Ignorar', 'Culpar a otros'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Por qué es valioso compartir los errores con otros emprendedores?',
        options: ['Para presumir', 'Para que no cometan los mismos errores', 'Para conseguir clientes', 'No tiene ningún valor'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es la actitud correcta ante un error en tu negocio?',
        options: ['Ocultarlo por vergüenza', 'Analizarlo y buscar la solución', 'Cerrar el negocio inmediatamente', 'Ignorarlo y seguir igual'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFB57EDC),
    title: 'Crea tu pitch',
    shortDesc: 'Resume tu idea de negocio en 1 minuto.',
    difficulty: 3,
    content: '''Un pitch es una presentación breve y clara de tu negocio, pensada para captar la atención de inversores, clientes o colaboradores. En España, cada vez es más habitual participar en concursos de pitch o presentaciones ante inversores.

**¿Cómo hacer un buen pitch?**
- Explica el problema que resuelves y por qué es importante.
- Presenta tu solución de forma sencilla y atractiva.
- Habla de tu equipo y por qué sois los mejores para llevarlo a cabo.
- Muestra el potencial de crecimiento y el modelo de negocio.
- Termina con una llamada a la acción (invertir, colaborar, probar el producto).

**Consejos prácticos:**
- Practica tu pitch hasta poder hacerlo en menos de 1 minuto.
- Usa ejemplos y datos concretos.
- Adapta el mensaje al público (inversores, clientes, jurado).
- Consulta recursos y programas de aceleración de bancos como Santander, BBVA, CaixaBank, Sabadell, ING y Openbank, así como de cámaras de comercio y asociaciones de emprendedores.

**Errores comunes:**
- Hablar demasiado de la idea y poco del mercado o del equipo.
- No transmitir pasión ni confianza.

**Recuerda:** Un buen pitch puede abrirte muchas puertas, pero solo si eres capaz de transmitir tu visión de forma clara y convincente.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué es un pitch?',
        options: ['Un plan largo', 'Una presentación breve', 'Un producto', 'Un cliente'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuánto debe durar un buen pitch según la lección?',
        options: ['10 minutos', '5 minutos', 'Menos de 1 minuto', 'Más de 30 minutos'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué es lo más importante que debes transmitir en un pitch?',
        options: ['El precio de tu producto', 'El problema que resuelves y tu solución', 'Tu currículum', 'Las redes sociales de tu empresa'],
        correctIndex: 1,
      ),
    ],
  ),
];

final List<EduPill> debtPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFA07A),
    title: 'Deuda buena vs mala',
    shortDesc: 'No todas las deudas son iguales.',
    difficulty: 1,
    content: '''En España, como en otros países, no todas las deudas son iguales. Es fundamental distinguir entre deuda buena y deuda mala para tomar decisiones financieras inteligentes.

**Deuda buena:**
- Es la que te ayuda a generar ingresos o a aumentar tu patrimonio a largo plazo.
- Ejemplos: hipoteca para comprar una vivienda habitual (tipo fijo o variable, con bancos como Santander, BBVA, CaixaBank, ING, Sabadell, Openbank), préstamo para estudios universitarios o máster, financiación para montar un negocio rentable.
- Suele tener tipos de interés bajos (hipotecas desde el 2,5% TAE en 2024) y plazos largos.

**Deuda mala:**
- Es la que se utiliza para consumir bienes o servicios que no generan valor a futuro.
- Ejemplos: compras con tarjeta de crédito a plazos, préstamos rápidos para vacaciones, financiar un coche de alta gama sin necesitarlo.
- Suele tener intereses altos (tarjetas de crédito 15-25% TAE, préstamos rápidos hasta 30% TAE) y puede llevarte al sobreendeudamiento.

**Consejos prácticos:**
- Antes de pedir un préstamo, pregúntate: ¿esto me ayudará a mejorar mi situación financiera en el futuro?
- Compara siempre las condiciones (TAE, comisiones, plazos) entre bancos. Santander, BBVA, CaixaBank, ING, Sabadell y Openbank ofrecen simuladores online para comparar préstamos.

**Errores comunes:**
- Pedir préstamos para tapar otros préstamos (efecto bola de nieve).
- No leer la letra pequeña de los contratos.

**Recuerda:** La deuda puede ser una herramienta útil si se usa con cabeza, pero puede convertirse en un problema si se abusa de ella.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es un ejemplo de deuda buena?',
        options: ['Tarjeta de crédito', 'Hipoteca para vivienda', 'Préstamo para vacaciones', 'Compra de ropa'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿A qué TAE pueden llegar los préstamos rápidos en España?',
        options: ['2%', '5%', '15%', 'Hasta el 30%'],
        correctIndex: 3,
      ),
      PillQuiz(
        question: 'Antes de pedir un préstamo, ¿qué pregunta clave debes hacerte?',
        options: ['¿Es el banco más grande?', '¿Me ayudará a mejorar mi situación financiera?', '¿Lo piden mis amigos?', '¿Tiene buena publicidad?'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFA07A),
    title: 'Método bola de nieve',
    shortDesc: 'Ordena tus deudas y págales en orden.',
    difficulty: 2,
    content: '''El método bola de nieve es una estrategia muy eficaz para salir de deudas, especialmente si tienes varias a la vez (tarjetas, préstamos personales, etc.).

**¿Cómo funciona?**
1. Haz una lista de todas tus deudas, de menor a mayor importe pendiente.
2. Paga el mínimo en todas, excepto en la más pequeña, a la que destinas todo el dinero extra que puedas.
3. Cuando la liquides, pasa al siguiente préstamo más pequeño, y así sucesivamente.

**Ventajas:**
- Te motiva ver resultados rápidos (deudas que desaparecen).
- Libera dinero para atacar la siguiente deuda.

**Ejemplo español:** Si tienes una tarjeta de crédito con 500€, un préstamo personal de 2.000€ y una deuda familiar de 1.000€, empieza por la tarjeta, luego la deuda familiar y por último el préstamo. Puedes usar la app de tu banco (Santander, BBVA, CaixaBank, ING, Sabadell, Openbank) para programar pagos automáticos y no olvidar ninguna cuota.

**Errores comunes:**
- No dejar de usar las tarjetas mientras pagas las deudas.
- No ajustar el presupuesto para evitar nuevas deudas.

**Consejo:** Si tienes dudas, consulta con el servicio de atención al cliente de tu banco o con asociaciones de ayuda al endeudado como ADICAE, OCU o la propia banca online.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué deuda debes pagar primero con el método bola de nieve?',
        options: ['La más grande', 'La más pequeña', 'La de menor interés', 'La de mayor interés'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué haces con las demás deudas mientras aplicas el método bola de nieve?',
        options: ['Las ignoras', 'Las cancelas todas a la vez', 'Pagas solo el mínimo en ellas', 'Las renegocias'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cuál es la principal motivación psicológica del método bola de nieve?',
        options: ['Pagar menos intereses', 'Ver resultados rápidos al eliminar deudas pequeñas', 'Mejorar el historial crediticio', 'Obtener mejores condiciones bancarias'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFA07A),
    title: 'Historial crediticio',
    shortDesc: 'La importancia de un buen historial.',
    difficulty: 2,
    content: '''El historial crediticio es el registro de cómo has gestionado tus deudas y pagos a lo largo del tiempo. En España, este historial es consultado por bancos y entidades financieras antes de concederte un préstamo, una hipoteca o incluso un contrato de telefonía.

**¿Por qué es importante?**
- Un buen historial te permite acceder a mejores condiciones de financiación (intereses más bajos, mayor importe, menos comisiones).
- Un mal historial (impagos, retrasos, deudas en ASNEF) puede cerrarte muchas puertas.

**¿Cómo se construye y mantiene?**
- Paga siempre tus recibos y cuotas a tiempo.
- No abuses de las tarjetas de crédito ni de los préstamos rápidos.
- Si tienes problemas para pagar, habla con tu banco antes de que la deuda se agrave. Santander, BBVA, CaixaBank, ING, Sabadell y Openbank ofrecen servicios de asesoramiento para clientes con dificultades.

**Errores comunes:**
- Ignorar cartas o avisos de impago.
- Pedir préstamos a nombre de otra persona.

**Consejo:** Consulta tu historial en ficheros como ASNEF o CIRBE (Banco de España) para saber si tienes incidencias. Los bancos pueden ayudarte a mejorar tu perfil crediticio con productos adaptados y consejos personalizados.''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué es importante el historial crediticio?',
        options: ['Para obtener mejores préstamos', 'Para gastar más', 'Para evitar ahorrar', 'No es importante'],
        correctIndex: 0,
      ),
      PillQuiz(
        question: '¿Cuál es el fichero de morosos más conocido en España?',
        options: ['CIRBE', 'ASNEF', 'SEPE', 'CNMV'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué debes hacer si tienes problemas para pagar una deuda?',
        options: ['Ignorar las cartas del banco', 'Esperar a que prescriba', 'Hablar con tu banco antes de que la deuda se agrave', 'Pedir otro préstamo'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFA07A),
    title: 'Evita el sobreendeudamiento',
    shortDesc: 'No pidas más de lo que puedes pagar.',
    difficulty: 2,
    content: '''El sobreendeudamiento ocurre cuando tus deudas superan tu capacidad de pago. En España, esto puede llevar a embargos, inclusión en listas de morosos y graves problemas financieros y personales.

**¿Cómo evitarlo?**
- No pidas préstamos para cubrir otros préstamos (efecto bola de nieve).
- Calcula tu ratio de endeudamiento: la suma de tus cuotas mensuales no debe superar el 35-40% de tus ingresos netos. Compara ofertas de bancos como Santander, BBVA, CaixaBank, ING, Sabadell y Openbank.

**Errores comunes:**
- Usar tarjetas de crédito para gastos cotidianos y no pagar el total a fin de mes.
- No tener un fondo de emergencia y recurrir siempre al crédito.

**Consejo:** Si ya tienes problemas, acude a tu banco o a asociaciones de ayuda al endeudado (ADICAE, OCU) para buscar soluciones antes de que sea tarde.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué debes evitar al usar crédito?',
        options: ['Pedir más de lo necesario', 'Pagar a tiempo', 'Comparar opciones', 'Ahorrar'],
        correctIndex: 0,
      ),
      PillQuiz(
        question: '¿Qué porcentaje máximo de tus ingresos deben representar las cuotas mensuales de deuda?',
        options: ['10-15%', '20-25%', '35-40%', '60-70%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué ocurre si usas tarjetas de crédito para gastos diarios y no pagas el total a fin de mes?',
        options: ['Mejora tu historial', 'Acumulas deuda con intereses altos', 'Recibes puntos de fidelidad gratis', 'No ocurre nada'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFFFA07A),
    title: 'Auditoría de deudas',
    shortDesc: 'Haz una lista de todas tus deudas.',
    difficulty: 3,
    content: '''Hacer una auditoría de deudas es el primer paso para tomar el control de tu situación financiera. Consiste en recopilar toda la información sobre tus deudas y analizarla para tomar decisiones.

**¿Cómo hacerla?**
1. Haz una lista de todas tus deudas: importe pendiente, tipo de interés, cuota mensual, plazo restante, entidad.
2. Ordena las deudas por importe, tipo de interés o urgencia.
3. Calcula el total de tu deuda y el coste mensual.
4. Analiza si puedes renegociar condiciones, reunificar deudas o buscar mejores ofertas. Bancos como Santander, BBVA, CaixaBank, ING, Sabadell y Openbank ofrecen simuladores y asesores para ayudarte a gestionar tus deudas.

**Errores comunes:**
- Olvidar deudas pequeñas (tarjetas, tiendas, familiares).
- No revisar los extractos bancarios y contratos.

**Consejo:** Usa una hoja de cálculo o una app para llevar el control. Consulta con tu banco y con asociaciones de consumidores para encontrar la mejor solución a tu caso.''',
    quizzes: [
      PillQuiz(
        question: '¿Para qué sirve una auditoría de deudas?',
        options: ['Para gastar más', 'Para conocer y priorizar pagos', 'Para pedir más préstamos', 'No sirve'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué información debes incluir en tu lista de deudas?',
        options: ['Solo el nombre del banco', 'Importe, interés, cuota mensual y entidad', 'Solo la cuota mensual', 'El número de la tarjeta'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué puedes hacer si detectas deudas con malas condiciones?',
        options: ['Ignorarlas', 'Renegociar o reunificarlas', 'Pedir más crédito', 'Cancelar todas las cuentas'],
        correctIndex: 1,
      ),
    ],
  ),
];

final List<EduPill> insurancePills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED9C2),
    title: '¿Qué es un seguro?',
    shortDesc: 'Protege tu patrimonio y tu salud.',
    difficulty: 1,
    content: '''Un seguro es un contrato por el cual una compañía (aseguradora) se compromete a indemnizarte o prestarte un servicio si ocurre un evento adverso (accidente, robo, enfermedad, etc.), a cambio del pago de una prima.

**¿Por qué son importantes los seguros en España?**
- El sistema público cubre muchas cosas (salud, pensiones), pero no todo. Un seguro te protege ante imprevistos que pueden tener un gran impacto económico.
- Ejemplo: un seguro de hogar cubre daños por incendio, robo o agua; un seguro de salud te da acceso rápido a especialistas; un seguro de vida protege a tu familia si tú faltas.

**Tipos de seguros más comunes:**
- Seguro de hogar: obligatorio si tienes hipoteca. Cubre daños materiales y responsabilidad civil. Ofrecido por bancos como Santander, BBVA, CaixaBank, Sabadell y aseguradoras como Mapfre, Mutua Madrileña, Línea Directa.
- Seguro de salud: complementa la sanidad pública, permite elegir médico y hospital. Compara ofertas de Santander, Adeslas, Sanitas, DKV, Asisa, BBVA, CaixaBank, ING, Sabadell.
- Seguro de vida: garantiza un capital a tus beneficiarios en caso de fallecimiento. Disponible en Santander, BBVA, CaixaBank, Sabadell, Mapfre, Mutua Madrileña, etc.
- Seguro de coche: obligatorio para circular. Elige entre terceros, terceros ampliado o todo riesgo. Compara precios y coberturas en bancos y aseguradoras.

**Errores comunes:**
- Contratar seguros sin comparar coberturas y precios.
- No revisar las condiciones y exclusiones.
- No actualizar los capitales asegurados con el tiempo.

**Consejo:** Antes de contratar, pide varias ofertas (Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Mutua Madrileña, Línea Directa, etc.) y revisa bien qué cubre y qué no. Un seguro barato puede salir caro si no cubre lo que necesitas.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es la función principal de un seguro?',
        options: ['Ganar dinero', 'Proteger ante imprevistos', 'Ahorrar', 'Invertir'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál de estos seguros es obligatorio por ley en España?',
        options: ['Seguro de vida', 'Seguro de salud', 'Seguro del coche', 'Seguro del hogar'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué es la prima de un seguro?',
        options: ['La indemnización que recibes', 'El pago que haces a la aseguradora', 'La franquicia', 'El contrato del seguro'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED9C2),
    title: 'Seguro de salud',
    shortDesc: 'La importancia de estar cubierto.',
    difficulty: 1,
    content: '''En España, la sanidad pública es de calidad, pero en ocasiones hay listas de espera largas o no se cubren ciertos tratamientos. Un seguro de salud privado te permite acceder más rápido a especialistas, pruebas diagnósticas y tratamientos.

**Ventajas de un seguro de salud privado:**
- Elección de médico y hospital.
- Rapidez en consultas y operaciones.
- Cobertura de servicios no incluidos en la sanidad pública (fisioterapia, psicología, etc.).

**Errores comunes:**
- Contratar el seguro solo por el precio, sin mirar coberturas.
- No declarar enfermedades preexistentes (puede ser motivo de exclusión).

**Consejo:** Compara varias compañías y bancos (Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Sanitas, Adeslas, DKV, Asisa, Mutua Madrileña) y elige la que mejor se adapte a tus necesidades y presupuesto. Lee bien las condiciones y periodos de carencia.''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué es importante el seguro de salud?',
        options: ['Por obligación', 'Para evitar deudas por emergencias', 'Para viajar', 'No es importante'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué ventaja principal ofrece un seguro de salud privado en España?',
        options: ['Es más barato que la sanidad pública', 'Elección de médico y rapidez en la atención', 'Cubre todos los tratamientos', 'Es obligatorio contratarlo'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué debes declarar obligatoriamente al contratar un seguro de salud?',
        options: ['Tu salario', 'Las enfermedades preexistentes', 'Tu historial crediticio', 'El número de hijos'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED9C2),
    title: 'Seguro de vida',
    shortDesc: 'Protege a tu familia en caso de fallecimiento.',
    difficulty: 2,
    content: '''El seguro de vida es un producto que garantiza un capital o una renta a los beneficiarios designados en caso de fallecimiento del asegurado. En España, es especialmente recomendable si tienes hijos, pareja o personas a tu cargo.

**¿Por qué contratar un seguro de vida?**
- Para que tu familia pueda mantener su nivel de vida si tú faltas.
- Para cubrir deudas pendientes (hipoteca, préstamos).
- Para dejar un respaldo económico ante imprevistos graves.

**Tipos de seguro de vida:**
- Riesgo puro: solo cubre fallecimiento.
- Vida ahorro: combina protección y ahorro/inversión.

**Errores comunes:**
- No actualizar los beneficiarios tras cambios familiares (divorcio, nacimiento de hijos).
- Contratar un capital insuficiente.

**Consejo:** Calcula bien el capital necesario (deudas + gastos familiares x años) y revisa las condiciones cada cierto tiempo. Santander, BBVA, CaixaBank, Sabadell, Mapfre, Mutua Madrileña y otras entidades ofrecen simuladores online para ayudarte.''',
    quizzes: [
      PillQuiz(
        question: '¿Para quién es útil el seguro de vida?',
        options: ['Solo para solteros', 'Para quienes tienen dependientes', 'Para todos', 'No es útil'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué tipo de seguro de vida combina protección con ahorro o inversión?',
        options: ['Seguro de riesgo puro', 'Seguro vida ahorro', 'Seguro de accidentes', 'Seguro de hogar'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuándo debes actualizar los beneficiarios de tu seguro de vida?',
        options: ['Nunca, el contrato es fijo', 'Tras cambios familiares como divorcio o nacimiento de hijos', 'Cada 10 años sin excepción', 'Solo si cambia el precio'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED9C2),
    title: 'Compara seguros',
    shortDesc: 'No todos los seguros son iguales.',
    difficulty: 2,
    content: '''No todos los seguros ofrecen las mismas coberturas ni cuestan lo mismo. Comparar es fundamental para no pagar de más ni quedarte corto de protección.

**¿Qué debes comparar?**
- Coberturas incluidas y excluidas.
- Límites de indemnización y franquicias.
- Precio de la prima y posibles subidas.
- Servicio de atención al cliente y facilidad de gestión de siniestros.

**Errores comunes:**
- Contratar el seguro más barato sin mirar coberturas.
- No preguntar por las exclusiones (lo que NO cubre el seguro).

**Consejo:** Usa comparadores online, pide varias ofertas y consulta opiniones de otros clientes. Bancos y aseguradoras como Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Mutua Madrileña, Línea Directa y otras tienen simuladores y atención personalizada.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué debes hacer antes de contratar un seguro?',
        options: ['Contratar el primero', 'Comparar opciones', 'No leer condiciones', 'Pagar más'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué son las exclusiones en un seguro?',
        options: ['Los servicios incluidos', 'Lo que NO cubre el seguro', 'Las cuotas mensuales', 'Los beneficiarios'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué es la franquicia en un seguro?',
        options: ['El precio anual del seguro', 'La parte del daño que pagas tú antes de que actúe el seguro', 'El beneficio extra que recibes', 'El número de póliza'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF7ED9C2),
    title: 'Revisa tus pólizas',
    shortDesc: 'Asegúrate de estar bien cubierto.',
    difficulty: 3,
    content: '''Revisar tus pólizas de seguro periódicamente es clave para no llevarte sorpresas desagradables cuando más lo necesitas.

**¿Por qué revisarlas?**
- Tu situación personal cambia (nacimiento de hijos, mudanza, compra de coche nuevo, etc.).
- Las condiciones y precios de los seguros pueden variar cada año.
- Puedes encontrar mejores ofertas o coberturas más adecuadas.

**¿Cómo hacerlo?**
- Haz una lista de todos tus seguros (hogar, vida, salud, coche, etc.).
- Revisa las coberturas, capitales asegurados y exclusiones.
- Contacta con tu aseguradora o banco (Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Mutua Madrileña, Línea Directa, etc.) para resolver dudas o actualizar datos.

**Errores comunes:**
- No revisar nunca las pólizas y descubrir tarde que no cubren lo necesario.
- Pagar de más por coberturas que no necesitas.

**Consejo:** Marca en tu calendario una fecha al año para revisar todos tus seguros. Puedes pedir ayuda a tu banco, aseguradora o corredor de seguros para comparar y actualizar tus pólizas.''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué revisar tus pólizas regularmente?',
        options: ['Por costumbre', 'Para actualizar coberturas', 'Para pagar más', 'No es necesario'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Con qué frecuencia se recomienda revisar tus seguros?',
        options: ['Cada semana', 'Al menos una vez al año', 'Cada 5 años', 'Solo cuando tengas un siniestro'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué puede cambiar en tu póliza entre renovaciones anuales?',
        options: ['El número de póliza', 'El precio de la prima', 'El nombre de la aseguradora', 'El banco asociado'],
        correctIndex: 1,
      ),
    ],
  ),
];

// ── Planificación Financiera ──────────────────────────────────────────────────
final List<EduPill> planningPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF4FC3F7),
    title: 'Establece metas financieras',
    shortDesc: 'Sin objetivos claros, el dinero se escapa sin rumbo.',
    difficulty: 1,
    content: '''Una meta financiera es un objetivo concreto al que destinas dinero de forma planificada. Sin metas, el dinero simplemente desaparece.

**Tipos de metas:**
- **Corto plazo (menos de 1 año):** Fondo de emergencia, vacaciones, nuevo móvil.
- **Medio plazo (1-5 años):** Depósito para vivienda, coche, formación.
- **Largo plazo (más de 5 años):** Jubilación, independencia financiera, educación de los hijos.

**Cómo escribir una buena meta (método SMART):**
- **S**pecífica: "Ahorrar 5.000€ para la entrada de un piso" en lugar de "quiero ahorrar".
- **M**edible: con una cifra concreta.
- **A**lcanzable: realista con tus ingresos.
- **R**elevante: que de verdad te importe.
- **T**emporal: con una fecha límite.

**Ejemplo práctico:** Si quieres ahorrar 3.000€ en 12 meses, debes guardar 250€ al mes. Comprueba si es posible con tu presupuesto actual.

**Consejo:** Escribe tus metas y ponlas en algún lugar visible. Recuerda que los bancos españoles como ING o Openbank permiten crear "sobres" o subcuentas por objetivo, lo que facilita mucho el seguimiento.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué caracteriza a una buena meta financiera según el método SMART?',
        options: ['Es vaga y general', 'Es específica y tiene fecha límite', 'Solo depende de tu ánimo', 'No necesita cifras'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es un ejemplo de meta de largo plazo?',
        options: ['Pagar el móvil este mes', 'Ahorrar para las vacaciones de verano', 'Planificar la jubilación', 'Comprar ropa nueva'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: 'Si quieres ahorrar 3.000€ en 12 meses, ¿cuánto debes guardar cada mes?',
        options: ['100€', '150€', '200€', '250€'],
        correctIndex: 3,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF4FC3F7),
    title: 'Corto, medio y largo plazo',
    shortDesc: 'Aprende a equilibrar tus objetivos en el tiempo.',
    difficulty: 1,
    content: '''Gestionar bien tus finanzas implica tener objetivos en los tres horizontes temporales al mismo tiempo, no solo uno.

**¿Por qué los tres horizontes?**
- Si solo piensas a corto plazo, nunca acumulas riqueza.
- Si solo piensas a largo plazo, descuidas necesidades inmediatas y pierdes motivación.
- El equilibrio entre los tres es la base de una planificación financiera sana.

**Cómo distribuir tus ahorros:**
Una estrategia sencilla es dividir tu ahorro mensual en tres partes:
- 40% → corto plazo (fondo de emergencia, gastos previstos)
- 30% → medio plazo (vivienda, formación, coche)
- 30% → largo plazo (jubilación, inversión)

**Ejemplo real:**
Si ahorras 300€ al mes: 120€ para corto, 90€ para medio, 90€ para largo.

**Herramientas en España:**
- Corto plazo: cuenta de ahorro o depósito a plazo fijo.
- Medio plazo: fondos de inversión conservadores.
- Largo plazo: plan de pensiones o fondo indexado.

**Consejo:** Revisa y ajusta la distribución cada año según tu situación vital.''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué es importante tener metas en los tres horizontes temporales?',
        options: ['Para complicar las finanzas', 'Para equilibrar necesidades inmediatas y futuras', 'Porque lo exige el banco', 'Solo importa el largo plazo'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué producto es más adecuado para el ahorro a largo plazo en España?',
        options: ['Cuenta corriente sin intereses', 'Efectivo en casa', 'Plan de pensiones o fondo indexado', 'Lotería'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: 'Si ahorras 300€/mes y destinas el 30% al largo plazo, ¿cuánto es?',
        options: ['30€', '60€', '90€', '150€'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF4FC3F7),
    title: 'Crea tu plan financiero',
    shortDesc: 'Un plan en papel vale más que mil intenciones.',
    difficulty: 2,
    content: '''Un plan financiero personal es un documento o hoja de cálculo donde defines tu situación actual, tus objetivos y los pasos concretos para alcanzarlos.

**Pasos para crear tu plan:**
1. **Inventario actual:** Anota todos tus activos (lo que tienes: ahorro, inversiones, inmuebles) y pasivos (lo que debes: hipoteca, préstamos, tarjetas).
2. **Balance neto:** Activos − Pasivos. Si es positivo, vas bien; si es negativo, necesitas actuar.
3. **Flujo de caja mensual:** Ingresos − Gastos. El excedente es lo que puedes destinar a tus metas.
4. **Metas priorizadas:** Ordena tus objetivos por urgencia e importancia.
5. **Estrategia:** ¿Cuánto ahorrar? ¿Dónde? ¿Cuándo empezar?
6. **Seguimiento:** Revisa el plan cada 3-6 meses.

**Herramientas gratuitas:**
- Hojas de cálculo (Google Sheets, Excel).
- Apps de finanzas personales: Fintonic, MoneyWiz, Wallet.
- La propia app de tu banco.

**Consejo:** No necesita ser perfecto desde el principio. Un plan sencillo y actualizado vale más que uno elaborado que nunca usas.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué es el balance neto personal?',
        options: ['La suma de todos tus gastos', 'Activos menos pasivos', 'Tu salario mensual', 'Lo que gastas en ocio'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Con qué frecuencia se recomienda revisar el plan financiero?',
        options: ['Cada 10 años', 'Solo cuando hay crisis', 'Cada 3-6 meses', 'Nunca, si está bien hecho'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cuál de estas es una buena herramienta gratuita para el plan financiero personal?',
        options: ['Solo un asesor de banca privada', 'Google Sheets o apps como Fintonic', 'Una calculadora de bolsillo', 'Solo el extracto bancario en papel'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF4FC3F7),
    title: 'Revisa y ajusta tu plan',
    shortDesc: 'Un plan que no se revisa deja de ser útil.',
    difficulty: 2,
    content: '''La vida cambia: subes de sueldo, tienes un hijo, cambias de trabajo, suben los precios. Tu plan financiero debe adaptarse a estos cambios.

**¿Cuándo revisar el plan?**
- Cada 3-6 meses de forma rutinaria.
- Ante cualquier cambio importante: matrimonio, divorcio, herencia, despido, ascenso.
- Cuando alcances una meta (¡celebra y fija la siguiente!).

**Qué revisar:**
- ¿Sigues ahorrando el porcentaje previsto?
- ¿Tus gastos han aumentado sin justificación?
- ¿Tus metas siguen siendo las mismas o han cambiado?
- ¿El rendimiento de tus inversiones se ajusta a lo esperado?

**Señales de alerta:**
- Llevas 2 meses sin ahorrar nada.
- Tus gastos fijos superan el 60% de tus ingresos.
- Tienes deudas con interés superior al 10%.

**Consejo:** Fija una "cita financiera" mensual contigo mismo (o con tu pareja) para revisar cuentas. Solo 30 minutos al mes pueden marcar una gran diferencia a lo largo del año.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuándo debes revisar tu plan financiero además de las revisiones periódicas?',
        options: ['Nunca', 'Ante cambios importantes en tu vida', 'Solo si ganas más dinero', 'Una vez a la vida'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es una señal de alerta en tus finanzas personales?',
        options: ['Ahorrar más de lo previsto', 'Gastos fijos superiores al 60% de tus ingresos', 'Tener demasiadas inversiones', 'Cobrar el sueldo puntual'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuánto tiempo al mes es suficiente para una revisión financiera básica?',
        options: ['5 horas', '2 horas diarias', '30 minutos', 'No hace falta tiempo'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF4FC3F7),
    title: 'Simula tu futuro financiero',
    shortDesc: 'Calcula cuánto tendrás si empiezas a ahorrar hoy.',
    difficulty: 3,
    content: '''El interés compuesto es la fuerza más poderosa en las finanzas personales: tus ganancias generan más ganancias, y el tiempo es tu mayor aliado.

**La fórmula del interés compuesto:**
Capital final = Capital inicial × (1 + tasa)^años + Aportación × [(1 + tasa)^años − 1] / tasa

**Ejemplo real (España, 2024):**
- Empiezas con 0€.
- Aportas 200€/mes.
- Rentabilidad anual media: 6% (fondo indexado global).
- Plazo: 30 años.

**Resultado:**
- Total aportado: 200 × 12 × 30 = 72.000€
- Capital acumulado gracias al interés compuesto: ≈ 201.000€
- La diferencia (≈ 129.000€) son los rendimientos generados.

**¿Y si esperas 10 años?**
- Aportas durante 20 años: total 48.000€ aportados → capital ≈ 92.000€.
- Perdiste casi 110.000€ por esperar. El tiempo tiene un precio enorme.

**Herramientas para simular:**
- Calculadora de interés compuesto de Rankia.
- Simulador de fondos de ING, Indexa Capital, MyInvestor.

**Consejo:** Empieza hoy aunque sea con poco. 50€/mes a los 25 años valen mucho más que 200€/mes a los 45.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué hace el interés compuesto que lo diferencia del interés simple?',
        options: ['Solo calcula el capital inicial', 'Los rendimientos generan nuevos rendimientos', 'Es exclusivo de los bancos', 'Solo funciona con grandes capitales'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: 'Si aportas 200€/mes durante 30 años al 6% anual, ¿cuánto habrás aportado en total?',
        options: ['20.000€', '48.000€', '72.000€', '200.000€'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Por qué es tan importante empezar a invertir cuanto antes?',
        options: ['Por el interés compuesto y el tiempo disponible', 'Porque los mercados siempre suben', 'Para pagar menos impuestos', 'Porque el banco lo exige'],
        correctIndex: 0,
      ),
    ],
  ),
];

// ── Psicología del Dinero ─────────────────────────────────────────────────────
final List<EduPill> psychologyPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFCE93D8),
    title: '¿Por qué gastamos más de la cuenta?',
    shortDesc: 'Nuestro cerebro no está diseñado para las finanzas modernas.',
    difficulty: 1,
    content: '''La mayoría de los problemas financieros no son matemáticos, son psicológicos. Nuestras decisiones de gasto están influidas por emociones, hábitos y sesgos cognitivos.

**Principales razones por las que gastamos de más:**

**1. Gratificación inmediata**
El cerebro prefiere una recompensa pequeña ahora que una grande después. Por eso es más fácil comprarte ese capricho hoy que ahorrar para la jubilación.

**2. El dolor de pagar**
Pagar con tarjeta o con el móvil duele menos que pagar en efectivo. Los estudios muestran que gastamos hasta un 83% más con tarjeta que con dinero físico.

**3. El efecto del precio ancla**
Si ves algo de 200€ rebajado a 80€, parece una ganga. Pero si no necesitas el producto, sigues gastando 80€ de más.

**4. Comparación social**
Las redes sociales nos hacen creer que todo el mundo vive mejor que nosotros, lo que genera una presión de gasto innecesaria.

**5. El gasto emocional**
Comprar para sentirse mejor después de un mal día es muy común, pero crea un círculo vicioso.

**Consejo:** Antes de comprar algo, pregúntate: ¿Lo necesito, o solo lo quiero ahora mismo? Espera 24 horas para las compras no esenciales.''',
    quizzes: [
      PillQuiz(
        question: '¿Por qué gastamos más con tarjeta que con efectivo?',
        options: ['Porque la tarjeta tiene más dinero', 'Porque pagar con tarjeta duele menos psicológicamente', 'Porque el banco lo fomenta', 'Por los puntos de fidelidad'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué es el "efecto ancla" en el consumo?',
        options: ['Quedarse anclado a una marca', 'Usar un precio de referencia alto para que otro parezca barato', 'Ahorrar en el mismo banco siempre', 'No cambiar de banco'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué técnica ayuda a evitar compras impulsivas?',
        options: ['Pagar siempre con tarjeta de crédito', 'Esperar 24 horas antes de comprar algo no esencial', 'Suscribirse a más newsletters de ofertas', 'Ir de compras solo'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFCE93D8),
    title: 'Sesgos cognitivos y dinero',
    shortDesc: 'Errores de pensamiento que arruinan decisiones financieras.',
    difficulty: 2,
    content: '''Un sesgo cognitivo es un patrón de pensamiento que nos lleva a tomar decisiones irracionales. En finanzas, estos sesgos pueden costarnos mucho dinero.

**Los más comunes en finanzas:**

**Sesgo de confirmación**
Solo prestamos atención a la información que confirma lo que ya creemos. Si pensamos que Bitcoin va a subir, ignoramos las noticias negativas.

**Aversión a las pérdidas**
Las pérdidas duelen el doble que lo que placer da una ganancia equivalente. Por eso mantenemos inversiones en pérdidas esperando recuperar, cuando lo racional sería vender.

**Exceso de confianza**
Creemos que somos mejores inversores que la media. La mayoría de los inversores particulares obtienen peores resultados que un fondo indexado simple.

**Sesgo del presente**
Valoramos más el presente que el futuro. "Ya ahorraré el mes que viene" es la frase que más dinero cuesta a largo plazo.

**Efecto manada**
Compramos cuando todo el mundo compra (en máximos) y vendemos cuando todo el mundo vende (en mínimos). Lo opuesto de lo que recomienda Warren Buffett.

**Cómo combatirlos:**
- Automatizar decisiones (transferencia automática de ahorro).
- Invertir en fondos indexados en lugar de elegir acciones individuales.
- Tener una política de inversión escrita y seguirla.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué es la "aversión a las pérdidas"?',
        options: ['No querer invertir nunca', 'Que las pérdidas nos afectan psicológicamente más que las ganancias', 'Preferir el efectivo a la inversión', 'No querer pagar impuestos'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué hace el "efecto manada" en los mercados?',
        options: ['Estabiliza los precios', 'Lleva a comprar en máximos y vender en mínimos', 'Reduce los impuestos', 'Mejora la rentabilidad'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué estrategia ayuda a combatir el sesgo del presente?',
        options: ['Gastar más hoy', 'Automatizar el ahorro', 'Revisar las noticias diariamente', 'Cambiar de banco cada año'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFCE93D8),
    title: 'El coste emocional del dinero',
    shortDesc: 'El estrés financiero afecta tu salud y tus decisiones.',
    difficulty: 2,
    content: '''El dinero es la principal fuente de estrés para muchas familias españolas. El estrés financiero no solo afecta al bienestar emocional, sino también a la capacidad de tomar buenas decisiones.

**Efectos del estrés financiero:**
- Dificultad para concentrarse (la preocupación por el dinero ocupa espacio mental).
- Peor toma de decisiones (el cerebro bajo estrés busca soluciones rápidas, no óptimas).
- Problemas de sueño y salud.
- Conflictos de pareja (el dinero es la causa número 1 de discusiones en la pareja en España).

**El círculo vicioso:**
Poco dinero → estrés → malas decisiones → más problemas económicos → más estrés.

**Cómo romper el ciclo:**
1. **Transparencia:** Enfrenta la situación real, aunque sea dura. El autoengaño empeora todo.
2. **Plan de acción:** Aunque sea pequeño, tener un plan reduce la ansiedad.
3. **Hábitos pequeños:** Un pequeño avance cada día (ahorrar 5€, pagar una deuda mínima) mantiene la motivación.
4. **Red de apoyo:** No tienes que gestionarlo solo. Habla con tu banco o con asociaciones como OCU o ADICAE.
5. **Desconexión digital:** Reduce el tiempo en redes sociales si te generan presión de gasto.

**Consejo:** La ansiedad financiera disminuye cuando tienes claridad sobre tu situación. El primer paso siempre es conocer exactamente cuánto entra y cuánto sale.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es el principal efecto del estrés financiero en la toma de decisiones?',
        options: ['Mejora la concentración', 'El cerebro busca soluciones rápidas, no óptimas', 'Ayuda a ahorrar más', 'No tiene efecto'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál es el primer paso para reducir la ansiedad financiera?',
        options: ['Pedir un préstamo', 'Ignorar el problema', 'Conocer exactamente cuánto entra y cuánto sale', 'Cambiar de trabajo'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Por qué el dinero es la causa número 1 de discusiones en pareja en España?',
        options: ['Porque las parejas no se comunican sobre finanzas', 'Porque el dinero es complicado por ley', 'Porque los bancos lo fomentan', 'Porque es ilegal hablar de dinero'],
        correctIndex: 0,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFCE93D8),
    title: 'Cómo mejorar tu disciplina financiera',
    shortDesc: 'La disciplina no es fuerza de voluntad, es diseño de entorno.',
    difficulty: 2,
    content: '''La fuerza de voluntad es un recurso limitado. Los expertos en comportamiento financiero coinciden en que la clave no es tener más disciplina, sino diseñar un entorno que facilite las buenas decisiones.

**Estrategias probadas:**

**1. Automatiza todo lo que puedas**
Transferencia automática de ahorro el día de cobrar. Si el dinero no pasa por tu cuenta corriente, no lo gastas.

**2. Fracciona los objetivos grandes**
En lugar de "ahorrar 10.000€", piensa en "ahorrar 278€ este mes". Más manejable y motivador.

**3. Usa la regla de las 24 horas**
Para compras no esenciales superiores a 50€, espera 24 horas. El 80% de las veces no comprarás.

**4. Elimina fricciones al ahorro**
Abre una cuenta de ahorro específica. Cuanto más difícil sea acceder al dinero ahorrado, menos lo tocarás.

**5. Añade fricción al gasto**
Elimina tarjetas guardadas en apps de compra. El esfuerzo extra de introducir datos frena compras impulsivas.

**6. Recompénsate**
Define pequeñas recompensas al alcanzar metas intermedias. El cerebro aprende mejor con refuerzo positivo.

**Consejo:** Empieza con un solo cambio de hábito durante 30 días. No intentes cambiarlo todo a la vez.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es la estrategia más eficaz para ahorrar según la psicología del comportamiento?',
        options: ['Depender de la fuerza de voluntad', 'Automatizar el ahorro', 'Revisar el saldo cada hora', 'No tener tarjeta de crédito'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué hace la regla de las 24 horas para las compras?',
        options: ['Acelera la decisión de compra', 'Reduce las compras impulsivas al dar tiempo de reflexión', 'Obliga a comprar más barato', 'Es una ley española'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cómo se puede "añadir fricción al gasto"?',
        options: ['Tener más tarjetas', 'Eliminar tarjetas guardadas en apps de compra', 'Aumentar el límite de crédito', 'Comprar siempre en efectivo'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFCE93D8),
    title: 'Diseña tus hábitos financieros',
    shortDesc: 'Construye una rutina que trabaje por ti.',
    difficulty: 3,
    content: '''Los hábitos son comportamientos automatizados que no requieren decisión consciente. Construir hábitos financieros sólidos es la base de la riqueza a largo plazo.

**El ciclo del hábito (James Clear - Atomic Habits):**
Señal → Rutina → Recompensa

**Aplicado a las finanzas:**
- **Señal:** Llega la nómina.
- **Rutina:** Transfiero automáticamente el 20% a la cuenta de ahorro.
- **Recompensa:** Veo crecer mi saldo y me siento seguro.

**Los 5 hábitos financieros más poderosos:**
1. **Revisar el saldo una vez a la semana** (no más, para evitar ansiedad).
2. **Registro diario de gastos** durante al menos 30 días para conocer tus patrones.
3. **"Cita financiera" mensual** para revisar presupuesto y metas.
4. **Ahorro automático el día de cobrar.**
5. **Leer o escuchar contenido financiero** 15 minutos al día (podcasts, libros, newsletters).

**Tu desafío:**
Esta semana, elige UN hábito de la lista anterior e impleméntalo. Solo uno. Repítelo durante 30 días hasta que sea automático. Luego añade el siguiente.

**Libros recomendados en español:**
- *La psicología del dinero* - Morgan Housel
- *Padre rico, padre pobre* - Robert Kiyosaki
- *El método FIRE* - Scott Rieckens

**Consejo:** No te compares con otros. Tu único competidor eres tú de hace un año.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es el ciclo básico de formación de un hábito?',
        options: ['Pensar, actuar, olvidar', 'Señal, rutina, recompensa', 'Objetivo, dinero, resultado', 'Banco, ahorro, inversión'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Con qué frecuencia se recomienda revisar el saldo para evitar ansiedad financiera?',
        options: ['Cada hora', 'Diariamente', 'Una vez a la semana', 'Solo a final de mes'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cuántos hábitos nuevos se recomienda implementar a la vez?',
        options: ['Todos a la vez para avanzar más rápido', 'Solo uno, hasta automatizarlo', 'Cinco, uno por día de la semana', 'Ninguno, los hábitos no funcionan'],
        correctIndex: 1,
      ),
    ],
  ),
];

// ── Bienes Raíces ─────────────────────────────────────────────────────────────
final List<EduPill> realEstatePills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFAB91),
    title: '¿Comprar o alquilar?',
    shortDesc: 'No hay respuesta universal: depende de tu situación.',
    difficulty: 1,
    content: '''El debate "comprar vs alquilar" es uno de los más frecuentes en finanzas personales en España. No hay una respuesta correcta para todos: depende de tu situación personal, financiera y laboral.

**Argumentos a favor de comprar:**
- Acumulas patrimonio en lugar de "tirar el dinero".
- Protección frente a la inflación (el valor real del alquiler puede bajar).
- Libertad para reformar o personalizar.
- Seguridad a largo plazo.

**Argumentos a favor de alquilar:**
- Mayor flexibilidad geográfica (clave si tu trabajo puede cambiar).
- Sin gastos de mantenimiento, IBI, comunidad, seguros del propietario.
- Capital disponible para invertir en otros activos más rentables.
- Sin riesgo de depreciación del inmueble.

**La realidad en España:**
- El esfuerzo para comprar una vivienda (precio / salario anual) es uno de los más altos de Europa.
- En ciudades como Madrid o Barcelona, alquilar puede ser más barato a corto plazo.
- En municipios medianos, comprar suele salir mejor.

**Regla práctica:** Si piensas quedarte más de 5-7 años en el mismo lugar y tienes el ahorro para la entrada (20% + gastos), comprar puede tener sentido. Si tienes dudas sobre tu estabilidad o ubicación, alquilar es más prudente.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuántos años de permanencia suelen recomendarse para que comprar sea rentable?',
        options: ['1-2 años', '3-4 años', '5-7 años o más', '15 años o más'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Cuál es una ventaja del alquiler frente a la compra?',
        options: ['Acumulas más patrimonio', 'Mayor flexibilidad para cambiar de ciudad', 'Pagas menos impuestos', 'El precio nunca sube'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: 'Aproximadamente, ¿qué porcentaje del precio de compra necesitas tener ahorrado para la entrada más gastos?',
        options: ['5%', '10%', '20-30%', '50%'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFAB91),
    title: 'Cómo funciona la hipoteca',
    shortDesc: 'El préstamo más grande de tu vida explicado sin letra pequeña.',
    difficulty: 2,
    content: '''Una hipoteca es un préstamo a largo plazo (generalmente 20-30 años) en el que el banco financia la compra de tu vivienda y tú lo devuelves con intereses. El inmueble queda como garantía.

**Conceptos clave:**

**Capital:** El importe prestado. Los bancos suelen financiar hasta el 80% del valor de tasación (o precio, el menor). El 20% restante más los gastos (aprox. 10%) lo pones tú: necesitas el 30% en efectivo.

**Interés:** El precio del préstamo. En España existen dos tipos:
- **Hipoteca fija:** Cuota constante durante toda la vida del préstamo. Mayor seguridad, tipo más alto.
- **Hipoteca variable:** Referenciada al Euríbor + diferencial. Cuota cambia con el mercado.
- **Hipoteca mixta:** Fija los primeros años, luego variable.

**Euríbor:** Tipo de interés interbancario europeo. En 2023-2024 alcanzó máximos (>4%). Muchas familias españolas vieron sus cuotas dispararse.

**TAE vs TIN:**
- **TIN:** Tipo de interés nominal (solo el interés).
- **TAE:** Incluye todos los costes (comisiones, seguros vinculados). Usa la TAE para comparar.

**Otros costes:**
- Tasación: 300-500€.
- Notaría, registro, gestión: ~1.500-2.000€.
- ITP (impuesto de transmisiones): entre el 4-10% según comunidad autónoma (vivienda usada).
- IVA 10%: si es vivienda nueva.

**Consejo:** Compara al menos 3 ofertas de bancos diferentes (Santander, BBVA, CaixaBank, ING, Openbank, Sabadell) y valora si te conviene contratar un bróker hipotecario.''',
    quizzes: [
      PillQuiz(
        question: '¿Qué porcentaje del precio suele financiar el banco en una hipoteca estándar?',
        options: ['50%', '70%', '80%', '100%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué indicador debes usar para comparar hipotecas de diferentes bancos?',
        options: ['El TIN', 'La TAE', 'El Euríbor', 'El IVA'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué tipo de hipoteca tiene cuota constante durante toda su vida?',
        options: ['Variable', 'Mixta', 'Fija', 'Euríbor plus'],
        correctIndex: 2,
      ),
    ],
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFAB91),
    title: 'Gastos ocultos al comprar vivienda',
    shortDesc: 'El precio de compra es solo el comienzo.',
    difficulty: 2,
    content: '''Muchos compradores se centran solo en el precio de la vivienda y se llevan una sorpresa al ver todos los gastos adicionales. En España, los costes adicionales pueden suponer entre el 10-15% del precio de compra.

**Gastos al comprar (vivienda usada):**
- **ITP (Impuesto de Transmisiones Patrimoniales):** 4-10% del precio, según comunidad autónoma (Madrid: 6%, Cataluña: 10%, Andalucía: 7%...).
- **Notaría:** 500-1.500€ (varía según precio de la vivienda).
- **Registro de la Propiedad:** 300-800€.
- **Gestoría:** 300-500€.
- **Tasación:** 300-500€ (la exige el banco).

**Gastos al comprar (vivienda nueva):**
- **IVA:** 10% (o 4% para protección oficial).
- **AJD (Actos Jurídicos Documentados):** 0,5-1,5% según CCAA.

**Gastos recurrentes tras la compra:**
- **IBI (Impuesto de Bienes Inmuebles):** 200-2.000€/año según municipio y valor catastral.
- **Comunidad de vecinos:** 50-200€/mes en pisos.
- **Seguro de hogar:** obligatorio con hipoteca, 200-400€/año.
- **Mantenimiento:** se recomienda reservar 1% del valor anual.

**Ejemplo real:**
Piso de 200.000€ en Madrid: 12.000€ en ITP + 3.000€ en otros gastos = 15.000€ adicionales.
Total necesario: 200.000€ + 40.000€ (20% entrada) + 15.000€ (gastos) = 55.000€ en efectivo antes de entrar.

**Consejo:** Pide siempre una estimación escrita de todos los gastos antes de firmar.''',
    quizzes: [
      PillQuiz(
        question: '¿Aproximadamente qué porcentaje del precio de compra representan los gastos adicionales en España?',
        options: ['1-2%', '5-7%', '10-15%', '25-30%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué impuesto grava la compra de vivienda usada en España?',
        options: ['IVA', 'IRPF', 'ITP', 'IBI'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué gasto recurrente es obligatorio contratar con la hipoteca?',
        options: ['Seguro de vida', 'Seguro de hogar', 'Seguro de desempleo', 'Seguro dental'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFAB91),
    title: 'La vivienda como inversión',
    shortDesc: '¿Es la vivienda la mejor inversión posible?',
    difficulty: 2,
    content: '''En España, existe la creencia generalizada de que comprar una vivienda es siempre la mejor inversión. La realidad es más matizada.

**La vivienda como inversión: pros y contras**

**Pros:**
- Tangible y comprensible para todos.
- Generación de renta si se alquila (yield bruto en España: 4-7% en ciudades medianas).
- Protección frente a inflación a largo plazo.
- Apalancamiento (puedes comprar un activo de 200.000€ con 60.000€ propios).

**Contras:**
- Baja liquidez (no puedes vender una habitación si necesitas dinero rápido).
- Alta concentración de riesgo (todo el huevo en la misma cesta).
- Gastos continuos: mantenimiento, IBI, comunidad, seguros.
- Gestión activa: inquilinos, reparaciones, impagos.
- Rentabilidad real (descontando inflación y gastos) frecuentemente inferior a un fondo indexado global.

**Rentabilidad histórica comparada (España, últimos 30 años):**
- Vivienda: ~4-5% anual (precio + alquiler, bruto).
- Bolsa global (índice MSCI World): ~8-10% anual (bruto).

**¿Cuándo sí tiene sentido invertir en inmuebles?**
- Cuando tienes la vivienda propia asegurada.
- Cuando diversificas con otros activos también.
- Cuando sabes gestionar las responsabilidades del propietario.

**Consejo:** La vivienda puede ser un buen componente de una cartera diversificada, pero raramente debería ser el único activo de inversión de una persona.''',
    quizzes: [
      PillQuiz(
        question: '¿Cuál es la principal desventaja de la vivienda como inversión frente a los fondos de inversión?',
        options: ['Es más rentable', 'Tiene baja liquidez', 'No paga impuestos', 'No tiene gastos'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cuál ha sido históricamente la rentabilidad anual bruta aproximada de la bolsa global (MSCI World)?',
        options: ['2-3%', '4-5%', '8-10%', '15-20%'],
        correctIndex: 2,
      ),
      PillQuiz(
        question: '¿Qué significa "yield bruto" de un inmueble en alquiler?',
        options: ['El precio de compra dividido por el alquiler', 'La renta anual de alquiler dividida entre el precio de compra', 'Los gastos de mantenimiento anuales', 'El valor catastral del inmueble'],
        correctIndex: 1,
      ),
    ],
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFFFAB91),
    title: 'Simula tu hipoteca',
    shortDesc: 'Calcula cuánto pagarás realmente por una vivienda.',
    difficulty: 3,
    content: '''Antes de firmar una hipoteca, es fundamental entender exactamente cuánto vas a pagar en total y cómo funciona la amortización.

**Ejemplo de cálculo completo:**
- Precio vivienda: 220.000€
- Entrada (20%): 44.000€
- Gastos compra (~12%): 26.400€
- **Capital hipotecado:** 176.000€
- Tipo fijo: 3,5% anual
- Plazo: 25 años

**Cuota mensual:** ≈ 880€/mes

**Total pagado al banco:** 880€ × 300 meses = 264.000€

**Total intereses pagados:** 264.000€ − 176.000€ = **88.000€ en intereses**

**Capital propio total necesario:** 44.000€ + 26.400€ = **70.400€**

**Coste real de la vivienda:** 264.000€ (banco) + 70.400€ (propio) = **334.400€** por una vivienda de 220.000€.

**¿Cómo reducir los intereses?**
- Amortizar anticipadamente cuando tengas ahorros extra (con comisión máxima del 0,25-0,5% los primeros años).
- Elegir el plazo más corto que puedas permitirte.
- Comparar y negociar el tipo de interés.

**Herramientas para calcular:**
- Simuladores de Santander, BBVA, CaixaBank, ING.
- Calculadora hipotecaria del Banco de España (bankofspain.es).

**Consejo:** Nunca firmes una hipoteca sin haber calculado el coste total, no solo la cuota mensual.''',
    quizzes: [
      PillQuiz(
        question: 'En el ejemplo del ejercicio, ¿cuánto se paga en total en intereses durante 25 años?',
        options: ['44.000€', '88.000€', '176.000€', '264.000€'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Cómo puedes reducir el total de intereses pagados en una hipoteca?',
        options: ['Alargando el plazo lo máximo posible', 'Eligiendo el plazo más corto que puedas permitirte', 'No amortizando nunca anticipadamente', 'Cambiando de banco cada año'],
        correctIndex: 1,
      ),
      PillQuiz(
        question: '¿Qué representa el "capital propio necesario" para comprar una vivienda?',
        options: ['Solo el precio de la vivienda', 'Solo la entrada del 20%', 'La entrada más los gastos de compra', 'Solo los gastos notariales'],
        correctIndex: 2,
      ),
    ],
  ),
];

// --- PANTALLA DE DETALLE DE TEMA ---
class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailScreen({super.key, required this.topic});

  static const _difficultyLabel = {1: 'Básico', 2: 'Intermedio', 3: 'Avanzado'};
  static const _difficultyIcon = {
    1: Icons.signal_cellular_alt_1_bar,
    2: Icons.signal_cellular_alt_2_bar,
    3: Icons.signal_cellular_alt,
  };
  static const _difficultyColor = {
    1: Color(0xFF4CAF50),
    2: Color(0xFFFF9800),
    3: Color(0xFFE53935),
  };

  bool _hasDifficultyVariance(List<EduPill> pills) {
    if (pills.isEmpty) return false;
    final first = pills.first.difficulty;
    return pills.any((p) => p.difficulty != first);
  }

  @override
  Widget build(BuildContext context) {
    final pills = topic.pills;
    final hasDifficulty = _hasDifficultyVariance(pills);

    // Build a flat list of items: header banner, then for each pill optionally
    // a difficulty section header, then the pill card itself.
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF7),
      appBar: AppBar(
        backgroundColor: topic.pillColor,
        foregroundColor: Colors.white,
        title: Text(topic.title),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          final completed = appProvider.completedLessons;

          // Build flat item list
          final List<_DetailItem> items = [];
          int? lastDifficulty;

          for (int i = 0; i < pills.length; i++) {
            final pill = pills[i];
            // Pill N is locked if the previous pill in the list is not completed
            final isLocked = hasDifficulty && i > 0 && !completed.contains(pills[i - 1].title);

            // Insert difficulty section header on first pill of each new level
            if (hasDifficulty && pill.difficulty != lastDifficulty) {
              items.add(_DetailItem.sectionHeader(pill.difficulty));
              lastDifficulty = pill.difficulty;
            }

            items.add(_DetailItem.pill(pill, i, isLocked));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              if (idx == 0) return _buildTopicBanner();

              final item = items[idx - 1];
              if (item.isSectionHeader) {
                final d = item.difficulty!;
                return _DifficultyHeader(
                  label: _difficultyLabel[d]!,
                  icon: _difficultyIcon[d]!,
                  color: _difficultyColor[d]!,
                );
              }
              return _PillCard(
                pill: item.pill!,
                isLocked: item.isLocked,
                difficulty: hasDifficulty ? item.pill!.difficulty : null,
                difficultyColor: hasDifficulty
                    ? _difficultyColor[item.pill!.difficulty]!
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopicBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: topic.pillColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: topic.pillColor.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: topic.iconBg,
            radius: 24,
            child: Icon(topic.icon, color: topic.iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: topic.pillColor.darken(0.25),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Flat list item discriminator for TopicDetailScreen
class _DetailItem {
  final EduPill? pill;
  final int? difficulty;
  final bool isLocked;

  const _DetailItem._({this.pill, this.difficulty, this.isLocked = false});

  factory _DetailItem.sectionHeader(int difficulty) =>
      _DetailItem._(difficulty: difficulty);

  factory _DetailItem.pill(EduPill pill, int index, bool isLocked) =>
      _DetailItem._(pill: pill, isLocked: isLocked);

  bool get isSectionHeader => pill == null;
}

class _DifficultyHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _DifficultyHeader({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1.5,
              color: color.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillCard extends StatefulWidget {
  final EduPill pill;
  final bool isLocked;
  final int? difficulty;
  final Color? difficultyColor;

  const _PillCard({
    required this.pill,
    this.isLocked = false,
    this.difficulty,
    this.difficultyColor,
  });

  @override
  State<_PillCard> createState() => _PillCardState();
}

class _PillCardState extends State<_PillCard> {
  /// Navigates to the full-screen swiper, then shows the result dialog.
  Future<void> _openPill(BuildContext context) async {
    if (widget.isLocked) return;
    final result = await Navigator.of(context).push<Map<String, int>>(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (ctx, _, __) => _PillSwiperScreen(pill: widget.pill),
        transitionsBuilder: (ctx, anim, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
    if (result == null || !context.mounted) return;

    final correctCount = result['correctCount']!;
    final totalCount = result['totalCount']!;
    final isPerfect = correctCount == totalCount;

    if (isPerfect) {
      final appProvider = context.read<AppProvider>();
      if (!appProvider.completedLessons.contains(widget.pill.title)) {
        appProvider.completeLesson(widget.pill.title);
      }
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    if (!context.mounted) return;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (ctx, _, __) => _PillCompletionDialog(
        pill: widget.pill,
        correctCount: correctCount,
        totalCount: totalCount,
        onContinue: () => Navigator.of(ctx).pop(),
        onRetry: isPerfect ? null : () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pill = widget.pill;
    final isLocked = widget.isLocked;
    final isCompleted = context
        .watch<AppProvider>()
        .completedLessons
        .contains(pill.title);

    final cardColor = isLocked
        ? Colors.grey.withOpacity(0.07)
        : isCompleted
            ? Colors.green.withOpacity(0.08)
            : pill.typeColor.withOpacity(0.13);

    final borderColor = isLocked
        ? Colors.grey.withOpacity(0.25)
        : isCompleted
            ? Colors.green.withOpacity(0.5)
            : pill.typeColor.withOpacity(0.25);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: isCompleted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLocked ? 0.01 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Main content (always rendered, opacity-dimmed when locked) ──
          Opacity(
            opacity: isLocked ? 0.45 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey.withOpacity(0.5)
                              : pill.typeColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          pill.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Difficulty dot
                      if (widget.difficultyColor != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey
                                : widget.difficultyColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          pill.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: isLocked
                                ? Colors.grey.shade600
                                : pill.typeColor.darken(0.2),
                          ),
                        ),
                      ),
                      if (isCompleted)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                        ),
                      if (!isLocked)
                        Icon(
                          Icons.chevron_right_rounded,
                          color: pill.typeColor.darken(0.2),
                        ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      pill.shortDesc,
                      style: TextStyle(
                        fontSize: 15,
                        color: isLocked ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                  onTap: isLocked
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '🔒 Completa la píldora anterior para desbloquear esta.'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          )
                      : () => _openPill(context),
                ),
                // ── "open pill" hint row ─────────────────────────────────
                if (!isLocked) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle_outline
                              : Icons.swipe_right_outlined,
                          size: 16,
                          color: isCompleted
                              ? Colors.green.shade600
                              : pill.typeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCompleted ? 'Repetir' : 'Desliza para leer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCompleted
                                ? Colors.green.shade600
                                : pill.typeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Lock overlay badge (top-right corner) ──
          if (isLocked)
            Positioned(
              top: 12,
              right: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 13, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Bloqueada',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Pill swiper screen ────────────────────────────────────────────────────────

class _PillSwiperScreen extends StatefulWidget {
  final EduPill pill;
  const _PillSwiperScreen({required this.pill});
  @override
  State<_PillSwiperScreen> createState() => _PillSwiperScreenState();

  static List<String> _parseSlides(String content) {
    final raw = content
        .split('\n\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final out = <String>[];
    for (final part in raw) {
      if (out.isNotEmpty && out.last.length <= 60) {
        out[out.length - 1] = '${out.last}\n\n$part';
      } else {
        out.add(part);
      }
    }
    return out;
  }
}

// ── Tinder-style swipe state ──────────────────────────────────────────────────

class _SwiperParticle {
  final double angle;
  final double speed;
  final Color color;
  final double size;
  _SwiperParticle(this.angle, this.speed, this.color, this.size);

  static _SwiperParticle random(math.Random rng) {
    const palette = [
      Color(0xFFFFD700),
      Color(0xFFFF6B6B),
      Color(0xFF7ED957),
      Color(0xFF7B2FF7),
      Color(0xFF00C9FF),
      Color(0xFFFF9500),
    ];
    return _SwiperParticle(
      rng.nextDouble() * 2 * math.pi,
      0.3 + rng.nextDouble() * 0.7,
      palette[rng.nextInt(palette.length)],
      4 + rng.nextDouble() * 6,
    );
  }
}

class _SwiperParticlePainter extends CustomPainter {
  final List<_SwiperParticle> particles;
  final double progress; // 0 → 1

  const _SwiperParticlePainter(
      {required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide * 0.9;
    final opacity = progress < 0.6
        ? 1.0
        : 1.0 - ((progress - 0.6) / 0.4).clamp(0.0, 1.0);

    for (final p in particles) {
      final dist = p.speed * progress * maxRadius;
      final gravity = size.height * 0.5 * progress * progress;
      final pos = Offset(
        center.dx + math.cos(p.angle) * dist,
        center.dy + math.sin(p.angle) * dist + gravity,
      );
      final paint = Paint()
        ..color = p.color.withAlpha((opacity * 255).round())
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, p.size * (1.0 - progress * 0.4), paint);
    }
  }

  @override
  bool shouldRepaint(_SwiperParticlePainter old) =>
      old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────

class _PillSwiperScreenState extends State<_PillSwiperScreen>
    with TickerProviderStateMixin {
  late final List<String> _slides;

  // ── drag state ──────────────────────────────────────────────────────────────
  int _currentIdx = 0;
  double _dragX = 0;
  bool _animating = false;

  // ── animation controllers ───────────────────────────────────────────────────
  late final AnimationController _throwCtrl;
  late final AnimationController _snapCtrl;
  late final AnimationController _revealCtrl;
  late final AnimationController _entryCtrl;

  double _throwStart = 0;
  double _throwEnd = 0;
  double _snapStart = 0;

  // ── quiz reveal ──────────────────────────────────────────────────────────────
  bool _showReveal = false;
  late final List<_SwiperParticle> _particles;

  // ── lazily-built kahoot args ─────────────────────────────────────────────────
  List<List<String>>? _shuffledOptions;
  List<int>? _correctIndices;

  @override
  void initState() {
    super.initState();
    _slides = _PillSwiperScreen._parseSlides(widget.pill.content);

    _throwCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..addListener(_onThrowTick)
      ..addStatusListener(_onThrowStatus);

    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..addListener(_onSnapTick);

    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) _launchKahoot();
      });

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();

    final rng = math.Random(42);
    _particles = List.generate(36, (_) => _SwiperParticle.random(rng));

    // Pre-shuffle quiz options once
    final shuffled = <List<String>>[];
    final correct = <int>[];
    for (final q in widget.pill.quizzes) {
      final opts = q.getShuffledOptions();
      shuffled.add(opts);
      correct.add(q.getCorrectIndexAfterShuffle(opts));
    }
    _shuffledOptions = shuffled;
    _correctIndices = correct;
  }

  // ── throw animation ─────────────────────────────────────────────────────────

  void _onThrowTick() {
    if (!_animating) return;
    setState(() {
      _dragX = _throwStart +
          (_throwEnd - _throwStart) *
              CurvedAnimation(parent: _throwCtrl, curve: Curves.easeIn)
                  .value;
    });
  }

  void _onThrowStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    final forward = _throwEnd > 0;
    if (forward) {
      if (_currentIdx >= _slides.length - 1) {
        // Last slide thrown — show reveal
        setState(() {
          _dragX = 0;
          _animating = false;
          _showReveal = true;
        });
        HapticFeedback.heavyImpact();
        _revealCtrl.forward();
      } else {
        setState(() {
          _currentIdx++;
          _dragX = 0;
          _animating = false;
        });
        HapticFeedback.lightImpact();
      }
    } else {
      if (_currentIdx > 0) {
        setState(() {
          _currentIdx--;
          _dragX = 0;
          _animating = false;
        });
        HapticFeedback.lightImpact();
      } else {
        setState(() {
          _dragX = 0;
          _animating = false;
        });
      }
    }
    _throwCtrl.reset();
  }

  // ── snap-back animation ─────────────────────────────────────────────────────

  void _onSnapTick() {
    if (!_animating) return;
    setState(() {
      _dragX = _snapStart *
          (1.0 -
              CurvedAnimation(parent: _snapCtrl, curve: Curves.elasticOut)
                  .value);
    });
    if (_snapCtrl.isCompleted) {
      _animating = false;
      _dragX = 0;
    }
  }

  // ── gesture handling ────────────────────────────────────────────────────────

  void _onPanUpdate(DragUpdateDetails d) {
    if (_animating || _showReveal) return;
    setState(() {
      _dragX += d.delta.dx;
      // First slide: no left swipe
      if (_currentIdx == 0 && _dragX < 0) _dragX = 0;
    });
  }

  void _onPanEnd(DragEndDetails d) {
    if (_animating || _showReveal) return;
    final vx = d.velocity.pixelsPerSecond.dx;
    const threshold = 80.0;
    const velThreshold = 400.0;
    final screenW = MediaQuery.of(context).size.width;

    final goForward =
        _dragX > threshold || (vx > velThreshold && _dragX > 20);
    final goBack = _currentIdx > 0 &&
        (_dragX < -threshold || (vx < -velThreshold && _dragX < -20));

    if (goForward) {
      _throwStart = _dragX;
      _throwEnd = screenW * 1.4;
      _animating = true;
      _throwCtrl.reset();
      _throwCtrl.forward();
    } else if (goBack) {
      _throwStart = _dragX;
      _throwEnd = -screenW * 1.4;
      _animating = true;
      _throwCtrl.reset();
      _throwCtrl.forward();
    } else {
      _snapStart = _dragX;
      _animating = true;
      _snapCtrl.reset();
      _snapCtrl.forward();
    }
  }

  // ── kahoot launch ───────────────────────────────────────────────────────────

  Future<void> _launchKahoot() async {
    if (!mounted) return;
    final result = await Navigator.of(context).push<Map<String, int>>(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (ctx, _, __) => _KahootQuizScreen(
          pill: widget.pill,
          shuffledOptions: _shuffledOptions!,
          correctIndices: _correctIndices!,
        ),
        transitionsBuilder: (ctx, anim, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  void dispose() {
    _throwCtrl.dispose();
    _snapCtrl.dispose();
    _revealCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── helpers ─────────────────────────────────────────────────────────────────

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  // ── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final pill = widget.pill;
    final total = _slides.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _darken(pill.typeColor, 0.18),
              _darken(pill.typeColor, 0.42),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity:
                CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(pill, total),
                    _buildProgressBar(total),
                    const SizedBox(height: 12),
                    Expanded(child: _buildCardStack(total)),
                    const SizedBox(height: 10),
                    _buildDots(total),
                    _buildSwipeHint(),
                    const SizedBox(height: 14),
                  ],
                ),

                // ── Quiz reveal overlay ───────────────────────────────────
                if (_showReveal) _buildRevealOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(EduPill pill, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(46),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pill.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pill.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_currentIdx + 1} / $total',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── progress bar ─────────────────────────────────────────────────────────────

  Widget _buildProgressBar(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: TweenAnimationBuilder<double>(
          tween: Tween(
              begin: (_currentIdx) / total,
              end: (_currentIdx + 1) / total),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          builder: (_, v, __) => LinearProgressIndicator(
            value: v,
            backgroundColor: Colors.white24,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 5,
          ),
        ),
      ),
    );
  }

  // ── card stack ───────────────────────────────────────────────────────────────

  Widget _buildCardStack(int total) {
    final nextIdx = _currentIdx + 1;
    // How far the drag has gone as a 0→1 fraction of screen width
    final dragFrac =
        (_dragX.abs() / MediaQuery.of(context).size.width).clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Stack(
          children: [
            // ── next card (peeks and scales up as drag progresses) ────────
            if (nextIdx <= total)
              Positioned.fill(
                child: Transform.scale(
                  scale: 0.93 + dragFrac * 0.07,
                  child: Opacity(
                    opacity: 0.5 + dragFrac * 0.5,
                    child: nextIdx == total
                        ? _buildQuizCardStatic()
                        : _buildSlideCard(
                            _slides[nextIdx], nextIdx, total),
                  ),
                ),
              ),

            // ── current card (draggable) ───────────────────────────────────
            Positioned.fill(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_dragX, 0.0)
                  ..rotateZ(_dragX * 0.00045),
                alignment: Alignment.bottomCenter,
                child: _buildSlideCard(
                    _slides[_currentIdx], _currentIdx, total),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── slide card ───────────────────────────────────────────────────────────────

  Widget _buildSlideCard(String text, int index, int total) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        widget.pill.typeColor.withAlpha(31),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${index + 1} / $total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _darken(widget.pill.typeColor, 0.15),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _RichTextContent(
              text: text,
              accentColor: widget.pill.typeColor,
            ),
          ],
        ),
      ),
    );
  }

  // ── quiz card (static peek behind last slide) ─────────────────────────────

  Widget _buildQuizCardStatic() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D1B69), Color(0xFF0D1B4B)],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7).withAlpha(115),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_rounded,
                color: Color(0xFF7ED957), size: 64),
            SizedBox(height: 16),
            Text(
              '¡Hora del Quiz!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── dots ─────────────────────────────────────────────────────────────────────

  Widget _buildDots(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == _currentIdx;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // ── swipe hint ───────────────────────────────────────────────────────────────

  Widget _buildSwipeHint() {
    final isFirst = _currentIdx == 0;
    final isLast = _currentIdx == _slides.length - 1;
    return AnimatedOpacity(
      opacity: _animating ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isFirst) ...[
              const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white54, size: 13),
              const SizedBox(width: 3),
            ],
            Text(
              isLast
                  ? '¡Desliza para el quiz! →'
                  : 'Desliza  →',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── quiz reveal overlay ───────────────────────────────────────────────────────

  Widget _buildRevealOverlay() {
    // Stage intervals
    final bgAnim = CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn));
    final particleAnim = CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOut));
    final iconAnim = CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.1, 0.55, curve: Curves.elasticOut));
    final titleAnim = CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.28, 0.55, curve: Curves.easeOut));
    final subtitleAnim = CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.38, 0.62, curve: Curves.easeOut));
    final btnAnim = CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.55, 0.80, curve: Curves.easeOut));

    return AnimatedBuilder(
      animation: _revealCtrl,
      builder: (_, __) {
        return Positioned.fill(
          child: Container(
            color:
                Color.lerp(Colors.transparent, const Color(0xE61A0533),
                    bgAnim.value),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Particles
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SwiperParticlePainter(
                      particles: _particles,
                      progress: particleAnim.value,
                    ),
                  ),
                ),

                // Content column
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pulsing icon
                    Transform.scale(
                      scale: iconAnim.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              const Color(0xFF7B2FF7).withAlpha(40),
                          border: Border.all(
                            color: const Color(0xFF7ED957),
                            width: 3.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7B2FF7)
                                  .withAlpha(100),
                              blurRadius: 30,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.quiz_rounded,
                          color: Color(0xFF7ED957),
                          size: 60,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Title
                    Opacity(
                      opacity: titleAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - titleAnim.value)),
                        child: const Text(
                          '¡HORA DEL QUIZ!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    Opacity(
                      opacity: subtitleAnim.value,
                      child: Transform.translate(
                        offset:
                            Offset(0, 16 * (1 - subtitleAnim.value)),
                        child: Text(
                          '¿Listo para demostrar lo aprendido?',
                          style: TextStyle(
                            color: Colors.white.withAlpha(178),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // "Comenzando…" label
                    Opacity(
                      opacity: btnAnim.value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF7ED957)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Comenzando quiz…',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Rich text content renderer ────────────────────────────────────────────────

class _RichTextContent extends StatelessWidget {
  final String text;
  final Color accentColor;
  const _RichTextContent({required this.text, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _buildLine(line)).toList(),
    );
  }

  Widget _buildLine(String line) {
    if (line.trim().isEmpty) return const SizedBox(height: 6);

    // Numbered list  e.g. "1. **Title**"
    final numberedMatch = RegExp(r'^(\d+)\.\s+(.+)$').firstMatch(line);
    if (numberedMatch != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2, right: 8),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                numberedMatch.group(1)!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _darkenColor(accentColor, 0.2),
                ),
              ),
            ),
            Expanded(child: _buildRichText(numberedMatch.group(2)!)),
          ],
        ),
      );
    }

    // Bullet point
    if (line.startsWith('- ')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, right: 8),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(child: _buildRichText(line.substring(2))),
          ],
        ),
      );
    }

    // Section header starting with **text**:
    if (line.startsWith('**') && line.endsWith('**')) {
      final inner = line.substring(2, line.length - 2);
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: Text(
          inner,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _darkenColor(accentColor, 0.2),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: _buildRichText(line),
    );
  }

  Widget _buildRichText(String text) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, m.start)));
      }
      spans.add(TextSpan(
        text: m.group(1),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: _darkenColor(accentColor, 0.18),
        ),
      ));
      lastEnd = m.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1A1A2E),
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }

  static Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

// ── Kahoot-style quiz screen ──────────────────────────────────────────────────

class _KahootQuizScreen extends StatefulWidget {
  final EduPill pill;
  final List<List<String>> shuffledOptions;
  final List<int> correctIndices;

  const _KahootQuizScreen({
    required this.pill,
    required this.shuffledOptions,
    required this.correctIndices,
  });

  @override
  State<_KahootQuizScreen> createState() => _KahootQuizScreenState();
}

class _KahootQuizScreenState extends State<_KahootQuizScreen>
    with TickerProviderStateMixin {
  int _qi = 0;
  int? _selected; // index 0-3, null = not answered yet
  late List<bool?> _results; // true/false per question

  // Classic Kahoot tile colours
  static const _colors = [
    Color(0xFFE53935), // red
    Color(0xFF1E88E5), // blue
    Color(0xFF43A047), // green
    Color(0xFFFFB300), // amber
  ];
  static const _icons = [
    Icons.change_history_rounded,  // triangle
    Icons.diamond_rounded,         // diamond
    Icons.circle_rounded,          // circle
    Icons.crop_square_rounded,     // square
  ];

  // Animations
  late AnimationController _slideCtrl;   // question slides in
  late AnimationController _tilesCtrl;   // tiles pop in (staggered)
  late AnimationController _feedbackCtrl;// ✓/✗ badge
  late AnimationController _shakeCtrl;   // wrong-answer shake
  late AnimationController _progressCtrl;// progress bar fill

  late Animation<Offset> _questionSlide;
  late Animation<double> _feedbackScale;
  late Animation<double> _feedbackFade;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _results = List<bool?>.filled(widget.shuffledOptions.length, null);

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _tilesCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _feedbackCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _progressCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600));

    _questionSlide = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _feedbackScale = CurvedAnimation(
        parent: _feedbackCtrl, curve: Curves.elasticOut);
    _feedbackFade = CurvedAnimation(
        parent: _feedbackCtrl, curve: Curves.easeIn);

    _progressAnim = Tween<double>(begin: 0, end: 1 / widget.shuffledOptions.length)
        .animate(CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut));

    _slideCtrl.forward();
    _tilesCtrl.forward();
    _progressCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _tilesCtrl.dispose();
    _feedbackCtrl.dispose();
    _shakeCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _onTileTap(int tileIndex) {
    if (_selected != null) return; // already answered
    final isCorrect = tileIndex == widget.correctIndices[_qi];

    setState(() {
      _selected = tileIndex;
      _results[_qi] = isCorrect;
    });

    if (isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
      _shakeCtrl.forward(from: 0);
    }
    _feedbackCtrl.forward(from: 0);

    // Auto-advance after 1.8 s
    Future.delayed(const Duration(milliseconds: 1800), _advance);
  }

  void _advance() {
    if (!mounted) return;
    final isLast = _qi == widget.shuffledOptions.length - 1;
    if (isLast) {
      final correctCount = _results.where((r) => r == true).length;
      Navigator.of(context).pop({
        'correctCount': correctCount,
        'totalCount': widget.shuffledOptions.length,
      });
      return;
    }

    // Slide to next question
    _slideCtrl.reset();
    _tilesCtrl.reset();
    _feedbackCtrl.reset();
    _shakeCtrl.reset();

    // Update progress bar for next question
    final nextQ = _qi + 1;
    final newProgress = (nextQ + 1) / widget.shuffledOptions.length;
    _progressAnim = Tween<double>(
      begin: _progressAnim.value,
      end: newProgress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut));
    _progressCtrl.forward(from: 0);

    setState(() {
      _qi = nextQ;
      _selected = null;
    });

    _slideCtrl.forward();
    _tilesCtrl.forward();
  }

  /// Shake offset for the wrong tile
  double _shakeOffset() {
    final t = _shakeCtrl.value;
    return math.sin(t * math.pi * 5) * 10;
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.shuffledOptions[_qi];
    final correctIdx = widget.correctIndices[_qi];
    final total = widget.shuffledOptions.length;
    final isAnswered = _selected != null;
    final isCorrect = isAnswered && _results[_qi] == true;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0533), Color(0xFF0D1B4B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(
                          {'correctCount': 0, 'totalCount': total}),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Pregunta ${_qi + 1} de $total',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedBuilder(
                            animation: _progressAnim,
                            builder: (_, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _progressAnim.value,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFF7ED957)),
                                minHeight: 7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ── Question card ──────────────────────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: SlideTransition(
                    position: _questionSlide,
                    child: FadeTransition(
                      opacity: _slideCtrl,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.pill.typeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.pill.title,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: widget.pill.typeColor.darken(0.2),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              widget.pill.quizzes[_qi].question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Feedback badge ─────────────────────────────────────
              AnimatedBuilder(
                animation: _feedbackCtrl,
                builder: (_, __) => _feedbackCtrl.value > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FadeTransition(
                          opacity: _feedbackFade,
                          child: ScaleTransition(
                            scale: _feedbackScale,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green.shade400
                                    : Colors.red.shade400,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        .withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isCorrect ? '¡Correcto! 🎉' : '¡Incorrecto! 😢',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: 44),
              ),

              // ── Answer tiles 2×2 ──────────────────────────────────
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  child: AnimatedBuilder(
                    animation: _shakeCtrl,
                    builder: (_, __) {
                      return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(4, (i) {
                          if (i >= quiz.length) return const SizedBox();

                          final isSelected = _selected == i;
                          final isThisCorrect = i == correctIdx;

                          // Dimming logic after answer
                          double opacity = 1.0;
                          if (isAnswered) {
                            if (isThisCorrect) {
                              opacity = 1.0;
                            } else if (isSelected) {
                              opacity = 0.85;
                            } else {
                              opacity = 0.35;
                            }
                          }

                          // Shake only the wrong selected tile
                          final xOffset = (isAnswered && isSelected && !isThisCorrect)
                              ? _shakeOffset()
                              : 0.0;

                          return AnimatedBuilder(
                            animation: _tilesCtrl,
                            builder: (_, __) {
                              final tileDelay = CurvedAnimation(
                                parent: _tilesCtrl,
                                curve: Interval(
                                  i * 0.12,
                                  (i * 0.12 + 0.6).clamp(0.0, 1.0),
                                  curve: Curves.easeOutBack,
                                ),
                              );
                              return ScaleTransition(
                                scale: _selected == null
                                    ? tileDelay
                                    : const AlwaysStoppedAnimation(1.0),
                                child: Transform.translate(
                                  offset: Offset(xOffset, 0),
                                  child: Opacity(
                                    opacity: opacity,
                                    child: _KahootTile(
                                      label: quiz[i],
                                      color: _colors[i],
                                      icon: _icons[i],
                                      isAnswered: isAnswered,
                                      isCorrect: isThisCorrect,
                                      isSelected: isSelected,
                                      onTap: () => _onTileTap(i),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single Kahoot answer tile ─────────────────────────────────────────────────

class _KahootTile extends StatefulWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool isAnswered;
  final bool isCorrect;
  final bool isSelected;
  final VoidCallback onTap;

  const _KahootTile({
    required this.label,
    required this.color,
    required this.icon,
    required this.isAnswered,
    required this.isCorrect,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_KahootTile> createState() => _KahootTileState();
}

class _KahootTileState extends State<_KahootTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _bounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.12), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 0.96), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(_KahootTile old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _bounceCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showCheck = widget.isAnswered && widget.isCorrect;
    final showCross = widget.isAnswered && widget.isSelected && !widget.isCorrect;

    return GestureDetector(
      onTap: widget.isAnswered ? null : widget.onTap,
      child: ScaleTransition(
        scale: _bounce,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: showCheck
                ? Colors.green.shade500
                : showCross
                    ? Colors.red.shade600
                    : widget.color,
            borderRadius: BorderRadius.circular(18),
            border: widget.isAnswered && widget.isCorrect
                ? Border.all(color: Colors.white, width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: (showCheck
                        ? Colors.green
                        : showCross
                            ? Colors.red
                            : widget.color)
                    .withOpacity(0.5),
                blurRadius: widget.isAnswered ? 18 : 8,
                spreadRadius: widget.isAnswered && widget.isCorrect ? 3 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background icon (large, subtle, top-right)
              Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  widget.icon,
                  color: Colors.white.withOpacity(0.12),
                  size: 72,
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small icon top-left
                    Icon(widget.icon, color: Colors.white, size: 22),
                    const Spacer(),
                    // Answer text
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.3,
                        shadows: [
                          Shadow(blurRadius: 2, color: Color(0x44000000)),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Result overlay icon (centre)
              if (showCheck || showCross)
                Center(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 350),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (_, v, __) => Transform.scale(
                      scale: v,
                      child: Icon(
                        showCheck
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: Colors.white,
                        size: 52,
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
}

// ── Pill completion celebration ───────────────────────────────────────────────

class _PillCompletionDialog extends StatefulWidget {
  final EduPill pill;
  final int correctCount;
  final int totalCount;
  final VoidCallback onContinue;
  /// Null on perfect score; provided when the user must retry.
  final VoidCallback? onRetry;

  const _PillCompletionDialog({
    required this.pill,
    required this.correctCount,
    required this.totalCount,
    required this.onContinue,
    this.onRetry,
  });

  @override
  State<_PillCompletionDialog> createState() => _PillCompletionDialogState();
}

class _PillCompletionDialogState extends State<_PillCompletionDialog>
    with TickerProviderStateMixin {
  // Confetti loops indefinitely
  late final AnimationController _confettiCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  // Master timeline: 0 → 1 over 2.2 s drives everything else
  late final AnimationController _timelineCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..forward();

  // Card enters
  late final Animation<double> _cardScale = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
  );

  // Checkmark circle stroke
  late final Animation<double> _circleStroke = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
  );

  // Checkmark tick stroke
  late final Animation<double> _checkStroke = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.48, 0.68, curve: Curves.easeOut),
  );

  // Stars pop in sequentially
  late final Animation<double> _star1 = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.55, 0.70, curve: Curves.elasticOut),
  );
  late final Animation<double> _star2 = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.62, 0.77, curve: Curves.elasticOut),
  );
  late final Animation<double> _star3 = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.69, 0.84, curve: Curves.elasticOut),
  );

  // XP badge floats up then fades
  late final Animation<double> _xpSlide = Tween<double>(begin: 0, end: -48).animate(
    CurvedAnimation(
      parent: _timelineCtrl,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
    ),
  );
  late final Animation<double> _xpOpacity = Tween<double>(begin: 1, end: 0).animate(
    CurvedAnimation(
      parent: _timelineCtrl,
      curve: const Interval(0.82, 1.0, curve: Curves.easeIn),
    ),
  );

  // Button slides up + fades in
  late final Animation<Offset> _btnSlide = Tween<Offset>(
    begin: const Offset(0, 0.4),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.76, 1.0, curve: Curves.easeOut),
  ));
  late final Animation<double> _btnFade = CurvedAnimation(
    parent: _timelineCtrl,
    curve: const Interval(0.76, 1.0, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _timelineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pillColor = widget.pill.typeColor;
    final isPerfect = widget.onRetry == null;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // ── Confetti (success only) ──────────────────────────────────────
          if (isPerfect)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _confettiCtrl,
                builder: (_, __) => CustomPaint(
                  painter: _ConfettiPainter(
                    progress: _confettiCtrl.value,
                    accent: pillColor,
                  ),
                ),
              ),
            ),

          // ── Result card ──────────────────────────────────────────────────
          Center(
            child: ScaleTransition(
              scale: _cardScale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: isPerfect
                      ? null
                      : Border.all(color: Colors.red.shade200, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: isPerfect
                          ? const Color(0x40000000)
                          : Colors.red.withOpacity(0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Icon: checkmark (success) or X (failure) ──────────
                    AnimatedBuilder(
                      animation: _timelineCtrl,
                      builder: (_, __) => SizedBox(
                        width: 80,
                        height: 80,
                        child: isPerfect
                            ? CustomPaint(
                                painter: _CheckmarkPainter(
                                  circleProgress: _circleStroke.value,
                                  checkProgress: _checkStroke.value,
                                  color: Colors.green.shade600,
                                ),
                              )
                            : CustomPaint(
                                painter: _CrossPainter(
                                  progress: _circleStroke.value,
                                  color: Colors.red.shade500,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Title ─────────────────────────────────────────────
                    Text(
                      isPerfect ? '¡Píldora completada!' : '¡Sigue intentándolo!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isPerfect
                            ? const Color(0xFF1B6B4B)
                            : Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isPerfect
                          ? widget.pill.title
                          : '${widget.correctCount} de ${widget.totalCount} respuestas correctas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

                    // ── Stars (reflect correct answers) ───────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.totalCount, (i) {
                        final filled = i < widget.correctCount;
                        // sizes: medium, large, medium for 3-star layout
                        final size = widget.totalCount == 3
                            ? (i == 1 ? 44.0 : 34.0)
                            : 36.0;
                        final anim = i == 0
                            ? _star1
                            : i == 1
                                ? _star2
                                : _star3;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ScaleTransition(
                            scale: anim,
                            child: Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: filled
                                  ? Colors.amber.shade600
                                  : Colors.grey.shade300,
                              size: size,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 14),

                    // ── XP badge (success only, floats up) ────────────────
                    if (isPerfect)
                      AnimatedBuilder(
                        animation: _timelineCtrl,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(0, _xpSlide.value),
                          child: Opacity(
                            opacity: _xpOpacity.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt,
                                      color: Colors.amber.shade700, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+10 XP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.amber.shade800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      // Failure hint
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Necesitas el 100% para completar\nesta píldora y desbloquear la siguiente.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),

                    const SizedBox(height: 22),

                    // ── Action button(s) ──────────────────────────────────
                    SlideTransition(
                      position: _btnSlide,
                      child: FadeTransition(
                        opacity: _btnFade,
                        child: Column(
                          children: [
                            // Primary: retry (failure) or continue (success)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPerfect
                                      ? const Color(0xFF1B6B4B)
                                      : Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: isPerfect
                                    ? widget.onContinue
                                    : widget.onRetry,
                                child: Text(
                                  isPerfect
                                      ? '¡Continuar!'
                                      : '🔄  Intentarlo de nuevo',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            // Secondary: close without retrying
                            if (!isPerfect) ...[
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: widget.onContinue,
                                child: Text(
                                  'Cerrar',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated checkmark (circle stroke → tick stroke) ─────────────────────────

class _CheckmarkPainter extends CustomPainter {
  final double circleProgress; // 0→1: circle outline draws itself
  final double checkProgress;  // 0→1: tick draws itself
  final Color color;

  const _CheckmarkPainter({
    required this.circleProgress,
    required this.checkProgress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Filled background circle (grows with circle stroke)
    if (circleProgress > 0) {
      canvas.drawCircle(
        center,
        radius * circleProgress.clamp(0.0, 1.0),
        Paint()..color = color.withOpacity(0.12),
      );
    }

    // Circle outline stroke
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * circleProgress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // Checkmark (two segments: left→bottom, then bottom→top-right)
    if (checkProgress > 0) {
      final p1 = Offset(size.width * 0.22, size.height * 0.50);
      final p2 = Offset(size.width * 0.43, size.height * 0.67);
      final p3 = Offset(size.width * 0.78, size.height * 0.33);

      final seg1Len = (p2 - p1).distance;
      final seg2Len = (p3 - p2).distance;
      final total = seg1Len + seg2Len;
      final seg1Frac = seg1Len / total;

      final path = Path()..moveTo(p1.dx, p1.dy);

      if (checkProgress <= seg1Frac) {
        final t = checkProgress / seg1Frac;
        path.lineTo(
          p1.dx + (p2.dx - p1.dx) * t,
          p1.dy + (p2.dy - p1.dy) * t,
        );
      } else {
        final t = (checkProgress - seg1Frac) / (1 - seg1Frac);
        path.lineTo(p2.dx, p2.dy);
        path.lineTo(
          p2.dx + (p3.dx - p2.dx) * t,
          p2.dy + (p3.dy - p2.dy) * t,
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) =>
      old.circleProgress != circleProgress ||
      old.checkProgress != checkProgress;
}

// ── Cross painter (failure state) ────────────────────────────────────────────

class _CrossPainter extends CustomPainter {
  final double progress; // 0→1
  final Color color;

  const _CrossPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Filled background circle
    if (progress > 0) {
      canvas.drawCircle(
        center,
        radius * progress.clamp(0.0, 1.0),
        Paint()..color = color.withOpacity(0.12),
      );
    }

    // Circle outline
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // X strokes (appear in second half of animation)
    if (progress > 0.5) {
      final t = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round;

      final pad = size.width * 0.28;
      final tl = Offset(pad, pad);
      final br = Offset(size.width - pad, size.height - pad);
      final tr = Offset(size.width - pad, pad);
      final bl = Offset(pad, size.height - pad);

      // First stroke: top-left → bottom-right
      canvas.drawLine(
        tl,
        Offset(tl.dx + (br.dx - tl.dx) * t, tl.dy + (br.dy - tl.dy) * t),
        paint,
      );
      // Second stroke: top-right → bottom-left
      canvas.drawLine(
        tr,
        Offset(tr.dx + (bl.dx - tr.dx) * t, tr.dy + (bl.dy - tr.dy) * t),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CrossPainter old) => old.progress != progress;
}

// ── Confetti particles ────────────────────────────────────────────────────────

class _Particle {
  final double x;      // 0-1, horizontal start position
  final double phase;  // 0-1, time offset in loop
  final double speed;  // relative fall speed
  final double size;
  final Color color;
  final double spin;   // rotation multiplier
  final double drift;  // horizontal sway amount

  const _Particle({
    required this.x,
    required this.phase,
    required this.speed,
    required this.size,
    required this.color,
    required this.spin,
    required this.drift,
  });

  static const _palette = [
    Color(0xFFE53935), // red
    Color(0xFF1E88E5), // blue
    Color(0xFF43A047), // green
    Color(0xFFFDD835), // yellow
    Color(0xFF8E24AA), // purple
    Color(0xFFFF6F00), // orange
    Color(0xFFEC407A), // pink
    Color(0xFF00ACC1), // cyan
  ];

  factory _Particle.generate(math.Random rng) {
    return _Particle(
      x: rng.nextDouble(),
      phase: rng.nextDouble(),
      speed: 0.6 + rng.nextDouble() * 0.8,
      size: 5 + rng.nextDouble() * 8,
      color: _palette[rng.nextInt(_palette.length)],
      spin: (rng.nextDouble() - 0.5) * 10,
      drift: (rng.nextDouble() - 0.5) * 0.06,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final Color accent;

  // Generate particles once with a fixed seed so they're stable across repaints
  static final _particles = List.generate(
    72,
    (i) => _Particle.generate(math.Random(i * 37)),
  );

  const _ConfettiPainter({required this.progress, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = ((progress * p.speed) + p.phase) % 1.0;
      final x = (p.x + p.drift * t) * size.width;
      final y = t * (size.height + p.size * 2) - p.size;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin * t * math.pi * 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.5),
          const Radius.circular(2),
        ),
        Paint()..color = p.color.withOpacity(0.85),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

// ── Star icon ─────────────────────────────────────────────────────────────────

class _StarIcon extends StatelessWidget {
  final double size;
  const _StarIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star_rounded, color: Colors.amber.shade600, size: size);
  }
}

// --- EXTENSIÓN PARA OSCURECER COLOR ---
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}