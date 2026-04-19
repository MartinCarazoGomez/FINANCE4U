import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Comentado temporalmente para Windows

class DebtDestroyerGame extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const DebtDestroyerGame({super.key, this.onCompleted});
  
  @override
  State<DebtDestroyerGame> createState() => _DebtDestroyerGameState();
}

class Debt {
  final String name;
  final String emoji;
  final String description;
  double balance;
  final double interestRate;
  final double minimumPayment;
  double totalPaid;
  final DateTime startDate;
  bool isPaidOff;
  
  Debt({
    required this.name,
    required this.emoji,
    required this.description,
    required this.balance,
    required this.interestRate,
    required this.minimumPayment,
    this.totalPaid = 0,
    DateTime? startDate,
    this.isPaidOff = false,
  }) : startDate = startDate ?? DateTime.now();
  
  double get monthlyInterest => balance * (interestRate / 100 / 12);
  double get payoffTime => balance > 0 ? balance / minimumPayment : 0;
  double get totalInterestRemaining => (minimumPayment * payoffTime) - balance;
}

enum PayoffStrategy {
  snowball, // Menor balance primero
  avalanche, // Mayor interés primero
  custom, // Personalizado
}

class DebtEvent {
  final String title;
  final String description;
  final String emoji;
  final double incomeChange;
  final double extraPayment;
  final bool isPositive;
  
  DebtEvent({
    required this.title,
    required this.description,
    required this.emoji,
    this.incomeChange = 0,
    this.extraPayment = 0,
    required this.isPositive,
  });
}

class _DebtDestroyerGameState extends State<DebtDestroyerGame> with TickerProviderStateMixin {
  // Datos del jugador
  double _monthlyIncome = 2200.0; // Salario medio neto español más realista
  double _monthlyExpenses = 1600.0; // Gastos típicos españoles
  double _extraPaymentBudget = 0.0;
  PayoffStrategy _currentStrategy = PayoffStrategy.snowball;
  
  // Deudas
  List<Debt> _debts = [];
  
  // Estado del juego
  int _currentMonth = 1;
  int _currentYear = 2024;
  int _level = 1;
  double _experience = 0.0;
  Timer? _gameTimer;
  
  // Métricas
  double _totalDebtPaid = 0.0;
  double _totalInterestSaved = 0.0;
  int _debtsEliminated = 0;
  List<String> _achievements = [];
  Map<String, List<double>> _debtHistory = {};
  
  // UI
  int _selectedTab = 0;
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeDebts();
    _loadGameProgress();
    _calculateBudget();
    _startDebtJourney();
  }

  void _setupAnimations() {
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));
  }

  void _initializeDebts() {
    _debts = [
      Debt(
        name: 'Tarjeta de Crédito BBVA',
        emoji: '💳',
        description: 'Deuda de consumo con TIN 22.5% (TAE 24.8%)',
        balance: 2500.0,
        interestRate: 22.5,
        minimumPayment: 75.0,
      ),
      Debt(
        name: 'Préstamo Coche Santander',
        emoji: '🚗',
        description: 'Financiamiento del vehículo con TIN 8.5%',
        balance: 12000.0,
        interestRate: 8.5,
        minimumPayment: 280.0,
      ),
      Debt(
        name: 'Préstamo Personal CaixaBank',
        emoji: '💰',
        description: 'Préstamo para gastos varios con TIN 15.2%',
        balance: 6000.0,
        interestRate: 15.2,
        minimumPayment: 150.0,
      ),
      Debt(
        name: 'Préstamo Estudiantil ING',
        emoji: '🎓',
        description: 'Inversión en educación con TIN 3.2%',
        balance: 18000.0,
        interestRate: 3.2,
        minimumPayment: 200.0,
      ),
    ];
    
    // Inicializar historial
    for (var debt in _debts) {
      _debtHistory[debt.name] = [debt.balance];
    }
  }

  void _calculateBudget() {
    double totalMinPayments = _debts.where((d) => !d.isPaidOff).fold(0, (sum, d) => sum + d.minimumPayment);
    _extraPaymentBudget = (_monthlyIncome - _monthlyExpenses - totalMinPayments).clamp(0, double.infinity);
  }

  void _startDebtJourney() {
    _gameTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_gameCompleted) {
        _processMonth();
      }
    });
    
    // Programar eventos aleatorios
    _scheduleRandomEvents();
  }

  void _scheduleRandomEvents() {
    final random = math.Random();
    final events = [
      DebtEvent(
        title: 'Aumento de Sueldo',
        description: '¡Tu jefe reconoció tu buen trabajo!',
        emoji: '💼',
        incomeChange: 200.0 + random.nextDouble() * 300.0,
        isPositive: true,
      ),
      DebtEvent(
        title: 'Bono de Fin de Año',
        description: 'Dinero extra para atacar deudas',
        emoji: '🎁',
        extraPayment: 500.0 + random.nextDouble() * 1000.0,
        isPositive: true,
      ),
      DebtEvent(
        title: 'Emergencia Médica',
        description: 'Gasto inesperado reduce tu presupuesto',
        emoji: '🏥',
        incomeChange: -(100.0 + random.nextDouble() * 200.0),
        isPositive: false,
      ),
      DebtEvent(
        title: 'Reparación de Casa',
        description: 'Gastos del hogar afectan tu presupuesto',
        emoji: '🔧',
        incomeChange: -(80.0 + random.nextDouble() * 150.0),
        isPositive: false,
      ),
      DebtEvent(
        title: 'Trabajo Extra',
        description: 'Ingresos adicionales por freelance',
        emoji: '💻',
        extraPayment: 200.0 + random.nextDouble() * 400.0,
        isPositive: true,
      ),
      DebtEvent(
        title: 'Regalo de Familia',
        description: 'Dinero inesperado de un familiar',
        emoji: '👨‍👩‍👧‍👦',
        extraPayment: 300.0 + random.nextDouble() * 500.0,
        isPositive: true,
      ),
    ];
    
    Timer(Duration(seconds: 15 + random.nextInt(20)), () {
      if (mounted && !_gameCompleted) {
        final event = events[random.nextInt(events.length)];
        _triggerEvent(event);
        _scheduleRandomEvents();
      }
    });
  }

  void _triggerEvent(DebtEvent event) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    if (event.isPositive) {
              // appProvider.hapticService.correctAnswer();
      } else {
        // appProvider.hapticService.wrongAnswer();
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${event.emoji} ${event.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(event.description),
            const SizedBox(height: 16),
            if (event.incomeChange != 0) 
              Text(
                'Cambio en ingresos: ${event.incomeChange > 0 ? '+' : ''}€${event.incomeChange.toInt()}/mes',
                style: TextStyle(
                  color: event.incomeChange > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (event.extraPayment > 0)
              Text(
                'Pago extra disponible: +€${event.extraPayment.toInt()}',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyEvent(event);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _applyEvent(DebtEvent event) {
    setState(() {
      _monthlyIncome += event.incomeChange;
      if (event.extraPayment > 0) {
        _makeExtraPayment(event.extraPayment);
      }
    });
    
    _calculateBudget();
    _saveGameProgress();
  }

  void _processMonth() {
    if (_debts.every((debt) => debt.isPaidOff)) {
      _completeGame();
      return;
    }
    
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
    });
    
    // Aplicar intereses y pagos mínimos
    for (var debt in _debts) {
      if (!debt.isPaidOff) {
        // Agregar interés
        double interest = debt.monthlyInterest;
        debt.balance += interest;
        
        // Aplicar pago mínimo
        double payment = math.min(debt.minimumPayment, debt.balance);
        debt.balance -= payment;
        debt.totalPaid += payment;
        _totalDebtPaid += payment;
        
        if (debt.balance <= 0) {
          debt.balance = 0;
          debt.isPaidOff = true;
          _debtEliminated(debt);
        }
        
        // Actualizar historial
        _debtHistory[debt.name]!.add(debt.balance);
        if (_debtHistory[debt.name]!.length > 24) {
          _debtHistory[debt.name]!.removeAt(0);
        }
      }
    }
    
    // Aplicar estrategia de pago extra
    if (_extraPaymentBudget > 0) {
      _applyPayoffStrategy();
    }
    
    _calculateBudget();
    _checkAchievements();
    _saveGameProgress();
  }

  void _applyPayoffStrategy() {
    List<Debt> activeDebts = _debts.where((d) => !d.isPaidOff).toList();
    if (activeDebts.isEmpty) return;
    
    double remainingBudget = _extraPaymentBudget;
    
    // Ordenar según estrategia
    switch (_currentStrategy) {
      case PayoffStrategy.snowball:
        activeDebts.sort((a, b) => a.balance.compareTo(b.balance));
        break;
      case PayoffStrategy.avalanche:
        activeDebts.sort((a, b) => b.interestRate.compareTo(a.interestRate));
        break;
      case PayoffStrategy.custom:
        // Mantener orden actual
        break;
    }
    
    // Aplicar pagos extra
    for (var debt in activeDebts) {
      if (remainingBudget <= 0) break;
      
      double extraPayment = math.min(remainingBudget, debt.balance);
      debt.balance -= extraPayment;
      debt.totalPaid += extraPayment;
      _totalDebtPaid += extraPayment;
      remainingBudget -= extraPayment;
      
      if (debt.balance <= 0) {
        debt.balance = 0;
        debt.isPaidOff = true;
        _debtEliminated(debt);
      }
    }
  }

  void _debtEliminated(Debt debt) {
    _debtsEliminated++;
    _experience += 200;
    _celebrationController.forward().then((_) => _celebrationController.reverse());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🎉 ¡${debt.name} Eliminada!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¡Felicitaciones! Has eliminado tu ${debt.name.toLowerCase()}'),
            const SizedBox(height: 8),
            Text('Total pagado: €${debt.totalPaid.toInt()}'),
            Text('Interés pagado: €${(debt.totalPaid - (_debtHistory[debt.name]?.first ?? 0)).toInt()}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('¡Continuar!'),
          ),
        ],
      ),
    );
    
    _calculateBudget(); // Más dinero disponible para otras deudas
    _checkLevelUp();
  }

  void _makeExtraPayment(double amount) {
    List<Debt> activeDebts = _debts.where((d) => !d.isPaidOff).toList();
    if (activeDebts.isEmpty) return;
    
    // Aplicar a la deuda prioritaria según estrategia
    Debt targetDebt;
    switch (_currentStrategy) {
      case PayoffStrategy.snowball:
        targetDebt = activeDebts.reduce((a, b) => a.balance < b.balance ? a : b);
        break;
      case PayoffStrategy.avalanche:
        targetDebt = activeDebts.reduce((a, b) => a.interestRate > b.interestRate ? a : b);
        break;
      case PayoffStrategy.custom:
        targetDebt = activeDebts.first;
        break;
    }
    
    double payment = math.min(amount, targetDebt.balance);
    targetDebt.balance -= payment;
    targetDebt.totalPaid += payment;
    _totalDebtPaid += payment;
    
    if (targetDebt.balance <= 0) {
      targetDebt.balance = 0;
      targetDebt.isPaidOff = true;
      _debtEliminated(targetDebt);
    }
  }

  void _checkAchievements() {
    if (_debtsEliminated >= 1 && !_achievements.contains('Primera Victoria')) {
      _achievements.add('Primera Victoria');
      _showAchievement('🎯 ¡Eliminaste tu primera deuda!');
    }
    
    if (_totalDebtPaid >= 10000 && !_achievements.contains('Destructor de 10K')) {
      _achievements.add('Destructor de 10K');
      _showAchievement('🏆 ¡Has pagado más de €10,000 en deudas!');
    }
    
    if (_debtsEliminated >= 2 && !_achievements.contains('Liberación Doble')) {
      _achievements.add('Liberación Doble');
      _showAchievement('🔥 ¡Dos deudas eliminadas!');
    }
    
    if (_extraPaymentBudget >= 1000 && !_achievements.contains('Presupuesto Master')) {
      _achievements.add('Presupuesto Master');
      _showAchievement('💰 ¡Más de €1,000 extra para deudas!');
    }
  }

  void _checkLevelUp() {
    int newLevel = (_experience / 300).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _showAchievement('🆙 ¡Subiste al nivel $_level!');
    }
  }

  void _completeGame() {
    setState(() {
      _gameCompleted = true;
    });
    
    _gameTimer?.cancel();
    
    double totalInterestSaved = _calculateInterestSaved();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 ¡LIBERTAD FINANCIERA! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¡Has eliminado TODAS tus deudas!'),
            const SizedBox(height: 16),
            Text('Total pagado: €${_totalDebtPaid.toInt()}'),
            Text('Tiempo: ${_currentMonth + (_currentYear - 2024) * 12} meses'),
            Text('Interés ahorrado: €${totalInterestSaved.toInt()}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onCompleted?.call();
            },
            child: const Text('¡Continuar!'),
          ),
        ],
      ),
    );
  }

  double _calculateInterestSaved() {
    // Cálculo simplificado del interés que se habría pagado
    // con solo pagos mínimos vs. estrategia acelerada
    return _totalDebtPaid * 0.15; // Estimación
  }

  void _showAchievement(String message) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
          // appProvider.hapticService.achievementUnlocked();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 ¡Logro Desbloqueado!'),
        content: Text(message, style: const TextStyle(fontSize: 18)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('¡Genial!'),
          ),
        ],
      ),
    );
  }

  // Métodos de persistencia usando AppProvider
  Future<void> _saveGameProgress() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Convertir deudas a formato serializable
    List<Map<String, dynamic>> debtsData = _debts.map((debt) => {
      'name': debt.name,
      'balance': debt.balance,
      'totalPaid': debt.totalPaid,
      'isPaidOff': debt.isPaidOff,
    }).toList();
    
    appProvider.saveDebtGameData(
      monthlyIncome: _monthlyIncome,
      monthlyExpenses: _monthlyExpenses,
      extraPaymentBudget: _extraPaymentBudget,
      currentMonth: _currentMonth,
      currentYear: _currentYear,
      level: _level,
      experience: _experience,
      totalDebtPaid: _totalDebtPaid,
      debtsEliminated: _debtsEliminated,
      strategy: _currentStrategy.toString(),
      gameCompleted: _gameCompleted,
      achievements: _achievements,
      debts: debtsData,
    );
  }

  Future<void> _loadGameProgress() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final data = appProvider.getGameData('debt_destroyer');
    
    if (data != null) {
      _monthlyIncome = data['monthlyIncome'] ?? 2200.0;
      _monthlyExpenses = data['monthlyExpenses'] ?? 1600.0;
      _extraPaymentBudget = data['extraPaymentBudget'] ?? 0.0;
      _currentMonth = data['currentMonth'] ?? 1;
      _currentYear = data['currentYear'] ?? 2024;
      _level = data['level'] ?? 1;
      _experience = data['experience'] ?? 0.0;
      _totalDebtPaid = data['totalDebtPaid'] ?? 0.0;
      _debtsEliminated = data['debtsEliminated'] ?? 0;
      _gameCompleted = data['gameCompleted'] ?? false;
      
      String? strategyString = data['strategy'];
      if (strategyString != null) {
        _currentStrategy = PayoffStrategy.values.firstWhere(
          (e) => e.toString() == strategyString,
          orElse: () => PayoffStrategy.snowball,
        );
      }
      
      _achievements = List<String>.from(data['achievements'] ?? []);
      
      // Cargar deudas
      List<Map<String, dynamic>> debtsData = List<Map<String, dynamic>>.from(data['debts'] ?? []);
      for (int i = 0; i < debtsData.length && i < _debts.length; i++) {
        _debts[i].balance = debtsData[i]['balance'] ?? _debts[i].balance;
        _debts[i].totalPaid = debtsData[i]['totalPaid'] ?? 0.0;
        _debts[i].isPaidOff = debtsData[i]['isPaidOff'] ?? false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('⚡ Debt Destroyer', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF16213E),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              'Nivel $_level',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: _buildCurrentView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    double totalDebt = _debts.where((d) => !d.isPaidOff).fold(0, (sum, d) => sum + d.balance);
    double totalMinPayments = _debts.where((d) => !d.isPaidOff).fold(0, (sum, d) => sum + d.minimumPayment);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoCard('💸 Deuda Total', '€${totalDebt.toInt()}', Colors.red),
              _buildInfoCard('📅 ${_currentMonth}/$_currentYear', 'Mes actual', Colors.blue),
              _buildInfoCard('💰 Extra', '€${_extraPaymentBudget.toInt()}', Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    children: [
                      Text('Ingresos: €${_monthlyIncome.toInt()}', style: const TextStyle(color: Colors.orange)),
                      Text('Gastos: €${_monthlyExpenses.toInt()}', style: const TextStyle(color: Colors.orange)),
                      Text('Pagos mín: €${totalMinPayments.toInt()}', style: const TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple),
                ),
                child: Column(
                  children: [
                    Text('Estrategia:', style: const TextStyle(color: Colors.purple)),
                    DropdownButton<PayoffStrategy>(
                      value: _currentStrategy,
                      dropdownColor: const Color(0xFF16213E),
                      onChanged: (strategy) {
                        setState(() {
                          _currentStrategy = strategy!;
                        });
                        _saveGameProgress();
                      },
                      items: [
                        DropdownMenuItem(
                          value: PayoffStrategy.snowball,
                          child: Text('🏔️ Bola de Nieve', style: TextStyle(color: Colors.purple)),
                        ),
                        DropdownMenuItem(
                          value: PayoffStrategy.avalanche,
                          child: Text('❄️ Avalancha', style: TextStyle(color: Colors.purple)),
                        ),
                        DropdownMenuItem(
                          value: PayoffStrategy.custom,
                          child: Text('⚙️ Personalizado', style: TextStyle(color: Colors.purple)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 12)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: const Color(0xFF16213E),
      child: Row(
        children: [
          _buildTab('💳 Deudas', 0),
          _buildTab('📊 Progreso', 1),
          _buildTab('🏆 Logros', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.red.withOpacity(0.2) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_selectedTab) {
      case 0:
        return _buildDebtsView();
      case 1:
        return _buildProgressView();
      case 2:
        return _buildAchievementsView();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDebtsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!_gameCompleted) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                const Text(
                  '🎯 Tu Plan de Eliminación de Deudas',
                  style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _getStrategyDescription(),
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        ..._debts.map((debt) => _buildDebtCard(debt)),
        
        if (_gameCompleted) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Column(
              children: [
                Text('🎉', style: TextStyle(fontSize: 48)),
                SizedBox(height: 16),
                Text(
                  '¡LIBRE DE DEUDAS!',
                  style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Has eliminado todas tus deudas',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getStrategyDescription() {
    switch (_currentStrategy) {
      case PayoffStrategy.snowball:
        return 'Pagando primero las deudas más pequeñas para ganar momentum';
      case PayoffStrategy.avalanche:
        return 'Atacando primero las deudas con mayor interés para ahorrar más';
      case PayoffStrategy.custom:
        return 'Usando tu propia estrategia personalizada';
    }
  }

  Widget _buildDebtCard(Debt debt) {
    double progressValue = debt.isPaidOff ? 1.0 : debt.balance / (_debtHistory[debt.name]?.first ?? debt.balance);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: debt.isPaidOff ? Colors.green : Colors.red.withOpacity(0.3),
          width: debt.isPaidOff ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(debt.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(debt.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (debt.isPaidOff) 
                          const Text(' ✅', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Text(debt.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          if (!debt.isPaidOff) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance: €${debt.balance.toInt()}', style: const TextStyle(color: Colors.white)),
                Text('${debt.interestRate.toStringAsFixed(1)}% APR', 
                     style: const TextStyle(color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pago mín: €${debt.minimumPayment.toInt()}', 
                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Pagado: €${debt.totalPaid.toInt()}', 
                     style: const TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 1.0 - progressValue,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${((1.0 - progressValue) * 100).toStringAsFixed(1)}% pagado', 
                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text('~${debt.payoffTime.toStringAsFixed(0)} meses restantes', 
                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text('✅', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('¡ELIMINADA!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Text('Total pagado: €${debt.totalPaid.toInt()}', 
                             style: const TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    double totalOriginalDebt = _debtHistory.values.fold(0, (sum, history) => sum + (history.first ?? 0));
    double totalCurrentDebt = _debts.fold(0, (sum, debt) => sum + debt.balance);
    double progressPercentage = totalOriginalDebt > 0 ? ((totalOriginalDebt - totalCurrentDebt) / totalOriginalDebt) * 100 : 0;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('📊 Progreso General', 
                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              CircularProgressIndicator(
                value: progressPercentage / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              const SizedBox(height: 16),
              Text('${progressPercentage.toStringAsFixed(1)}% Completado', 
                   style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Deuda original: €${totalOriginalDebt.toInt()}', 
                   style: const TextStyle(color: Colors.grey)),
              Text('Deuda restante: €${totalCurrentDebt.toInt()}', 
                   style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('🎯 Estadísticas', 
                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildStatCard('Deudas Eliminadas', '$_debtsEliminated/${_debts.length}', Colors.green),
              _buildStatCard('Total Pagado', '€${_totalDebtPaid.toInt()}', Colors.blue),
              _buildStatCard('Tiempo Transcurrido', '${_currentMonth + (_currentYear - 2024) * 12} meses', Colors.purple),
              _buildStatCard('Pago Extra Mensual', '€${_extraPaymentBudget.toInt()}', Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: color)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildAchievementsView() {
    final totalAchievements = ['Primera Victoria', 'Destructor de 10K', 'Liberación Doble', 'Presupuesto Master'];
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('🏆 Progreso de Logros', 
                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('${_achievements.length}/${totalAchievements.length} completados', 
                   style: const TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _achievements.length / totalAchievements.length,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        ..._achievements.map((achievement) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  achievement,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        )),
        
        if (_achievements.isEmpty) 
          const Center(
            child: Column(
              children: [
                Text('🏆', style: TextStyle(fontSize: 48)),
                SizedBox(height: 16),
                Text(
                  'Aún no tienes logros',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Elimina deudas para desbloquearlos',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _saveGameProgress();
    _gameTimer?.cancel();
    _celebrationController.dispose();
    super.dispose();
  }
} 