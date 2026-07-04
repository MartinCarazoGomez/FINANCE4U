import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/currency_helper.dart';
import 'fintech_tycoon_engine.dart';

/// Fintech Tycoon: Mi Imperio Digital
///
/// Juego tipo tycoon con avatar: compra camisetas a proveedores, véndelas a
/// clientes y gestiona gastos variables y fijos, todo con acciones visibles.
class FintechTycoonGame extends StatefulWidget {
  final VoidCallback? onCompleted;

  const FintechTycoonGame({super.key, this.onCompleted});

  @override
  State<FintechTycoonGame> createState() => _FintechTycoonGameState();
}

class _FintechTycoonGameState extends State<FintechTycoonGame>
    with TickerProviderStateMixin {
  static const _bg = Color(0xFF120E2E);
  static const _magenta = Color(0xFFFF007F);
  static const _cyan = Color(0xFF00F0FF);
  static const _green = Color(0xFF00FF66);
  static const _yellow = Color(0xFFFFFF00);

  static const _tutorialCards = [
    {
      'emoji': '🎮',
      'title': 'Bienvenido/a, futuro/a magnate',
      'text':
          'Eres un/a joven emprendedor/a. Empiezas en tu garaje con 500 € y una '
              'idea: crear tu propia marca de camisetas.',
    },
    {
      'emoji': '🎯',
      'title': 'Tu objetivo',
      'text':
          'Haz crecer tu negocio mes a mes. Compra barato, vende más caro y no '
              'dejes que los gastos te hundan. ¡Cuanto más beneficio, más grande '
              'será tu imperio!',
    },
    {
      'emoji': '🛒',
      'title': 'Cómo ganar dinero',
      'text':
          '1) Compra camisetas a tu proveedor.\n'
              '2) Ábrete al público y véndelas más caras a tus clientes.\n'
              'La diferencia es tu beneficio 💸',
    },
    {
      'emoji': '📉',
      'title': 'Cuidado con los gastos',
      'text':
          'GASTOS VARIABLES: lo que pagas por cada camiseta (compra + envío). '
              'Suben cuanto más vendes.\n\n'
              'GASTOS FIJOS: el alquiler del local, que pagas cada mes vendas lo '
              'que vendas.',
    },
    {
      'emoji': '⭐',
      'title': 'Gana fama',
      'text':
          'Si atiendes bien a tus clientes, tu reputación sube y cada mes '
              'vendrá más gente a comprarte. ¿List@ para empezar?',
    },
  ];

  late final FintechTycoonEngine _engine;
  late final TextEditingController _nameCtrl;
  late final AnimationController _idleCtrl;
  late final AnimationController _actionCtrl;
  late final AnimationController _floatCtrl;

  String _floatText = '';
  Color _floatColor = _green;

  late BizSnapshot _snap;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _engine = FintechTycoonEngine(onChanged: _onUpdate);
    _snap = _engine.snapshot;

    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _actionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  void _onUpdate(BizSnapshot snap) {
    if (!mounted) return;
    setState(() => _snap = snap);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idleCtrl.dispose();
    _actionCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  String _money(double eur) => context.money(eur);

  void _showFloat(String text, Color color) {
    setState(() {
      _floatText = text;
      _floatColor = color;
    });
    _floatCtrl.forward(from: 0);
    _actionCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: switch (_snap.phase) {
            GamePhase.tutorial => _buildTutorial(),
            GamePhase.naming => _buildNaming(),
            GamePhase.buying => _buildBuying(),
            GamePhase.selling => _buildSelling(),
            GamePhase.monthSummary => _buildSummary(),
          },
        ),
      ),
    );
  }

  // ── Onboarding ──────────────────────────────────────────────────────────────
  Widget _buildTutorial() {
    final card = _tutorialCards[_snap.tutorialStep];
    final isLast = _snap.tutorialStep == _tutorialCards.length - 1;
    return Container(
      key: ValueKey('tut-${_snap.tutorialStep}'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bg, Color(0xFF2A1055), _bg],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Text(card['emoji']!, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text(
            card['title']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _cyan,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card['text']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_tutorialCards.length, (i) {
              final active = i == _snap.tutorialStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? _magenta : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          _neonButton(
            label: isLast ? '¡Empezar! 🚀' : 'Siguiente',
            color: _magenta,
            onTap: () {
              HapticFeedback.lightImpact();
              _engine.nextTutorial();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNaming() {
    return Container(
      key: const ValueKey('naming'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          const Text('🏷️', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text(
            '¿Cómo se llama tu marca?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameCtrl,
            onChanged: _engine.setCompanyName,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Ej: Urban Threads',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: _magenta.withValues(alpha: 0.6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _cyan, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _neonButton(
            label: 'Abrir mi negocio',
            color: _green,
            onTap: _snap.companyName.isEmpty
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    FocusScope.of(context).unfocus();
                    _engine.confirmCompanyName();
                  },
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // ── Fase COMPRAR ─────────────────────────────────────────────────────────────
  Widget _buildBuying() {
    final canBuy = _snap.cash >= _snap.unitCost;
    return Column(
      key: const ValueKey('buying'),
      children: [
        _header(),
        _phaseBanner(
          '🛒 Mes ${_snap.month}: abastece tu stock',
          'Compra camisetas a tu proveedor. Cada una te cuesta '
              '${_money(_snap.unitCost)} (gasto variable).',
          _cyan,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _scene(
                  left: '🧑‍💼',
                  right: '🏭',
                  rightLabel: 'Proveedor',
                  action: '📦',
                ),
                const SizedBox(height: 16),
                _infoStrip([
                  _infoChip('👕 Stock', '${_snap.inventory}', _cyan),
                  _infoChip('🏷️ Compra', _money(_snap.unitCost), _yellow),
                  _infoChip('💰 Venta', _money(_snap.unitPrice), _green),
                ]),
                const SizedBox(height: 20),
                _neonButton(
                  label: canBuy
                      ? '📦 Comprar 1 camiseta (−${_money(_snap.unitCost)})'
                      : 'Sin caja suficiente',
                  color: _cyan,
                  onTap: canBuy
                      ? () {
                          if (_engine.buyOne()) {
                            _showFloat('+1 👕', _cyan);
                            HapticFeedback.selectionClick();
                          }
                        }
                      : null,
                ),
                const SizedBox(height: 10),
                _neonButton(
                  label: '📦 Comprar 5 de golpe',
                  color: _magenta,
                  outlined: true,
                  onTap: _snap.cash >= _snap.unitCost
                      ? () {
                          final n = _engine.buyBatch(5);
                          if (n > 0) {
                            _showFloat('+$n 👕', _cyan);
                            HapticFeedback.mediumImpact();
                          }
                        }
                      : null,
                ),
                const SizedBox(height: 24),
                _neonButton(
                  label: _snap.inventory > 0
                      ? '🚪 Abrir la tienda y vender ▶'
                      : 'Compra stock para abrir',
                  color: _green,
                  onTap: _snap.inventory > 0
                      ? () {
                          HapticFeedback.mediumImpact();
                          _engine.openStore();
                        }
                      : null,
                ),
                const SizedBox(height: 12),
                _tipBox(
                  'Consejo: te esperan ${_snap.customersRemaining} clientes este '
                  'mes. Compra suficiente stock para no quedarte corto.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Fase VENDER ──────────────────────────────────────────────────────────────
  Widget _buildSelling() {
    return Column(
      key: const ValueKey('selling'),
      children: [
        _header(),
        _phaseBanner(
          '🛍️ ¡Tienda abierta!',
          'Atiende a cada cliente. Ganas ${_money(_snap.unitPrice)} pero pagas '
              '${_money(_snap.packagingCost)} de envío por venta (variable).',
          _green,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _scene(
                  left: '🧑‍💼',
                  right: _snap.customersRemaining > 0 ? '🧑' : '🙌',
                  rightLabel: _snap.customersRemaining > 0
                      ? 'Cliente'
                      : '¡Todos atendidos!',
                  action: '👕',
                ),
                const SizedBox(height: 16),
                _infoStrip([
                  _infoChip('👕 Stock', '${_snap.inventory}', _cyan),
                  _infoChip('🧑 En cola', '${_snap.customersRemaining}', _yellow),
                  _infoChip('✅ Vendidas', '${_snap.customersServed}', _green),
                ]),
                const SizedBox(height: 8),
                _sellProgress(),
                const SizedBox(height: 20),
                if (_snap.canServe)
                  _neonButton(
                    label:
                        '💸 Vender camiseta (+${_money(_snap.profitPerUnit)} beneficio)',
                    color: _green,
                    onTap: () {
                      if (_engine.serveCustomer()) {
                        _showFloat('+${_money(_snap.profitPerUnit)}', _green);
                        HapticFeedback.lightImpact();
                      }
                    },
                  )
                else if (_snap.outOfStock)
                  Column(
                    children: [
                      _tipBox(
                        '¡Te has quedado sin stock y aún hay '
                        '${_snap.customersRemaining} clientes esperando! '
                        'Compra más o cierra el mes.',
                        color: _yellow,
                      ),
                      const SizedBox(height: 12),
                      _neonButton(
                        label: '📦 Comprar más stock',
                        color: _cyan,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _engine.backToBuying();
                        },
                      ),
                    ],
                  )
                else
                  _tipBox(
                    '🎉 ¡Has atendido a todos los clientes del mes!',
                    color: _green,
                  ),
                const SizedBox(height: 16),
                _neonButton(
                  label: '📅 Cerrar el mes ▶',
                  color: _magenta,
                  outlined: true,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _engine.closeMonth();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Resumen del mes ──────────────────────────────────────────────────────────
  Widget _buildSummary() {
    final profit = _snap.lastProfit;
    final positive = profit >= 0;
    return Container(
      key: const ValueKey('summary'),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Resultados del mes ${_snap.month}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: (positive ? _green : _magenta).withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    _sumRow('🛍️ Ingresos por ventas', _snap.monthRevenue, _green),
                    const Divider(color: Colors.white12, height: 24),
                    _sumRow('📦 Coste camisetas (variable)',
                        -_snap.monthGoodsCost, _yellow),
                    _sumRow('🚚 Envíos (variable)', -_snap.monthPackaging,
                        _yellow),
                    _sumRow('🏠 Alquiler (fijo)', -_snap.rent, _magenta),
                    const Divider(color: Colors.white12, height: 24),
                    _sumRow(
                      positive ? '✅ Beneficio' : '❌ Pérdidas',
                      profit,
                      positive ? _green : _magenta,
                      bold: true,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _cyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _snap.lastRepChange >= 0
                                ? '⭐ Reputación +${_snap.lastRepChange}'
                                : '⭐ Reputación ${_snap.lastRepChange}',
                            style: const TextStyle(
                              color: _cyan,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _summaryFeedback(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _infoStrip([
            _infoChip('💰 Caja', _money(_snap.cash), _green),
            _infoChip('⭐ Fama', '${_snap.reputation}', _cyan),
          ]),
          const SizedBox(height: 16),
          _neonButton(
            label: '▶ Empezar mes ${_snap.month + 1}',
            color: _green,
            onTap: () {
              HapticFeedback.mediumImpact();
              _engine.nextMonth();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _summaryFeedback() {
    final rate = _snap.customersTotal > 0
        ? _snap.customersServed / _snap.customersTotal
        : 0.0;
    if (_snap.lastProfit < 0) {
      return 'Este mes has perdido dinero. Intenta vender más o controlar gastos.';
    }
    if (rate >= 0.9) {
      return '¡Genial! Atendiste a casi todos. Tu fama sube y vendrán más clientes.';
    }
    if (_snap.lastCustomersLost > 0) {
      return 'Se quedaron ${_snap.lastCustomersLost} clientes sin comprar. '
          'Compra más stock el próximo mes.';
    }
    return 'Buen trabajo. Sigue creciendo poco a poco.';
  }

  // ── Componentes visuales ─────────────────────────────────────────────────────
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: _magenta.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                _headerChip('🏢 ${_snap.companyName}', _magenta),
                _headerChip('💰 ${_money(_snap.cash)}', _green),
                _headerChip('⭐ ${_snap.reputation}', _cyan),
                _headerChip('📅 Mes ${_snap.month}', _yellow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _phaseBanner(String title, String subtitle, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  /// Escena con avatar a la izquierda y proveedor/cliente a la derecha.
  Widget _scene({
    required String left,
    required String right,
    required String rightLabel,
    required String action,
  }) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1548), Color(0xFF0A0820)],
        ),
        border: Border.all(color: _cyan.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Container(height: 2, color: Colors.white10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _avatar(left, 'Tú'),
              AnimatedBuilder(
                animation: _actionCtrl,
                builder: (_, __) => Transform.scale(
                  scale: 1 + _actionCtrl.value * 0.5,
                  child: Opacity(
                    opacity: 0.5 + _actionCtrl.value * 0.5,
                    child: Text(action, style: const TextStyle(fontSize: 30)),
                  ),
                ),
              ),
              _avatar(right, rightLabel),
            ],
          ),
          _floatingFeedback(),
        ],
      ),
    );
  }

  Widget _avatar(String emoji, String label) {
    return AnimatedBuilder(
      animation: _idleCtrl,
      builder: (_, __) {
        final dy = -3 + _idleCtrl.value * 6;
        return Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(0, dy),
                child: Text(emoji, style: const TextStyle(fontSize: 52)),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _floatingFeedback() {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, __) {
        if (_floatCtrl.value == 0 || _floatCtrl.isDismissed) {
          return const SizedBox.shrink();
        }
        return Positioned(
          top: 20 - _floatCtrl.value * 20,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: (1 - _floatCtrl.value).clamp(0.0, 1.0),
            child: Center(
              child: Text(
                _floatText,
                style: TextStyle(
                  color: _floatColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoStrip(List<Widget> chips) {
    return Row(
      children: [
        for (var i = 0; i < chips.length; i++) ...[
          Expanded(child: chips[i]),
          if (i < chips.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellProgress() {
    final total = _snap.customersTotal;
    final value = total > 0 ? _snap.customersServed / total : 0.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 10,
        backgroundColor: Colors.white12,
        valueColor: const AlwaysStoppedAnimation(_green),
      ),
    );
  }

  Widget _tipBox(String text, {Color color = _cyan}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.85),
          fontSize: 12,
          height: 1.4,
        ),
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
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: bold ? 16 : 13,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$sign${_money(amount)}',
            style: TextStyle(
              color: color,
              fontSize: bold ? 18 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _neonButton({
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool outlined = false,
  }) {
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
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: enabled ? color : Colors.white24),
          ),
          elevation: enabled && !outlined ? 6 : 0,
          shadowColor: color.withValues(alpha: 0.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}
