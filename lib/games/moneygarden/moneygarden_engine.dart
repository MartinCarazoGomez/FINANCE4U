import 'dart:math';

import 'moneygarden_data.dart';

/// Motor de MoneyGarden (puro, sin UI).
///
/// Bucle por turnos: personalizar → onboarding → mapa → comprar/vender/pagar
/// → resumen de mes → siguiente mes. Introduce un concepto nuevo por mes
/// (ahorro, impuestos, imprevisto, crédito) y controla victoria/derrota.

enum GamePhase {
  personalize,
  onboarding,
  map,
  provider,
  shop,
  bills,
  piggybank,
  monthSummary,
  gameOver,
  victory,
}

enum MgZone { provider, shop, bills, piggybank }

class MgSnapshot {
  final GamePhase phase;
  final int onboardingStep;

  final String avatarName;
  final int avatarStyle;

  final double coins;
  final int inventory;
  final int month;
  final int reputation;
  final double savings;

  // Economía
  final double unitCost;
  final double unitPrice; // ya incluye ajuste del jugador
  final int priceAdjust; // -2..+2
  final double rent;
  final double taxRate;
  final int minSales;

  // Progreso del mes
  final int customersTotal;
  final int customersRemaining;
  final int soldThisMonth;
  final double monthRevenue;
  final double monthGoodsCost;
  final bool boughtThisMonth;
  final bool billsPaidThisMonth;

  // Evento / crédito
  final double eventCost;
  final String eventText;
  final bool creditOffered;
  final double loanOutstanding;
  final int loanMonthsLeft;

  // Cierre
  final double lastProfit;
  final double lastTaxPaid;
  final int lastRepChange;
  final bool lastImpago;
  final int consecutiveImpagos;

  // Tarjeta educativa pendiente y cuaderno
  final Flashcard? pendingCard;
  final List<String> notebook;

  // Frase puntual del mentor (banner)
  final String? mentorFlash;

  const MgSnapshot({
    required this.phase,
    required this.onboardingStep,
    required this.avatarName,
    required this.avatarStyle,
    required this.coins,
    required this.inventory,
    required this.month,
    required this.reputation,
    required this.savings,
    required this.unitCost,
    required this.unitPrice,
    required this.priceAdjust,
    required this.rent,
    required this.taxRate,
    required this.minSales,
    required this.customersTotal,
    required this.customersRemaining,
    required this.soldThisMonth,
    required this.monthRevenue,
    required this.monthGoodsCost,
    required this.boughtThisMonth,
    required this.billsPaidThisMonth,
    required this.eventCost,
    required this.eventText,
    required this.creditOffered,
    required this.loanOutstanding,
    required this.loanMonthsLeft,
    required this.lastProfit,
    required this.lastTaxPaid,
    required this.lastRepChange,
    required this.lastImpago,
    required this.consecutiveImpagos,
    required this.pendingCard,
    required this.notebook,
    required this.mentorFlash,
  });

  double get profitPerUnit => unitPrice - unitCost;
  bool get canServe => inventory > 0 && customersRemaining > 0;
  bool get minSalesMet => soldThisMonth >= minSales;
  bool get outOfDemand => customersRemaining <= 0;

  /// Total que hay que pagar al cobrador este mes.
  double get billsDue => rent + eventCost;

  bool get avatarStyleReady => avatarStyle >= 0;
  String get avatarEmoji =>
      avatarStyle >= 0 && avatarStyle < kAvatarOptions.length
          ? kAvatarOptions[avatarStyle].emoji
          : '🧑';
}

class MoneyGardenEngine {
  static const double startCoins = 100;
  static const int totalMonths = 12;
  static const double victorySavings = 200;

  final void Function(MgSnapshot) onChanged;
  final Random _rng = Random();

  MoneyGardenEngine({required this.onChanged});

  GamePhase _phase = GamePhase.personalize;
  int _onboardingStep = 0;

  String _avatarName = '';
  int _avatarStyle = -1;

  double _coins = startCoins;
  int _inventory = 0;
  int _month = 1;
  int _reputation = 10;
  double _savings = 0;

  final double _unitCost = 5;
  final double _basePrice = 10;
  int _priceAdjust = 0;
  final double _rent = 20;
  final int _minSales = 5;

  int _customersTotal = 0;
  int _customersRemaining = 0;
  int _soldThisMonth = 0;
  double _monthRevenue = 0;
  double _monthGoodsCost = 0;
  bool _boughtThisMonth = false;
  bool _billsPaidThisMonth = false;

  double _eventCost = 0;
  String _eventText = '';
  bool _creditOffered = false;
  double _loanOutstanding = 0;
  int _loanMonthsLeft = 0;

  double _lastProfit = 0;
  double _lastTaxPaid = 0;
  int _lastRepChange = 0;
  bool _lastImpago = false;
  int _consecutiveImpagos = 0;

  Flashcard? _pendingCard;
  final Set<String> _seenCards = {};
  final List<String> _notebook = [];
  String? _mentorFlash;

  double get _taxRate => _month >= 3 ? 0.10 : 0.0;
  double get _unitPrice => (_basePrice + _priceAdjust).clamp(1, 999).toDouble();

  MgSnapshot get snapshot => MgSnapshot(
        phase: _phase,
        onboardingStep: _onboardingStep,
        avatarName: _avatarName,
        avatarStyle: _avatarStyle,
        coins: _coins,
        inventory: _inventory,
        month: _month,
        reputation: _reputation,
        savings: _savings,
        unitCost: _unitCost,
        unitPrice: _unitPrice,
        priceAdjust: _priceAdjust,
        rent: _rent,
        taxRate: _taxRate,
        minSales: _minSales,
        customersTotal: _customersTotal,
        customersRemaining: _customersRemaining,
        soldThisMonth: _soldThisMonth,
        monthRevenue: _monthRevenue,
        monthGoodsCost: _monthGoodsCost,
        boughtThisMonth: _boughtThisMonth,
        billsPaidThisMonth: _billsPaidThisMonth,
        eventCost: _eventCost,
        eventText: _eventText,
        creditOffered: _creditOffered,
        loanOutstanding: _loanOutstanding,
        loanMonthsLeft: _loanMonthsLeft,
        lastProfit: _lastProfit,
        lastTaxPaid: _lastTaxPaid,
        lastRepChange: _lastRepChange,
        lastImpago: _lastImpago,
        consecutiveImpagos: _consecutiveImpagos,
        pendingCard: _pendingCard,
        notebook: List.unmodifiable(_notebook),
        mentorFlash: _mentorFlash,
      );

  // ── Personalización y onboarding ────────────────────────────────────────────
  void setAvatarName(String name) {
    _avatarName = name.trim();
    _notify();
  }

  void setAvatarStyle(int index) {
    _avatarStyle = index;
    if (_avatarName.isEmpty && index >= 0 && index < kAvatarOptions.length) {
      _avatarName = kAvatarOptions[index].label;
    }
    _notify();
  }

  void finishPersonalize() {
    if (_avatarStyle < 0 || _avatarName.isEmpty) return;
    _phase = GamePhase.onboarding;
    _notify();
  }

  void nextOnboarding() {
    if (_onboardingStep >= kOnboarding.length - 1) {
      _startMonth();
    } else {
      _onboardingStep++;
    }
    _notify();
  }

  void skipOnboarding() {
    _startMonth();
    _notify();
  }

  // ── Ciclo mensual ────────────────────────────────────────────────────────────
  void _startMonth() {
    _priceAdjust = 0;
    _soldThisMonth = 0;
    _monthRevenue = 0;
    _monthGoodsCost = 0;
    _boughtThisMonth = false;
    _billsPaidThisMonth = false;
    _lastImpago = false;
    _computeDemand();
    _rollEvent();
    _rollCredit();
    _phase = GamePhase.map;
  }

  void _computeDemand() {
    var base = 8 + (_reputation * 0.4).round() + (_month - 1);
    // Estacionalidad y clientes más exigentes a partir del mes 7.
    if (_month >= 7) {
      final swing = _rng.nextInt(7) - 3; // -3..+3
      base += swing;
    }
    // Precio alto reduce clientes; precio bajo los aumenta.
    _customersTotal = base.clamp(_minSales + 1, 40);
    _customersRemaining = _customersTotal;
  }

  void _applyPriceToDemand() {
    // Recalcula la cola en función del precio, respetando ya vendidas.
    var base = 8 + (_reputation * 0.4).round() + (_month - 1);
    if (_month >= 7) base += 0;
    final factor = 1 - (_priceAdjust * 0.15);
    final adjusted = (base * factor).round().clamp(_minSales + 1, 40);
    _customersRemaining = (adjusted - _soldThisMonth).clamp(0, adjusted);
    _customersTotal = adjusted;
  }

  void _rollEvent() {
    _eventCost = 0;
    _eventText = '';
    if (_month == 4) {
      final options = [
        ['Se rompió el escaparate 🪟', 20.0],
        ['Producto dañado en el transporte 📦', 18.0],
        ['Subida inesperada de la luz 💡', 15.0],
      ];
      final pick = options[_rng.nextInt(options.length)];
      _eventText = pick[0] as String;
      _eventCost = pick[1] as double;
    }
  }

  void _rollCredit() {
    _creditOffered = (_month == 5 || _month == 6) && _loanOutstanding <= 0;
  }

  // ── Navegación por el mapa ───────────────────────────────────────────────────
  void goToZone(MgZone zone) {
    switch (zone) {
      case MgZone.provider:
        _phase = GamePhase.provider;
        break;
      case MgZone.shop:
        _phase = GamePhase.shop;
        break;
      case MgZone.bills:
        _phase = GamePhase.bills;
        break;
      case MgZone.piggybank:
        _phase = GamePhase.piggybank;
        break;
    }
    _notify();
  }

  void backToMap() {
    if (_phase == GamePhase.gameOver || _phase == GamePhase.victory) return;
    _phase = GamePhase.map;
    _notify();
  }

  // ── Comprar (gasto variable) ─────────────────────────────────────────────────
  bool buyOne() {
    if (_coins < _unitCost) return false;
    _coins -= _unitCost;
    _inventory++;
    _monthGoodsCost += _unitCost;
    if (!_boughtThisMonth) {
      _boughtThisMonth = true;
      _trigger(CardTrigger.variableCost, MentorSays.firstBuy);
    }
    _notify();
    return true;
  }

  int buyBatch(int count) {
    var bought = 0;
    for (var i = 0; i < count; i++) {
      if (!buyOne()) break;
      bought++;
    }
    return bought;
  }

  void takeLoan() {
    if (!_creditOffered || _loanOutstanding > 0) return;
    _coins += 50;
    _loanOutstanding = 55; // 50 + 10% interés
    _loanMonthsLeft = 2;
    _creditOffered = false;
    _trigger(CardTrigger.credit, null);
    _notify();
  }

  // ── Vender ───────────────────────────────────────────────────────────────────
  void setPriceAdjust(int value) {
    _priceAdjust = value.clamp(-2, 2);
    _applyPriceToDemand();
    _notify();
  }

  bool serveCustomer() {
    if (_inventory <= 0 || _customersRemaining <= 0) return false;
    _inventory--;
    _customersRemaining--;
    _soldThisMonth++;
    _coins += _unitPrice;
    _monthRevenue += _unitPrice;
    if (_soldThisMonth == 1) {
      _mentorFlash = MentorSays.firstSell;
    }
    _notify();
    return true;
  }

  // ── Ahorro (hucha, mes 2+) ───────────────────────────────────────────────────
  bool deposit(double amount) {
    if (amount <= 0 || amount > _coins) return false;
    _coins -= amount;
    _savings += amount;
    _trigger(CardTrigger.savings, null);
    _notify();
    return true;
  }

  bool withdraw(double amount) {
    if (amount <= 0 || amount > _savings) return false;
    _savings -= amount;
    _coins += amount;
    _notify();
    return true;
  }

  // ── Pagar gastos (fijo + impuesto + evento) ──────────────────────────────────
  /// Devuelve true si el pago fue completo; false si hubo impago.
  bool payBills() {
    if (_billsPaidThisMonth) return true;
    if (!snapshot.minSalesMet && !snapshot.outOfDemand) {
      _mentorFlash = MentorSays.needMoreSales;
      _notify();
      return false;
    }

    final tax = _monthRevenue * _taxRate;
    final loanPayment = _loanDueThisMonth();
    final totalDue = _rent + _eventCost + tax + loanPayment;

    if (_coins < totalDue) {
      _handleImpago();
      return false;
    }

    _coins -= totalDue;
    _lastTaxPaid = tax;
    _billsPaidThisMonth = true;
    _consecutiveImpagos = 0;
    _lastImpago = false;

    if (loanPayment > 0) {
      _loanOutstanding = (_loanOutstanding - loanPayment).clamp(0, 9999);
      _loanMonthsLeft = (_loanMonthsLeft - 1).clamp(0, 24);
    }

    _trigger(CardTrigger.fixedCost, MentorSays.firstFixed);
    if (tax > 0 && !_seenCards.contains(CardTrigger.taxes)) {
      // Si la tarjeta de gasto fijo no estaba pendiente, dispara impuestos.
      if (_pendingCard == null) _trigger(CardTrigger.taxes, null);
    }
    _notify();
    return true;
  }

  double _loanDueThisMonth() {
    if (_loanOutstanding <= 0 || _loanMonthsLeft <= 0) return 0;
    return _loanOutstanding / _loanMonthsLeft;
  }

  void _handleImpago() {
    _lastImpago = true;
    _consecutiveImpagos++;
    _reputation = (_reputation - 8).clamp(0, 100);
    // Penalización: pierde parte del stock.
    _inventory = (_inventory * 0.6).floor();
    _mentorFlash = MentorSays.impago;
    _billsPaidThisMonth = true; // el mes se cierra igualmente

    if (_consecutiveImpagos >= 2) {
      _phase = GamePhase.gameOver;
    }
    _notify();
  }

  // ── Cierre de mes ────────────────────────────────────────────────────────────
  void closeMonth() {
    if (_phase == GamePhase.gameOver) return;
    if (!_billsPaidThisMonth) {
      payBills();
      if (!_billsPaidThisMonth) return;
      if (_phase == GamePhase.gameOver) return;
    }

    final serveRate =
        _customersTotal > 0 ? _soldThisMonth / _customersTotal : 0.0;
    if (_lastImpago) {
      _lastRepChange = -8;
    } else if (serveRate >= 0.9) {
      _lastRepChange = 5;
    } else if (serveRate >= 0.6) {
      _lastRepChange = 2;
    } else if (serveRate >= 0.3) {
      _lastRepChange = 0;
    } else {
      _lastRepChange = -3;
    }
    if (!_lastImpago) {
      _reputation = (_reputation + _lastRepChange).clamp(0, 100);
    }

    _lastProfit =
        _monthRevenue - _monthGoodsCost - _rent - _eventCost - _lastTaxPaid;

    _mentorFlash = MentorSays.monthClose;
    _phase = GamePhase.monthSummary;
    _notify();
  }

  void nextMonth() {
    if (_month >= totalMonths) {
      _phase = _savings >= victorySavings ? GamePhase.victory : GamePhase.gameOver;
      _notify();
      return;
    }
    _month++;
    _startMonth();
    _notify();
  }

  void restart() {
    _phase = GamePhase.personalize;
    _onboardingStep = 0;
    _coins = startCoins;
    _inventory = 0;
    _month = 1;
    _reputation = 10;
    _savings = 0;
    _priceAdjust = 0;
    _consecutiveImpagos = 0;
    _loanOutstanding = 0;
    _loanMonthsLeft = 0;
    _seenCards.clear();
    _notebook.clear();
    _pendingCard = null;
    _mentorFlash = null;
    _notify();
  }

  // ── Tarjetas educativas ──────────────────────────────────────────────────────
  void _trigger(String id, String? mentorText) {
    if (mentorText != null) _mentorFlash = mentorText;
    if (_seenCards.contains(id)) return;
    _seenCards.add(id);
    if (!_notebook.contains(id)) _notebook.add(id);
    final card = kFlashcards[id];
    if (card != null) _pendingCard = card;
  }

  void dismissCard() {
    _pendingCard = null;
    _notify();
  }

  void clearMentorFlash() {
    _mentorFlash = null;
    _notify();
  }

  void _notify() => onChanged(snapshot);
}
