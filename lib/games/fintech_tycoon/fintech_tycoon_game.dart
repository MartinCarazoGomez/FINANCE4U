import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/currency_helper.dart';
import 'fintech_tycoon_engine.dart';

/// Fintech Tycoon: Mi Imperio Digital — Fase 1 (motor + onboarding + clicks MVP).
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

  late final FintechTycoonEngine _engine;
  late final TextEditingController _nameCtrl;
  late final AnimationController _pulseCtrl;
  FintechTycoonSnapshot _snap = FintechTycoonSnapshot(
    companyName: '',
    sector: null,
    phase: FintechPhase.onboardingName,
    cajaActual: FintechTycoonEngine.cajaInicial,
    ingresosPorSegundo: 0,
    gastosFijosMensuales: 50,
    ticksEnMes: 0,
    mes: 1,
    creditScore: 650,
    reputacionMarca: 10,
    mvpClicks: 0,
    mvpLaunched: false,
    overdraftAlert: false,
    monthJustClosed: false,
  );

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _engine = FintechTycoonEngine(onChanged: _onEngineUpdate);
  }

  void _onEngineUpdate(FintechTycoonSnapshot snap) {
    if (!mounted) return;
    setState(() => _snap = snap);
    if (snap.overdraftAlert) _showOverdraftDialog();
    if (snap.monthJustClosed && !snap.overdraftAlert) _showMonthDialog();
  }

  @override
  void dispose() {
    _engine.dispose();
    _nameCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _money(double eur) => context.money(eur);

  void _showOverdraftDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_snap.overdraftAlert) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A1440),
          title: const Text('⚠️ Descubierto bancario',
              style: TextStyle(color: _yellow)),
          content: Text(
            'Tus gastos fijos del mes superaron la caja. '
            'En la Fase 2 se abrirá el menú de Financiación.',
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _engine.acknowledgeOverdraft();
              },
              child: const Text('Entendido', style: TextStyle(color: _cyan)),
            ),
          ],
        ),
      );
    });
  }

  void _showMonthDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_snap.monthJustClosed) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A1440),
          title: Text('📅 Fin del mes ${_snap.mes - 1}',
              style: const TextStyle(color: _cyan)),
          content: Text(
            'Se han pagado ${_money(_snap.gastosFijosMensuales)} en gastos fijos. '
            'Caja actual: ${_money(_snap.cajaActual)}',
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _engine.acknowledgeMonthClose();
              },
              child: const Text('Continuar', style: TextStyle(color: _green)),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: switch (_snap.phase) {
            FintechPhase.onboardingName => _buildNameOnboarding(),
            FintechPhase.onboardingSector => _buildSectorOnboarding(),
            FintechPhase.clickLoop || FintechPhase.running => _buildGameplay(),
          },
        ),
      ),
    );
  }

  Widget _buildNameOnboarding() {
    return Container(
      key: const ValueKey('name'),
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
          const Text('🌆', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text(
            'Fintech Tycoon',
            style: TextStyle(
              color: _magenta,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mi Imperio Digital',
            style: TextStyle(
              color: _cyan.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameCtrl,
            onChanged: _engine.setCompanyName,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Nombre de tu empresa',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _magenta),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: _magenta.withOpacity(0.6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _cyan, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _neonButton(
            label: 'Empezar aventura',
            color: _magenta,
            onTap: _snap.companyName.isEmpty
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    _engine.confirmCompanyName();
                  },
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildSectorOnboarding() {
    return Container(
      key: const ValueKey('sector'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${_snap.companyName} — elige tu sector',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: FintechSector.values.map((sector) {
                final p = FintechTycoonEngine.sectorProfiles[sector]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _sectorCard(sector, p),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectorCard(FintechSector sector, SectorProfile profile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          _engine.selectSector(sector);
        },
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _cyan.withOpacity(0.5)),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.06),
                _magenta.withOpacity(0.12),
              ],
            ),
          ),
          child: Row(
            children: [
              Text(profile.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _cyan),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameplay() {
    final profile = _snap.sector != null
        ? FintechTycoonEngine.sectorProfiles[_snap.sector!]!
        : null;

    return Column(
      key: const ValueKey('game'),
      children: [
        _buildHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _garageView(profile?.emoji ?? '🏢'),
                const SizedBox(height: 16),
                if (!_snap.mvpLaunched) ...[
                  Text(
                    'Lanzamiento del MVP',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _snap.mvpProgress,
                      minHeight: 12,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(_green),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_snap.mvpClicks} / ${FintechTycoonEngine.mvpClickTarget} clics',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  _neonButton(
                    label: '💻 Hacer clic para trabajar (+1€)',
                    color: _cyan,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _engine.onWorkClick();
                    },
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _green.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🚀 ¡Lanzamiento exitoso!',
                          style: TextStyle(
                            color: _green,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingresos pasivos: ${_money(_snap.ingresosPorSegundo)}/s',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'La simulación avanza cada segundo. Al mes 60s se pagan gastos fijos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                _statsRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        border: Border(bottom: BorderSide(color: _magenta.withOpacity(0.4))),
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
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                _headerChip('🏢 ${_snap.companyName}', _magenta),
                _headerChip('💰 ${_money(_snap.cajaActual)}', _green),
                _headerChip('📊 ${_snap.creditScore}', _cyan),
                _headerChip('📅 Mes ${_snap.mes}', _yellow),
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
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
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

  Widget _garageView(String sectorEmoji) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cyan.withOpacity(0.35 + _pulseCtrl.value * 0.15)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1238), Color(0xFF0A0820)],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 24,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('🖥️', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 24),
                    Text('🪑', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 24),
                    Text('💡', style: TextStyle(fontSize: 22)),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sectorEmoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    'Garaje inicial — ${_snap.companyName}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statTile(
            'Ingresos/s',
            _money(_snap.ingresosPorSegundo),
            _green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statTile(
            'Gastos fijos/mes',
            _money(_snap.gastosFijosMensuales),
            _yellow,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statTile(
            'Reputación',
            '${_snap.reputacionMarca}',
            _magenta,
          ),
        ),
      ],
    );
  }

  Widget _statTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.white60, fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _neonButton({
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color.withOpacity(0.25) : Colors.white10,
          foregroundColor: enabled ? color : Colors.white38,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: enabled ? color : Colors.white24),
          ),
          elevation: enabled ? 6 : 0,
          shadowColor: color.withOpacity(0.5),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}
