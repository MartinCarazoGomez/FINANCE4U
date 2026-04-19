import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class InsuranceGuardian extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const InsuranceGuardian({super.key, this.onCompleted});
  
  @override
  State<InsuranceGuardian> createState() => _InsuranceGuardianState();
}

class Insurance {
  final String name;
  final String emoji;
  final double monthlyCost;
  final double coverage;
  final String description;
  bool isActive;
  
  Insurance({
    required this.name,
    required this.emoji,
    required this.monthlyCost,
    required this.coverage,
    required this.description,
    this.isActive = false,
  });
}

class RiskEvent {
  final String title;
  final String emoji;
  final double cost;
  final String insuranceType;
  final String description;
  
  RiskEvent({
    required this.title,
    required this.emoji,
    required this.cost,
    required this.insuranceType,
    required this.description,
  });
}

class _InsuranceGuardianState extends State<InsuranceGuardian> {
  double _monthlyIncome = 2200.0; // Salario medio neto español
  double _savings = 3000.0; // Ahorros iniciales más realistas
  int _currentMonth = 1;
  int _level = 1;
  double _totalInsuranceCost = 0.0;
  double _totalClaimsPaid = 0.0;
  double _totalPremiumsPaid = 0.0;
  
  List<Insurance> _insuranceOptions = [];
  List<String> _achievements = [];
  Timer? _gameTimer;
  
  @override
  void initState() {
    super.initState();
    _initializeInsurance();
    _startGame();
  }
  
  void _initializeInsurance() {
    _insuranceOptions = [
      Insurance(
        name: 'Seguro de Auto',
        emoji: '🚗',
        monthlyCost: 80, // Precio típico seguro coche España
        coverage: 30000, // Cobertura típica
        description: 'Cubre daños a terceros y tu vehículo (Mapfre/Axa) - Obligatorio en España',
      ),
      Insurance(
        name: 'Seguro de Hogar',
        emoji: '🏠',
        monthlyCost: 35, // Precio típico seguro hogar España
        coverage: 150000, // Cobertura típica
        description: 'Protege tu vivienda de incendios y robos (Línea Directa) - Incluye IBI',
      ),
      Insurance(
        name: 'Seguro de Salud',
        emoji: '🏥',
        monthlyCost: 60, // Precio típico seguro salud privado
        coverage: 50000, // Cobertura típica
        description: 'Complementa la sanidad pública (Sanitas/Adeslas) - Sin listas de espera (menos listas de espera)',
      ),
      Insurance(
        name: 'Seguro de Vida',
        emoji: '💝',
        monthlyCost: 25, // Precio típico seguro vida
        coverage: 100000, // Cobertura típica
        description: 'Protege a tu familia si falleces (Allianz/Generali) - Incluye hipoteca',
      ),
      Insurance(
        name: 'Seguro de Discapacidad',
        emoji: '🦽',
        monthlyCost: 50, // Precio típico seguro incapacidad
        coverage: 18000, // Cobertura típica
        description: 'Reemplaza ingresos si no puedes trabajar (Mutua Madrileña) - Complementa IT',
      ),
    ];
  }
  
  void _startGame() {
    _gameTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _processMonth();
    });
    
    _scheduleRiskEvents();
  }
  
  void _processMonth() {
    setState(() {
      _currentMonth++;
      
      // Pagar primas de seguros activos
      for (var insurance in _insuranceOptions) {
        if (insurance.isActive) {
          _savings -= insurance.monthlyCost;
          _totalPremiumsPaid += insurance.monthlyCost;
        }
      }
      
      // Ingresos mensuales menos gastos básicos
      _savings += _monthlyIncome - 2500; // Gastos básicos
      
      _checkAchievements();
    });
  }
  
  void _scheduleRiskEvents() {
    final riskEvents = [
      RiskEvent(
        title: 'Accidente de Auto',
        emoji: '🚗💥',
        cost: 8000,
        insuranceType: 'Seguro de Auto',
        description: 'Tu auto tuvo un accidente y necesita reparación',
      ),
      RiskEvent(
        title: 'Emergencia Médica',
        emoji: '🏥',
        cost: 15000,
        insuranceType: 'Seguro de Salud',
        description: 'Hospitalización de emergencia',
      ),
      RiskEvent(
        title: 'Incendio en Casa',
        emoji: '🏠🔥',
        cost: 50000,
        insuranceType: 'Seguro de Hogar',
        description: 'Un incendio dañó parte de tu hogar',
      ),
      RiskEvent(
        title: 'Lesión Laboral',
        emoji: '🦽',
        cost: 24000,
        insuranceType: 'Seguro de Discapacidad',
        description: 'Una lesión te impide trabajar por 8 meses',
      ),
    ];
    
    Timer(Duration(seconds: 10 + Random().nextInt(20)), () {
      if (mounted) {
        final event = riskEvents[Random().nextInt(riskEvents.length)];
        _triggerRiskEvent(event);
        _scheduleRiskEvents();
      }
    });
  }
  
  void _triggerRiskEvent(RiskEvent event) {
    Insurance? relevantInsurance = _insuranceOptions
        .where((i) => i.name == event.insuranceType && i.isActive)
        .firstOrNull;
    
    double outOfPocketCost = event.cost;
    
    if (relevantInsurance != null) {
      outOfPocketCost = max(0, event.cost - relevantInsurance.coverage);
      _totalClaimsPaid += event.cost - outOfPocketCost;
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
            Text('Costo total: €${event.cost.toInt()}', 
                 style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            if (relevantInsurance != null) ...[
              Text('Cubierto por seguro: €${(event.cost - outOfPocketCost).toInt()}', 
                   style: const TextStyle(color: Colors.green)),
              Text('Tu parte: €${outOfPocketCost.toInt()}', 
                   style: const TextStyle(color: Colors.orange)),
            ] else ...[
              const Text('Sin seguro - Pagas todo', style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _payForEvent(outOfPocketCost);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
  
  void _payForEvent(double cost) {
    setState(() {
      _savings -= cost;
    });
    
    if (_savings < 0) {
      _showMessage('💸 Te endeudaste por no tener seguro suficiente', Colors.red);
    } else if (cost == 0) {
      _showMessage('✅ ¡Tu seguro cubrió todo!', Colors.green);
    } else {
      _showMessage('💰 Pagaste €${cost.toInt()} de tu bolsillo', Colors.orange);
    }
    
    _checkGameEnd();
  }
  
  void _toggleInsurance(Insurance insurance) {
    setState(() {
      insurance.isActive = !insurance.isActive;
      _updateTotalCost();
    });
    
    _showMessage(
      insurance.isActive 
        ? '✅ ${insurance.name} activado' 
        : '❌ ${insurance.name} cancelado',
      insurance.isActive ? Colors.green : Colors.red,
    );
  }
  
  void _updateTotalCost() {
    _totalInsuranceCost = _insuranceOptions
        .where((i) => i.isActive)
        .fold(0, (sum, i) => sum + i.monthlyCost);
  }
  
  void _checkAchievements() {
    int activeInsurances = _insuranceOptions.where((i) => i.isActive).length;
    
    if (activeInsurances >= 3 && !_achievements.contains('Bien Protegido')) {
      _achievements.add('Bien Protegido');
      _showAchievement('🛡️ ¡Tienes 3 o más seguros activos!');
    }
    
    if (_totalClaimsPaid > _totalPremiumsPaid && !_achievements.contains('Seguro Rentable')) {
      _achievements.add('Seguro Rentable');
      _showAchievement('💰 ¡Los seguros te ahorraron dinero!');
    }
    
    if (_savings >= 20000 && !_achievements.contains('Fondo Sólido')) {
      _achievements.add('Fondo Sólido');
      _showAchievement('🏦 ¡Mantienes un buen fondo de emergencia!');
    }
  }
  
  void _checkGameEnd() {
    if (_currentMonth >= 18) {
      _completeGame();
    }
  }
  
  void _completeGame() {
    _gameTimer?.cancel();
    
    double netWorth = _savings;
    String performance;
    
    if (netWorth >= 15000) {
      performance = 'Excelente gestión de riesgos';
      _level = 3;
    } else if (netWorth >= 5000) {
      performance = 'Buena protección financiera';
      _level = 2;
    } else {
      performance = 'Necesitas mejor protección';
      _level = 1;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🛡️ ¡Insurance Guardian! 🛡️'),
        content: Text(
          'Meses transcurridos: $_currentMonth\n'
          'Dinero final: €${netWorth.toInt()}\n'
          'Primas pagadas: €${_totalPremiumsPaid.toInt()}\n'
          'Reclamos recibidos: €${_totalClaimsPaid.toInt()}\n'
          'Evaluación: $performance'
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_level >= 2) {
                widget.onCompleted?.call();
              } else {
                _restartGame();
              }
            },
            child: Text(_level >= 2 ? '¡Continuar!' : 'Intentar de Nuevo'),
          ),
        ],
      ),
    );
  }
  
  void _restartGame() {
    setState(() {
      _currentMonth = 1;
      _savings = 3000.0;
      _totalInsuranceCost = 0.0;
      _totalClaimsPaid = 0.0;
      _totalPremiumsPaid = 0.0;
      _achievements.clear();
      for (var insurance in _insuranceOptions) {
        insurance.isActive = false;
      }
    });
    _startGame();
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('🛡️ Insurance Guardian'),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildInsuranceList()),
          _buildSummary(),
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
                  Text('Mes $_currentMonth', style: const TextStyle(color: Colors.white)),
                  Text('Ahorros: €${_savings.toInt()}', 
                       style: TextStyle(color: _savings >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Seguros: €${_totalInsuranceCost.toInt()}/mes', style: const TextStyle(color: Colors.blue)),
                  Text('${_insuranceOptions.where((i) => i.isActive).length}/5 activos', 
                       style: const TextStyle(color: Colors.purple)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInsuranceList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _insuranceOptions.map((insurance) => _buildInsuranceCard(insurance)).toList(),
    );
  }
  
  Widget _buildInsuranceCard(Insurance insurance) {
    return Card(
      color: const Color(0xFF16213E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(insurance.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(insurance.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(insurance.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: insurance.isActive,
                  onChanged: (_) => _toggleInsurance(insurance),
                  activeColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Prima: €${insurance.monthlyCost.toInt()}/mes', style: const TextStyle(color: Colors.orange)),
                Text('Cobertura: €${insurance.coverage.toInt()}', style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF16213E),
      child: Column(
        children: [
          const Text('📊 Resumen Financiero', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Primas pagadas: €${_totalPremiumsPaid.toInt()}', style: const TextStyle(color: Colors.red)),
              Text('Reclamos: €${_totalClaimsPaid.toInt()}', style: const TextStyle(color: Colors.green)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Balance: ${_totalClaimsPaid > _totalPremiumsPaid ? "Ganancia" : "Inversión"} de €${(_totalClaimsPaid - _totalPremiumsPaid).abs().toInt()}',
            style: TextStyle(
              color: _totalClaimsPaid > _totalPremiumsPaid ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
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