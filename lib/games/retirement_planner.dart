import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class RetirementPlanner extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const RetirementPlanner({super.key, this.onCompleted});
  
  @override
  State<RetirementPlanner> createState() => _RetirementPlannerState();
}

class _RetirementPlannerState extends State<RetirementPlanner> {
  int _currentAge = 25;
  int _retirementAge = 67;
  double _salary = 28000.0;
  double _retirementSavings = 0.0;
  double _monthlyContribution = 300.0;
  double _expectedReturn = 5.0; // % anual más conservador para España
  int _level = 1;
  
  Timer? _gameTimer;
  List<String> _achievements = [];
  
  @override
  void initState() {
    super.initState();
    _startCareer();
  }
  
  void _startCareer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _ageOneYear();
    });
  }
  
  void _ageOneYear() {
    setState(() {
      _currentAge++;
      
      // Aplicar crecimiento de inversiones
      _retirementSavings = _retirementSavings * (1 + _expectedReturn / 100);
      
      // Agregar contribuciones anuales
      _retirementSavings += _monthlyContribution * 12;
      
      // Aumentos de salario esporádicos
      if (Random().nextDouble() < 0.3) {
        _salary *= 1.05; // 5% de aumento
        _showMessage('🎉 ¡Aumento de salario!', Colors.green);
      }
    });
    
    _checkMilestones();
    
    if (_currentAge >= _retirementAge) {
      _retire();
    }
  }
  
  void _checkMilestones() {
    if (_retirementSavings >= 100000 && !_achievements.contains('Primer 100K')) {
      _achievements.add('Primer 100K');
      _showAchievement('💰 ¡Primer €100,000 ahorrados!');
    }
    
    if (_retirementSavings >= 500000 && !_achievements.contains('Medio Millón')) {
      _achievements.add('Medio Millón');
      _showAchievement('🏆 ¡Medio millón alcanzado!');
    }
    
    if (_retirementSavings >= 1000000 && !_achievements.contains('Millonario')) {
      _achievements.add('Millonario');
      _showAchievement('💎 ¡Eres millonario!');
    }
  }
  
  void _retire() {
    _gameTimer?.cancel();
    
    double monthlyIncome = _retirementSavings * 0.04 / 12; // Regla del 4%
    double salaryReplacement = (monthlyIncome * 12) / _salary * 100;
    
    String retirementQuality;
    if (salaryReplacement >= 80) {
      retirementQuality = 'Excelente - Vida cómoda';
      _level = 3;
    } else if (salaryReplacement >= 60) {
      retirementQuality = 'Buena - Estable';
      _level = 2;
    } else {
      retirementQuality = 'Modesta - Ajustada';
      _level = 1;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🏖️ ¡Jubilación! 🏖️'),
        content: Text(
          'Edad de jubilación: $_currentAge\n'
          'Ahorros totales: €${_retirementSavings.toInt()}\n'
          'Ingreso mensual: €${monthlyIncome.toInt()}\n'
          'Reemplazo de salario: ${salaryReplacement.toStringAsFixed(1)}%\n'
          'Calidad de jubilación: $retirementQuality'
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_level >= 2) {
                widget.onCompleted?.call();
              } else {
                _restartCareer();
              }
            },
            child: Text(_level >= 2 ? '¡Continuar!' : 'Intentar de Nuevo'),
          ),
        ],
      ),
    );
  }
  
  void _restartCareer() {
    setState(() {
      _currentAge = 25;
      _retirementSavings = 0.0;
      _salary = 28000.0;
      _monthlyContribution = 300.0;
      _achievements.clear();
    });
    _startCareer();
  }
  
  void _increaseContribution() {
    if (_monthlyContribution < _salary * 0.2 / 12) {
      setState(() {
        _monthlyContribution += 100;
      });
      _showMessage('📈 Contribución aumentada', Colors.blue);
    }
  }
  
  void _decreaseContribution() {
    if (_monthlyContribution > 100) {
      setState(() {
        _monthlyContribution -= 100;
      });
      _showMessage('📉 Contribución reducida', Colors.orange);
    }
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
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double yearsToRetirement = _retirementAge - _currentAge.toDouble();
    double projectedSavings = _calculateProjectedSavings();
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('🏖️ Retirement Planner'),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildPlanningPanel()),
          _buildControls(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
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
                  Text('Edad: $_currentAge años', style: const TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Salario: \$${_salary.toInt()}', style: const TextStyle(color: Colors.green)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${_retirementSavings.toInt()}', 
                       style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Ahorros', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (_currentAge - 25) / (_retirementAge - 25),
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            '${_retirementAge - _currentAge} años hasta la jubilación',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlanningPanel() {
    double projectedSavings = _calculateProjectedSavings();
    double monthlyIncome = projectedSavings * 0.04 / 12;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF16213E),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📊 Proyección de Jubilación', 
                           style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Ahorros proyectados: \$${projectedSavings.toInt()}', 
                     style: const TextStyle(color: Colors.green)),
                Text('Ingreso mensual estimado: \$${monthlyIncome.toInt()}', 
                     style: const TextStyle(color: Colors.blue)),
                Text('Contribución actual: \$${_monthlyContribution.toInt()}/mes', 
                     style: const TextStyle(color: Colors.purple)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFF16213E),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 Consejos', 
                           style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('• Empieza a ahorrar temprano', style: TextStyle(color: Colors.grey)),
                const Text('• Aprovecha el interés compuesto', style: TextStyle(color: Colors.grey)),
                const Text('• Considera planes de pensiones (Santander, BBVA)', style: TextStyle(color: Colors.grey)),
                const Text('• Complementa la pensión pública', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_achievements.isNotEmpty) ...[
          Card(
            color: const Color(0xFF16213E),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🏆 Logros', 
                             style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._achievements.map((achievement) => Text(
                    '✅ $achievement',
                    style: const TextStyle(color: Colors.green),
                  )),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _decreaseContribution,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('- \$100/mes', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '\$${_monthlyContribution.toInt()}/mes',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _increaseContribution,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('+ \$100/mes', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  
  double _calculateProjectedSavings() {
    double yearsToRetirement = _retirementAge - _currentAge.toDouble();
    double annualContribution = _monthlyContribution * 12;
    double currentSavings = _retirementSavings;
    
    // Fórmula de valor futuro de anualidad
    double futureValueContributions = annualContribution * 
        ((pow(1 + _expectedReturn / 100, yearsToRetirement) - 1) / (_expectedReturn / 100));
    double futureValueCurrent = currentSavings * pow(1 + _expectedReturn / 100, yearsToRetirement);
    
    return futureValueContributions + futureValueCurrent;
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
} 