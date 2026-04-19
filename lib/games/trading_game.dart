import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'game_rewards.dart';
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';

class TradingGame extends StatefulWidget {
  final VoidCallback? onCompleted;
  final bool isQuickMode;
  final int? timeLimit;
  
  const TradingGame({
    super.key, 
    this.onCompleted,
    this.isQuickMode = false,
    this.timeLimit,
  });
  
  @override
  State<TradingGame> createState() => _TradingGameState();
}

class Stock {
  final String symbol;
  final String name;
  final String emoji;
  double price;
  double previousPrice;
  List<double> history;
  
  Stock({
    required this.symbol,
    required this.name,
    required this.emoji,
    required this.price,
  }) : previousPrice = price, history = [price];
  
  double get changePercent => ((price - previousPrice) / previousPrice) * 100;
  bool get isUp => price > previousPrice;
}

class Trade {
  final String symbol;
  final int shares;
  final double price;
  final bool isBuy;
  final DateTime timestamp;
  
  Trade({
    required this.symbol,
    required this.shares,
    required this.price,
    required this.isBuy,
    required this.timestamp,
  });
}

class _TradingGameState extends State<TradingGame> with TickerProviderStateMixin {
  // Game state
  double _cash = 5000.0; // Capital inicial más realista en euros
  double _portfolioValue = 5000.0;
  int _score = 0;
  int _timeLeft = 180; // 3 minutos
  Timer? _gameTimer;
  Timer? _marketTimer;
  bool _gameRunning = false;
  bool _gameCompleted = false;
  
  // Market data
  List<Stock> _stocks = [];
  Map<String, int> _holdings = {};
  List<Trade> _trades = [];
  
  // UI
  String? _selectedStock;
  int _selectedShares = 1;
  
  // Animations
  late AnimationController _priceController;
  late Animation<double> _priceAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeStocks();
    _startGame();
  }

  void _setupAnimations() {
    _priceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _priceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _priceController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeStocks() {
    _stocks = [
      Stock(symbol: 'SAN', name: 'Banco Santander', emoji: '🏦', price: 3.50),
      Stock(symbol: 'BBVA', name: 'BBVA', emoji: '💳', price: 8.20),
      Stock(symbol: 'TEF', name: 'Telefónica', emoji: '📞', price: 3.80),
      Stock(symbol: 'ITX', name: 'Inditex', emoji: '👕', price: 28.50),
      Stock(symbol: 'IBE', name: 'Iberdrola', emoji: '⚡', price: 11.20),
      Stock(symbol: 'REP', name: 'Repsol', emoji: '⛽', price: 14.80),
      Stock(symbol: 'ACS', name: 'ACS', emoji: '🏗️', price: 35.60),
      Stock(symbol: 'FER', name: 'Ferrovial', emoji: '🚧', price: 32.40),
    ];
    
    for (var stock in _stocks) {
      _holdings[stock.symbol] = 0;
    }
  }

  void _startGame() {
    setState(() {
      _gameRunning = true;
    });
    
    // Game timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
    
    // Market updates every 2 seconds
    _marketTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateMarket();
    });
  }

  void _updateMarket() {
    final random = Random();
    
    setState(() {
      for (var stock in _stocks) {
        stock.previousPrice = stock.price;
        
        // Random price movement (-5% to +5%)
        double change = (random.nextDouble() - 0.5) * 0.1;
        stock.price *= (1 + change);
        stock.price = double.parse(stock.price.toStringAsFixed(2));
        
        stock.history.add(stock.price);
        if (stock.history.length > 20) {
          stock.history.removeAt(0);
        }
      }
      
      _calculatePortfolioValue();
    });
    
    _priceController.forward().then((_) => _priceController.reverse());
  }

  void _calculatePortfolioValue() {
    double portfolioValue = _cash;
    
    for (var stock in _stocks) {
      portfolioValue += _holdings[stock.symbol]! * stock.price;
    }
    
    _portfolioValue = portfolioValue;
    
    // Calculate score based on portfolio growth
    double growth = ((_portfolioValue - 5000) / 5000) * 100;
    _score = (growth * 10).round().clamp(0, 1000);
  }

  void _buyStock(String symbol, int shares) {
    final stock = _stocks.firstWhere((s) => s.symbol == symbol);
    final cost = stock.price * shares;
    
    if (_cash >= cost) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      setState(() {
        _cash -= cost;
        _holdings[symbol] = _holdings[symbol]! + shares;
        _trades.add(Trade(
          symbol: symbol,
          shares: shares,
          price: stock.price,
          isBuy: true,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  void _sellStock(String symbol, int shares) {
    if (_holdings[symbol]! >= shares) {
      final stock = _stocks.firstWhere((s) => s.symbol == symbol);
      final income = stock.price * shares;
      
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      setState(() {
        _cash += income;
        _holdings[symbol] = _holdings[symbol]! - shares;
        _trades.add(Trade(
          symbol: symbol,
          shares: shares,
          price: stock.price,
          isBuy: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  void _endGame() {
    _gameTimer?.cancel();
    _marketTimer?.cancel();
    
    setState(() {
      _gameRunning = false;
      _gameCompleted = true;
    });
    
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    final growth = ((_portfolioValue - 5000) / 5000) * 100;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎯 ¡Trading Completado!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💰 Portafolio Final: €${_portfolioValue.toStringAsFixed(0)}'),
            Text('📈 Crecimiento: ${growth.toStringAsFixed(1)}%'),
            Text('⭐ Puntuación: $_score'),
            Text('💼 Operaciones: ${_trades.length}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onCompleted?.call();
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('📈 Trading Game', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
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
              '\$${_portfolioValue.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusCard('💰 Efectivo', '\$${_cash.toStringAsFixed(0)}', Colors.blue),
                _buildStatusCard('⏰ Tiempo', '${_timeLeft}s', Colors.orange),
                _buildStatusCard('⭐ Score', '$_score', Colors.purple),
              ],
            ),
          ),
          
          // Stock list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _stocks.length,
              itemBuilder: (context, index) {
                final stock = _stocks[index];
                final holdings = _holdings[stock.symbol]!;
                
                return AnimatedBuilder(
                  animation: _priceAnimation,
                  builder: (context, child) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: stock.isUp ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(stock.emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stock.symbol,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    stock.name,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${stock.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${stock.isUp ? '+' : ''}${stock.changePercent.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: stock.isUp ? Colors.green : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (holdings > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Posees: $holdings acciones = \$${(holdings * stock.price).toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _gameRunning ? () => _buyStock(stock.symbol, _selectedShares) : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('Comprar', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _gameRunning && holdings > 0 ? () => _sellStock(stock.symbol, _selectedShares) : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Vender', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _marketTimer?.cancel();
    _priceController.dispose();
    super.dispose();
  }
} 