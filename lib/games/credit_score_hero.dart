import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CreditScoreHero extends StatefulWidget {
  final VoidCallback onCompleted;

  const CreditScoreHero({super.key, required this.onCompleted});

  @override
  State<CreditScoreHero> createState() => _CreditScoreHeroState();
}

class _CreditScoreHeroState extends State<CreditScoreHero>
    with TickerProviderStateMixin {
  // Game state
  int creditScore = 650;
  double balance = 1000.0;
  int month = 1;
  int level = 1;
  int experiencePoints = 0;
  bool gameCompleted = false;
  
  // Credit cards with detailed information
  List<CreditCard> creditCards = [];
  List<String> achievements = [];
  
  // Advanced game mechanics
  Timer? gameTimer;
  List<GameEvent> eventHistory = [];
  int consecutiveGoodDecisions = 0;
  double monthlyIncome = 2200.0; // Salario medio neto español
  double monthlyExpenses = 1600.0; // Gastos típicos españoles
  int perfectPayments = 0;
  int emergenciesHandled = 0;
  double totalDebtsRepaid = 0;
  int creditInquiries = 0;
  Map<String, bool> completedChallenges = {};
  
  // New advanced features
  double emergencyFund = 0;
  int creditScoreStreak = 0;
  double totalInterestSaved = 0;
  Map<String, int> categorySpending = {};
  List<String> financialMilestones = [];
  int currentStreak = 0;
  int longestStreak = 0;
  double netWorth = 0;
  List<Investment> investments = [];
  Map<String, double> monthlyBudget = {
    'housing': 600, // Vivienda típica española
    'food': 350, // Alimentación típica
    'transportation': 200, // Transporte típico
    'entertainment': 150, // Entretenimiento típico
    'savings': 250, // Ahorros típicos
  };
  bool hasBudget = false;
  int budgetViolations = 0;
  double totalCashback = 0;
  
  // Ultra-advanced gamification features
  int playerLevel = 1;
  double experienceToNextLevel = 100;
  List<Quest> activeQuests = [];
  List<Quest> completedQuests = [];
  Map<String, Skill> skills = {};
  List<PowerUp> activePowerUps = [];
  int dailyStreak = 0;
  DateTime lastPlayDate = DateTime.now();
  Map<String, Achievement> unlockedAchievements = {};
  List<Notification> gameNotifications = [];
  int totalDecisionsMade = 0;
  double averageDecisionQuality = 0;
  Map<String, int> decisionHistory = {};
  List<String> tips = [];
  bool hasPersonalFinanceAdvisor = false;
  double stressLevel = 0; // 0-100 based on financial decisions
  List<Challenge> weeklyFinalChallenges = [];
  Map<String, double> marketConditions = {
    'stockMarket': 1.0,
    'realEstate': 1.0,
    'bonds': 1.0,
    'crypto': 1.0,
  };
  bool isEconomicRecession = false;
  
  // Animation controllers
  late AnimationController _scoreAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _eventAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _eventAnimation;

  // Current event
  GameEvent? currentEvent;
  bool waitingForResponse = false;
  Timer? responseTimer;
  int timeLeft = 20; // 20 seconds to respond

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeGame();
    _startGameLoop();
  }

  void _initializeAnimations() {
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _eventAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.elasticOut),
    );
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.bounceOut),
    );
    _eventAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _eventAnimationController, curve: Curves.easeInOut),
    );
  }

  void _initializeGame() {
    // Initialize skills
    skills = {
      'budgeting': Skill(name: 'Presupuesto', level: 1, experience: 0),
      'investing': Skill(name: 'Inversiones', level: 1, experience: 0),
      'creditManagement': Skill(name: 'Gestión de Crédito', level: 1, experience: 0),
      'negotiation': Skill(name: 'Negociación', level: 1, experience: 0),
      'riskAssessment': Skill(name: 'Evaluación de Riesgo', level: 1, experience: 0),
    };

    // Initialize starting quests
    activeQuests = [
      Quest(
        id: 'first_perfect_payment',
        title: 'Primer Pago Perfecto',
        description: 'Realiza tu primer pago completo de tarjeta de crédito',
        reward: 50,
        isCompleted: false,
        category: 'credit',
      ),
      Quest(
        id: 'reach_700_score',
        title: 'Alcanzar Score 700',
        description: 'Mejora tu credit score hasta 700 puntos (CIRBE)',
        reward: 100,
        isCompleted: false,
        category: 'credit',
      ),
    ];

    // Start with one basic credit card
    creditCards.add(CreditCard(
      name: "Tarjeta Santander Básica",
      limit: 1000,
      balance: 200,
      interestRate: 0.18, // TIN 18%
      color: Colors.red,
      type: CardType.basic,
    ));

    // Initialize daily streak tracking
    _checkDailyStreak();
    
    // Generate initial market conditions
    _updateMarketConditions();
    
    // Add welcome notification
    gameNotifications.add(Notification(
      title: '¡Bienvenido al Credit Score Hero!',
      message: 'Comienza tu viaje hacia la libertad financiera',
      type: 'welcome',
      timestamp: DateTime.now(),
    ));
  }

  void _startGameLoop() {
    gameTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!waitingForResponse && !gameCompleted) {
        _processMonthlyEvents();
        _triggerRandomEvent();
      }
    });
  }

  void _processMonthlyEvents() {
    // Monthly income and expenses
    setState(() {
      double netIncome = monthlyIncome - monthlyExpenses;
      balance += netIncome;
      
      // Emergency fund auto-contribution if enabled
      if (emergencyFund < monthlyExpenses * 6 && balance > monthlyExpenses * 1.5) {
        double autoSave = monthlyIncome * 0.1;
        emergencyFund += autoSave;
        balance -= autoSave;
      }
      
      // Apply interest to credit cards and calculate interest costs
      double monthlyInterestCost = 0;
      for (var card in creditCards) {
        if (card.balance > 0) {
          double interest = card.balance * (card.interestRate / 12);
          monthlyInterestCost += interest;
          card.balance *= (1 + card.interestRate / 12);
        }
      }
      
      // Investment returns
      for (var investment in investments) {
        investment.currentValue *= (1 + investment.monthlyReturn);
      }
      
      // Update net worth
      _calculateNetWorth();
      
      // Credit score natural drift based on utilization
      _updateCreditScoreFactors();
      
      // Check for financial milestones
      _checkFinancialMilestones();
      
      // Budget tracking
      if (hasBudget) {
        _trackBudgetPerformance();
      }
    });
  }

  void _updateCreditScoreFactors() {
    int oldScore = creditScore;
    
    if (creditCards.isNotEmpty) {
      double totalUtilization = 0;
      for (var card in creditCards) {
        totalUtilization += card.balance / card.limit;
      }
      totalUtilization /= creditCards.length;
      
      // Utilization impact (30% of score)
      if (totalUtilization < 0.1) {
        creditScore += 3;
      } else if (totalUtilization < 0.3) {
        creditScore += 1;
      } else if (totalUtilization > 0.7) {
        creditScore -= 4;
      } else if (totalUtilization > 0.5) {
        creditScore -= 2;
      }
      
      // Payment history impact (35% of score)
      if (perfectPayments >= 6) {
        creditScore += 2;
      }
      
      // Credit age impact (15% of score)
      if (month > 6) {
        creditScore += 1;
      }
      
      // Credit mix impact (10% of score)
      if (creditCards.length >= 3) {
        creditScore += 1;
      }
      
      // New credit impact (10% of score)
      if (creditInquiries > 5) {
        creditScore -= 2;
      }
      
      creditScore = creditScore.clamp(300, 850);
    }
    
    // Track score improvement streaks
    if (creditScore > oldScore) {
      currentStreak++;
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    } else if (creditScore < oldScore) {
      currentStreak = 0;
    }
  }

  void _calculateNetWorth() {
    netWorth = balance + emergencyFund;
    
    // Add investment values
    for (var investment in investments) {
      netWorth += investment.currentValue;
    }
    
    // Subtract debt
    for (var card in creditCards) {
      netWorth -= card.balance;
    }
  }

  void _checkFinancialMilestones() {
    // Emergency fund milestones
    if (emergencyFund >= monthlyExpenses * 3 && !financialMilestones.contains('Emergency Fund 3 Months')) {
      financialMilestones.add('Emergency Fund 3 Months');
      _addAchievement('Fondo de Emergencia: 3 Meses');
    }
    
    if (emergencyFund >= monthlyExpenses * 6 && !financialMilestones.contains('Emergency Fund 6 Months')) {
      financialMilestones.add('Emergency Fund 6 Months');
      _addAchievement('Fondo de Emergencia: 6 Meses');
    }
    
    // Net worth milestones
    if (netWorth >= 10000 && !financialMilestones.contains('Net Worth 10K')) {
      financialMilestones.add('Net Worth 10K');
      _addAchievement('Patrimonio Neto: €10,000');
    }
    
    if (netWorth >= 50000 && !financialMilestones.contains('Net Worth 50K')) {
      financialMilestones.add('Net Worth 50K');
      _addAchievement('Patrimonio Neto: €50,000');
    }
    
    // Credit score milestones
    if (creditScore >= 800 && !financialMilestones.contains('Credit Score 800')) {
      financialMilestones.add('Credit Score 800');
      _addAchievement('Score Perfecto: 800+ (CIRBE)');
    }
  }

  void _trackBudgetPerformance() {
    // Simplified budget tracking - in real game this would be more sophisticated
    if (monthlyExpenses > monthlyIncome * 0.8) {
      budgetViolations++;
    }
  }

  void _triggerRandomEvent() {
    final events = _getAvailableEvents();
    if (events.isNotEmpty) {
      final event = events[Random().nextInt(events.length)];
      setState(() {
        currentEvent = event;
        waitingForResponse = true;
        timeLeft = 20; // 20 seconds to respond - más tiempo para decisiones complejas
      });
      
      _eventAnimationController.forward();
      _startResponseTimer();
    }
  }

  void _startResponseTimer() {
    responseTimer?.cancel();
    responseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      
      if (timeLeft <= 0) {
        timer.cancel();
        _handleEventTimeout();
      }
    });
  }

  void _handleEventTimeout() {
    if (currentEvent != null) {
      // Auto-select the safest option (usually the first one)
      _handleEventChoice(currentEvent!.choices.first);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏰ ¡Tiempo agotado! Se eligió la opción más segura automáticamente'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  List<GameEvent> _getAvailableEvents() {
    List<GameEvent> events = [];
    
    // Dynamic events based on game state
    if (creditScore < 600) {
      events.addAll(_getBadCreditEvents());
    } else if (creditScore > 750) {
      events.addAll(_getExcellentCreditEvents());
    }
    
    // Standard credit card events
    events.addAll([
      GameEvent(
        id: 'credit_offer',
        title: '💳 Nueva Oferta de Tarjeta',
        description: 'Un banco te ofrece una nueva tarjeta de crédito con límite de \$2,500 y 0% de interés por 12 meses.',
        choices: [
          EventChoice(
            text: 'Aceptar la tarjeta',
            impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'Más crédito disponible mejora tu score'),
            action: () => _addCreditCard(CardType.promotional),
          ),
          EventChoice(
            text: 'Rechazar la oferta',
            impact: EventImpact(scoreChange: 0, balanceChange: 0, explanation: 'No hay cambios en tu perfil crediticio'),
          ),
          EventChoice(
            text: 'Solicitar información adicional',
            impact: EventImpact(scoreChange: 5, balanceChange: 0, explanation: 'Investigar antes de decidir es inteligente'),
          ),
        ],
      ),
      
      GameEvent(
        id: 'payment_reminder',
        title: '📅 Recordatorio de Pago',
        description: 'Tu tarjeta de crédito tiene un saldo de \$${creditCards.isNotEmpty ? creditCards.first.balance.toStringAsFixed(0) : "200"}. ¿Cómo quieres pagar?',
        choices: [
                     EventChoice(
             text: 'Pagar el total (\$${creditCards.isNotEmpty ? creditCards.first.balance.toStringAsFixed(0) : "200"})',
             impact: EventImpact(scoreChange: 25, balanceChange: -(creditCards.isNotEmpty ? creditCards.first.balance.toDouble() : 200.0), explanation: 'Pagar el total mejora mucho tu score'),
             action: () => _payCard(creditCards.isNotEmpty ? creditCards.first : null, PaymentType.full),
           ),
           EventChoice(
             text: 'Pagar el mínimo (\$${creditCards.isNotEmpty ? (creditCards.first.balance * 0.05).toStringAsFixed(0) : "10"})',
             impact: EventImpact(scoreChange: 5, balanceChange: -(creditCards.isNotEmpty ? (creditCards.first.balance * 0.05).toDouble() : 10.0), explanation: 'Pago mínimo mantiene tu historial pero acumula intereses'),
             action: () => _payCard(creditCards.isNotEmpty ? creditCards.first : null, PaymentType.minimum),
           ),
          EventChoice(
            text: 'No pagar este mes',
            impact: EventImpact(scoreChange: -50, balanceChange: 0, explanation: '¡Pagos atrasados dañan severamente tu score!'),
            action: () => _missPayment(),
          ),
        ],
      ),

      GameEvent(
        id: 'emergency_expense',
        title: '🚨 Gasto de Emergencia',
        description: 'Tu auto se averió y necesitas \$800 para repararlo. ¿Cómo vas a pagarlo?',
        choices: [
          EventChoice(
            text: 'Usar tarjeta de crédito',
            impact: EventImpact(scoreChange: -10, balanceChange: -800, explanation: 'Aumentar el saldo puede afectar tu utilización'),
            action: () => _useCredit(800),
          ),
          EventChoice(
            text: 'Usar ahorros de emergencia',
            impact: EventImpact(scoreChange: 10, balanceChange: -800, explanation: 'Usar ahorros demuestra buena planificación'),
          ),
          EventChoice(
            text: 'Pedir préstamo a familia',
            impact: EventImpact(scoreChange: 0, balanceChange: 0, explanation: 'No afecta tu historial crediticio'),
          ),
        ],
      ),

      GameEvent(
        id: 'salary_increase',
        title: '📈 Aumento de Salario',
        description: '¡Felicidades! Te aumentaron el salario. Tu ingreso mensual ahora es \$${(monthlyIncome * 1.2).toStringAsFixed(0)}.',
        choices: [
          EventChoice(
            text: 'Aumentar gastos proporcionalmente',
            impact: EventImpact(scoreChange: 0, balanceChange: 200, explanation: 'Más ingresos pero también más gastos'),
            action: () => {monthlyIncome *= 1.2, monthlyExpenses *= 1.15},
          ),
          EventChoice(
            text: 'Mantener gastos y ahorrar más',
            impact: EventImpact(scoreChange: 15, balanceChange: 500, explanation: 'Mejor capacidad de pago mejora tu perfil'),
            action: () => {monthlyIncome *= 1.2},
          ),
          EventChoice(
            text: 'Pagar deudas con el extra',
            impact: EventImpact(scoreChange: 30, balanceChange: 0, explanation: 'Reducir deudas es excelente para tu score'),
            action: () => {monthlyIncome *= 1.2, _payAllCards()},
          ),
        ],
      ),

      GameEvent(
        id: 'investment_opportunity',
        title: '💰 Oportunidad de Inversión',
        description: 'Un amigo te ofrece invertir \$1,000 en su negocio con promesa de 50% de retorno en 6 meses.',
        choices: [
          EventChoice(
            text: 'Invertir con tarjeta de crédito',
            impact: EventImpact(scoreChange: -25, balanceChange: -1000, explanation: 'Usar crédito para inversiones es muy riesgoso'),
          ),
          EventChoice(
            text: 'Invertir solo si tienes ahorros',
            impact: EventImpact(scoreChange: 5, balanceChange: balance > 1000 ? -1000 : 0, explanation: 'Invertir con dinero propio es más seguro'),
          ),
          EventChoice(
            text: 'No invertir y mantener estabilidad',
            impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'La estabilidad financiera es valiosa'),
          ),
        ],
      ),

      GameEvent(
        id: 'credit_limit_increase',
        title: '📊 Aumento de Límite',
        description: 'Tu banco te ofrece aumentar el límite de tu tarjeta de \$${creditCards.isNotEmpty ? creditCards.first.limit.toStringAsFixed(0) : "1000"} a \$${creditCards.isNotEmpty ? (creditCards.first.limit * 1.5).toStringAsFixed(0) : "1500"}.',
        choices: [
          EventChoice(
            text: 'Aceptar el aumento',
            impact: EventImpact(scoreChange: 20, balanceChange: 0, explanation: 'Más crédito disponible mejora tu ratio de utilización'),
            action: () => _increaseCreditLimit(),
          ),
          EventChoice(
            text: 'Mantener límite actual',
            impact: EventImpact(scoreChange: 0, balanceChange: 0, explanation: 'No hay cambios en tu perfil'),
          ),
                 ],
       ),
       
       GameEvent(
         id: 'financial_education',
         title: '📚 Curso de Finanzas Personales',
         description: 'Te ofrecen un curso online de finanzas personales por \$299. Promete enseñarte estrategias avanzadas de manejo de crédito.',
         choices: [
           EventChoice(
             text: 'Inscribirme inmediatamente - la educación es clave',
             impact: EventImpact(scoreChange: 20, balanceChange: balance > 299 ? -299 : 0, explanation: 'La educación financiera es una inversión excelente'),
             action: () => _addAchievement('Estudiante Financiero'),
           ),
           EventChoice(
             text: 'Investigar primero si hay alternativas gratuitas',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'Ser prudente con el dinero es inteligente'),
           ),
           EventChoice(
             text: 'Declinar - prefiero aprender por experiencia',
             impact: EventImpact(scoreChange: -5, balanceChange: 0, explanation: 'Rechazar educación puede costar caro a largo plazo'),
           ),
         ],
       ),

       GameEvent(
         id: 'store_credit_card',
         title: '🛍️ Tarjeta de Tienda Departamental',
         description: 'En el centro comercial te ofrecen una tarjeta de la tienda con 20% de descuento en tu compra de hoy (\$150). La tarjeta tiene 26% de interés anual.',
         choices: [
           EventChoice(
             text: 'Aceptar - el descuento vale la pena',
             impact: EventImpact(scoreChange: -15, balanceChange: -120, explanation: 'Las tarjetas de tienda suelen tener tasas muy altas'),
             action: () => _addStoreCard(),
           ),
           EventChoice(
             text: 'Pagar con efectivo sin la tarjeta',
             impact: EventImpact(scoreChange: 5, balanceChange: -150, explanation: 'Evitar deudas innecesarias es sabio'),
           ),
           EventChoice(
             text: 'No hacer la compra por ahora',
             impact: EventImpact(scoreChange: 8, balanceChange: 0, explanation: 'A veces es mejor esperar y ahorrar'),
           ),
         ],
       ),

       GameEvent(
         id: 'balance_transfer',
         title: '💳 Oferta de Transferencia de Saldo',
         description: 'Te llega una oferta para transferir tus deudas de otras tarjetas a una nueva con 0% de interés por 18 meses. Cuota de transferencia: 3%.',
         choices: [
           EventChoice(
             text: 'Transferir todas mis deudas inmediatamente',
             impact: EventImpact(scoreChange: 25, balanceChange: -(totalDebtsOnCards() * 0.03), explanation: 'Las transferencias pueden ahorrar mucho en intereses'),
             action: () => _performBalanceTransfer(),
           ),
           EventChoice(
             text: 'Solo transferir las deudas con mayor interés',
             impact: EventImpact(scoreChange: 15, balanceChange: -(totalDebtsOnCards() * 0.015), explanation: 'Ser selectivo con transferencias es inteligente'),
           ),
           EventChoice(
             text: 'Mantener mis deudas donde están',
             impact: EventImpact(scoreChange: -10, balanceChange: 0, explanation: 'Perder oportunidades de ahorro puede ser costoso'),
           ),
         ],
       ),

       GameEvent(
         id: 'credit_utilization_warning',
         title: '⚠️ Alerta de Utilización Alta',
         description: 'Has notado que tu utilización de crédito está llegando al 85%. Tu próximo reporte se genera en una semana.',
         choices: [
           EventChoice(
             text: 'Hacer un pago grande antes del reporte',
             impact: EventImpact(scoreChange: 30, balanceChange: -(balance * 0.3), explanation: 'Reducir utilización antes del reporte es muy efectivo'),
           ),
           EventChoice(
             text: 'Hacer solo el pago mínimo este mes',
             impact: EventImpact(scoreChange: -20, balanceChange: -(creditCards.isNotEmpty ? (creditCards.first.balance * 0.05).toDouble() : 50.0), explanation: 'Alta utilización daña mucho tu score'),
           ),
           EventChoice(
             text: 'Solicitar aumento de límite de crédito',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'Más límite disponible mejora la utilización'),
             action: () => _requestCreditIncrease(),
           ),
         ],
       ),

       GameEvent(
         id: 'budget_creation',
         title: '📊 Crear Presupuesto Personal',
         description: 'Un asesor financiero te ofrece ayuda para crear un presupuesto detallado. Cuesta \$200 pero puede ahorrarte miles.',
         choices: [
           EventChoice(
             text: 'Contratar al asesor y crear presupuesto completo',
             impact: EventImpact(scoreChange: 25, balanceChange: -200, explanation: 'Un presupuesto bien hecho es la base de la salud financiera'),
             action: () => _createBudget(),
           ),
           EventChoice(
             text: 'Crear mi propio presupuesto básico',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'La autodisciplina financiera es valiosa'),
             action: () => _createBasicBudget(),
           ),
           EventChoice(
             text: 'Seguir sin presupuesto formal',
             impact: EventImpact(scoreChange: -10, balanceChange: 0, explanation: 'Sin presupuesto es difícil controlar gastos'),
           ),
         ],
       ),

       GameEvent(
         id: 'emergency_fund_challenge',
         title: '🛡️ Desafío Fondo de Emergencia',
         description: 'Te propones ahorrar \$1,000 en 3 meses para emergencias. ¿Cómo lo lograrás?',
         choices: [
           EventChoice(
             text: 'Reducir gastos en entretenimiento y comida',
             impact: EventImpact(scoreChange: 20, balanceChange: 0, explanation: 'La disciplina en gastos es clave para ahorrar'),
             action: () => _startEmergencyFundChallenge(1000, 'strict'),
           ),
           EventChoice(
             text: 'Buscar ingresos extra con trabajos de fin de semana',
             impact: EventImpact(scoreChange: 25, balanceChange: 300, explanation: 'Generar ingresos extra es excelente estrategia'),
             action: () => _startEmergencyFundChallenge(1000, 'income'),
           ),
           EventChoice(
             text: 'Hacerlo gradualmente sin presión',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'Ir despacio es mejor que no empezar'),
             action: () => _startEmergencyFundChallenge(500, 'gradual'),
           ),
         ],
       ),

       GameEvent(
         id: 'investment_education',
         title: '📈 Curso de Inversiones',
         description: 'Te ofrecen un curso completo de inversiones por \$500. Incluye acceso a plataforma de trading y mentorías.',
         choices: [
           EventChoice(
             text: 'Tomar el curso completo - la educación es inversión',
             impact: EventImpact(scoreChange: 30, balanceChange: -500, explanation: 'Educación financiera avanzada abre muchas puertas'),
             action: () => _unlockInvestments(),
           ),
           EventChoice(
             text: 'Buscar recursos gratuitos primero',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'Empezar con recursos gratuitos es prudente'),
             action: () => _unlockBasicInvestments(),
           ),
           EventChoice(
             text: 'Enfocarme solo en pagar deudas por ahora',
             impact: EventImpact(scoreChange: 20, balanceChange: 0, explanation: 'Pagar deudas antes de invertir es una estrategia sólida'),
           ),
         ],
       ),

       GameEvent(
         id: 'cashback_optimization',
         title: '💰 Optimización de Cashback',
         description: 'Descubres que puedes optimizar tus tarjetas para máximo cashback. Requiere planificación pero puede generar \$500+ anuales.',
         choices: [
           EventChoice(
             text: 'Investigar y optimizar todas mis tarjetas',
             impact: EventImpact(scoreChange: 15, balanceChange: 50, explanation: 'Optimizar cashback es dinero gratis'),
             action: () => _optimizeCashback(),
           ),
           EventChoice(
             text: 'Solo optimizar mi tarjeta principal',
             impact: EventImpact(scoreChange: 10, balanceChange: 20, explanation: 'Un enfoque simple pero efectivo'),
           ),
           EventChoice(
             text: 'No complicarme - usar tarjetas normalmente',
             impact: EventImpact(scoreChange: 0, balanceChange: 0, explanation: 'Simplicidad tiene su valor, pero pierdes beneficios'),
           ),
         ],
       ),

       GameEvent(
         id: 'ai_financial_advisor',
         title: '🤖 Asesor Financiero IA',
         description: 'Una IA analiza tus finanzas y te ofrece consejos personalizados por \$99/mes. Promete optimizar tu situación financiera.',
         choices: [
           EventChoice(
             text: 'Contratar asesor IA - la tecnología es el futuro',
             impact: EventImpact(scoreChange: 40, balanceChange: -99, explanation: 'La IA puede optimizar tus finanzas 24/7'),
             action: () => _enableAIAdvisor(),
           ),
           EventChoice(
             text: 'Probar versión gratuita por 30 días',
             impact: EventImpact(scoreChange: 20, balanceChange: 0, explanation: 'Probar antes de comprar es inteligente'),
             action: () => _enableBasicAI(),
           ),
           EventChoice(
             text: 'Confiar en mi propio conocimiento',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'La autoconfianza tiene valor'),
           ),
         ],
       ),

       GameEvent(
         id: 'market_crash_opportunity',
         title: '📉 Crisis de Mercado',
         description: 'Los mercados caen 30%. Tu asesor sugiere: "Crisis = Oportunidad". ¿Cómo reaccionas?',
         choices: [
           EventChoice(
             text: 'Invertir agresivamente - comprar en la caída',
             impact: EventImpact(scoreChange: 30, balanceChange: -(balance * 0.5), explanation: 'Comprar en crisis puede ser muy rentable a largo plazo'),
             action: () => _investDuringCrash(),
           ),
           EventChoice(
             text: 'Mantener posiciones actuales sin cambios',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'Mantener la calma en crisis es sabiduría'),
           ),
           EventChoice(
             text: 'Vender todo y ir a efectivo',
             impact: EventImpact(scoreChange: -20, balanceChange: 0, explanation: 'Vender en pánico puede costarte caro'),
             action: () => _panicSell(),
           ),
         ],
       ),

       GameEvent(
         id: 'cryptocurrency_fomo',
         title: '₿ FOMO Criptomonedas',
         description: 'Bitcoin subió 200% este mes. Todos hablan de criptos. Tu amigo ganó \$10,000. ¿Entras al mercado crypto?',
         choices: [
           EventChoice(
             text: 'Invertir 20% de mi portfolio en crypto',
             impact: EventImpact(scoreChange: 25, balanceChange: -(netWorth * 0.2), explanation: 'Diversificar en crypto puede ser parte de un portfolio moderno'),
             action: () => _investInCrypto(0.2),
           ),
           EventChoice(
             text: 'Solo invertir dinero que puedo permitirme perder',
             impact: EventImpact(scoreChange: 20, balanceChange: -500, explanation: 'Invertir responsablemente en crypto es prudente'),
             action: () => _investInCrypto(0.05),
           ),
           EventChoice(
             text: 'No entrar - es una burbuja especulativa',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'Evitar FOMO muestra disciplina financiera'),
           ),
         ],
       ),

       GameEvent(
         id: 'side_hustle_opportunity',
         title: '💼 Oportunidad de Negocio Paralelo',
         description: 'Descubres una oportunidad de negocio online que puede generar \$1,000+ mensuales, pero requiere \$2,000 iniciales y 20 horas semanales.',
         choices: [
           EventChoice(
             text: 'Invertir tiempo y dinero - crear múltiples fuentes de ingreso',
             impact: EventImpact(scoreChange: 35, balanceChange: -2000, explanation: 'Múltiples fuentes de ingreso dan seguridad financiera'),
             action: () => _startSideHustle(),
           ),
           EventChoice(
             text: 'Empezar pequeño con \$500 para probar el concepto',
             impact: EventImpact(scoreChange: 20, balanceChange: -500, explanation: 'Validar antes de invertir fuerte es inteligente'),
             action: () => _testSideHustle(),
           ),
           EventChoice(
             text: 'Concentrarme en mi trabajo principal',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'Enfocar energía puede ser más efectivo'),
           ),
         ],
       ),

       GameEvent(
         id: 'real_estate_investment',
         title: '🏠 Inversión Inmobiliaria',
         description: 'Te ofrecen participar en un REIT (fondo inmobiliario) que promete 8% anual. Mínimo \$5,000.',
         choices: [
           EventChoice(
             text: 'Invertir el mínimo - diversificar en bienes raíces',
             impact: EventImpact(scoreChange: 30, balanceChange: -5000, explanation: 'REITs ofrecen exposición inmobiliaria sin comprar propiedades'),
             action: () => _investInREIT(),
           ),
           EventChoice(
             text: 'Investigar más antes de decidir',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'La diligencia debida siempre es importante'),
           ),
           EventChoice(
             text: 'Prefiero inversiones más líquidas',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'La liquidez tiene valor en un portfolio'),
           ),
         ],
       ),
     ]);

     return events;
  }

  List<GameEvent> _getBadCreditEvents() {
    return [
      GameEvent(
        id: 'credit_repair',
        title: '🔧 Reparación de Crédito',
        description: 'Una empresa promete "reparar" tu crédito eliminando reportes negativos por \$500.',
        choices: [
          EventChoice(
            text: 'Contratar la empresa',
            impact: EventImpact(scoreChange: -20, balanceChange: -500, explanation: '¡Cuidado! Muchas empresas de reparación son estafas'),
          ),
          EventChoice(
            text: 'Reparar mi crédito yo mismo',
            impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'Puedes disputar errores tú mismo gratuitamente'),
          ),
          EventChoice(
            text: 'Mejorar naturalmente con tiempo',
            impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'La paciencia y buenos hábitos son la mejor estrategia'),
          ),
        ],
      ),
      
             GameEvent(
         id: 'secured_card',
         title: '💳 Tarjeta Asegurada',
         description: 'Te ofrecen una tarjeta de crédito asegurada con depósito de \$200 para reconstruir tu crédito. Requiere verificación de ingresos.',
         choices: [
           EventChoice(
             text: 'Depositar \$200 y obtener la tarjeta',
             impact: EventImpact(scoreChange: 25, balanceChange: -200, explanation: 'Las tarjetas aseguradas son excelentes para reconstruir crédito'),
             action: () => _addCreditCard(CardType.secured),
           ),
           EventChoice(
             text: 'Preguntar si puedo depositar menos dinero',
             impact: EventImpact(scoreChange: 5, balanceChange: -100, explanation: 'Negociar puede funcionar pero con menor límite'),
           ),
           EventChoice(
             text: 'Buscar otras opciones primero',
             impact: EventImpact(scoreChange: -8, balanceChange: 0, explanation: 'Con mal crédito, las opciones son limitadas'),
           ),
         ],
       ),

       GameEvent(
         id: 'payday_loan_temptation',
         title: '💸 Préstamo de Día de Pago',
         description: 'Necesitas \$300 urgentemente. Una casa de préstamos te ofrece \$300 hoy, devuelves \$350 en 2 semanas.',
         choices: [
           EventChoice(
             text: 'Tomar el préstamo - necesito el dinero ya',
             impact: EventImpact(scoreChange: -25, balanceChange: 250, explanation: 'Los préstamos de día de pago crean ciclos de deuda'),
           ),
           EventChoice(
             text: 'Pedir prestado a familia/amigos',
             impact: EventImpact(scoreChange: 5, balanceChange: 300, explanation: 'Evitar prestamistas predatorios es sabio'),
           ),
           EventChoice(
             text: 'Buscar trabajos temporales para ganar el dinero',
             impact: EventImpact(scoreChange: 15, balanceChange: 200, explanation: 'Generar ingresos extra es la mejor opción'),
           ),
         ],
       ),

       GameEvent(
         id: 'debt_consolidation',
         title: '🔄 Consolidación de Deudas',
         description: 'Una financiera te ofrece un préstamo personal al 12% para pagar todas tus tarjetas de crédito que tienen 18-24% de interés.',
         choices: [
           EventChoice(
             text: 'Consolidar todas mis deudas inmediatamente',
             impact: EventImpact(scoreChange: 20, balanceChange: -(totalDebtsOnCards() * 0.05), explanation: 'La consolidación puede reducir pagos e intereses'),
             action: () => _consolidateDebt(),
           ),
           EventChoice(
             text: 'Solo consolidar las deudas más altas',
             impact: EventImpact(scoreChange: 10, balanceChange: -(totalDebtsOnCards() * 0.03), explanation: 'Ser selectivo puede ser más seguro'),
           ),
           EventChoice(
             text: 'Mantener mis deudas separadas',
             impact: EventImpact(scoreChange: -5, balanceChange: 0, explanation: 'Perder oportunidades de ahorro en intereses'),
           ),
         ],
       ),
    ];
  }

  List<GameEvent> _getExcellentCreditEvents() {
    return [
      GameEvent(
        id: 'premium_rewards',
        title: '💎 Tarjeta Premium Rewards',
        description: 'Te pre-aprueban para una tarjeta premium con 2% cashback, límite de \$10,000 y cuota anual de \$99.',
        choices: [
          EventChoice(
            text: 'Aceptar la tarjeta premium',
            impact: EventImpact(scoreChange: 30, balanceChange: -99, explanation: 'Las tarjetas premium pueden ofrecer excelentes beneficios'),
            action: () => _addCreditCard(CardType.premium),
          ),
          EventChoice(
            text: 'Negociar eliminar la cuota anual',
            impact: EventImpact(scoreChange: 20, balanceChange: 0, explanation: 'Negociar es una habilidad financiera valiosa'),
          ),
          EventChoice(
            text: 'Mantener mis tarjetas actuales',
            impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'A veces es mejor mantener la simplicidad'),
          ),
        ],
      ),
      
             GameEvent(
         id: 'mortgage_preapproval',
         title: '🏠 Pre-aprobación Hipotecaria',
         description: 'Tres bancos compiten por tu negocio ofreciendo hipotecas. Las tasas van del 3.2% al 3.8%. El proceso requiere documentación extensiva.',
         choices: [
           EventChoice(
             text: 'Aceptar la mejor tasa y comenzar proceso',
             impact: EventImpact(scoreChange: 25, balanceChange: -500, explanation: 'Tu excelente crédito te da acceso a las mejores tasas'),
             action: () => _addAchievement('Listo para Casa Propia'),
           ),
           EventChoice(
             text: 'Negociar mejores términos con mi banco actual',
             impact: EventImpact(scoreChange: 20, balanceChange: 0, explanation: 'La lealtad bancaria puede tener beneficios'),
           ),
           EventChoice(
             text: 'Esperar - el mercado inmobiliario puede bajar',
             impact: EventImpact(scoreChange: 5, balanceChange: 500, explanation: 'A veces esperar puede ser inteligente'),
           ),
         ],
       ),

       GameEvent(
         id: 'business_credit_line',
         title: '💼 Línea de Crédito Comercial',
         description: 'Te aprueban una línea de crédito comercial de \$50,000 al 6% para iniciar tu propio negocio. Requiere garantía personal.',
         choices: [
           EventChoice(
             text: 'Aceptar y lanzar mi negocio inmediatamente',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'El crédito comercial puede ser una gran oportunidad'),
             action: () => _addAchievement('Emprendedor Financiado'),
           ),
           EventChoice(
             text: 'Tomar solo una parte de la línea de crédito',
             impact: EventImpact(scoreChange: 10, balanceChange: 0, explanation: 'Ser conservador puede reducir riesgos'),
           ),
           EventChoice(
             text: 'Declinar - prefiero ahorrar primero',
             impact: EventImpact(scoreChange: 8, balanceChange: 1000, explanation: 'Autofinanciarse elimina riesgos pero puede ser más lento'),
           ),
         ],
       ),

       GameEvent(
         id: 'investment_opportunity_premium',
         title: '📈 Oportunidad de Inversión Premium',
         description: 'Tu banco privado te invita a invertir en un fondo exclusivo con rendimiento histórico del 12% anual. Mínimo \$10,000.',
         choices: [
           EventChoice(
             text: 'Invertir el mínimo requerido',
             impact: EventImpact(scoreChange: 20, balanceChange: balance > 10000 ? -10000 : 0, explanation: 'Acceso a inversiones premium es un privilegio del buen crédito'),
           ),
           EventChoice(
             text: 'Pedir más información sobre riesgos',
             impact: EventImpact(scoreChange: 15, balanceChange: 0, explanation: 'La diligencia debida es siempre inteligente'),
           ),
           EventChoice(
             text: 'Mantener mis inversiones actuales',
             impact: EventImpact(scoreChange: 5, balanceChange: 0, explanation: 'La diversificación es importante'),
           ),
         ],
       ),
    ];
  }

  void _handleEventChoice(EventChoice choice) {
    responseTimer?.cancel();
    
    // Process decision with advanced tracking
    _processDecision(choice);
    
    setState(() {
      creditScore = (creditScore + choice.impact.scoreChange).clamp(300, 850);
      balance += choice.impact.balanceChange;
      waitingForResponse = false;
      currentEvent = null;
      
      // Update streak tracking
      if (choice.impact.scoreChange > 0) {
        consecutiveGoodDecisions++;
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        consecutiveGoodDecisions = 0;
        currentStreak = 0;
      }
      
      // Enhanced XP calculation
      int baseXP = choice.impact.scoreChange.abs();
      int bonusXP = 0;
      
      // Bonus XP for good decisions
      if (choice.impact.scoreChange > 20) bonusXP += 15;
      else if (choice.impact.scoreChange > 10) bonusXP += 8;
      
      // Streak bonus
      if (currentStreak >= 3) bonusXP += 5;
      if (currentStreak >= 5) bonusXP += 10;
      
      experiencePoints += baseXP + bonusXP;
      
      // Update net worth calculation
      _calculateNetWorth();
      
      // Market volatility simulation
      if (investments.isNotEmpty && Random().nextDouble() < 0.3) {
        _updateMarketConditions();
        _applyMarketChanges();
      }
    });

    // Execute special action if any
    choice.action?.call();

    _scoreAnimationController.forward().then((_) {
      _scoreAnimationController.reset();
    });

    _eventAnimationController.reverse();

    // Show enhanced feedback
    _showEnhancedFeedback(choice);

    // Check for level completion
    _checkLevelCompletion();

    // Advance month
    month++;
    if (month > 12) {
      month = 1;
      level++;
    }
  }

  void _showEnhancedFeedback(EventChoice choice) {
    String emoji = choice.impact.scoreChange > 0 ? '✅' : choice.impact.scoreChange < 0 ? '❌' : 'ℹ️';
    Color color = choice.impact.scoreChange > 0 ? Colors.green : choice.impact.scoreChange < 0 ? Colors.red : Colors.blue;
    
    List<Widget> feedbackWidgets = [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 8),
      Expanded(child: Text(choice.impact.explanation)),
    ];
    
    // Add score change
    if (choice.impact.scoreChange != 0) {
      feedbackWidgets.add(
        Text(
          '${choice.impact.scoreChange > 0 ? '+' : ''}${choice.impact.scoreChange}',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      );
    }
    
    // Add streak indicator
    if (currentStreak >= 3) {
      feedbackWidgets.add(const SizedBox(width: 8));
      feedbackWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '🔥$currentStreak',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: feedbackWidgets),
        backgroundColor: color.withOpacity(0.8),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _applyMarketChanges() {
    setState(() {
      for (var investment in investments) {
        double marketMultiplier = 1.0;
        
        // Apply market conditions based on investment type
        if (investment.name.contains('Acciones') || investment.name.contains('S&P')) {
          marketMultiplier = marketConditions['stockMarket']!;
        } else if (investment.name.contains('REIT') || investment.name.contains('Inmobiliario')) {
          marketMultiplier = marketConditions['realEstate']!;
        } else if (investment.name.contains('Crypto') || investment.name.contains('Bitcoin')) {
          marketMultiplier = marketConditions['crypto']!;
        }
        
        // Apply market change
        double changePercent = (marketMultiplier - 1.0) * 0.1; // Dampen volatility
        investment.currentValue *= (1.0 + changePercent);
        
        // Ensure investments can't go below 10% of initial value
        investment.currentValue = investment.currentValue.clamp(
          investment.initialValue * 0.1, 
          investment.initialValue * 3.0
        );
      }
    });
  }

  void _checkLevelCompletion() {
    if (creditScore >= 750 && level >= 3 && !gameCompleted) {
      setState(() {
        gameCompleted = true;
      });
      
      gameTimer?.cancel();
      responseTimer?.cancel();
      
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Row(
          children: [
                         Icon(Icons.emoji_events, color: const Color(0xFFFFD700), size: 30),
            SizedBox(width: 10),
            Text('¡CREDIT HERO!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎉 ¡Felicidades! Has alcanzado un score de $creditScore',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                children: [
                  Text('Score Final: $creditScore', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Experiencia: $experiencePoints XP', style: const TextStyle(color: Colors.white)),
                  Text('Decisiones consecutivas correctas: $consecutiveGoodDecisions', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onCompleted();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('¡Continuar!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Helper methods for game actions
  void _addCreditCard(CardType type) {
    setState(() {
      switch (type) {
                 case CardType.secured:
           creditCards.add(CreditCard(
             name: "Tarjeta Asegurada",
             limit: 200,
             balance: 0,
             interestRate: 0.22,
             color: Colors.teal,
             type: type,
           ));
           break;
         case CardType.promotional:
          creditCards.add(CreditCard(
            name: "Tarjeta Promocional",
            limit: 2500,
            balance: 0,
            interestRate: 0.0,
            color: Colors.purple,
            type: type,
          ));
          break;
        case CardType.premium:
          creditCards.add(CreditCard(
            name: "Tarjeta Premium",
            limit: 5000,
            balance: 0,
            interestRate: 0.15,
                         color: const Color(0xFFFFD700), // Gold color
            type: type,
          ));
          break;
        default:
          break;
      }
    });
    _cardAnimationController.forward().then((_) {
      _cardAnimationController.reset();
    });
  }

  void _payCard(CreditCard? card, PaymentType type) {
    if (card == null) return;
    
    setState(() {
      switch (type) {
        case PaymentType.full:
          totalDebtsRepaid += card.balance;
          balance -= card.balance;
          card.balance = 0;
          perfectPayments++;
          _checkPaymentAchievements();
          break;
        case PaymentType.minimum:
          double minPayment = card.balance * 0.05;
          balance -= minPayment;
          card.balance -= minPayment;
          totalDebtsRepaid += minPayment;
          break;
      }
    });
  }

  void _checkPaymentAchievements() {
    if (perfectPayments >= 5 && !achievements.contains('Pagador Perfecto')) {
      _addAchievement('Pagador Perfecto');
    }
    if (totalDebtsRepaid >= 5000 && !achievements.contains('Destructor de Deudas')) {
      _addAchievement('Destructor de Deudas');
    }
  }

  void _addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      setState(() {
        achievements.add(achievement);
        experiencePoints += 50;
      });
      _showAchievementDialog(achievement);
    }
  }

  void _showAchievementDialog(String achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 24),
            SizedBox(width: 8),
            Text('¡Logro Desbloqueado!', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: Text(
          '🎉 $achievement',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)),
            child: const Text('¡Genial!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _payAllCards() {
    setState(() {
      for (var card in creditCards) {
        balance -= card.balance;
        card.balance = 0;
      }
    });
  }

  void _useCredit(double amount) {
    if (creditCards.isNotEmpty) {
      setState(() {
        creditCards.first.balance += amount;
      });
    }
  }

  void _missPayment() {
    // Already handled in the impact
  }

  void _increaseCreditLimit() {
    if (creditCards.isNotEmpty) {
      setState(() {
        creditCards.first.limit *= 1.5;
      });
    }
  }

  void _addStoreCard() {
    setState(() {
      creditCards.add(CreditCard(
        name: "Tarjeta de Tienda",
        limit: 500,
        balance: 120, // Ya se usó con el descuento
        interestRate: 0.26,
        color: Colors.deepPurple,
        type: CardType.basic,
      ));
      creditInquiries++;
    });
  }

  double totalDebtsOnCards() {
    double total = 0;
    for (var card in creditCards) {
      total += card.balance;
    }
    return total;
  }

  void _performBalanceTransfer() {
    if (creditCards.isNotEmpty) {
      setState(() {
        // Crear nueva tarjeta de transferencia
        creditCards.add(CreditCard(
          name: "Tarjeta de Transferencia",
          limit: totalDebtsOnCards() + 1000,
          balance: totalDebtsOnCards(),
          interestRate: 0.0, // 0% promotional
          color: Colors.cyan,
          type: CardType.promotional,
        ));
        
        // Limpiar saldos de otras tarjetas
        for (var card in creditCards) {
          if (card.name != "Tarjeta de Transferencia") {
            card.balance = 0;
          }
        }
        
        creditInquiries++;
      });
    }
  }

  void _requestCreditIncrease() {
    if (creditCards.isNotEmpty) {
      setState(() {
        creditCards.first.limit *= 1.3;
        creditInquiries++;
      });
      
      if (creditInquiries <= 2) {
        creditScore += 15;
      } else {
        creditScore -= 5; // Demasiadas consultas
      }
    }
  }

  void _consolidateDebt() {
    setState(() {
      double totalDebt = totalDebtsOnCards();
      
      // Limpiar saldos de tarjetas existentes
      for (var card in creditCards) {
        card.balance = 0;
      }
      
      // El préstamo de consolidación reduce el balance total
      balance -= totalDebt * 0.05; // Fee de consolidación
      totalDebtsRepaid += totalDebt;
      
      // Agregar logro si es significativo
      if (totalDebt > 2000) {
        _addAchievement('Maestro de Consolidación');
      }
    });
  }

  void _createBudget() {
    setState(() {
      hasBudget = true;
      monthlyExpenses *= 0.85; // Reduce gastos con presupuesto
      _addAchievement('Maestro del Presupuesto');
    });
  }

  void _createBasicBudget() {
    setState(() {
      hasBudget = true;
      monthlyExpenses *= 0.92; // Reducción menor
    });
  }

  void _startEmergencyFundChallenge(double target, String method) {
    setState(() {
      switch (method) {
        case 'strict':
          monthlyExpenses *= 0.8; // Reduce gastos significativamente
          break;
        case 'income':
          monthlyIncome *= 1.15; // Aumenta ingresos
          break;
        case 'gradual':
          // Método gradual, cambios menores
          break;
      }
      _addAchievement('Desafío Fondo de Emergencia');
    });
  }

  void _unlockInvestments() {
    setState(() {
      investments.add(Investment(
        name: 'Fondo de Índice S&P 500',
        initialValue: 1000,
        currentValue: 1000,
        monthlyReturn: 0.008, // ~10% anual
        riskLevel: 'Moderado',
      ));
      balance -= 1000;
      _addAchievement('Primer Inversionista');
    });
  }

  void _unlockBasicInvestments() {
    setState(() {
      investments.add(Investment(
        name: 'Cuenta de Ahorro de Alto Rendimiento',
        initialValue: 500,
        currentValue: 500,
        monthlyReturn: 0.004, // ~5% anual
        riskLevel: 'Bajo',
      ));
      balance -= 500;
    });
  }

  void _optimizeCashback() {
    setState(() {
      totalCashback += 50;
      balance += 50;
      monthlyIncome += 25; // Cashback mensual adicional
      _addAchievement('Maestro del Cashback');
    });
  }

  void _implementAdvancedUtilization() {
    setState(() {
      // Mejora significativa del score con estrategia avanzada
      creditScore += 15;
      _addAchievement('Estratega de Crédito');
    });
  }

  void _enableAIAdvisor() {
    setState(() {
      hasPersonalFinanceAdvisor = true;
      monthlyExpenses += 99; // Monthly cost
      // AI gives continuous small optimizations
      monthlyIncome += 150; // AI optimization saves money
      _addAchievement('Asesor IA Contratado');
      _levelUpSkill('creditManagement', 30);
    });
  }

  void _enableBasicAI() {
    setState(() {
      // Temporary AI trial
      _addAchievement('Probando IA');
      _levelUpSkill('creditManagement', 15);
    });
  }

  void _investDuringCrash() {
    setState(() {
      investments.add(Investment(
        name: 'Acciones de Crisis',
        initialValue: balance * 0.5,
        currentValue: balance * 0.35, // Initially down 30%
        monthlyReturn: 0.015, // Higher potential return
        riskLevel: 'Alto',
      ));
      _addAchievement('Inversionista Contrarian');
      _levelUpSkill('riskAssessment', 50);
      stressLevel += 20; // Investing during crisis is stressful
    });
  }

  void _panicSell() {
    setState(() {
      // Sell all investments at loss
      for (var investment in investments) {
        balance += investment.currentValue * 0.7; // 30% loss from panic selling
      }
      investments.clear();
      stressLevel += 30;
      _addAchievement('Vendedor de Pánico');
    });
  }

  void _investInCrypto(double percentage) {
    setState(() {
      double cryptoAmount = netWorth * percentage;
      investments.add(Investment(
        name: 'Portfolio Crypto',
        initialValue: cryptoAmount,
        currentValue: cryptoAmount,
        monthlyReturn: 0.05, // Very volatile - can be +/- 20%
        riskLevel: 'Extremo',
      ));
      balance -= cryptoAmount;
      _addAchievement('Crypto Investor');
      _levelUpSkill('riskAssessment', 25);
      stressLevel += 15;
    });
  }

  void _startSideHustle() {
    setState(() {
      monthlyIncome += 1000; // Side hustle income
      stressLevel += 10; // More work = more stress
      _addAchievement('Emprendedor Multiple');
      _levelUpSkill('budgeting', 40);
    });
  }

  void _testSideHustle() {
    setState(() {
      monthlyIncome += 200; // Smaller test income
      _levelUpSkill('budgeting', 20);
    });
  }

  void _investInREIT() {
    setState(() {
      investments.add(Investment(
        name: 'REIT Inmobiliario',
        initialValue: 5000,
        currentValue: 5000,
        monthlyReturn: 0.0067, // 8% annual
        riskLevel: 'Moderado',
      ));
      balance -= 5000;
      _addAchievement('Inversionista Inmobiliario');
      _levelUpSkill('investing', 35);
    });
  }

  void _levelUpSkill(String skillName, int experience) {
    if (skills.containsKey(skillName)) {
      setState(() {
        skills[skillName]!.experience += experience;
        int newLevel = (skills[skillName]!.experience / 100).floor() + 1;
        if (newLevel > skills[skillName]!.level) {
          skills[skillName]!.level = newLevel;
          experiencePoints += 25; // Bonus for skill level up
          _showSkillLevelUpDialog(skills[skillName]!);
        }
      });
    }
  }

  void _showSkillLevelUpDialog(Skill skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: [
            const Icon(Icons.trending_up, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            Text('¡Skill Subió de Nivel!', style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${skill.name} Nivel ${skill.level}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tu experiencia en ${skill.name.toLowerCase()} ha mejorado significativamente',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('¡Excelente!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _checkDailyStreak() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime lastPlay = DateTime(lastPlayDate.year, lastPlayDate.month, lastPlayDate.day);
    
    if (today.difference(lastPlay).inDays == 1) {
      // Consecutive day
      dailyStreak++;
    } else if (today.difference(lastPlay).inDays > 1) {
      // Streak broken
      dailyStreak = 1;
    }
    // Same day = maintain streak
    
    lastPlayDate = now;
  }

  void _updateMarketConditions() {
    setState(() {
      // Simulate market volatility
      marketConditions['stockMarket'] = 0.8 + Random().nextDouble() * 0.4; // 0.8 to 1.2
      marketConditions['realEstate'] = 0.9 + Random().nextDouble() * 0.2; // 0.9 to 1.1
      marketConditions['bonds'] = 0.95 + Random().nextDouble() * 0.1; // 0.95 to 1.05
      marketConditions['crypto'] = 0.5 + Random().nextDouble() * 1.0; // 0.5 to 1.5 (very volatile)
      
      // Check for recession conditions
      if (marketConditions['stockMarket']! < 0.85 && marketConditions['realEstate']! < 0.95) {
        isEconomicRecession = true;
      } else {
        isEconomicRecession = false;
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    responseTimer?.cancel();
    _scoreAnimationController.dispose();
    _cardAnimationController.dispose();
    _eventAnimationController.dispose();
    super.dispose();
  }

  Color _getStressColor() {
    if (stressLevel < 25) return Colors.green;
    if (stressLevel < 50) return Colors.yellow;
    if (stressLevel < 75) return Colors.orange;
    return Colors.red;
  }

  void _processDecision(EventChoice choice) {
    setState(() {
      totalDecisionsMade++;
      
      // Calculate decision quality (0-100)
      double quality = 50; // Base quality
      if (choice.impact.scoreChange > 20) quality += 30;
      else if (choice.impact.scoreChange > 0) quality += 15;
      else if (choice.impact.scoreChange < -10) quality -= 20;
      
      if (choice.impact.balanceChange > 0) quality += 10;
      else if (choice.impact.balanceChange < -1000) quality -= 15;
      
      // Update average decision quality
      averageDecisionQuality = ((averageDecisionQuality * (totalDecisionsMade - 1)) + quality) / totalDecisionsMade;
      
      // Track decision history by type
      String decisionCategory = 'general';
      if (choice.text.toLowerCase().contains('invertir')) decisionCategory = 'investment';
      else if (choice.text.toLowerCase().contains('pagar')) decisionCategory = 'payment';
      else if (choice.text.toLowerCase().contains('ahorrar')) decisionCategory = 'saving';
      
      decisionHistory[decisionCategory] = (decisionHistory[decisionCategory] ?? 0) + 1;
      
      // Update stress based on decision
      if (choice.impact.scoreChange < -10 || choice.impact.balanceChange < -500) {
        stressLevel += 5;
      } else if (choice.impact.scoreChange > 20) {
        stressLevel = (stressLevel - 3).clamp(0, 100);
      }
      
      // Check for quest completion
      _checkQuestCompletion(choice);
      
      // Level up player if enough experience
      if (experiencePoints >= experienceToNextLevel) {
        _levelUpPlayer();
      }
    });
  }

  void _checkQuestCompletion(EventChoice choice) {
    for (var quest in activeQuests) {
      if (!quest.isCompleted) {
        bool completed = false;
        
        switch (quest.id) {
          case 'first_perfect_payment':
            if (choice.text.toLowerCase().contains('pagar') && choice.impact.scoreChange > 15) {
              completed = true;
            }
            break;
          case 'reach_700_score':
            if (creditScore >= 700) {
              completed = true;
            }
            break;
        }
        
        if (completed) {
          quest.isCompleted = true;
          experiencePoints += quest.reward;
          completedQuests.add(quest);
          _showQuestCompletedDialog(quest);
        }
      }
    }
    
    // Remove completed quests from active list
    activeQuests.removeWhere((quest) => quest.isCompleted);
    
    // Add new quests if needed
    _generateNewQuests();
  }

  void _generateNewQuests() {
    if (activeQuests.length < 3) {
      List<Quest> possibleQuests = [
        Quest(
          id: 'emergency_fund_1000',
          title: 'Fondo de Emergencia \$1000',
          description: 'Acumula \$1000 en tu fondo de emergencia',
          reward: 75,
          isCompleted: false,
          category: 'savings',
        ),
        Quest(
          id: 'credit_score_750',
          title: 'Score Elite',
          description: 'Alcanza un credit score de 750',
          reward: 150,
          isCompleted: false,
          category: 'credit',
        ),
        Quest(
          id: 'diversify_investments',
          title: 'Portfolio Diversificado',
          description: 'Ten al menos 3 tipos diferentes de inversiones',
          reward: 100,
          isCompleted: false,
          category: 'investment',
        ),
      ];
      
      for (var quest in possibleQuests) {
        if (!activeQuests.any((q) => q.id == quest.id) && 
            !completedQuests.any((q) => q.id == quest.id)) {
          activeQuests.add(quest);
          if (activeQuests.length >= 3) break;
        }
      }
    }
  }

  void _showQuestCompletedDialog(Quest quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            const Text('¡Quest Completado!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quest.title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              quest.description,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.yellow, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '+${quest.reward} XP',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('¡Genial!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _levelUpPlayer() {
    setState(() {
      playerLevel++;
      experienceToNextLevel = playerLevel * 150; // Increase XP requirement
      
      // Unlock new features based on level
      if (playerLevel == 3) {
        _addAchievement('Nivel 3 Alcanzado');
      } else if (playerLevel == 5) {
        _addAchievement('Experto Emergente');
      } else if (playerLevel == 10) {
        _addAchievement('Maestro Financiero');
      }
    });
    
    _showLevelUpDialog();
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text('¡LEVEL UP!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nivel $playerLevel',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tu experiencia financiera ha crecido significativamente',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('¡Continuar!', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Credit Score Hero', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreDisplay(),
            const SizedBox(height: 20),
            _buildGameStats(),
            const SizedBox(height: 20),
            _buildSkillsAndQuests(),
            const SizedBox(height: 20),
            _buildCreditCards(),
            const SizedBox(height: 20),
                         if (currentEvent != null) _buildCurrentEvent(),
             const SizedBox(height: 20),
                         if (achievements.isNotEmpty) _buildAchievements(),
            const SizedBox(height: 20),
            if (investments.isNotEmpty) _buildInvestments(),
            const SizedBox(height: 20),
            _buildFinancialInsights(),
            const SizedBox(height: 20),
            _buildProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay() {
    Color scoreColor = creditScore >= 750 ? Colors.green :
                      creditScore >= 650 ? Colors.orange : Colors.red;
    
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_scoreAnimation.value * 0.1),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scoreColor.withOpacity(0.3), scoreColor.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scoreColor, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  'CREDIT SCORE',
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$creditScore',
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _getScoreCategory(creditScore),
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillsAndQuests() {
    return Column(
      children: [
        // Skills Section
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.deepPurple, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Habilidades Financieras',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...skills.entries.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value.name,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          LinearProgressIndicator(
                            value: (entry.value.experience % 100) / 100,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Nv.${entry.value.level}',
                        style: const TextStyle(color: Colors.deepPurple, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Active Quests Section
        if (activeQuests.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assignment, color: Colors.cyan, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Misiones Activas',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...activeQuests.map((quest) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quest.title,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              quest.description,
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events, color: Colors.yellow, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${quest.reward}',
                              style: const TextStyle(color: Colors.yellow, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGameStats() {
    return Column(
      children: [
        // Primera fila de estadísticas
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Balance', '\$${balance.toStringAsFixed(0)}', Icons.account_balance_wallet, Colors.blue),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Mes', '$month/12', Icons.calendar_today, Colors.purple),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Nivel', '$level', Icons.trending_up, Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Segunda fila de estadísticas
        Row(
          children: [
            Expanded(
              child: _buildStatCard('XP', '$experiencePoints', Icons.star, Colors.yellow),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Logros', '${achievements.length}', Icons.emoji_events, const Color(0xFFFFD700)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Racha', '$currentStreak', Icons.trending_up, Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Tercera fila de estadísticas avanzadas
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Patrimonio', '\$${netWorth.toStringAsFixed(0)}', Icons.account_balance, Colors.purple),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Emergencia', '\$${emergencyFund.toStringAsFixed(0)}', Icons.security, Colors.blue),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Inversiones', '${investments.length}', Icons.trending_up, Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Cuarta fila - Gamificación avanzada
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Quests', '${activeQuests.length}', Icons.assignment, Colors.cyan),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Estrés', '${stressLevel.toInt()}%', Icons.psychology, _getStressColor()),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Skills', '${skills.length}', Icons.school, Colors.deepPurple),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            title, 
            style: TextStyle(color: color, fontSize: 10),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value, 
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCards() {
    if (creditCards.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis Tarjetas de Crédito',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: creditCards.length,
            itemBuilder: (context, index) {
              final card = creditCards[index];
              double utilizationRate = card.balance > 0 ? (card.balance / card.limit).clamp(0.0, 1.0) : 0.0;
              
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [card.color, card.color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: card.color.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.name, 
                            style: const TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${(card.interestRate * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Límite: \$${card.limit.toStringAsFixed(0)}', 
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Saldo: \$${card.balance.toStringAsFixed(0)}', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: utilizationRate,
                            backgroundColor: Colors.white30,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              utilizationRate > 0.7 ? Colors.red : 
                              utilizationRate > 0.3 ? Colors.orange : Colors.green,
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(utilizationRate * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Utilización',
                      style: const TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentEvent() {
    if (currentEvent == null) return const SizedBox();
    
    return AnimatedBuilder(
      animation: _eventAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _eventAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      currentEvent!.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: timeLeft <= 5 ? Colors.red : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${timeLeft}s',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  currentEvent!.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 15),
                ...currentEvent!.choices.map((choice) => _buildChoiceButton(choice)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChoiceButton(EventChoice choice) {
    // Colores neutros para no revelar las consecuencias
    List<Color> buttonColors = [
      const Color(0xFF4A90E2), // Azul
      const Color(0xFF7B68EE), // Violeta
      const Color(0xFF20B2AA), // Teal
    ];
    
    // Asignar color basado en el índice de la opción
    int choiceIndex = currentEvent!.choices.indexOf(choice);
    Color buttonColor = buttonColors[choiceIndex % buttonColors.length];
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () => _handleEventChoice(choice),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor.withOpacity(0.15),
          side: BorderSide(color: buttonColor, width: 1.5),
          padding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: buttonColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                choice.text,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: buttonColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    double progress = creditScore / 850;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progreso hacia Credit Hero (750+)',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(
            creditScore >= 750 ? Colors.green : Colors.blue,
          ),
          minHeight: 8,
        ),
        const SizedBox(height: 5),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% completado',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
         );
   }

     Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Logros Desbloqueados',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.black, size: 16),
                    const SizedBox(height: 2),
                    Text(
                      achievement,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInvestments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Portfolio de Inversiones',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...investments.map((investment) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_up, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      investment.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Riesgo: ${investment.riskLevel}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${investment.currentValue.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${((investment.currentValue / investment.initialValue - 1) * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: investment.currentValue >= investment.initialValue ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildFinancialInsights() {
    double debtToIncomeRatio = totalDebtsOnCards() / monthlyIncome;
    String healthStatus = _getFinancialHealthStatus();
    Color healthColor = _getHealthColor(healthStatus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: healthColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: healthColor, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Análisis Financiero',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard('Salud Financiera', healthStatus, healthColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInsightCard('Ratio Deuda/Ingreso', '${(debtToIncomeRatio * 100).toStringAsFixed(1)}%', 
                  debtToIncomeRatio < 0.2 ? Colors.green : debtToIncomeRatio < 0.4 ? Colors.orange : Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard('Meses de Emergencia', '${(emergencyFund / monthlyExpenses).toStringAsFixed(1)}', 
                  emergencyFund >= monthlyExpenses * 6 ? Colors.green : emergencyFund >= monthlyExpenses * 3 ? Colors.orange : Colors.red),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInsightCard('Racha Máxima', '$longestStreak meses', Colors.purple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getFinancialHealthStatus() {
    int score = 0;
    
    // Credit score weight (40%)
    if (creditScore >= 750) score += 40;
    else if (creditScore >= 700) score += 30;
    else if (creditScore >= 650) score += 20;
    else if (creditScore >= 600) score += 10;
    
    // Emergency fund weight (30%)
    if (emergencyFund >= monthlyExpenses * 6) score += 30;
    else if (emergencyFund >= monthlyExpenses * 3) score += 20;
    else if (emergencyFund >= monthlyExpenses) score += 10;
    
    // Debt to income weight (20%)
    double debtRatio = totalDebtsOnCards() / monthlyIncome;
    if (debtRatio < 0.1) score += 20;
    else if (debtRatio < 0.2) score += 15;
    else if (debtRatio < 0.3) score += 10;
    else if (debtRatio < 0.4) score += 5;
    
    // Net worth weight (10%)
    if (netWorth > monthlyIncome * 12) score += 10;
    else if (netWorth > monthlyIncome * 6) score += 7;
    else if (netWorth > 0) score += 5;
    
    if (score >= 80) return 'EXCELENTE';
    if (score >= 60) return 'BUENA';
    if (score >= 40) return 'REGULAR';
    if (score >= 20) return 'MALA';
    return 'CRÍTICA';
  }

  Color _getHealthColor(String status) {
    switch (status) {
      case 'EXCELENTE': return Colors.green;
      case 'BUENA': return Colors.lightGreen;
      case 'REGULAR': return Colors.orange;
      case 'MALA': return Colors.deepOrange;
      case 'CRÍTICA': return Colors.red;
      default: return Colors.grey;
    }
  }

   String _getScoreCategory(int score) {
    if (score >= 800) return 'EXCELENTE';
    if (score >= 750) return 'MUY BUENO';
    if (score >= 700) return 'BUENO';
    if (score >= 650) return 'REGULAR';
    if (score >= 600) return 'MALO';
    return 'MUY MALO';
  }
}

// Data classes
class CreditCard {
  final String name;
  double limit;
  double balance;
  final double interestRate;
  final Color color;
  final CardType type;

  CreditCard({
    required this.name,
    required this.limit,
    required this.balance,
    required this.interestRate,
    required this.color,
    required this.type,
  });
}

enum CardType { basic, promotional, premium, secured }
enum PaymentType { full, minimum }

class GameEvent {
  final String id;
  final String title;
  final String description;
  final List<EventChoice> choices;

  GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.choices,
  });
}

class EventChoice {
  final String text;
  final EventImpact impact;
  final VoidCallback? action;

  EventChoice({
    required this.text,
    required this.impact,
    this.action,
  });
}

class EventImpact {
  final int scoreChange;
  final double balanceChange;
  final String explanation;

  EventImpact({
    required this.scoreChange,
    required this.balanceChange,
    required this.explanation,
  });
}

class Investment {
  final String name;
  final double initialValue;
  double currentValue;
  final double monthlyReturn;
  final String riskLevel;

  Investment({
    required this.name,
    required this.initialValue,
    required this.currentValue,
    required this.monthlyReturn,
    required this.riskLevel,
  });
}

class Quest {
  final String id;
  final String title;
  final String description;
  final int reward;
  bool isCompleted;
  final String category;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.isCompleted,
    required this.category,
  });
}

class Skill {
  final String name;
  int level;
  int experience;

  Skill({
    required this.name,
    required this.level,
    required this.experience,
  });
}

class PowerUp {
  final String name;
  final String description;
  final int duration; // in months
  final double multiplier;
  int remainingDuration;

  PowerUp({
    required this.name,
    required this.description,
    required this.duration,
    required this.multiplier,
    required this.remainingDuration,
  });
}

class Achievement {
  final String name;
  final String description;
  final DateTime unlockedDate;
  final int experienceReward;

  Achievement({
    required this.name,
    required this.description,
    required this.unlockedDate,
    required this.experienceReward,
  });
}

class Notification {
  final String title;
  final String message;
  final String type; // 'achievement', 'warning', 'info', 'welcome'
  final DateTime timestamp;
  bool isRead;

  Notification({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

class Challenge {
  final String name;
  final String description;
  final int reward;
  final DateTime deadline;
  bool isCompleted;

  Challenge({
    required this.name,
    required this.description,
    required this.reward,
    required this.deadline,
    required this.isCompleted,
  });
} 