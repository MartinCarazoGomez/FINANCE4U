import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class EmergencyFundBuilder extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const EmergencyFundBuilder({super.key, this.onCompleted});
  
  @override
  State<EmergencyFundBuilder> createState() => _EmergencyFundBuilderState();
}

class SavingsVehicle {
  final String name;
  final String emoji;
  final double interestRate;
  final int liquidity; // días para acceder al dinero
  final String description;
  
  SavingsVehicle({
    required this.name,
    required this.emoji,
    required this.interestRate,
    required this.liquidity,
    required this.description,
  });
}

class Emergency {
  final String title;
  final String emoji;
  final double cost;
  final int urgency; // días para resolver
  final String description;
  
  Emergency({
    required this.title,
    required this.emoji,
    required this.cost,
    required this.urgency,
    required this.description,
  });
}

class _EmergencyFundBuilderState extends State<EmergencyFundBuilder> {
  double _monthlyIncome = 2000.0; // Salario medio neto español más realista
  double _monthlyExpenses = 1400.0; // Gastos típicos españoles
  double _emergencyGoal = 4200.0; // 3 meses de gastos
  Map<String, double> _savings = {};
  int _currentMonth = 1;
  int _level = 1;
  double _experience = 0.0;
  
  Timer? _gameTimer;
  List<Emergency> _pendingEmergencies = [];
  List<String> _achievements = [];
  int _emergenciesHandled = 0;
  double _totalSaved = 0.0;
  
  final List<SavingsVehicle> _savingsOptions = [
    SavingsVehicle(
      name: 'Cuenta Corriente',
      emoji: '🏦',
      interestRate: 0.1, // Interés típico cuenta corriente España
      liquidity: 1, // Muy líquida
      description: 'Cuenta bancaria básica (Santander, BBVA, CaixaBank)',
    ),
    SavingsVehicle(
      name: 'Cuenta de Ahorro',
      emoji: '💰',
      interestRate: 0.5, // Interés típico cuenta ahorro España
      liquidity: 1, // Muy líquida
      description: 'Cuenta de ahorro con mejor interés (ING, Openbank)',
    ),
    SavingsVehicle(
      name: 'Depósito a Plazo',
      emoji: '📅',
      interestRate: 2.5, // Interés típico depósito España
      liquidity: 12, // 12 meses
      description: 'Depósito a plazo fijo (mejor interés, menos liquidez)',
    ),
    SavingsVehicle(
      name: 'Fondo de Inversión',
      emoji: '📈',
      interestRate: 4.0, // Rendimiento típico fondo España
      liquidity: 7, // 7 días
      description: 'Fondo de inversión monetario (más riesgo, más rendimiento)',
    ),
    SavingsVehicle(
      name: 'Letras del Tesoro',
      emoji: '📜',
      interestRate: 3.2, // Rendimiento típico letras España
      liquidity: 12, // 12 meses
      description: 'Letras del Tesoro español (inversión segura del Estado)',
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeSavings();
    _startGame();
  }
  
  void _initializeSavings() {
    for (var vehicle in _savingsOptions) {
      _savings[vehicle.name] = 0.0;
    }
  }
  
  void _startGame() {
    _gameTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _processMonth();
    });
    
    _scheduleEmergencies();
  }
  
  void _scheduleEmergencies() {
    final emergencies = [
      Emergency(
        title: 'Reparación del Coche',
        emoji: '🚗',
        cost: 450, // Reparación típica en España
        urgency: 7,
        description: 'Tu coche se ha estropeado y necesitas repararlo urgentemente en el taller',
      ),
      Emergency(
        title: 'Consulta Médica Privada',
        emoji: '🏥',
        cost: 180, // Consulta privada + pruebas
        urgency: 1,
        description: 'Visita de emergencia a médico privado (evita lista de espera)',
      ),
      Emergency(
        title: 'Electrodoméstico Dañado',
        emoji: '❄️',
        cost: 350, // Reparación frigorífico
        urgency: 14,
        description: 'El frigorífico se ha estropeado y necesitas repararlo',
      ),
      Emergency(
        title: 'Reparación del Techo',
        emoji: '🏠',
        cost: 800, // Reparación techo típica
        urgency: 30,
        description: 'Una tormenta ha dañado el techo de tu casa',
      ),
      Emergency(
        title: 'Pérdida de Empleo Temporal',
        emoji: '💼',
        cost: 1400, // Un mes de gastos básicos
        urgency: 30,
        description: 'Necesitas cubrir gastos por un mes sin ingresos (paro)',
      ),
      Emergency(
        title: 'Avería en Casa',
        emoji: '🏠',
        cost: 250, // Reparación fontanería/electricidad
        urgency: 3,
        description: 'Avería urgente en la instalación de casa',
      ),
      Emergency(
        title: 'Multa de Tráfico',
        emoji: '🚨',
        cost: 200, // Multa típica
        urgency: 15,
        description: 'Multa de tráfico que debes pagar (DGT)',
      ),
      Emergency(
        title: 'Reparación Calefacción',
        emoji: '🔥',
        cost: 300, // Reparación calefacción
        urgency: 5,
        description: 'La calefacción se ha estropeado en invierno',
      ),
    ];
    
    Timer(Duration(seconds: 15 + math.Random().nextInt(20)), () {
      if (mounted) {
        final emergency = emergencies[math.Random().nextInt(emergencies.length)];
        _triggerEmergency(emergency);
        _scheduleEmergencies();
      }
    });
  }
  
  void _processMonth() {
    setState(() {
      _currentMonth++;
      
      // Aplicar intereses
      for (var vehicle in _savingsOptions) {
        double currentAmount = _savings[vehicle.name] ?? 0;
        double monthlyInterest = currentAmount * (vehicle.interestRate / 100 / 12);
        _savings[vehicle.name] = currentAmount + monthlyInterest;
      }
      
      _checkAchievements();
      _checkLevelUp();
    });
  }
  
  void _triggerEmergency(Emergency emergency) {
    setState(() {
      _pendingEmergencies.add(emergency);
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🚨 ${emergency.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emergency.description),
            const SizedBox(height: 16),
            Text('Costo: €${emergency.cost.toInt()}', 
                 style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text('Urgencia: ${emergency.urgency} días', 
                 style: const TextStyle(color: Colors.orange)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEmergencyOptions(emergency);
            },
            child: const Text('Manejar Emergencia'),
          ),
        ],
      ),
    );
  }
  
  void _showEmergencyOptions(Emergency emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💡 ¿Cómo vas a pagar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _getTotalAvailableFunds() >= emergency.cost 
                ? () {
                    Navigator.pop(context);
                    _payWithEmergencyFund(emergency);
                  } 
                : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Usar Fondo de Emergencia (€${_getTotalAvailableFunds().toInt()} disponible)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _payWithCredit(emergency);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Usar Tarjeta de Crédito'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _askForLoan(emergency);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Pedir Préstamo a Familia'),
            ),
          ],
        ),
      ),
    );
  }
  
  double _getTotalAvailableFunds() {
    double total = 0;
    for (var vehicle in _savingsOptions) {
      if (vehicle.liquidity <= 3) { // Solo considerar fondos líquidos
        total += _savings[vehicle.name] ?? 0;
      }
    }
    return total;
  }
  
  void _payWithEmergencyFund(Emergency emergency) {
    // Retirar de la cuenta más líquida primero
    double remaining = emergency.cost;
    var liquidVehicles = _savingsOptions.where((v) => v.liquidity <= 3).toList();
    liquidVehicles.sort((a, b) => a.liquidity.compareTo(b.liquidity));
    
    for (var vehicle in liquidVehicles) {
      if (remaining <= 0) break;
      
      double available = _savings[vehicle.name] ?? 0;
      double withdrawal = math.min(remaining, available);
      
      setState(() {
        _savings[vehicle.name] = available - withdrawal;
        remaining -= withdrawal;
      });
    }
    
    setState(() {
      _pendingEmergencies.remove(emergency);
      _emergenciesHandled++;
    });
    
    _experience += 100;
    _showMessage('✅ Emergencia resuelta con tu fondo de emergencia!', Colors.green);
  }
  
  void _payWithCredit(Emergency emergency) {
    setState(() {
      _pendingEmergencies.remove(emergency);
      _emergenciesHandled++;
    });
    
    _experience += 25; // Menos XP por usar crédito
    _showMessage('⚠️ Usaste crédito. Tendrás que pagar intereses.', Colors.orange);
    
    // Simular deuda que afecta ingresos futuros
    Timer(const Duration(seconds: 10), () {
      setState(() {
        _monthlyExpenses += emergency.cost * 0.05; // 5% de interés mensual
      });
      _showMessage('💳 El pago mensual de tu deuda aumentó tus gastos', Colors.red);
    });
  }
  
  void _askForLoan(Emergency emergency) {
    setState(() {
      _pendingEmergencies.remove(emergency);
      _emergenciesHandled++;
    });
    
    _experience += 10; // Mínimo XP
    _showMessage('👨‍👩‍👧‍👦 Familia te ayudó, pero no siempre estarán disponibles.', Colors.blue);
  }
  
  void _addToSavings(String vehicleName, double amount) {
    double availableToSave = _monthlyIncome - _monthlyExpenses;
    if (amount > availableToSave) {
      _showMessage('No puedes ahorrar más de tus ingresos disponibles', Colors.red);
      return;
    }
    
    setState(() {
      _savings[vehicleName] = (_savings[vehicleName] ?? 0) + amount;
      _totalSaved += amount;
    });
    
    _experience += amount / 10; // XP por ahorrar
    _showMessage('💰 €${amount.toInt()} agregado a ${vehicleName}', Colors.green);
  }
  
  void _checkAchievements() {
    double totalEmergencyFund = _getTotalAvailableFunds();
    
    if (totalEmergencyFund >= 1000 && !_achievements.contains('Primer \$1K')) {
      _achievements.add('Primer \$1K');
      _showAchievement('🎯 ¡Primer \$1,000 en tu fondo de emergencia!');
    }
    
    if (totalEmergencyFund >= _monthlyExpenses && !_achievements.contains('Un Mes Seguro')) {
      _achievements.add('Un Mes Seguro');
      _showAchievement('🛡️ ¡Tienes gastos de un mes cubiertos!');
    }
    
    if (totalEmergencyFund >= _emergencyGoal && !_achievements.contains('Meta Alcanzada')) {
      _achievements.add('Meta Alcanzada');
      _showAchievement('🏆 ¡Alcanzaste tu meta de 3 meses de gastos!');
    }
    
    if (_emergenciesHandled >= 3 && !_achievements.contains('Veterano de Crisis')) {
      _achievements.add('Veterano de Crisis');
      _showAchievement('⚡ ¡Manejaste 3 emergencias!');
    }
  }
  
  void _checkLevelUp() {
    int newLevel = (_experience / 500).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      if (_level >= 4) {
        _completeGame();
      }
    }
  }
  
  void _completeGame() {
    _gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🛡️ ¡Emergency Fund Master! 🛡️'),
        content: Text(
          '¡Felicitaciones!\n'
          'Fondo de emergencia: \$${_getTotalAvailableFunds().toInt()}\n'
          'Emergencias manejadas: $_emergenciesHandled\n'
          '¡Estás preparado para cualquier imprevisto!'
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
  
  void _showAchievement(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Logro Desbloqueado'),
        content: Text(message),
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
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double totalFund = _getTotalAvailableFunds();
    double progress = totalFund / _emergencyGoal;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('🛡️ Emergency Fund Builder'),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: Column(
        children: [
          _buildHeader(totalFund, progress),
          Expanded(child: _buildSavingsOptions()),
          if (_pendingEmergencies.isNotEmpty) _buildEmergencyAlert(),
        ],
      ),
    );
  }
  
  Widget _buildHeader(double totalFund, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF16213E),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mes $_currentMonth', style: const TextStyle(color: Colors.white)),
                  Text('Nivel $_level', style: const TextStyle(color: Colors.blue)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${totalFund.toInt()}', 
                       style: const TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('de \$${_emergencyGoal.toInt()}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? Colors.green : 
              progress >= 0.5 ? Colors.blue : Colors.orange
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% de tu meta',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Disponible para ahorrar: \$${(_monthlyIncome - _monthlyExpenses).toInt()}/mes',
            style: const TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSavingsOptions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _savingsOptions.map((vehicle) => _buildSavingsCard(vehicle)).toList(),
    );
  }
  
  Widget _buildSavingsCard(SavingsVehicle vehicle) {
    double currentAmount = _savings[vehicle.name] ?? 0;
    double availableToSave = _monthlyIncome - _monthlyExpenses;
    
    return Card(
      color: const Color(0xFF16213E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(vehicle.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(vehicle.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance: \$${currentAmount.toInt()}', style: const TextStyle(color: Colors.white)),
                Text('${vehicle.interestRate}% anual', style: const TextStyle(color: Colors.green)),
              ],
            ),
            Text('Liquidez: ${vehicle.liquidity} días', style: const TextStyle(color: Colors.blue, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: availableToSave >= 100 ? () => _addToSavings(vehicle.name, 100) : null,
                    child: const Text('\$100'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: availableToSave >= 250 ? () => _addToSavings(vehicle.name, 250) : null,
                    child: const Text('\$250'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: availableToSave >= 500 ? () => _addToSavings(vehicle.name, 500) : null,
                    child: const Text('\$500'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmergencyAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.red.withOpacity(0.2),
      child: Row(
        children: [
          const Text('🚨', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${_pendingEmergencies.length} emergencia(s) pendiente(s)',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => _showEmergencyOptions(_pendingEmergencies.first),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ver', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
} 