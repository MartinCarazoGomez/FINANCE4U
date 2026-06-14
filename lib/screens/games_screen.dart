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
    const double circleSize = 64;

    // Por ahora el "camino" muestra solo el primer step: Maestro del Presupuesto.
    const Offset firstStep = Offset(0.435546875, 0.252760736196319);
    final RiverGame pathGame =
        games.firstWhere((g) => g.id == 'budget_master');
    final Offset pathPos = Offset(
      riverWidth * firstStep.dx - circleSize / 2,
      riverHeight * firstStep.dy - circleSize / 2,
    );

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
              // Botón de menú (3 rayas) arriba a la izquierda
              Positioned(
                top: 24,
                left: 16,
                child: _buildMenuButton(context, appProvider, games),
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
              // Único nodo del camino: Maestro del Presupuesto
              Positioned(
                left: pathPos.dx,
                top: pathPos.dy,
                child: _buildGameNode(
                  context,
                  pathGame,
                  appProvider,
                  circleSize,
                  appProvider.isGameUnlocked(pathGame.id),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Botón de menú con 3 rayas ─────────────────────────────────────────────
  Widget _buildMenuButton(
    BuildContext context,
    AppProvider appProvider,
    List<RiverGame> games,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showGamesMenu(context, appProvider, games),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.menu, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  // ── Menú desplegable con todos los juegos ─────────────────────────────────
  void _showGamesMenu(
    BuildContext context,
    AppProvider appProvider,
    List<RiverGame> games,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (sheetContext, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1B2330),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Todos los juegos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: games.length,
                      itemBuilder: (gridContext, i) {
                        final game = games[i];
                        final unlocked = appProvider.isGameUnlocked(game.id);
                        return _buildMenuTile(context, game, unlocked);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuTile(BuildContext context, RiverGame game, bool unlocked) {
    return GestureDetector(
      onTap: unlocked
          ? () {
              Navigator.pop(context);
              _launchGame(context, game);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: unlocked
              ? game.color.withOpacity(0.92)
              : Colors.grey.withOpacity(0.32),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unlocked ? Colors.white24 : Colors.white10,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: game.color.withOpacity(0.35),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(game.emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 8),
            Text(
              game.title.replaceAll('\n', ' '),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unlocked ? Colors.white : Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (!unlocked) ...[
              const SizedBox(height: 6),
              const Icon(Icons.lock, size: 14, color: Colors.white60),
            ],
          ],
        ),
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