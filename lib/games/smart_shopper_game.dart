import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SmartShopperGame extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const SmartShopperGame({super.key, this.onCompleted});
  
  @override
  State<SmartShopperGame> createState() => _SmartShopperGameState();
}

class ShoppingChoice {
  final String item;
  final String emoji;
  final List<String> options;
  final List<double> prices;
  final List<int> qualityScores;
  final int correctChoice;
  
  ShoppingChoice({
    required this.item,
    required this.emoji,
    required this.options,
    required this.prices,
    required this.qualityScores,
    required this.correctChoice,
  });
}

class _SmartShopperGameState extends State<SmartShopperGame> {
  double _budget = 500.0; // Presupuesto más realista en euros
  double _savings = 0.0;
  int _smartChoices = 0;
  int _totalChoices = 0;
  int _level = 1;
  double _experience = 0.0;
  
  int _currentChoiceIndex = 0;
  List<ShoppingChoice> _choices = [];
  
  @override
  void initState() {
    super.initState();
    _initializeChoices();
    // Defer showing dialog until after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNextChoice();
    });
  }
  
  void _initializeChoices() {
    _choices = [
      ShoppingChoice(
        item: 'Móvil',
        emoji: '📱',
        options: ['iPhone 15 Pro', 'Samsung Galaxy S24', 'Xiaomi Redmi Note'],
        prices: [1200, 800, 250],
        qualityScores: [95, 90, 75],
        correctChoice: 1, // Mejor relación calidad-precio
      ),
      ShoppingChoice(
        item: 'Café',
        emoji: '☕',
        options: ['Café de Especialidad', 'Café de Bar', 'Café en Casa'],
        prices: [3.50, 1.20, 0.30],
        qualityScores: [80, 75, 70],
        correctChoice: 2, // Mejor ahorro
      ),
      ShoppingChoice(
        item: 'Ropa',
        emoji: '👕',
        options: ['Zara Premium', 'H&M/Mango', 'Marca Básica'],
        prices: [120, 45, 20],
        qualityScores: [90, 75, 60],
        correctChoice: 1, // Balance calidad-precio
      ),
      ShoppingChoice(
        item: 'Comida',
        emoji: '🍔',
        options: ['Restaurante Caro', 'Comida Rápida', 'Cocinar en Casa'],
        prices: [35, 15, 8],
        qualityScores: [85, 60, 80],
        correctChoice: 2, // Mejor para salud y dinero
      ),
      ShoppingChoice(
        item: 'Entretenimiento',
        emoji: '🎬',
        options: ['Cine Premium', 'Cine Normal', 'Streaming en Casa'],
        prices: [12, 8, 2],
        qualityScores: [90, 75, 70],
        correctChoice: 2, // Mejor valor
      ),
      ShoppingChoice(
        item: 'Transporte',
        emoji: '🚗',
        options: ['Taxi', 'Uber/Cabify', 'Transporte Público'],
        prices: [25, 15, 2],
        qualityScores: [85, 80, 75],
        correctChoice: 2, // Mejor ahorro
      ),
    ];
  }
  
  void _showNextChoice() {
    if (_currentChoiceIndex >= _choices.length) {
      _completeGame();
      return;
    }
    
    // Ensure widget is still mounted before showing dialog
    if (!mounted) return;
    
    final choice = _choices[_currentChoiceIndex];
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('${choice.emoji} ${choice.item}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Presupuesto: €${_budget.toInt()}'),
            const SizedBox(height: 16),
            ...choice.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final price = choice.prices[index];
              final quality = choice.qualityScores[index];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: _budget >= price ? () {
                    Navigator.pop(context);
                    _makeChoice(index, choice);
                  } : null,
                  child: Text('$option - €${price.toInt()} (Calidad: $quality/100)'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  void _makeChoice(int choiceIndex, ShoppingChoice shoppingChoice) {
    setState(() {
      _totalChoices++;
      _budget -= shoppingChoice.prices[choiceIndex];
      
      if (choiceIndex == shoppingChoice.correctChoice) {
        _smartChoices++;
        _experience += 100;
        _savings += shoppingChoice.prices.reduce(max) - shoppingChoice.prices[choiceIndex];
      } else {
        _experience += 25;
      }
      
      _currentChoiceIndex++;
    });
    
    String feedback = choiceIndex == shoppingChoice.correctChoice 
        ? '✅ ¡Excelente elección! Ahorraste dinero.' 
        : '❌ Podrías haber elegido mejor.';
    
    _showMessage(feedback, choiceIndex == shoppingChoice.correctChoice ? Colors.green : Colors.orange);
    
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _showNextChoice();
      }
    });
  }
  
  void _completeGame() {
    if (!mounted) return;
    
    double efficiency = _smartChoices / _totalChoices * 100;
    
    if (efficiency >= 80) {
      _level = 3; // Victoria
    } else if (efficiency >= 60) {
      _level = 2;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🛍️ ¡Smart Shopper! 🛍️'),
        content: Text(
          'Decisiones inteligentes: $_smartChoices/$_totalChoices\n'
          'Dinero ahorrado: €${_savings.toInt()}\n'
          'Eficiencia: ${efficiency.toStringAsFixed(1)}%\n'
          '${efficiency >= 80 ? "¡Eres un comprador experto!" : "¡Sigue practicando!"}'
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_level >= 3) {
                widget.onCompleted?.call();
              } else {
                _restartGame();
              }
            },
            child: Text(_level >= 3 ? '¡Continuar!' : 'Intentar de Nuevo'),
          ),
        ],
      ),
    );
  }
  
  void _restartGame() {
    setState(() {
      _budget = 500.0;
      _savings = 0.0;
      _smartChoices = 0;
      _totalChoices = 0;
      _currentChoiceIndex = 0;
    });
    _showNextChoice();
  }
  
  void _showMessage(String message, Color color) {
    if (!mounted) return;
    
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
        title: const Text('🛍️ Smart Shopper'),
        backgroundColor: const Color(0xFF16213E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    '🎯 Toma decisiones inteligentes de compra',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Presupuesto: €${_budget.toInt()}',
                    style: const TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ahorrado: €${_savings.toInt()}',
                    style: const TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  Text(
                    'Elecciones inteligentes: $_smartChoices/$_totalChoices',
                    style: const TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Evalúa cada opción considerando:\n• Precio vs Calidad\n• Necesidad vs Deseo\n• Valor a largo plazo',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    super.dispose();
  }
} 