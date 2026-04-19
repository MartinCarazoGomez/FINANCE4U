import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../games/budget_master_game.dart';
import '../games/credit_score_hero.dart';
import '../games/debt_destroyer_game.dart';
import '../games/emergency_fund_builder.dart';
import '../games/entrepreneur_sim.dart';
import '../games/insurance_guardian.dart';
import '../games/smart_shopper_game.dart';
import '../games/trading_game.dart';
import '../games/real_estate_empire.dart';
import '../games/retirement_planner.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = getGames();
    final size = MediaQuery.of(context).size;
    final double riverHeight = size.height;
    final double riverWidth = size.width;
    final double circleSize = 64; // Más pequeño
    final double topPadding = 80;
    final double bottomPadding = 40;
    final double availableHeight = riverHeight - topPadding - bottomPadding;
    final int gameCount = games.length;
    // Coordenadas relativas proporcionadas por el usuario (actualizadas)
    final List<Offset> relativePositions = [
      Offset(0.435546875, 0.252760736196319),
      Offset(0.3310546875, 0.2950920245398773),
      Offset(0.4072265625, 0.347239263803681),
      Offset(0.5625, 0.3852760736196319),
      Offset(0.662109375, 0.4349693251533742),
      Offset(0.5439453125, 0.4950920245398773),
      Offset(0.365234375, 0.5539877300613497),
      Offset(0.3525390625, 0.6374233128834356),
      Offset(0.5556640625, 0.7141104294478527),
      Offset(0.54296875, 0.8208588957055215),
    ];
    final List<Offset> positions = List.generate(games.length, (i) {
      if (i < relativePositions.length) {
        final rel = relativePositions[i];
        return Offset(
          riverWidth * rel.dx - circleSize / 2,
          riverHeight * rel.dy - circleSize / 2,
        );
      } else {
        // Si hay más juegos, los coloca en la parte inferior derecha
        return Offset(riverWidth * 0.95 - circleSize / 2, riverHeight * 0.95 - circleSize / 2);
      }
    });

    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Stack(
            children: [
              // Fondo del río
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/fondo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // AppBar flotante
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'Juegos Financieros',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Círculos de juegos
              ...List.generate(games.length, (i) {
                final game = games[i];
                final pos = positions[i];
                final isUnlocked = appProvider.isGameUnlocked(game.id);
                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  child: _buildGameNode(context, game, appProvider, circleSize, isUnlocked),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGameNode(BuildContext context, RiverGame game, AppProvider appProvider, double size, bool isUnlocked) {
    return GestureDetector(
      onTap: isUnlocked ? () => _launchGame(context, game) : null,
      child: Tooltip(
        message: game.title.replaceAll('\n', ' '),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked 
                ? game.color.withOpacity(0.9)
                : Colors.grey.withOpacity(0.5),
            border: Border.all(
              color: isUnlocked ? Colors.white : Colors.grey,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnlocked 
                    ? game.color.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  game.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 22,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      game.title,
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.white : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.lock,
                    size: 10,
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchGame(BuildContext context, RiverGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => game.screen,
      ),
    );
  }

  // Método para obtener la lista de juegos
  List<RiverGame> getGames() {
    return [
      RiverGame(
        id: 'budget_master',
        title: 'Maestro del\nPresupuesto',
        emoji: '💰',
        color: const Color(0xFF4CAF50),
        riverPosition: RiverPosition.left,
        screen: const BudgetMasterGame(),
        description: 'Aprende a crear y mantener presupuestos efectivos',
      ),
      RiverGame(
        id: 'credit_score',
        title: 'Héroe del\nCrédito',
        emoji: '📊',
        color: const Color(0xFF2196F3),
        riverPosition: RiverPosition.right,
        screen: CreditScoreHero(
          onCompleted: () {},
        ),
        description: 'Mejora tu puntaje de crédito y salud financiera',
      ),
      RiverGame(
        id: 'debt_destroyer',
        title: 'Destructor\nde Deudas',
        emoji: '💥',
        color: const Color(0xFFFF5722),
        riverPosition: RiverPosition.left,
        screen: const DebtDestroyerGame(),
        description: 'Elimina tus deudas de manera estratégica',
      ),
      RiverGame(
        id: 'emergency_fund',
        title: 'Constructor\nde Emergencias',
        emoji: '🛡️',
        color: const Color(0xFF9C27B0),
        riverPosition: RiverPosition.right,
        screen: const EmergencyFundBuilder(),
        description: 'Construye tu fondo de emergencia',
      ),
      RiverGame(
        id: 'entrepreneur',
        title: 'Simulador\nEmpresarial',
        emoji: '🏢',
        color: const Color(0xFFFF9800),
        riverPosition: RiverPosition.left,
        screen: const EntrepreneurSim(),
        description: 'Gestiona tu propio negocio virtual',
      ),
      RiverGame(
        id: 'trading',
        title: 'Trading\nMáster',
        emoji: '📈',
        color: const Color(0xFF00BCD4),
        riverPosition: RiverPosition.right,
        screen: const TradingGame(),
        description: 'Aprende a invertir en el mercado',
      ),
      RiverGame(
        id: 'real_estate',
        title: 'Imperio\nInmobiliario',
        emoji: '🏠',
        color: const Color(0xFF795548),
        riverPosition: RiverPosition.left,
        screen: const RealEstateEmpire(),
        description: 'Construye tu imperio inmobiliario',
      ),
      RiverGame(
        id: 'insurance',
        title: 'Guardián\ndel Seguro',
        emoji: '🛡️',
        color: const Color(0xFF607D8B),
        riverPosition: RiverPosition.right,
        screen: const InsuranceGuardian(),
        description: 'Protege tus activos con seguros',
      ),
      RiverGame(
        id: 'retirement',
        title: 'Planificador\nde Jubilación',
        emoji: '🌅',
        color: const Color(0xFFE91E63),
        riverPosition: RiverPosition.left,
        screen: const RetirementPlanner(),
        description: 'Planifica tu futuro financiero',
      ),
      RiverGame(
        id: 'smart_shopper',
        title: 'Comprador\nInteligente',
        emoji: '🛒',
        color: const Color(0xFF8BC34A),
        riverPosition: RiverPosition.right,
        screen: const SmartShopperGame(),
        description: 'Aprende a comprar de manera inteligente',
      ),
    ];
  }
}

// Modelo para los juegos del río
class RiverGame {
  final String id;
  final String title;
  final String emoji;
  final Color color;
  final RiverPosition riverPosition;
  final Widget screen;
  final String description;

  const RiverGame({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.riverPosition,
    required this.screen,
    required this.description,
  });
}

enum RiverPosition { left, right } 