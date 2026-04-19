import 'package:flutter/material.dart';
import '../utils/progress_service.dart';

class QuickPracticeScreen extends StatefulWidget {
  const QuickPracticeScreen({super.key});

  @override
  State<QuickPracticeScreen> createState() => _QuickPracticeScreenState();
}

class _QuickPracticeScreenState extends State<QuickPracticeScreen> {
  final ProgressService _progressService = ProgressService();
  
  final List<PracticeMode> _practiceModes = [
    PracticeMode(
      id: 'budget_practice',
      title: 'Práctica de Presupuesto',
      subtitle: '5 ejercicios en 2 minutos',
      description: 'Practica la creación y gestión de presupuestos personales',
      icon: Icons.account_balance_wallet,
      color: Colors.green,
      duration: '2 min',
      difficulty: 'Fácil',
      xpReward: 100,
    ),
    PracticeMode(
      id: 'investment_practice',
      title: 'Práctica de Inversiones',
      subtitle: 'Conceptos básicos de inversión',
      description: 'Aprende los fundamentos de las inversiones y el mercado',
      icon: Icons.trending_up,
      color: Colors.blue,
      duration: '3 min',
      difficulty: 'Medio',
      xpReward: 150,
    ),
    PracticeMode(
      id: 'credit_practice',
      title: 'Práctica de Crédito',
      subtitle: 'Manejo responsable del crédito',
      description: 'Aprende a usar el crédito de manera inteligente y responsable',
      icon: Icons.credit_card,
      color: Colors.purple,
      duration: '4 min',
      difficulty: 'Medio',
      xpReward: 120,
    ),
    PracticeMode(
      id: 'daily_challenge',
      title: 'Desafío Diario',
      subtitle: '¡Solo hoy! +50% XP extra',
      description: 'Un reto especial que cambia cada día con recompensas extra',
      icon: Icons.star,
      color: Colors.amber,
      duration: '5 min',
      difficulty: 'Variado',
      xpReward: 200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Práctica Rápida',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1B6B4B),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _practiceModes.length,
              itemBuilder: (context, index) {
                return _buildPracticeModeCard(_practiceModes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    final progress = _progressService.getUserProgress();
    final currentStreak = progress['currentStreak'] ?? 0;
    final todayCompleted = progress['todayCompleted'] ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1B6B4B),
            const Color(0xFF1B6B4B).withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.amber, size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Sesiones cortas, grandes resultados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat('Racha', '$currentStreak días', Icons.local_fire_department, Colors.orange),
              _buildQuickStat('Hoy', '$todayCompleted', Icons.today, Colors.blue),
              _buildQuickStat('Nivel', '${_progressService.getCurrentLevel()}', Icons.trending_up, Colors.green),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPracticeModeCard(PracticeMode mode) {
    final isSpecial = mode.id == 'daily_challenge';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isSpecial ? 12 : 4,
        shadowColor: isSpecial ? mode.color.withOpacity(0.3) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSpecial 
                ? mode.color.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSpecial 
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      mode.color.withOpacity(0.1),
                      mode.color.withOpacity(0.05),
                    ],
                  )
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mode.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(mode.icon, color: mode.color, size: 28),
            ),
            title: Text(
              mode.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  mode.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mode.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildChip(mode.duration, Icons.timer),
                    const SizedBox(width: 8),
                    _buildChip(mode.difficulty, Icons.speed),
                    const SizedBox(width: 8),
                    _buildChip('${mode.xpReward} XP', Icons.star),
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => _startPractice(mode),
              style: ElevatedButton.styleFrom(
                backgroundColor: mode.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Comenzar'),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  void _startPractice(PracticeMode mode) {
    // Navegar a la pantalla de juegos para practicar
    Navigator.of(context).pushNamed('/main');
  }
}

class PracticeMode {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String duration;
  final String difficulty;
  final int xpReward;

  PracticeMode({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.duration,
    required this.difficulty,
    required this.xpReward,
  });
} 