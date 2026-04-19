import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class RealEstateEmpire extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const RealEstateEmpire({super.key, this.onCompleted});
  
  @override
  State<RealEstateEmpire> createState() => _RealEstateEmpireState();
}

class Property {
  final String name;
  final String emoji;
  final String location;
  double purchasePrice;
  double currentValue;
  double monthlyRent;
  double monthlyExpenses;
  bool isOwned;
  bool isRented;
  int improvementLevel;
  
  Property({
    required this.name,
    required this.emoji,
    required this.location,
    required this.purchasePrice,
    required this.currentValue,
    required this.monthlyRent,
    required this.monthlyExpenses,
    this.isOwned = false,
    this.isRented = false,
    this.improvementLevel = 0,
  });
  
  double get monthlyProfit => monthlyRent - monthlyExpenses;
  double get roi => (monthlyProfit * 12) / currentValue * 100;
}

class _RealEstateEmpireState extends State<RealEstateEmpire> {
  double _cash = 80000.0; // Capital inicial más realista en euros para España
  double _monthlyIncome = 0.0;
  double _monthlyExpenses = 0.0;
  double _portfolioValue = 0.0;
  int _currentMonth = 1;
  int _level = 1;
  double _experience = 0.0;
  
  List<Property> _availableProperties = [];
  List<Property> _ownedProperties = [];
  List<String> _achievements = [];
  Timer? _gameTimer;
  
  @override
  void initState() {
    super.initState();
    _initializeProperties();
    _startGame();
  }
  
  void _initializeProperties() {
    _availableProperties = [
      Property(
        name: 'Piso Centro Madrid',
        emoji: '🏢',
        location: 'Centro de Madrid (Salamanca)',
        purchasePrice: 280000, // Precio típico centro Madrid
        currentValue: 280000,
        monthlyRent: 1200, // Renta típica centro
        monthlyExpenses: 400, // Comunidad + IBI + suministros
      ),
      Property(
        name: 'Apartamento Barcelona',
        emoji: '🏙️',
        location: 'Eixample, Barcelona',
        purchasePrice: 350000, // Precio típico Eixample
        currentValue: 350000,
        monthlyRent: 1500, // Renta típica Barcelona
        monthlyExpenses: 500, // Comunidad + IBI + suministros
      ),
      Property(
        name: 'Casa Adosada Valencia',
        emoji: '🏘️',
        location: 'Valencia Centro (Ruzafa)',
        purchasePrice: 220000, // Precio típico Valencia
        currentValue: 220000,
        monthlyRent: 900, // Renta típica Valencia
        monthlyExpenses: 300, // IBI + mantenimiento
      ),
      Property(
        name: 'Apartamento Costa del Sol',
        emoji: '🏖️',
        location: 'Marbella, Málaga',
        purchasePrice: 320000, // Precio típico costa
        currentValue: 320000,
        monthlyRent: 1800, // Renta turística
        monthlyExpenses: 350, // Comunidad + IBI
      ),
      Property(
        name: 'Estudio Salamanca',
        emoji: '🏠',
        location: 'Zona Universitaria',
        purchasePrice: 120000, // Precio típico estudio
        currentValue: 120000,
        monthlyRent: 600, // Renta estudiante
        monthlyExpenses: 150, // Comunidad + IBI
      ),
    ];
  }
  
  void _startGame() {
    _gameTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _processMonth();
    });
  }
  
  void _processMonth() {
    setState(() {
      _currentMonth++;
      
      // Calcular ingresos y gastos mensuales
      _monthlyIncome = 0;
      _monthlyExpenses = 0;
      
      for (var property in _ownedProperties) {
        if (property.isRented) {
          _monthlyIncome += property.monthlyRent;
        }
        _monthlyExpenses += property.monthlyExpenses;
      }
      
      double netIncome = _monthlyIncome - _monthlyExpenses;
      _cash += netIncome;
      
      // Fluctuaciones del mercado
      _updateMarketValues();
      
      // Calcular valor del portfolio
      _portfolioValue = _ownedProperties.fold(0.0, (sum, p) => sum + p.currentValue) + _cash;
      
      _checkAchievements();
      _checkLevelUp();
    });
  }
  
  void _updateMarketValues() {
    final random = Random();
    
    // Actualizar valores de propiedades
    for (var property in [..._availableProperties, ..._ownedProperties]) {
      double change = (random.nextDouble() - 0.5) * 0.05; // ±2.5% cambio
      property.currentValue *= (1 + change);
      
      // Ajustar renta basada en valor
      property.monthlyRent = property.currentValue * 0.01;
    }
  }
  
  void _buyProperty(Property property) {
    if (_cash >= property.currentValue) {
      setState(() {
        _cash -= property.currentValue;
        _availableProperties.remove(property);
        property.isOwned = true;
        property.isRented = Random().nextBool(); // 50% probabilidad de tener inquilino
        _ownedProperties.add(property);
      });
      
      _experience += 50;
      _showMessage('🏠 Propiedad comprada: ${property.name}', Colors.green);
    } else {
      _showMessage('💸 Fondos insuficientes', Colors.red);
    }
  }
  
  void _sellProperty(Property property) {
    setState(() {
      _cash += property.currentValue;
      _ownedProperties.remove(property);
      property.isOwned = false;
      property.isRented = false;
      _availableProperties.add(property);
    });
    
    _experience += 30;
    _showMessage('💰 Propiedad vendida: ${property.name}', Colors.blue);
  }
  
  void _improveProperty(Property property) {
    double cost = property.currentValue * 0.1; // 10% del valor
    
    if (_cash >= cost && property.improvementLevel < 3) {
      setState(() {
        _cash -= cost;
        property.improvementLevel++;
        property.currentValue *= 1.15; // 15% aumento de valor
        property.monthlyRent *= 1.12; // 12% aumento de renta
        property.monthlyExpenses *= 1.05; // 5% aumento de gastos
      });
      
      _experience += 25;
      _showMessage('🔨 Propiedad mejorada: ${property.name}', Colors.orange);
    } else {
      _showMessage('❌ No se puede mejorar más o fondos insuficientes', Colors.red);
    }
  }
  
  void _toggleRental(Property property) {
    setState(() {
      property.isRented = !property.isRented;
    });
    
    _showMessage(
      property.isRented 
        ? '🔑 Inquilino encontrado para ${property.name}' 
        : '📤 Inquilino salió de ${property.name}',
      property.isRented ? Colors.green : Colors.orange,
    );
  }
  
  void _checkAchievements() {
    if (_ownedProperties.length >= 1 && !_achievements.contains('Primera Propiedad')) {
      _achievements.add('Primera Propiedad');
      _showAchievement('🏠 ¡Tu primera propiedad!');
    }
    
    if (_ownedProperties.length >= 3 && !_achievements.contains('Portfolio Diverso')) {
      _achievements.add('Portfolio Diverso');
      _showAchievement('🏘️ ¡3 propiedades en tu portfolio!');
    }
    
    if (_monthlyIncome >= 5000 && !_achievements.contains('Ingreso Pasivo')) {
      _achievements.add('Ingreso Pasivo');
      _showAchievement('💰 ¡€5000+ en ingresos pasivos!');
    }
    
    if (_portfolioValue >= 500000 && !_achievements.contains('Medio Millón')) {
      _achievements.add('Medio Millón');
      _showAchievement('💎 ¡Portfolio de medio millón!');
    }
  }
  
  void _checkLevelUp() {
    int newLevel = (_experience / 200).floor() + 1;
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
        title: const Text('🏆 ¡Real Estate Mogul! 🏆'),
        content: Text(
          '¡Felicitaciones!\n'
          'Portfolio: \$${_portfolioValue.toInt()}\n'
          'Ingresos mensuales: \$${_monthlyIncome.toInt()}\n'
          'Propiedades: ${_ownedProperties.length}\n'
          '¡Eres un magnate inmobiliario!'
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
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('🏠 Real Estate Empire'),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(child: _buildPropertyView()),
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
                  Text('Nivel $_level', style: const TextStyle(color: Colors.blue)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${_cash.toInt()}', 
                       style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Efectivo', style: TextStyle(color: Colors.green)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('📊 Portfolio', '\$${_portfolioValue.toInt()}', Colors.purple),
              _buildStatCard('📈 Ingresos', '\$${_monthlyIncome.toInt()}/mes', Colors.green),
              _buildStatCard('🏠 Propiedades', '${_ownedProperties.length}', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  Widget _buildTabs() {
    return Container(
      color: const Color(0xFF16213E),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              '🏠 Gestión de Propiedades',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPropertyView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_availableProperties.isNotEmpty) ...[
          const Text('🛒 Propiedades Disponibles', 
                     style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._availableProperties.map((property) => _buildPropertyCard(property, false)),
          const SizedBox(height: 16),
        ],
        
        if (_ownedProperties.isNotEmpty) ...[
          const Text('🏠 Mis Propiedades', 
                     style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._ownedProperties.map((property) => _buildPropertyCard(property, true)),
        ],
        
        if (_ownedProperties.isEmpty && _availableProperties.isEmpty) 
          const Center(
            child: Text('No hay propiedades disponibles', 
                       style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
  
  Widget _buildPropertyCard(Property property, bool isOwned) {
    return Card(
      color: const Color(0xFF16213E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(property.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(property.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(property.location, style: const TextStyle(color: Colors.grey)),
                      if (property.improvementLevel > 0)
                        Text('${'⭐' * property.improvementLevel} Mejorada', 
                             style: const TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
                if (isOwned && property.isRented) 
                  const Icon(Icons.key, color: Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor: \$${property.currentValue.toInt()}', style: const TextStyle(color: Colors.blue)),
                Text('ROI: ${property.roi.toStringAsFixed(1)}%', 
                     style: TextStyle(color: property.roi > 8 ? Colors.green : Colors.orange)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Renta: \$${property.monthlyRent.toInt()}/mes', style: const TextStyle(color: Colors.green)),
                Text('Gastos: \$${property.monthlyExpenses.toInt()}/mes', style: const TextStyle(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 12),
            if (!isOwned) ...[
              ElevatedButton(
                onPressed: _cash >= property.currentValue ? () => _buyProperty(property) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: Text('Comprar - \$${property.currentValue.toInt()}', 
                           style: const TextStyle(color: Colors.white)),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _sellProperty(property),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Vender', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _improveProperty(property),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Mejorar', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _toggleRental(property),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: property.isRented ? Colors.grey : Colors.blue,
                      ),
                      child: Text(
                        property.isRented ? 'Desalojar' : 'Rentar',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
} 