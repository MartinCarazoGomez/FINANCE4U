/// Motor de negocio de Fintech Tycoon (Fase 1 reformulada).
///
/// Bucle claro tipo videojuego: COMPRAR stock a proveedores → VENDER a
/// clientes → pagar gastos (variables y fijos) → cerrar el mes y crecer.
/// El motor es puro (sin UI) para mantener la precisión de los cálculos.

enum GamePhase {
  tutorial,
  naming,
  buying,
  selling,
  monthSummary,
}

class BizSnapshot {
  final GamePhase phase;
  final int tutorialStep;
  final String companyName;

  final double cash;
  final int inventory;
  final int month;
  final int reputation;

  // Economía por unidad
  final double unitCost;
  final double unitPrice;
  final double packagingCost;
  final double rent;

  // Seguimiento del mes en curso
  final double monthRevenue;
  final double monthGoodsCost;
  final double monthPackaging;
  final int customersTotal;
  final int customersServed;
  final int customersRemaining;

  // Resultado del último cierre de mes
  final double lastProfit;
  final int lastRepChange;
  final int lastCustomersLost;

  const BizSnapshot({
    required this.phase,
    required this.tutorialStep,
    required this.companyName,
    required this.cash,
    required this.inventory,
    required this.month,
    required this.reputation,
    required this.unitCost,
    required this.unitPrice,
    required this.packagingCost,
    required this.rent,
    required this.monthRevenue,
    required this.monthGoodsCost,
    required this.monthPackaging,
    required this.customersTotal,
    required this.customersServed,
    required this.customersRemaining,
    required this.lastProfit,
    required this.lastRepChange,
    required this.lastCustomersLost,
  });

  /// Beneficio por camiseta vendida (precio - coste - envío).
  double get profitPerUnit => unitPrice - unitCost - packagingCost;

  bool get canServe => inventory > 0 && customersRemaining > 0;
  bool get outOfStock => inventory <= 0 && customersRemaining > 0;
}

class FintechTycoonEngine {
  static const double startCash = 500.0;
  static const int tutorialCards = 5;

  final void Function(BizSnapshot) onChanged;

  FintechTycoonEngine({required this.onChanged});

  GamePhase _phase = GamePhase.tutorial;
  int _tutorialStep = 0;
  String _companyName = '';

  double _cash = startCash;
  int _inventory = 0;
  int _month = 1;
  int _reputation = 10;

  // Economía (fija en Fase 1: producto = camisetas)
  final double _unitCost = 6;
  final double _unitPrice = 15;
  final double _packagingCost = 1;
  final double _rent = 50;

  double _monthRevenue = 0;
  double _monthGoodsCost = 0;
  double _monthPackaging = 0;
  int _customersTotal = 0;
  int _customersServed = 0;
  int _customersRemaining = 0;

  double _lastProfit = 0;
  int _lastRepChange = 0;
  int _lastCustomersLost = 0;

  BizSnapshot get snapshot => BizSnapshot(
        phase: _phase,
        tutorialStep: _tutorialStep,
        companyName: _companyName,
        cash: _cash,
        inventory: _inventory,
        month: _month,
        reputation: _reputation,
        unitCost: _unitCost,
        unitPrice: _unitPrice,
        packagingCost: _packagingCost,
        rent: _rent,
        monthRevenue: _monthRevenue,
        monthGoodsCost: _monthGoodsCost,
        monthPackaging: _monthPackaging,
        customersTotal: _customersTotal,
        customersServed: _customersServed,
        customersRemaining: _customersRemaining,
        lastProfit: _lastProfit,
        lastRepChange: _lastRepChange,
        lastCustomersLost: _lastCustomersLost,
      );

  // ── Onboarding ────────────────────────────────────────────────────────────
  void nextTutorial() {
    if (_tutorialStep >= tutorialCards - 1) {
      _phase = GamePhase.naming;
    } else {
      _tutorialStep++;
    }
    _notify();
  }

  void setCompanyName(String name) {
    _companyName = name.trim();
    _notify();
  }

  void confirmCompanyName() {
    if (_companyName.isEmpty) return;
    _startMonth();
    _notify();
  }

  // ── Ciclo mensual ──────────────────────────────────────────────────────────
  void _startMonth() {
    _monthRevenue = 0;
    _monthGoodsCost = 0;
    _monthPackaging = 0;
    _customersServed = 0;
    _customersTotal = _demandForReputation();
    _customersRemaining = _customersTotal;
    _phase = GamePhase.buying;
  }

  int _demandForReputation() {
    // A más reputación, más clientes potenciales este mes.
    return 8 + (_reputation * 0.6).round();
  }

  /// Comprar una camiseta al proveedor (gasto variable inmediato).
  bool buyOne() {
    if (_phase != GamePhase.buying) return false;
    if (_cash < _unitCost) return false;
    _cash -= _unitCost;
    _inventory++;
    _monthGoodsCost += _unitCost;
    _notify();
    return true;
  }

  /// Comprar un lote (hasta [count] según caja disponible).
  int buyBatch(int count) {
    var bought = 0;
    for (var i = 0; i < count; i++) {
      if (!buyOne()) break;
      bought++;
    }
    return bought;
  }

  /// Abrir la tienda: pasar de comprar a vender.
  void openStore() {
    if (_inventory <= 0) return;
    _phase = GamePhase.selling;
    _notify();
  }

  /// Volver a comprar stock en mitad del mes (por ejemplo si te quedas sin stock).
  void backToBuying() {
    _phase = GamePhase.buying;
    _notify();
  }

  /// Vender una camiseta al cliente que espera.
  bool serveCustomer() {
    if (_phase != GamePhase.selling) return false;
    if (_inventory <= 0 || _customersRemaining <= 0) return false;
    _inventory--;
    _customersRemaining--;
    _customersServed++;
    _cash += _unitPrice - _packagingCost;
    _monthRevenue += _unitPrice;
    _monthPackaging += _packagingCost;
    _notify();
    return true;
  }

  /// Cerrar el mes: pagar el alquiler (gasto fijo) y calcular resultados.
  void closeMonth() {
    _lastCustomersLost = _customersRemaining;
    _cash -= _rent;
    _lastProfit =
        _monthRevenue - _monthGoodsCost - _monthPackaging - _rent;

    final serveRate =
        _customersTotal > 0 ? _customersServed / _customersTotal : 0.0;
    if (serveRate >= 0.9) {
      _lastRepChange = 5;
    } else if (serveRate >= 0.6) {
      _lastRepChange = 2;
    } else if (serveRate >= 0.3) {
      _lastRepChange = 0;
    } else {
      _lastRepChange = -3;
    }
    _reputation = (_reputation + _lastRepChange).clamp(0, 100);

    _phase = GamePhase.monthSummary;
    _notify();
  }

  void nextMonth() {
    _month++;
    _startMonth();
    _notify();
  }

  void _notify() => onChanged(snapshot);
}
