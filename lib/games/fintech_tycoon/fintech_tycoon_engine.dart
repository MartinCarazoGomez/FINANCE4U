import 'dart:async';

/// Motor económico desacoplado del renderizado (Fase 1).
enum FintechSector {
  streetwear,
  indieGames,
  contentAgency,
}

enum FintechPhase {
  onboardingName,
  onboardingSector,
  clickLoop,
  running,
}

class SectorProfile {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final double gastosFijosMensuales;
  final double ingresosTrasMvp;
  final int reputacionInicial;

  const SectorProfile({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.gastosFijosMensuales,
    required this.ingresosTrasMvp,
    required this.reputacionInicial,
  });
}

class FintechTycoonSnapshot {
  final String companyName;
  final FintechSector? sector;
  final FintechPhase phase;
  final double cajaActual;
  final double ingresosPorSegundo;
  final double gastosFijosMensuales;
  final int ticksEnMes;
  final int mes;
  final int creditScore;
  final int reputacionMarca;
  final int mvpClicks;
  final bool mvpLaunched;
  final bool overdraftAlert;
  final bool monthJustClosed;

  const FintechTycoonSnapshot({
    required this.companyName,
    required this.sector,
    required this.phase,
    required this.cajaActual,
    required this.ingresosPorSegundo,
    required this.gastosFijosMensuales,
    required this.ticksEnMes,
    required this.mes,
    required this.creditScore,
    required this.reputacionMarca,
    required this.mvpClicks,
    required this.mvpLaunched,
    required this.overdraftAlert,
    required this.monthJustClosed,
  });

  double get mvpProgress => (mvpClicks / FintechTycoonEngine.mvpClickTarget).clamp(0.0, 1.0);
}

class FintechTycoonEngine {
  static const int ticksPerMonth = 60;
  static const int mvpClickTarget = 100;
  static const double clickReward = 1.0;
  static const double cajaInicial = 500.0;

  static const sectorProfiles = <FintechSector, SectorProfile>{
    FintechSector.streetwear: SectorProfile(
      id: 'streetwear',
      title: 'Ropa Streetwear',
      emoji: '👕',
      description: 'Bajo coste de servidores, alta volatilidad en marketing.',
      gastosFijosMensuales: 45,
      ingresosTrasMvp: 0.50,
      reputacionInicial: 12,
    ),
    FintechSector.indieGames: SectorProfile(
      id: 'indie_games',
      title: 'Videojuegos Indie',
      emoji: '🎮',
      description: 'Alto coste inicial, ingresos en picos tras el lanzamiento.',
      gastosFijosMensuales: 55,
      ingresosTrasMvp: 0.55,
      reputacionInicial: 8,
    ),
    FintechSector.contentAgency: SectorProfile(
      id: 'content_agency',
      title: 'Agencia de Creadores',
      emoji: '📱',
      description: 'Ingresos constantes, muy sensible a la reputación de marca.',
      gastosFijosMensuales: 50,
      ingresosTrasMvp: 0.48,
      reputacionInicial: 14,
    ),
  };

  String _companyName = '';
  FintechSector? _sector;
  FintechPhase _phase = FintechPhase.onboardingName;

  double _cajaActual = cajaInicial;
  double _ingresosPorSegundo = 0;
  double _gastosFijosMensuales = 50;
  int _ticksEnMes = 0;
  int _mes = 1;
  int _creditScore = 650;
  int _reputacionMarca = 10;

  int _mvpClicks = 0;
  bool _mvpLaunched = false;
  bool _overdraftAlert = false;
  bool _monthJustClosed = false;

  Timer? _tickTimer;
  final void Function(FintechTycoonSnapshot) onChanged;

  FintechTycoonEngine({required this.onChanged});

  FintechTycoonSnapshot get snapshot => FintechTycoonSnapshot(
        companyName: _companyName,
        sector: _sector,
        phase: _phase,
        cajaActual: _cajaActual,
        ingresosPorSegundo: _ingresosPorSegundo,
        gastosFijosMensuales: _gastosFijosMensuales,
        ticksEnMes: _ticksEnMes,
        mes: _mes,
        creditScore: _creditScore,
        reputacionMarca: _reputacionMarca,
        mvpClicks: _mvpClicks,
        mvpLaunched: _mvpLaunched,
        overdraftAlert: _overdraftAlert,
        monthJustClosed: _monthJustClosed,
      );

  void dispose() {
    _tickTimer?.cancel();
  }

  void setCompanyName(String name) {
    _companyName = name.trim();
    _notify();
  }

  void confirmCompanyName() {
    if (_companyName.isEmpty) return;
    _phase = FintechPhase.onboardingSector;
    _notify();
  }

  void selectSector(FintechSector sector) {
    final profile = sectorProfiles[sector]!;
    _sector = sector;
    _gastosFijosMensuales = profile.gastosFijosMensuales;
    _reputacionMarca = profile.reputacionInicial;
    _phase = FintechPhase.clickLoop;
    _startTicks();
    _notify();
  }

  void onWorkClick() {
    if (_phase != FintechPhase.clickLoop || _mvpLaunched) return;
    _mvpClicks++;
    _cajaActual += clickReward;
    if (_mvpClicks >= mvpClickTarget) {
      _launchMvp();
    }
    _notify();
  }

  void acknowledgeOverdraft() {
    _overdraftAlert = false;
    _notify();
  }

  void acknowledgeMonthClose() {
    _monthJustClosed = false;
    _notify();
  }

  void _launchMvp() {
    final profile = sectorProfiles[_sector!]!;
    _mvpLaunched = true;
    _ingresosPorSegundo = profile.ingresosTrasMvp;
    _phase = FintechPhase.running;
    _notify();
  }

  void _startTicks() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    if (_phase == FintechPhase.onboardingName ||
        _phase == FintechPhase.onboardingSector) {
      return;
    }

    _monthJustClosed = false;

    if (_mvpLaunched && _ingresosPorSegundo > 0) {
      _cajaActual += _ingresosPorSegundo;
    }

    _ticksEnMes++;
    if (_ticksEnMes >= ticksPerMonth) {
      _pagarGastosMensuales();
    }

    _notify();
  }

  void _pagarGastosMensuales() {
    _ticksEnMes = 0;
    _mes++;
    _cajaActual -= _gastosFijosMensuales;
    _monthJustClosed = true;

    if (_cajaActual < 0) {
      _overdraftAlert = true;
      _creditScore = (_creditScore - 25).clamp(300, 850);
    } else if (_cajaActual > _gastosFijosMensuales * 2) {
      _creditScore = (_creditScore + 3).clamp(300, 850);
    }
  }

  void _notify() => onChanged(snapshot);
}
