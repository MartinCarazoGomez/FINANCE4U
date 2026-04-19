import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Comentado temporalmente para Windows

class BudgetMasterGame extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const BudgetMasterGame({super.key, this.onCompleted});
  
  @override
  State<BudgetMasterGame> createState() => _BudgetMasterGameState();
}

class BudgetCategory {
  final String name;
  final String emoji;
  final String description;
  double allocated;
  double spent;
  final double minRequired; // Mínimo necesario
  final bool isEssential;
  
  BudgetCategory({
    required this.name,
    required this.emoji,
    required this.description,
    this.allocated = 0,
    this.spent = 0,
    required this.minRequired,
    required this.isEssential,
  });
  
  double get remaining => allocated - spent;
  double get usagePercentage => allocated > 0 ? (spent / allocated) * 100 : 0;
  bool get isOverBudget => spent > allocated;
  bool get meetsMinimum => allocated >= minRequired;
}

class BudgetEvent {
  final String title;
  final String description;
  final String emoji;
  final String category;
  final double amount;
  final bool isOptional;
  final List<String> choices;
  final List<double> costs;
  
  BudgetEvent({
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.amount,
    this.isOptional = false,
    this.choices = const [],
    this.costs = const [],
  });
}

class _BudgetMasterGameState extends State<BudgetMasterGame> with TickerProviderStateMixin {
  // Datos del juego
  double _monthlyIncome = 1800.0; // Salario medio neto español más realista
  int _currentMonth = 1;
  int _currentYear = 2024;
  int _level = 1;
  double _experience = 0.0;
  double _savingsGoal = 300.0; // 15% del salario
  double _totalSavings = 0.0;
  
  // Categorías de presupuesto
  List<BudgetCategory> _categories = [];
  
  // Estado del juego
  bool _budgetSet = false;
  double _totalAllocated = 0.0;
  Timer? _gameTimer;
  List<String> _achievements = [];
  List<BudgetEvent> _pendingEvents = [];
  Map<String, double> _monthlyHistory = {};
  
  // UI
  int _selectedTab = 0;
  late AnimationController _alertController;
  late Animation<double> _alertAnimation;
  
  // Métricas
  int _monthsCompleted = 0;
  double _bestSavingsRate = 0.0;
  int _eventsHandled = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeCategories();
    _loadGameProgress();
    _startMonth();
  }

  void _setupAnimations() {
    _alertController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _alertAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _alertController,
      curve: Curves.elasticOut,
    ));
  }

  void _initializeCategories() {
    _categories = [
      BudgetCategory(
        name: 'Vivienda',
        emoji: '🏠',
        description: 'Renta, hipoteca, servicios',
        minRequired: _monthlyIncome * 0.25,
        isEssential: true,
      ),
      BudgetCategory(
        name: 'Alimentación',
        emoji: '🍽️',
        description: 'Comida y bebidas',
        minRequired: _monthlyIncome * 0.10,
        isEssential: true,
      ),
      BudgetCategory(
        name: 'Transporte',
        emoji: '🚗',
        description: 'Gasolina, transporte público',
        minRequired: _monthlyIncome * 0.08,
        isEssential: true,
      ),
      BudgetCategory(
        name: 'Salud',
        emoji: '🏥',
        description: 'Seguros médicos, medicinas',
        minRequired: _monthlyIncome * 0.05,
        isEssential: true,
      ),
      BudgetCategory(
        name: 'Ahorros',
        emoji: '💰',
        description: 'Fondo de emergencia, inversiones',
        minRequired: _monthlyIncome * 0.10,
        isEssential: true,
      ),
      BudgetCategory(
        name: 'Entretenimiento',
        emoji: '🎬',
        description: 'Cine, juegos, salidas',
        minRequired: 0,
        isEssential: false,
      ),
      BudgetCategory(
        name: 'Ropa',
        emoji: '👕',
        description: 'Vestimenta y accesorios',
        minRequired: 0,
        isEssential: false,
      ),
      BudgetCategory(
        name: 'Educación',
        emoji: '📚',
        description: 'Cursos, libros, capacitación',
        minRequired: 0,
        isEssential: false,
      ),
    ];
  }

  void _startMonth() {
    setState(() {
      // Resetear gastos de todas las categorías
      for (var category in _categories) {
        category.spent = 0;
      }
      _pendingEvents.clear();
      _budgetSet = false;
      _totalAllocated = 0;
    });
    
    // Programar eventos aleatorios durante el mes
    _scheduleRandomEvents();
  }

  void _scheduleRandomEvents() {
    final random = Random();
    final events = [
      BudgetEvent(
        title: 'Reparación del Coche',
        description: 'Tu coche necesita reparación urgente en el taller',
        emoji: '🔧',
        category: 'Transporte',
        amount: 250 + random.nextDouble() * 150, // 250-400€ más realista en España
      ),
      BudgetEvent(
        title: 'Boda de Amigo',
        description: '¿Asistir a la boda de tu amigo? (Regalo típico español)',
        emoji: '💒',
        category: 'Entretenimiento',
        amount: 120, // 120€ más realista para boda en España
        isOptional: true,
        choices: ['Asistir', 'Enviar regalo', 'Declinar'],
        costs: [120, 60, 0], // Regalo típico 60€
      ),
      BudgetEvent(
        title: 'Oferta en El Corte Inglés',
        description: 'Gran descuento en tu tienda favorita',
        emoji: '🛍️',
        category: 'Ropa',
        amount: 60, // 60€ más realista
        isOptional: true,
        choices: ['Comprar', 'Resistir la tentación'],
        costs: [60, 0],
      ),
      BudgetEvent(
        title: 'Consulta Médica Privada',
        description: 'Visita al médico privado (complementa la sanidad pública)',
        emoji: '🏥',
        category: 'Salud',
        amount: 80 + random.nextDouble() * 60, // 80-140€ consulta privada
      ),
      BudgetEvent(
        title: 'Cena con Amigos',
        description: '¿Salir a cenar con amigos? (Tradición española)',
        emoji: '🍕',
        category: 'Entretenimiento',
        amount: 35, // 35€ cena típica española
        isOptional: true,
        choices: ['Ir al restaurante', 'Cocinar en casa', 'No ir'],
        costs: [35, 12, 0], // Cocinar en casa 12€
      ),
      BudgetEvent(
        title: 'Curso Online',
        description: 'Oportunidad de capacitación profesional',
        emoji: '💻',
        category: 'Educación',
        amount: 150, // 150€ curso online típico
        isOptional: true,
        choices: ['Tomar curso', 'Buscar alternativa gratuita', 'Postponer'],
        costs: [150, 0, 0],
      ),
      BudgetEvent(
        title: 'Avería en Casa',
        description: 'El frigorífico se ha estropeado',
        emoji: '🏠',
        category: 'Vivienda',
        amount: 180 + random.nextDouble() * 120, // 180-300€ reparación electrodoméstico
      ),
      BudgetEvent(
        title: 'Concierto',
        description: '¿Ir al concierto de tu artista favorito?',
        emoji: '🎵',
        category: 'Entretenimiento',
        amount: 45, // 45€ entrada concierto
        isOptional: true,
        choices: ['Comprar entrada', 'Ver en streaming', 'No ir'],
        costs: [45, 8, 0], // Streaming 8€
      ),
      BudgetEvent(
        title: 'Seguro del Coche',
        description: 'Renovación anual del seguro (obligatorio en España)',
        emoji: '🚗',
        category: 'Transporte',
        amount: 400 + random.nextDouble() * 200, // 400-600€ seguro anual
      ),
      BudgetEvent(
        title: 'Vacaciones de Fin de Semana',
        description: '¿Planificar un viaje de fin de semana? (Puente español)',
        emoji: '✈️',
        category: 'Entretenimiento',
        amount: 200, // 200€ fin de semana
        isOptional: true,
        choices: ['Viajar', 'Quedarse en casa', 'Planificar para más tarde'],
        costs: [200, 0, 0],
      ),
    ];
    
    // Programar 2-4 eventos durante el mes
    final eventCount = 2 + random.nextInt(3);
    for (int i = 0; i < eventCount; i++) {
      Timer(Duration(seconds: 10 + i * 8), () {
        if (mounted) {
          final event = events[random.nextInt(events.length)];
          _triggerEvent(event);
        }
      });
    }
  }

  void _triggerEvent(BudgetEvent event) {
    setState(() {
      _pendingEvents.add(event);
    });
    
    _alertController.forward().then((_) => _alertController.reverse());
    
    if (event.isOptional) {
      _showEventDialog(event);
    } else {
      _handleEvent(event, event.amount);
    }
  }

  void _showEventDialog(BudgetEvent event) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('${event.emoji} ${event.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(event.description),
            const SizedBox(height: 16),
            if (event.choices.isNotEmpty)
              ...event.choices.asMap().entries.map((entry) {
                final index = entry.key;
                final choice = entry.value;
                final cost = event.costs[index];
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleEvent(event, cost);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cost == 0 ? Colors.green : Colors.orange,
                    ),
                    child: Text(
                      '$choice ${cost > 0 ? "(-€${cost.toInt()})" : ""}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _handleEvent(BudgetEvent event, double cost) {
    final category = _categories.firstWhere((c) => c.name == event.category);
    
    setState(() {
      category.spent += cost;
      _eventsHandled++;
    });
    
    _checkBudgetStatus();
    _saveGameProgress();
    
    if (cost > 0) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (category.isOverBudget) {
        // appProvider.hapticService.wrongAnswer();
      } else {
        // appProvider.hapticService.correctAnswer();
      }
    }
  }

  void _setBudget() {
    if (_totalAllocated != _monthlyIncome) {
      _showMessage('El presupuesto debe sumar exactamente €${_monthlyIncome.toInt()}', Colors.red);
      return;
    }
    
    // Verificar que las categorías esenciales tengan el mínimo
    for (var category in _categories) {
      if (category.isEssential && !category.meetsMinimum) {
        _showMessage('${category.name} necesita al menos €${category.minRequired.toInt()}', Colors.orange);
        return;
      }
    }
    
    setState(() {
      _budgetSet = true;
    });
    
    _showMessage('¡Presupuesto establecido! El mes ha comenzado.', Colors.green);
    _saveGameProgress();
  }

  void _finishMonth() {
    double totalSpent = _categories.fold(0, (sum, c) => sum + c.spent);
    double savings = _monthlyIncome - totalSpent;
    double savingsRate = (savings / _monthlyIncome) * 100;
    
    setState(() {
      _totalSavings += savings;
      _monthsCompleted++;
      if (savingsRate > _bestSavingsRate) {
        _bestSavingsRate = savingsRate;
      }
      _monthlyHistory['${_currentMonth}/${_currentYear}'] = savings;
    });
    
    _checkAchievements(savings, savingsRate);
    _checkLevelUp();
    
    // Mostrar resumen del mes
    _showMonthSummary(savings, savingsRate);
    
    // Preparar siguiente mes
    _nextMonth();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
        _monthlyIncome += _monthlyIncome * 0.03; // 3% aumento anual
        _savingsGoal = _monthlyIncome * 0.15; // Ajustar meta de ahorro
      }
    });
    
    Timer(const Duration(seconds: 3), () {
      _startMonth();
    });
  }

  void _checkAchievements(double savings, double savingsRate) {
    if (savings >= _savingsGoal && !_achievements.contains('Meta Mensual')) {
      _achievements.add('Meta Mensual');
      _showAchievement('🎯 ¡Alcanzaste tu meta de ahorro mensual!');
    }
    
    if (savingsRate >= 20 && !_achievements.contains('Super Ahorrador')) {
      _achievements.add('Super Ahorrador');
      _showAchievement('💎 ¡Ahorraste más del 20% de tus ingresos!');
    }
    
    if (_monthsCompleted >= 6 && !_achievements.contains('Constancia')) {
      _achievements.add('Constancia');
      _showAchievement('⭐ ¡6 meses gestionando tu presupuesto!');
    }
    
    if (_eventsHandled >= 10 && !_achievements.contains('Gestor de Crisis')) {
      _achievements.add('Gestor de Crisis');
      _showAchievement('🛡️ ¡Manejaste 10 eventos inesperados!');
    }
  }

  void _checkLevelUp() {
    _experience += 100; // XP por completar mes
    if (_bestSavingsRate > 15) _experience += 50; // Bonus por buen ahorro
    
    int newLevel = (_experience / 500).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _showAchievement('🆙 ¡Subiste al nivel $_level!');
      
      // Verificar condición de victoria (nivel 3)
      if (_level >= 3) {
        _completeGame();
      }
    }
  }

  void _completeGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 ¡FELICITACIONES! 🎉'),
        content: const Text('¡Has dominado el arte del presupuesto!\n¡Eres un verdadero Budget Master!'),
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

  void _showMonthSummary(double savings, double savingsRate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📊 Resumen del Mes ${_currentMonth}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ingresos: €${_monthlyIncome.toInt()}'),
            Text('Gastos: €${(_monthlyIncome - savings).toInt()}'),
            Text('Ahorrado: €${savings.toInt()}'),
            Text('Tasa de Ahorro: ${savingsRate.toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Text(
              savings >= _savingsGoal ? '🎯 ¡Meta alcanzada!' : '❌ Meta no alcanzada',
              style: TextStyle(
                color: savings >= _savingsGoal ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
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

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _checkBudgetStatus() {
    for (var category in _categories) {
      if (category.isOverBudget && category.isEssential) {
        _showMessage('⚠️ ${category.name} está sobre presupuesto!', Colors.red);
      }
    }
  }

  // Métodos de persistencia usando AppProvider
  Future<void> _saveGameProgress() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Convertir categorías a formato serializable
    List<Map<String, dynamic>> categoriesData = _categories.map((category) => {
      'name': category.name,
      'allocated': category.allocated,
      'spent': category.spent,
    }).toList();
    
    appProvider.saveBudgetGameData(
      monthlyIncome: _monthlyIncome,
      currentMonth: _currentMonth,
      currentYear: _currentYear,
      level: _level,
      experience: _experience,
      savingsGoal: _savingsGoal,
      totalSavings: _totalSavings,
      budgetSet: _budgetSet,
      monthsCompleted: _monthsCompleted,
      bestSavingsRate: _bestSavingsRate,
      eventsHandled: _eventsHandled,
      achievements: _achievements,
      categories: categoriesData,
    );
  }

  Future<void> _loadGameProgress() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final data = appProvider.getGameData('budget_master');
    
    if (data != null) {
      _monthlyIncome = data['monthlyIncome'] ?? 1800.0;
      _currentMonth = data['currentMonth'] ?? 1;
      _currentYear = data['currentYear'] ?? 2024;
      _level = data['level'] ?? 1;
      _experience = data['experience'] ?? 0.0;
      _savingsGoal = data['savingsGoal'] ?? 300.0;
      _totalSavings = data['totalSavings'] ?? 0.0;
      _budgetSet = data['budgetSet'] ?? false;
      _monthsCompleted = data['monthsCompleted'] ?? 0;
      _bestSavingsRate = data['bestSavingsRate'] ?? 0.0;
      _eventsHandled = data['eventsHandled'] ?? 0;
      _achievements = List<String>.from(data['achievements'] ?? []);
      
      // Cargar categorías
      List<Map<String, dynamic>> categoriesData = List<Map<String, dynamic>>.from(data['categories'] ?? []);
      for (int i = 0; i < categoriesData.length && i < _categories.length; i++) {
        _categories[i].allocated = categoriesData[i]['allocated'] ?? 0.0;
        _categories[i].spent = categoriesData[i]['spent'] ?? 0.0;
      }
      
      _totalAllocated = _categories.fold(0, (sum, c) => sum + c.allocated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('💰 Budget Master', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF16213E),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green),
            ),
            child: Text(
              'Nivel $_level',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
          if (!_budgetSet) _buildSetBudgetButton(),
          if (_budgetSet) _buildFinishMonthButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              _buildInfoCard('💵 Ingresos', '€${_monthlyIncome.toInt()}', Colors.blue),
              _buildInfoCard('📅 ${_currentMonth}/$_currentYear', 'Mes actual', Colors.purple),
              _buildInfoCard('💰 Ahorros', '€${_totalSavings.toInt()}', Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Meta de ahorro: €${_savingsGoal.toInt()}',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
          _buildTab('📊 Presupuesto', 0),
          _buildTab('📈 Progreso', 1),
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
            color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
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
        return _buildBudgetView();
      case 1:
        return _buildProgressView();
      case 2:
        return _buildAchievementsView();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBudgetView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!_budgetSet) ...[
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
                  '📋 Establece tu presupuesto mensual',
                  style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Distribuye tus €${_monthlyIncome.toInt()} entre las categorías',
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 8),
                Text(
                  'Asignado: €${_totalAllocated.toInt()} / €${_monthlyIncome.toInt()}',
                  style: TextStyle(
                    color: _totalAllocated == _monthlyIncome ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        ..._categories.map((category) => _buildCategoryCard(category)),
        
        if (_pendingEvents.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
            child: Column(
              children: [
                const Text(
                  '⚠️ Eventos Pendientes',
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...(_pendingEvents.map((event) => Text(
                  '${event.emoji} ${event.title}',
                  style: const TextStyle(color: Colors.red),
                ))),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryCard(BudgetCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: category.isOverBudget ? Colors.red : 
                 !category.meetsMinimum && category.isEssential ? Colors.orange : 
                 Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(category.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (category.isEssential) 
                          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 18)),
                      ],
                    ),
                    Text(category.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          if (!_budgetSet) ...[
            // Slider para asignar presupuesto
            Text(
              'Asignado: €${category.allocated.toInt()} ${category.isEssential ? "(Min: €${category.minRequired.toInt()})" : ""}',
              style: TextStyle(
                color: category.meetsMinimum || !category.isEssential ? Colors.white : Colors.orange,
              ),
            ),
            Slider(
              value: category.allocated,
              min: 0,
              max: _monthlyIncome,
              divisions: (_monthlyIncome / 50).round(),
              onChanged: (value) {
                setState(() {
                  _totalAllocated = _totalAllocated - category.allocated + value;
                  category.allocated = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ] else ...[
            // Vista durante el mes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Presupuesto: €${category.allocated.toInt()}', style: const TextStyle(color: Colors.white)),
                Text('Gastado: €${category.spent.toInt()}', 
                     style: TextStyle(color: category.isOverBudget ? Colors.red : Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: category.allocated > 0 ? (category.spent / category.allocated).clamp(0.0, 1.0) : 0,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                category.isOverBudget ? Colors.red : 
                category.usagePercentage > 80 ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${category.usagePercentage.toStringAsFixed(1)}% usado', 
                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Restante: €${category.remaining.toInt()}', 
                     style: TextStyle(
                       color: category.remaining >= 0 ? Colors.green : Colors.red,
                       fontSize: 12,
                     )),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressView() {
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
              const Text('📊 Estadísticas Generales', 
                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildStatCard('Meses Completados', _monthsCompleted.toString(), Colors.blue),
              _buildStatCard('Mejor Tasa de Ahorro', '${_bestSavingsRate.toStringAsFixed(1)}%', Colors.green),
              _buildStatCard('Total Ahorrado', '€${_totalSavings.toInt()}', Colors.purple),
              _buildStatCard('Eventos Manejados', _eventsHandled.toString(), Colors.orange),
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
              const Text('💎 Progreso de Nivel', 
                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Nivel $_level', style: const TextStyle(color: Colors.purple, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('XP: ${_experience.toInt()}', style: const TextStyle(color: Colors.purple)),
              LinearProgressIndicator(
                value: (_experience % 500) / 500,
                backgroundColor: Colors.purple.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
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
    final totalAchievements = ['Meta Mensual', 'Super Ahorrador', 'Constancia', 'Gestor de Crisis'];
    
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
                  'Gestiona tu presupuesto para desbloquearlos',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSetBudgetButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _totalAllocated == _monthlyIncome ? _setBudget : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Confirmar Presupuesto',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildFinishMonthButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _finishMonth,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Terminar Mes',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _saveGameProgress();
    _gameTimer?.cancel();
    _alertController.dispose();
    super.dispose();
  }
} 