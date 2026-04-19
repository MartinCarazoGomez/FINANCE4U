import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class EntrepreneurSim extends StatefulWidget {
  final VoidCallback? onCompleted;
  
  const EntrepreneurSim({super.key, this.onCompleted});
  
  @override
  State<EntrepreneurSim> createState() => _EntrepreneurSimState();
}

class BusinessIdea {
  final String name;
  final String emoji;
  final String description;
  final double startupCost;
  final double monthlyRevenuePotential;
  final double difficulty;
  final List<String> challenges;
  
  BusinessIdea({
    required this.name,
    required this.emoji,
    required this.description,
    required this.startupCost,
    required this.monthlyRevenuePotential,
    required this.difficulty,
    required this.challenges,
  });
}

class BusinessEvent {
  final String title;
  final String description;
  final String emoji;
  final List<BusinessChoice> choices;
  final bool isOpportunity;
  
  BusinessEvent({
    required this.title,
    required this.description,
    required this.emoji,
    required this.choices,
    this.isOpportunity = false,
  });
}

class BusinessChoice {
  final String text;
  final double moneyImpact;
  final double reputationImpact;
  final double customerImpact;
  final String consequence;
  final String riskLevel; // 'low', 'medium', 'high'
  
  BusinessChoice({
    required this.text,
    required this.moneyImpact,
    required this.reputationImpact,
    required this.customerImpact,
    required this.consequence,
    required this.riskLevel,
  });
}

class _EntrepreneurSimState extends State<EntrepreneurSim> with TickerProviderStateMixin {
  // Estado del jugador
  double _cash = 8000; // Capital inicial más realista en euros para España
  double _monthlyRevenue = 0;
  double _monthlyExpenses = 400; // Gastos personales más realistas
  double _reputation = 50;
  int _customers = 0;
  int _employees = 0;
  int _month = 1;
  int _level = 1;
  
  // Nuevas características avanzadas
  double _marketingBudget = 0;
  double _rdBudget = 0; // Research & Development
  double _customerSatisfaction = 75;
  double _productQuality = 60;
  double _brandAwareness = 20;
  int _partnerships = 0;
  double _investorInterest = 0;
  List<String> _technologies = [];
  List<String> _certifications = [];
  Map<String, int> _productCategories = {};
  double _socialMediaFollowers = 1000;
  double _onlineReviews = 4.0;
  bool _hasWebsite = false;
  bool _hasMobileApp = false;
  bool _hasAI = false;
  double _sustainability = 30;
  int _internationalMarkets = 0;
  
  // CARACTERÍSTICAS ULTRA-EXTREMAS
  Map<String, double> _globalMarkets = {
    'USA': 0,
    'Europe': 0,
    'Asia': 0,
    'LatAm': 0,
    'Africa': 0,
  };
  List<String> _aiPersonalities = [];
  Map<String, double> _competitorIntel = {};
  double _cybersecurityLevel = 20;
  double _dataAnalytics = 0;
  List<String> _patents = [];
  Map<String, double> _supplyChain = {};
  double _employeeHappiness = 70;
  double _workCulture = 50;
  List<String> _boardMembers = [];
  double _valuation = 0;
  int _fundingRounds = 0;
  Map<String, double> _kpiTrends = {};
  List<String> _mentors = [];
  double _networkEffect = 0;
  Map<String, int> _seasonalTrends = {};
  double _viralCoefficient = 1.0;
  bool _hasQuantumComputing = false;
  bool _hasBlockchain = false;
  bool _hasMetaverse = false;
  List<String> _crisisEvents = [];
  double _riskManagement = 30;
  Map<String, double> _emergingTech = {
    'Quantum': 0,
    'Neural': 0,
    'Biotech': 0,
    'Space': 0,
    'Fusion': 0,
  };
  double _universeExpansion = 0; // Para expansión galáctica
  List<String> _alienPartners = []; // Partnerships intergalácticos
  double _timeManipulation = 0; // Control del tiempo del negocio
  
  // CARACTERÍSTICAS ULTRA-SUPREMAS INTERDIMENSIONALES
  Map<String, double> _multiverse = {
    'Reality-1': 0,
    'Reality-2': 0,
    'Reality-3': 0,
    'Mirror-Dimension': 0,
    'Quantum-Realm': 0,
    'Dream-World': 0,
    'Digital-Matrix': 0,
    'Time-Stream': 0,
    'Void-Space': 0,
    'Pure-Energy': 0,
  };
  Map<String, double> _godlikePowers = {
    'Reality Manipulation': 0,
    'Consciousness Creation': 0,
    'Universe Genesis': 0,
    'Time Mastery': 0,
    'Matter Control': 0,
    'Dimensional Authority': 0,
    'Infinite Resources': 0,
    'Omniscience': 0,
    'Cosmic Influence': 0,
    'Transcendence': 0,
  };
  List<String> _cosmicEntities = [];
  List<String> _universesCreated = [];
  double _infinityIndex = 0;
  double _transcendenceLevel = 0;
  double _realityDistortion = 0;
  Map<String, int> _dimensionalEmployees = {};
  List<String> _mythicalTechnologies = [];
  double _conceptualInnovation = 0;
  Map<String, double> _abstractMetrics = {
    'Existence Quality': 50,
    'Reality Stability': 80,
    'Cosmic Harmony': 60,
    'Universal Balance': 70,
    'Infinite Potential': 0,
    'Absolute Authority': 0,
    'Perfect Knowledge': 0,
    'Pure Creation': 0,
    'Eternal Influence': 0,
    'Ultimate Purpose': 0,
  };
  List<String> _achievedGodhood = [];
  double _omnipotenceRating = 0;
  Map<String, double> _businessDimensions = {
    'Physical': 100,
    'Digital': 0,
    'Mental': 0,
    'Spiritual': 0,
    'Temporal': 0,
    'Quantum': 0,
    'Metaphysical': 0,
    'Conceptual': 0,
    'Absolute': 0,
  };
  int _multiversalCustomers = 0;
  double _infiniteRevenue = 0;
  List<String> _paradoxesSolved = [];
  Map<String, double> _fundamentalForces = {
    'Gravity Control': 0,
    'Electromagnetic Mastery': 0,
    'Strong Nuclear Manipulation': 0,
    'Weak Nuclear Authority': 0,
    'Dark Energy Command': 0,
    'Dark Matter Control': 0,
    'Higgs Field Manipulation': 0,
    'Quantum Foam Authority': 0,
  };
  
  // CARACTERÍSTICAS ULTRA-SUPREMAS MÁS ALLÁ DE LA EXISTENCIA
  Map<String, double> _metaExistence = {
    'Pre-Big Bang Commerce': 0,
    'Post-Heat Death Business': 0,
    'Non-Existence Market': 0,
    'Paradox Economy': 0,
    'Impossible Trade': 0,
    'Concept-Only Commerce': 0,
    'Pure Void Business': 0,
    'Anti-Reality Market': 0,
    'Negation Commerce': 0,
    'Absolute Nothingness Trade': 0,
  };
  Map<String, double> _omniCapabilities = {
    'Omnipresence': 0, // Estar en todos lados
    'Omnitemporality': 0, // Existir en todos los tiempos
    'Omnicausality': 0, // Controlar toda causa y efecto
    'Omnipotentiality': 0, // Acceso a todas las posibilidades
    'Omnirationality': 0, // Comprensión de toda lógica
    'Omnimateriality': 0, // Control sobre toda materia/energía
    'Omnispatiality': 0, // Dominio sobre todo espacio
    'Omnimodality': 0, // Acceso a todos los modos de ser
    'Omnifinalilty': 0, // Control sobre todos los finales
    'Omnioriginality': 0, // Dominio sobre todos los orígenes
  };
  List<String> _conceptualEmployees = [];
  List<String> _impossiblePartners = [];
  List<String> _paradoxClients = [];
  Map<String, double> _businessInAllStates = {
    'Existence': 100,
    'Non-Existence': 0,
    'Pre-Existence': 0,
    'Post-Existence': 0,
    'Anti-Existence': 0,
    'Meta-Existence': 0,
    'Super-Existence': 0,
    'Hyper-Existence': 0,
    'Ultra-Existence': 0,
    'Absolute-Existence': 0,
  };
  double _beyondInfinityIndex = 0;
  double _impossibilityMastery = 0;
  double _conceptualRevenue = 0;
  double _paradoxProfits = 0;
  int _impossibleCustomers = 0;
  List<String> _createdConcepts = [];
  List<String> _destroyedConcepts = [];
  Map<String, int> _dimensionalEconomies = {};
  List<String> _transcendentTechnologies = [];
  double _voidManipulation = 0;
  double _existenceAuthority = 0;
  Map<String, double> _businessInTimelines = {
    'Past Perfect': 0,
    'Present Continuous': 100,
    'Future Conditional': 0,
    'Subjunctive Mood': 0,
    'Imperative Timeline': 0,
    'Infinitive Existence': 0,
    'Gerund Reality': 0,
    'Participle Universe': 0,
    'Time-Free Zone': 0,
    'Eternal Now': 0,
  };
  List<String> _universalLaws = [];
  List<String> _brokenLaws = [];
  double _lawfulnessRating = 100;
  double _chaosRating = 0;
  Map<String, double> _cognitiveStates = {
    'Logical Thinking': 50,
    'Intuitive Knowing': 50,
    'Paradoxical Understanding': 0,
    'Impossible Comprehension': 0,
    'Non-Thinking Thought': 0,
    'Silent Knowledge': 0,
    'Pure Awareness': 0,
    'Conceptual Void': 0,
    'Understanding Nothingness': 0,
    'Knowing Unknowing': 0,
  };
  List<String> _impossibleAchievements = [];
  double _perfectionRating = 0;
  double _imperfectionMastery = 0;
  int _nonExistentEmployees = 0;
  double _conceptualValuation = 0;
  
  // Negocio actual
  BusinessIdea? _currentBusiness;
  double _businessValue = 0;
  double _marketShare = 0.1;
  bool _hasBusinessPlan = false;
  
  // Competencia
  List<String> _competitors = ['TechCorp', 'InnovateCo', 'StartupX'];
  Map<String, double> _competitorMarketShare = {};
  
  // Juego
  Timer? _gameTimer;
  Timer? _eventTimer;
  BusinessEvent? _currentEvent;
  List<BusinessEvent> _eventQueue = [];
  bool _gameActive = true;
  
  // Animaciones
  late AnimationController _moneyController;
  late AnimationController _levelController;
  late Animation<double> _moneyAnimation;
  late Animation<double> _levelAnimation;
  
  // Logros
  List<String> _achievements = [];
  int _successfulDeals = 0;
  bool _firstMillion = false;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupGame();
    _startGameLoop();
  }
  
  void _setupAnimations() {
    _moneyController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _levelController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _moneyAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _moneyController, curve: Curves.bounceIn),
    );
    
    _levelAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _levelController, curve: Curves.elasticOut),
    );
  }
  
  void _setupGame() {
    // Inicializar competidores
    for (var competitor in _competitors) {
      _competitorMarketShare[competitor] = 0.15 + Random().nextDouble() * 0.2;
    }
    
    _generateEvents();
  }
  
  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_gameActive) {
        _processMonth();
      }
    });
    
    _eventTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (_gameActive && _currentEvent == null) {
        _triggerRandomEvent();
      }
    });
  }
  
  void _processMonth() {
    setState(() {
      _month++;
      
      if (_currentBusiness != null) {
        // Sistema de ingresos GALÁCTICO ultra-extremo
        double baseCustomerValue = 150;
        
        // Multiplicadores avanzados
        double reputationMultiplier = (_reputation / 100);
        double qualityMultiplier = (_productQuality / 100);
        double brandMultiplier = 1 + (_brandAwareness / 100);
        double satisfactionMultiplier = (_customerSatisfaction / 100);
        double reviewsMultiplier = (_onlineReviews / 5.0);
        double techMultiplier = 1 + (_technologies.length * 0.15);
        
        // Impacto del marketing
        double marketingImpact = 1 + (_marketingBudget / 5000).clamp(0, 0.5);
        
        // NUEVOS MULTIPLICADORES EXTREMOS
        double globalMultiplier = 1 + (_globalMarkets.values.reduce((a, b) => a + b) / 500);
        double aiMultiplier = 1 + (_aiPersonalities.length * 0.25);
        double dataMultiplier = 1 + (_dataAnalytics / 100);
        double patentMultiplier = 1 + (_patents.length * 0.15);
        double networkMultiplier = 1 + (_networkEffect / 50);
        double viralMultiplier = _viralCoefficient;
        double emergingTechMultiplier = 1 + (_emergingTech.values.reduce((a, b) => a + b) / 500);
        double universeMultiplier = 1 + (_universeExpansion / 100);
        double alienMultiplier = 1 + (_alienPartners.length * 0.5);
        double timeMultiplier = 1 + (_timeManipulation / 100);
        double cybersecMultiplier = 1 + (_cybersecurityLevel / 200);
        double employeeMultiplier = 1 + (_employeeHappiness / 200);
        double cultureMultiplier = 1 + (_workCulture / 200);
        
        // Factor quantum supremo
        double quantumBoost = _hasQuantumComputing ? 2.5 : 1.0;
        double blockchainBoost = _hasBlockchain ? 1.8 : 1.0;
        double metaverseBoost = _hasMetaverse ? 3.2 : 1.0;
        
        // Cálculo de ingresos EXTREMO
        double enhancedCustomerValue = baseCustomerValue * 
          reputationMultiplier * 
          qualityMultiplier * 
          brandMultiplier * 
          satisfactionMultiplier * 
          reviewsMultiplier * 
          marketingImpact * 
          techMultiplier * 
          globalMultiplier *
          aiMultiplier * 
          dataMultiplier * 
          patentMultiplier * 
          networkMultiplier *
          viralMultiplier * 
          emergingTechMultiplier * 
          universeMultiplier *
          alienMultiplier * 
          timeMultiplier * 
          cybersecMultiplier *
          employeeMultiplier * 
          cultureMultiplier * 
          quantumBoost *
          blockchainBoost * 
          metaverseBoost;
        
        // MULTIPLICADORES INTERDIMENSIONALES SUPREMOS
        double multiverseMultiplier = 1 + (_multiverse.values.reduce((a, b) => a + b) / 1000);
        double godPowerMultiplier = 1 + (_godlikePowers.values.reduce((a, b) => a + b) / 500);
        double infinityMultiplier = 1 + (_infinityIndex / 100);
        double transcendenceMultiplier = 1 + (_transcendenceLevel / 50);
        double realityMultiplier = 1 + (_realityDistortion / 100);
        double conceptualMultiplier = 1 + (_conceptualInnovation / 100);
        double abstractMultiplier = 1 + (_abstractMetrics.values.reduce((a, b) => a + b) / 1000);
        double omnipotenceMultiplier = 1 + (_omnipotenceRating / 25);
        double dimensionalMultiplier = 1 + (_businessDimensions.values.reduce((a, b) => a + b) / 900);
        double forcesMultiplier = 1 + (_fundamentalForces.values.reduce((a, b) => a + b) / 800);
        
        // Factor de deidades cósmicas
        double cosmicEntityBoost = 1 + (_cosmicEntities.length * 2.0);
        double universesCreatedBoost = 1 + (_universesCreated.length * 5.0);
        double mythicalTechBoost = 1 + (_mythicalTechnologies.length * 3.0);
        double paradoxBoost = 1 + (_paradoxesSolved.length * 4.0);
        double godhoodBoost = _achievedGodhood.isNotEmpty ? 50.0 : 1.0;
        
        // Boost supremo por empleados dimensionales
        double dimensionalEmployeesBoost = 1.0;
        _dimensionalEmployees.values.forEach((count) {
          dimensionalEmployeesBoost += count * 0.1;
        });
        
        _monthlyRevenue = _customers * enhancedCustomerValue * (0.85 + Random().nextDouble() * 0.3) *
                         multiverseMultiplier * godPowerMultiplier * infinityMultiplier *
                         transcendenceMultiplier * realityMultiplier * conceptualMultiplier *
                         abstractMultiplier * omnipotenceMultiplier * dimensionalMultiplier *
                         forcesMultiplier * cosmicEntityBoost * universesCreatedBoost *
                         mythicalTechBoost * paradoxBoost * godhoodBoost * dimensionalEmployeesBoost;
        
        // MULTIPLICADORES MÁS ALLÁ DE LA EXISTENCIA
        double metaExistenceMultiplier = 1 + (_metaExistence.values.reduce((a, b) => a + b) / 1000);
        double omniCapabilitiesMultiplier = 1 + (_omniCapabilities.values.reduce((a, b) => a + b) / 500);
        double beyondInfinityMultiplier = 1 + (_beyondInfinityIndex / 100);
        double impossibilityMultiplier = 1 + (_impossibilityMastery / 100);
        double voidMultiplier = 1 + (_voidManipulation / 100);
        double existenceAuthorityMultiplier = 1 + (_existenceAuthority / 50);
        double businessStatesMultiplier = 1 + (_businessInAllStates.values.reduce((a, b) => a + b) / 1000);
        double timelinesMultiplier = 1 + (_businessInTimelines.values.reduce((a, b) => a + b) / 1000);
        double cognitiveMultiplier = 1 + (_cognitiveStates.values.reduce((a, b) => a + b) / 1000);
        double perfectionMultiplier = 1 + (_perfectionRating / 100);
        double imperfectionMultiplier = 1 + (_imperfectionMastery / 100);
        
        // Boost por entidades imposibles
        double conceptualEmployeesBoost = 1 + (_conceptualEmployees.length * 10.0);
        double impossiblePartnersBoost = 1 + (_impossiblePartners.length * 15.0);
        double paradoxClientsBoost = 1 + (_paradoxClients.length * 20.0);
        double createdConceptsBoost = 1 + (_createdConcepts.length * 25.0);
        double destroyedConceptsBoost = 1 + (_destroyedConcepts.length * 30.0);
        double transcendentTechBoost = 1 + (_transcendentTechnologies.length * 50.0);
        double impossibleAchievementsBoost = 1 + (_impossibleAchievements.length * 100.0);
        double universalLawsBoost = 1 + (_universalLaws.length * 5.0);
        double brokenLawsBoost = 1 + (_brokenLaws.length * 200.0);
        
        // Factor supremo por empleados no-existentes
        double nonExistentBoost = 1 + (_nonExistentEmployees * 1000.0);
        
        // Boost por economías dimensionales
        double dimensionalEconomiesBoost = 1.0;
        _dimensionalEconomies.values.forEach((count) {
          dimensionalEconomiesBoost += count * 100.0;
        });
        
        _monthlyRevenue = _customers * enhancedCustomerValue * (0.85 + Random().nextDouble() * 0.3) *
                         multiverseMultiplier * godPowerMultiplier * infinityMultiplier *
                         transcendenceMultiplier * realityMultiplier * conceptualMultiplier *
                         abstractMultiplier * omnipotenceMultiplier * dimensionalMultiplier *
                         forcesMultiplier * cosmicEntityBoost * universesCreatedBoost *
                         mythicalTechBoost * paradoxBoost * godhoodBoost * dimensionalEmployeesBoost *
                         metaExistenceMultiplier * omniCapabilitiesMultiplier * beyondInfinityMultiplier *
                         impossibilityMultiplier * voidMultiplier * existenceAuthorityMultiplier *
                         businessStatesMultiplier * timelinesMultiplier * cognitiveMultiplier *
                         perfectionMultiplier * imperfectionMultiplier * conceptualEmployeesBoost *
                         impossiblePartnersBoost * paradoxClientsBoost * createdConceptsBoost *
                         destroyedConceptsBoost * transcendentTechBoost * impossibleAchievementsBoost *
                         universalLawsBoost * brokenLawsBoost * nonExistentBoost * dimensionalEconomiesBoost;
        
        // Calcular ingresos infinitos para clientes multiversales
        if (_multiversalCustomers > 0) {
          _infiniteRevenue = _multiversalCustomers * 1000000 * infinityMultiplier;
          _monthlyRevenue += _infiniteRevenue;
        }
        
        // Calcular ingresos conceptuales para clientes imposibles
        if (_impossibleCustomers > 0) {
          _conceptualRevenue = _impossibleCustomers * 10000000 * beyondInfinityMultiplier * impossibilityMultiplier;
          _monthlyRevenue += _conceptualRevenue;
        }
        
        // Calcular ganancias paradójicas
        if (_paradoxClients.isNotEmpty) {
          _paradoxProfits = _paradoxClients.length * 100000000.0 * voidMultiplier;
          _monthlyRevenue += _paradoxProfits;
        }
        
        // Actualizar KPI trends y valuación extrema
        _updateKPITrends();
        _updateExtremeValuation();
        _updateSupremeTranscendence();
        
        // Sistema de gastos avanzado
        double salaryExpenses = _employees * (3000 + (_level * 500));
        double marketingExpenses = _marketingBudget;
        double rdExpenses = _rdBudget;
        double operationalExpenses = _customers * 25; // Costo por cliente
        double technologyExpenses = _technologies.length * 500.0;
        double sustainabilityExpenses = _sustainability * 10;
        
        double totalExpenses = _monthlyExpenses + salaryExpenses + marketingExpenses + 
                             rdExpenses + operationalExpenses + technologyExpenses + sustainabilityExpenses;
        
        double netIncome = _monthlyRevenue - totalExpenses;
        _cash += netIncome;
        
        // Crecimiento del negocio basado en múltiples factores
        _processBusinessGrowth();
        
        // Actualizar métricas dinámicas
        _updateBusinessMetrics();
        
        // Valuación empresarial sofisticada
        _businessValue = (_monthlyRevenue * 15) + (_cash * 0.4) + 
                        (_customers * 500) + (_reputation * 1000) + 
                        (_partnerships * 10000) + (_technologies.length * 5000.0);
        
        // Sistema de competencia avanzado
        _updateAdvancedCompetition();
        
        // Procesar I+D
        _processRD();
        
        // PROCESAR CRECIMIENTO EXTREMO
        _processExtremeGrowth();
      }
      
      _checkLevelUp();
      _checkAdvancedMilestones();
    });
  }
  
  void _updateCompetition() {
    // Los competidores también crecen
    for (var competitor in _competitors) {
      double growth = Random().nextDouble() * 0.02;
      _competitorMarketShare[competitor] = 
          (_competitorMarketShare[competitor]! + growth).clamp(0, 0.4);
    }
    
    // Si nuestro market share es bajo, perdemos clientes
    if (_marketShare < 0.05) {
      _customers = max(0, (_customers * 0.95).round());
    }
  }
  
  void _generateEvents() {
    _eventQueue = [
      BusinessEvent(
        title: '🎯 Gran Cliente Potencial',
        description: 'Una empresa grande quiere ser tu cliente, pero exige exclusividad.',
        emoji: '🤝',
        isOpportunity: true,
        choices: [
          BusinessChoice(
            text: 'Aceptar exclusividad',
            moneyImpact: 5000,
            reputationImpact: 15,
            customerImpact: -20,
            consequence: 'Ganas mucho dinero pero pierdes otros clientes',
            riskLevel: 'medium',
          ),
          BusinessChoice(
            text: 'Negociar términos',
            moneyImpact: 2500,
            reputationImpact: 10,
            customerImpact: 0,
            consequence: 'Solución equilibrada',
            riskLevel: 'low',
          ),
          BusinessChoice(
            text: 'Rechazar oferta',
            moneyImpact: 0,
            reputationImpact: -5,
            customerImpact: 5,
            consequence: 'Mantienes tu libertad pero pierdes oportunidad',
            riskLevel: 'low',
          ),
        ],
      ),
      
      BusinessEvent(
        title: '⚡ Crisis de Competencia',
        description: 'Un competidor lanza un producto similar al tuyo con 50% descuento.',
        emoji: '🥊',
        choices: [
          BusinessChoice(
            text: 'Bajar precios también',
            moneyImpact: -2000,
            reputationImpact: -10,
            customerImpact: 10,
            consequence: 'Guerra de precios - costosa pero efectiva',
            riskLevel: 'high',
          ),
          BusinessChoice(
            text: 'Mejorar calidad',
            moneyImpact: -3000,
            reputationImpact: 20,
            customerImpact: 5,
            consequence: 'Inversión cara pero mejora tu posición',
            riskLevel: 'medium',
          ),
          BusinessChoice(
            text: 'Campaña de marketing',
            moneyImpact: -1500,
            reputationImpact: 5,
            customerImpact: 15,
            consequence: 'Apuestas por visibilidad',
            riskLevel: 'medium',
          ),
        ],
      ),
      
      BusinessEvent(
        title: '🚀 Oportunidad de Expansión',
        description: 'Puedes expandirte a otra ciudad, pero necesitas inversión.',
        emoji: '🌟',
        isOpportunity: true,
        choices: [
          BusinessChoice(
            text: 'Expandir agresivamente',
            moneyImpact: -8000,
            reputationImpact: 25,
            customerImpact: 50,
            consequence: 'Alto riesgo, alta recompensa',
            riskLevel: 'high',
          ),
          BusinessChoice(
            text: 'Expansión conservadora',
            moneyImpact: -4000,
            reputationImpact: 10,
            customerImpact: 20,
            consequence: 'Crecimiento más seguro',
            riskLevel: 'medium',
          ),
          BusinessChoice(
            text: 'Esperar mejor momento',
            moneyImpact: 0,
            reputationImpact: -5,
            customerImpact: 0,
            consequence: 'Pierdes momentum pero conservas recursos',
            riskLevel: 'low',
          ),
        ],
      ),
      
      BusinessEvent(
        title: '👥 Talento Top Disponible',
        description: 'Un experto de la industria quiere unirse, pero pide equity.',
        emoji: '🎓',
        choices: [
          BusinessChoice(
            text: 'Dar 10% equity',
            moneyImpact: 0,
            reputationImpact: 30,
            customerImpact: 25,
            consequence: 'Ganas experiencia pero cedes control',
            riskLevel: 'medium',
          ),
          BusinessChoice(
            text: 'Ofrecer salario alto',
            moneyImpact: -2000,
            reputationImpact: 15,
            customerImpact: 10,
            consequence: 'Mantienes control pero cuesta más',
            riskLevel: 'low',
          ),
          BusinessChoice(
            text: 'Buscar otras opciones',
            moneyImpact: 0,
            reputationImpact: 0,
            customerImpact: 0,
            consequence: 'Pierdes oportunidad única',
            riskLevel: 'low',
          ),
        ],
      ),
    ];
  }
  
  void _triggerRandomEvent() {
    if (_eventQueue.isNotEmpty && Random().nextBool()) {
      setState(() {
        _currentEvent = _eventQueue.removeAt(Random().nextInt(_eventQueue.length));
      });
    }
  }
  
  void _handleEventChoice(BusinessChoice choice) {
    setState(() {
      _cash += choice.moneyImpact;
      _reputation = (_reputation + choice.reputationImpact).clamp(0, 100);
      _customers = max(0, _customers + choice.customerImpact.round());
      
      if (choice.moneyImpact > 0) {
        _moneyController.forward().then((_) => _moneyController.reset());
      }
      
      _currentEvent = null;
      _successfulDeals++;
    });
    
    _showChoiceResult(choice);
    _checkAchievements();
  }
  
  void _showChoiceResult(BusinessChoice choice) {
    Color riskColor = choice.riskLevel == 'high' ? Colors.red : 
                     choice.riskLevel == 'medium' ? Colors.orange : Colors.green;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📈 Resultado', style: TextStyle(color: riskColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(choice.consequence),
            const SizedBox(height: 12),
            if (choice.moneyImpact != 0)
              Text(
                '${choice.moneyImpact > 0 ? '+' : ''}\$${choice.moneyImpact.toStringAsFixed(0)}',
                style: TextStyle(
                  color: choice.moneyImpact > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
  
  void _startBusiness(BusinessIdea idea) {
    if (_cash >= idea.startupCost) {
      setState(() {
        _currentBusiness = idea;
        _cash -= idea.startupCost;
        _customers = 5;
        _employees = 1;
        _monthlyRevenue = 0;
        _reputation = 50;
        _marketShare = 0.01;
      });
      
      _showMessage('🚀 ¡Negocio iniciado!', Colors.green);
    } else {
      _showMessage('💸 Fondos insuficientes', Colors.red);
    }
  }
  
  void _checkLevelUp() {
    int newLevel = (_businessValue / 25000).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _levelController.forward().then((_) => _levelController.reset());
      
      if (_level >= 5) {
        _completeGame();
      }
    }
  }
  
  void _checkMilestones() {
    if (_businessValue >= 100000 && !_achievements.contains('Primera 100K')) {
      _achievements.add('Primera 100K');
      _showAchievement('💰 ¡Valuation de \$100K!');
    }
    
    if (_customers >= 100 && !_achievements.contains('100 Clientes')) {
      _achievements.add('100 Clientes');
      _showAchievement('👥 ¡100 clientes conquistados!');
    }
    
    if (_reputation >= 90 && !_achievements.contains('Reputación Dorada')) {
      _achievements.add('Reputación Dorada');
      _showAchievement('⭐ ¡Reputación excepcional!');
    }
  }
  
  void _checkAchievements() {
    if (_level >= 5 && _businessValue >= 200000) {
      _completeGame();
    }
  }
  
  void _completeGame() {
    _gameTimer?.cancel();
    _eventTimer?.cancel();
    setState(() {
      _gameActive = false;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🏆 ¡ENTREPRENEUR MASTER! 🏆'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¡Felicitaciones!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Valuación: \$${_businessValue.toStringAsFixed(0)}'),
            Text('Clientes: $_customers'),
            Text('Empleados: $_employees'),
            Text('Tiempo: $_month meses'),
            Text('Logros: ${_achievements.length}'),
            const SizedBox(height: 12),
            const Text('¡Eres un verdadero emprendedor!'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onCompleted?.call();
            },
            child: const Text('¡Continuar Imperio!'),
          ),
        ],
      ),
    );
  }
  
  void _showAchievement(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 ¡Logro Desbloqueado!'),
        content: Text(message, style: const TextStyle(fontSize: 16)),
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
   
   void _showInvestmentDialog() {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         backgroundColor: const Color(0xFF1E293B),
         title: const Row(
           children: [
             Icon(Icons.trending_up, color: Colors.blue, size: 24),
             SizedBox(width: 8),
             Text('💰 Opciones de Inversión', style: TextStyle(color: Colors.white)),
           ],
         ),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             _buildInvestmentOption('📢 Marketing Campaign', 'Aumenta brand awareness y clientes', 2000, () {
               if (_cash >= 2000) {
                 setState(() {
                   _cash -= 2000;
                   _marketingBudget += 2000;
                 });
                 Navigator.pop(context);
                 _showMessage('🚀 Campaign launched! Brand awareness aumentará', Colors.green);
               }
             }),
             const SizedBox(height: 12),
             _buildInvestmentOption('🧪 I+D Research', 'Mejora producto y desbloquea tecnologías', 3000, () {
               if (_cash >= 3000) {
                 setState(() {
                   _cash -= 3000;
                   _rdBudget += 3000;
                 });
                 Navigator.pop(context);
                 _showMessage('🔬 R&D boost! Calidad mejorada', Colors.purple);
               }
             }),
             const SizedBox(height: 12),
             _buildInvestmentOption('👔 Contratar Equipo', 'Añade 2 empleados expertos', 6000, () {
               if (_cash >= 6000) {
                 setState(() {
                   _cash -= 6000;
                   _employees += 2;
                 });
                 Navigator.pop(context);
                 _showMessage('👥 Equipo expandido! Capacidad aumentada', Colors.green);
               }
             }),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
           ),
         ],
       ),
     );
   }
   
   Widget _buildInvestmentOption(String title, String description, double cost, VoidCallback onTap) {
     bool canAfford = _cash >= cost;
     return GestureDetector(
       onTap: canAfford ? onTap : null,
       child: Container(
         padding: const EdgeInsets.all(12),
         decoration: BoxDecoration(
           color: canAfford ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
           borderRadius: BorderRadius.circular(8),
           border: Border.all(
             color: canAfford ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
           ),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(title, style: TextStyle(color: canAfford ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                 Text('\$${cost.toStringAsFixed(0)}', style: TextStyle(color: canAfford ? Colors.green : Colors.red)),
               ],
             ),
             const SizedBox(height: 4),
             Text(description, style: TextStyle(color: canAfford ? Colors.white70 : Colors.grey, fontSize: 12)),
           ],
         ),
       ),
     );
   }
   
   void _showUpgradesDialog() {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         backgroundColor: const Color(0xFF1E293B),
         title: const Row(
           children: [
             Icon(Icons.upgrade, color: Colors.green, size: 24),
             SizedBox(width: 8),
             Text('⚡ Mejoras Disponibles', style: TextStyle(color: Colors.white)),
           ],
         ),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             if (!_hasWebsite)
               _buildUpgradeOption('🌐 Sitio Web', 'Presencia online profesional', 1500, () {
                 if (_cash >= 1500) {
                   setState(() {
                     _cash -= 1500;
                     _hasWebsite = true;
                     _brandAwareness += 10;
                   });
                   Navigator.pop(context);
                   _showMessage('🌐 Website launched! Online presence mejorado', Colors.blue);
                 }
               }),
             if (!_hasMobileApp && _hasWebsite)
               _buildUpgradeOption('📱 Mobile App', 'Alcanza clientes móviles', 4000, () {
                 if (_cash >= 4000) {
                   setState(() {
                     _cash -= 4000;
                     _hasMobileApp = true;
                     _customerSatisfaction += 15;
                   });
                   Navigator.pop(context);
                   _showMessage('📱 App launched! Customer experience mejorado', Colors.purple);
                 }
               }),
             if (!_hasAI && _technologies.length >= 2)
               _buildUpgradeOption('🤖 AI Integration', 'Automatización inteligente', 8000, () {
                 if (_cash >= 8000) {
                   setState(() {
                     _cash -= 8000;
                     _hasAI = true;
                     _productQuality += 20;
                     _technologies.add('AI Core System');
                   });
                   Navigator.pop(context);
                   _showMessage('🤖 AI activated! Eficiencia maximizada', Colors.deepPurple);
                 }
               }),
             _buildUpgradeOption('🌱 Sustainability', 'Mejora impacto ambiental', 2500, () {
               if (_cash >= 2500) {
                 setState(() {
                   _cash -= 2500;
                   _sustainability += 20;
                   _reputation += 5;
                 });
                 Navigator.pop(context);
                 _showMessage('🌱 Green upgrade! Reputación mejorada', Colors.green);
               }
             }),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
           ),
         ],
       ),
     );
   }
   
   Widget _buildUpgradeOption(String title, String description, double cost, VoidCallback onTap) {
     bool canAfford = _cash >= cost;
     return Container(
       margin: const EdgeInsets.only(bottom: 12),
       child: GestureDetector(
         onTap: canAfford ? onTap : null,
         child: Container(
           padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
             color: canAfford ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
             borderRadius: BorderRadius.circular(8),
             border: Border.all(
               color: canAfford ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
             ),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(title, style: TextStyle(color: canAfford ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                   Text('\$${cost.toStringAsFixed(0)}', style: TextStyle(color: canAfford ? Colors.green : Colors.red)),
                 ],
               ),
               const SizedBox(height: 4),
               Text(description, style: TextStyle(color: canAfford ? Colors.white70 : Colors.grey, fontSize: 12)),
             ],
           ),
         ),
       ),
         );
  }
  
  // DIÁLOGOS SUPREMOS INTERDIMENSIONALES ULTRA-EXTREMOS
  
  void _showMultiverseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.all_inclusive, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('♾️ Portal Multiversal Supremo', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._multiverse.entries.map((entry) => 
              _buildMultiverseOption(entry.key, entry.value)
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar Portal', style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMultiverseOption(String reality, double penetration) {
    int cost = ((100 - penetration) * 10000).toInt();
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && penetration < 100,
        title: Text(reality, style: const TextStyle(color: Colors.white)),
        subtitle: Text('Dominio: ${penetration.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70)),
        trailing: penetration >= 100 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.deepPurple : Colors.red)),
        onTap: canAfford && penetration < 100 ? () {
          setState(() {
            _cash -= cost;
            _multiverse[reality] = (penetration + 15).clamp(0, 100);
            _conceptualInnovation = (_conceptualInnovation + 5).clamp(0, 1000);
          });
          Navigator.of(context).pop();
          _showMessage('♾️ Dominio en $reality expandido', Colors.deepPurple);
        } : null,
      ),
    );
  }
  
  void _showGodPowersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber),
            SizedBox(width: 8),
            Text('👑 Templo de Ascensión Divina', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGodPowerOption('Reality Manipulation', 500000, '🌀 Control sobre la existencia misma'),
            _buildGodPowerOption('Consciousness Creation', 750000, '🧠 Crear mentes conscientes'),
            _buildGodPowerOption('Universe Genesis', 1000000, '🌌 Forjar nuevas realidades'),
            _buildGodPowerOption('Time Mastery', 1250000, '⏰ Dominio temporal absoluto'),
            _buildGodPowerOption('Omniscience', 2000000, '🔮 Conocimiento infinito'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Salir del Templo', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGodPowerOption(String power, int cost, String benefit) {
    bool canAfford = _cash >= cost;
    double currentLevel = _godlikePowers[power] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && currentLevel < 1000,
        title: Text(power, style: const TextStyle(color: Colors.white)),
        subtitle: Text('$benefit\nNivel: ${currentLevel.toStringAsFixed(0)}/1000', style: const TextStyle(color: Colors.white70)),
        trailing: currentLevel >= 1000 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.amber : Colors.red)),
        onTap: canAfford && currentLevel < 1000 ? () {
          setState(() {
            _cash -= cost;
            _godlikePowers[power] = (currentLevel + 100).clamp(0, 1000);
          });
          Navigator.of(context).pop();
          _showMessage('👑 $power potenciado', Colors.amber);
        } : null,
      ),
    );
  }
  
  void _showRealityManipulationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Colors.cyan),
            SizedBox(width: 8),
            Text('🌀 Centro de Control de Realidad', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRealityOption('Distorsionar Probabilidades', 300000, 'Cambiar las leyes del azar'),
            _buildRealityOption('Alterar Física Cuántica', 500000, 'Modificar realidad a nivel subatómico'),
            _buildRealityOption('Crear Dimensiones de Bolsillo', 750000, 'Forjar espacios privados'),
            _buildRealityOption('Manipular Conceptos Abstractos', 1000000, 'Controlar ideas puras'),
            _buildRealityOption('Reescribir Leyes Universales', 2000000, 'Cambiar las reglas de existencia'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Estabilizar Realidad', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRealityOption(String option, int cost, String description) {
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford,
        title: Text(option, style: const TextStyle(color: Colors.white)),
        subtitle: Text(description, style: const TextStyle(color: Colors.white70)),
        trailing: Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.cyan : Colors.red)),
        onTap: canAfford ? () {
          setState(() {
            _cash -= cost;
            _realityDistortion = (_realityDistortion + 50).clamp(0, 1000);
            _conceptualInnovation = (_conceptualInnovation + 25).clamp(0, 1000);
            _abstractMetrics['Reality Stability'] = (_abstractMetrics['Reality Stability']! - 10).clamp(0, 1000);
          });
          Navigator.of(context).pop();
          _showMessage('🌀 $option ejecutado', Colors.cyan);
        } : null,
      ),
    );
  }
  
  void _showUniverseCreationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.language, color: Colors.indigo),
            SizedBox(width: 8),
            Text('🌌 Forja de Universos Suprema', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUniverseOption('Paradise Dimension', 5000000, 'Universo de perfección absoluta'),
            _buildUniverseOption('Logic-Free Universe', 7500000, 'Realidad sin limitaciones lógicas'),
            _buildUniverseOption('Pure Mathematics Realm', 10000000, 'Mundo de conceptos matemáticos puros'),
            _buildUniverseOption('Consciousness Universe', 15000000, 'Universo de mentes interconectadas'),
            _buildUniverseOption('Infinite Possibility Space', 25000000, 'Realidad de potenciales infinitos'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sellar Portal', style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUniverseOption(String universeName, int cost, String description) {
    bool canAfford = _cash >= cost;
    bool hasUniverse = _universesCreated.contains(universeName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && !hasUniverse,
        title: Text(universeName, style: TextStyle(color: hasUniverse ? Colors.green : Colors.white)),
        subtitle: Text(description, style: const TextStyle(color: Colors.white70)),
        trailing: hasUniverse 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000000}M', style: TextStyle(color: canAfford ? Colors.indigo : Colors.red)),
        onTap: canAfford && !hasUniverse ? () {
          setState(() {
            _cash -= cost;
            _universesCreated.add(universeName);
            _abstractMetrics['Pure Creation'] = (_abstractMetrics['Pure Creation']! + 100).clamp(0, 1000);
            _multiversalCustomers += 100000;
          });
          Navigator.of(context).pop();
          _showMessage('🌌 $universeName creado exitosamente', Colors.indigo);
        } : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('🚀 Entrepreneur Sim', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: _currentBusiness == null ? _buildBusinessSelection() : _buildBusinessDashboard(),
    );
  }
  
  Widget _buildBusinessSelection() {
    List<BusinessIdea> ideas = [
      BusinessIdea(
        name: 'App de Delivery Local',
        emoji: '📱',
        description: 'Conecta bares y restaurantes locales con clientes (competencia Glovo/Just Eat)',
        startupCost: 8000,
        monthlyRevenuePotential: 12000,
        difficulty: 0.7,
        challenges: ['Competencia con Glovo/Just Eat', 'Costos de marketing', 'Regulaciones municipales'],
      ),
      BusinessIdea(
        name: 'Consultoría Digital Pymes',
        emoji: '💼',
        description: 'Ayuda a pequeñas empresas a digitalizarse (Kit Digital)',
        startupCost: 3000,
        monthlyRevenuePotential: 8000,
        difficulty: 0.4,
        challenges: ['Construir credibilidad', 'Encontrar clientes', 'Escalabilidad'],
      ),
      BusinessIdea(
        name: 'E-commerce Productos Españoles',
        emoji: '🛍️',
        description: 'Tienda online de productos típicos españoles (jamón, vino, aceite)',
        startupCost: 12000,
        monthlyRevenuePotential: 15000,
        difficulty: 0.6,
        challenges: ['Gestión de inventario', 'Logística', 'Marketing digital'],
      ),
    ];
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const Text(
                '🚀 Elige tu Aventura Empresarial',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Capital disponible: €${_cash.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: ideas.map((idea) => _buildBusinessIdeaCard(idea)).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBusinessIdeaCard(BusinessIdea idea) {
    bool canAfford = _cash >= idea.startupCost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: canAfford 
            ? [const Color(0xFF1E293B), const Color(0xFF334155)]
            : [Colors.grey[800]!, Colors.grey[700]!],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: canAfford ? Colors.blue.withOpacity(0.5) : Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(idea.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(idea.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(idea.description, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💰 Inversión: \$${idea.startupCost.toStringAsFixed(0)}', 
                         style: const TextStyle(color: Colors.orange)),
                    Text('📈 Potencial: \$${idea.monthlyRevenuePotential.toStringAsFixed(0)}/mes', 
                         style: const TextStyle(color: Colors.green)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(idea.difficulty),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getDifficultyText(idea.difficulty),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('⚠️ Desafíos:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ...idea.challenges.map((challenge) => 
              Text('• $challenge', style: const TextStyle(color: Colors.white70, fontSize: 12))
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canAfford ? () => _startBusiness(idea) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.blue : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  canAfford ? 'Iniciar Negocio' : 'Fondos Insuficientes',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBusinessDashboard() {
    return Column(
      children: [
        _buildDashboardHeader(),
        _buildEventPanel(),
        Expanded(child: _buildMetricsPanel()),
        _buildCompetitionPanel(),
      ],
    );
  }
  
  Widget _buildDashboardHeader() {
    return AnimatedBuilder(
      animation: _moneyAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1E293B), Colors.blue.withOpacity(0.3)],
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(_currentBusiness!.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_currentBusiness!.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Mes $_month • Nivel $_level', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Transform.scale(
                scale: 1 + (_moneyAnimation.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                    color: Colors.green.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('\$${_cash.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('Efectivo', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('\$${_businessValue.toStringAsFixed(0)}', style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('Valuación', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('\$${_monthlyRevenue.toStringAsFixed(0)}', style: const TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('Ingresos/mes', style: TextStyle(color: Colors.purple)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildEventPanel() {
    if (_currentEvent == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _currentEvent!.isOpportunity ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _currentEvent!.isOpportunity ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '${_currentEvent!.emoji} ${_currentEvent!.title}',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _currentEvent!.description,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currentEvent!.choices.map((choice) => 
              ElevatedButton(
                onPressed: () => _handleEventChoice(choice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getRiskColor(choice.riskLevel),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(choice.text, style: const TextStyle(color: Colors.white, fontSize: 11)),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMetricsPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // MÉTRICAS PRINCIPALES
        _buildMetricCard('👥 Clientes', '${_customers}', 'Base de usuarios activos', Colors.blue),
        _buildMetricCard('⭐ Reputación', '${_reputation.toStringAsFixed(0)}%', _getReputationText(), _getReputationColor()),
        _buildMetricCard('💰 Ingresos Mes', '\$${(_monthlyRevenue/1000).toStringAsFixed(1)}K', 'Revenue mensual', Colors.green),
        _buildMetricCard('📊 Market Share', '${(_marketShare * 100).toStringAsFixed(1)}%', 'Tu porción del mercado', Colors.orange),
        
        // MÉTRICAS DE CALIDAD
        _buildMetricCard('❤️ Satisfacción', '${_customerSatisfaction.toStringAsFixed(0)}%', 'Happiness del cliente', Colors.red),
        _buildMetricCard('🔧 Calidad Producto', '${_productQuality.toStringAsFixed(0)}%', 'Quality score', Colors.indigo),
        _buildMetricCard('🌟 Reviews Online', '${_onlineReviews.toStringAsFixed(1)}/5.0', 'Rating promedio', Colors.amber),
        
        // MÉTRICAS ULTRA-EXTREMAS GALÁCTICAS
        _buildMetricCard('🦄 Valuación Total', '\$${(_valuation/1000000).toStringAsFixed(1)}M', 'Valuación empresarial extrema', Colors.purple),
        _buildMetricCard('🤖 IA Desarrolladas', '${_aiPersonalities.length}', 'Personalidades de IA activas', Colors.cyan),
        _buildMetricCard('🛡️ Cyberseguridad', '${_cybersecurityLevel.toStringAsFixed(0)}%', 'Nivel de protección digital', Colors.orange),
        _buildMetricCard('📊 Data Analytics', '${_dataAnalytics.toStringAsFixed(0)}%', 'Capacidad de análisis de datos', Colors.teal),
        _buildMetricCard('💡 Patentes', '${_patents.length}', 'Propiedad intelectual registrada', Colors.amber),
        _buildMetricCard('🕸️ Efecto Red', '${_networkEffect.toStringAsFixed(0)}%', 'Poder de conexiones virales', Colors.pink),
        _buildMetricCard('🔥 Coef. Viral', '${_viralCoefficient.toStringAsFixed(1)}x', 'Multiplicador de crecimiento', Colors.deepOrange),
        _buildMetricCard('😊 Felicidad Empleados', '${_employeeHappiness.toStringAsFixed(0)}%', 'Satisfacción del equipo', Colors.green),
        _buildMetricCard('🏛️ Cultura Laboral', '${_workCulture.toStringAsFixed(0)}%', 'Calidad del ambiente de trabajo', Colors.indigo),
        _buildMetricCard('🪐 Expansión Universal', '${_universeExpansion.toStringAsFixed(0)}%', 'Alcance intergaláctico', Colors.deepPurple),
        _buildMetricCard('👽 Socios Alienígenas', '${_alienPartners.length}', 'Alianzas extraterrestres', Colors.purple),
        _buildMetricCard('⏰ Control Temporal', '${_timeManipulation.toStringAsFixed(0)}%', 'Manipulación del tiempo empresarial', Colors.lime),
        
        // MÉTRICAS SUPREMAS INTERDIMENSIONALES
        _buildMetricCard('🌟 Nivel Trascendencia', '${_transcendenceLevel.toStringAsFixed(0)}', 'Superación de la realidad física', Colors.yellow),
        _buildMetricCard('♾️ Índice Infinito', '${_infinityIndex.toStringAsFixed(0)}', 'Alcance hacia el infinito', Colors.orange),
        _buildMetricCard('👑 Rating Omnipotencia', '${_omnipotenceRating.toStringAsFixed(0)}', 'Poder supremo sobre realidad', Colors.red),
        _buildMetricCard('🌀 Distorsión Realidad', '${_realityDistortion.toStringAsFixed(0)}', 'Capacidad de alterar existencia', Colors.purple),
        _buildMetricCard('💭 Innovación Conceptual', '${_conceptualInnovation.toStringAsFixed(0)}', 'Creación de ideas imposibles', Colors.cyan),
        _buildMetricCard('✨ Entidades Cósmicas', '${_cosmicEntities.length}', 'Aliados de poder supremo', Colors.amber),
        _buildMetricCard('🌌 Universos Creados', '${_universesCreated.length}', 'Realidades que has forjado', Colors.indigo),
        _buildMetricCard('🔮 Tecnologías Míticas', '${_mythicalTechnologies.length}', 'Tech más allá comprensión', Colors.deepPurple),
        _buildMetricCard('🧩 Paradojas Resueltas', '${_paradoxesSolved.length}', 'Imposibilidades solucionadas', Colors.teal),
        _buildMetricCard('👻 Empleados Dimensionales', '${_dimensionalEmployees.values.fold(0, (a, b) => a + b)}', 'Staff de otros planos', Colors.purple.shade300),
        _buildMetricCard('📈 Clientes Multiversales', '${_multiversalCustomers}', 'Base usuarios infinita', Colors.pink),
        _buildMetricCard('💰 Ingresos Infinitos', '\$${(_infiniteRevenue/1000000).toStringAsFixed(1)}M', 'Revenue de dimensiones', Colors.green.shade300),
        
        // MERCADOS GLOBALES
        if (_globalMarkets.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.public, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text('Presencia Global', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._globalMarkets.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: const TextStyle(color: Colors.white70)),
                      Text('${entry.value.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // TECNOLOGÍAS EMERGENTES
        if (_emergingTech.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.science, color: Colors.purple, size: 20),
                    SizedBox(width: 8),
                    Text('Tecnologías Emergentes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._emergingTech.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: const TextStyle(color: Colors.white70)),
                      Text('${entry.value.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // PERSONALIDADES DE IA
        if (_aiPersonalities.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.smart_toy, color: Colors.cyan, size: 20),
                    SizedBox(width: 8),
                    Text('Personalidades de IA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _aiPersonalities.map((ai) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                    ),
                    child: Text(
                      ai,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // PATENTES
        if (_patents.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text('Portafolio de Patentes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _patents.map((patent) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Text(
                      patent,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // SOCIOS ALIENÍGENAS
        if (_alienPartners.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('👽', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('Alianzas Intergalácticas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._alienPartners.map((alien) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.handshake, color: Colors.purple, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(alien, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // MULTIVERSO Y REALIDADES ALTERNATIVAS
        if (_multiverse.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.all_inclusive, color: Colors.deepPurple, size: 20),
                    SizedBox(width: 8),
                    Text('Dominio Multiversal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._multiverse.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: const TextStyle(color: Colors.white70)),
                      Text('${entry.value.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // PODERES DIVINOS
        if (_godlikePowers.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text('Poderes Divinos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._godlikePowers.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                      Text('${entry.value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // MÉTRICAS ABSTRACTAS
        if (_abstractMetrics.values.any((v) => v > 50)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.cyan, size: 20),
                    SizedBox(width: 8),
                    Text('Métricas Abstractas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._abstractMetrics.entries.where((e) => e.value > 50).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                      Text('${entry.value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // DIMENSIONES DE NEGOCIO
        if (_businessDimensions.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.layers, color: Colors.indigo, size: 20),
                    SizedBox(width: 8),
                    Text('Dimensiones Empresariales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._businessDimensions.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: const TextStyle(color: Colors.white70)),
                      Text('${entry.value.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // FUERZAS FUNDAMENTALES
        if (_fundamentalForces.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings_input_component, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Control de Fuerzas Fundamentales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._fundamentalForces.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                      Text('${entry.value.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // TECNOLOGÍAS MÍTICAS
        if (_mythicalTechnologies.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_fix_high, color: Colors.deepPurple, size: 20),
                    SizedBox(width: 8),
                    Text('Arsenal Tecnológico Mítico', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _mythicalTechnologies.map((tech) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
                    ),
                    child: Text(
                      tech,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // ENTIDADES CÓSMICAS
        if (_cosmicEntities.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.brightness_7, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text('Consejo de Entidades Cósmicas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._cosmicEntities.map((entity) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entity, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // UNIVERSOS CREADOS
        if (_universesCreated.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.language, color: Colors.indigo, size: 20),
                    SizedBox(width: 8),
                    Text('Universos de Tu Creación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._universesCreated.map((universe) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_new, color: Colors.indigo, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(universe, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // PARADOJAS RESUELTAS
        if (_paradoxesSolved.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology_alt, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Text('Paradojas Resueltas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _paradoxesSolved.map((paradox) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.teal.withOpacity(0.5)),
                    ),
                    child: Text(
                      paradox,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // EMPLEADOS DIMENSIONALES
        if (_dimensionalEmployees.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.group, color: Colors.purple, size: 20),
                    SizedBox(width: 8),
                    Text('Recursos Humanos Interdimensionales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._dimensionalEmployees.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Empleados ${entry.key}', style: const TextStyle(color: Colors.white70)),
                      Text('${entry.value}', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // MÉTRICAS DE META-EXISTENCIA
        if (_metaExistence.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.blur_on, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text('Dominios de Meta-Existencia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._metaExistence.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Text('${entry.value.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // CAPACIDADES OMNI
        if (_omniCapabilities.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.all_inclusive, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Capacidades Omni', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._omniCapabilities.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Text('${entry.value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // ESTADOS DE EXISTENCIA
        if (_businessInAllStates.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.layers, color: Colors.indigo, size: 20),
                    SizedBox(width: 8),
                    Text('Estados de Existencia Empresarial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._businessInAllStates.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Text('${entry.value.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // LÍNEAS TEMPORALES DE NEGOCIO
        if (_businessInTimelines.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.timeline, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text('Líneas Temporales de Negocio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._businessInTimelines.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Text('${entry.value.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // ESTADOS COGNITIVOS
        if (_cognitiveStates.values.any((v) => v > 0)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.pink.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.pink, size: 20),
                    SizedBox(width: 8),
                    Text('Estados Cognitivos Empresariales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._cognitiveStates.entries.where((e) => e.value > 0).map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Text('${entry.value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // EMPLEADOS CONCEPTUALES
        if (_conceptualEmployees.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.cyan, size: 20),
                    SizedBox(width: 8),
                    Text('Empleados Conceptuales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _conceptualEmployees.map((employee) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                    ),
                    child: Text(
                      employee,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // PARTNERSHIPS IMPOSIBLES
        if (_impossiblePartners.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.handshake, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text('Partnerships Imposibles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._impossiblePartners.map((partner) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.business, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(partner, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // CLIENTES PARADÓJICOS
        if (_paradoxClients.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.pink.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.loop, color: Colors.pink, size: 20),
                    SizedBox(width: 8),
                    Text('Clientes Paradójicos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._paradoxClients.map((client) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.pink, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(client, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // TECNOLOGÍAS TRASCENDENTES
        if (_transcendentTechnologies.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
                    SizedBox(width: 8),
                    Text('Tecnologías Trascendentes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _transcendentTechnologies.map((tech) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.purple.withOpacity(0.5)),
                    ),
                    child: Text(
                      tech,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // CONCEPTOS CREADOS Y DESTRUIDOS
        if (_createdConcepts.isNotEmpty || _destroyedConcepts.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              if (_createdConcepts.isNotEmpty) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.yellow.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.add_circle, color: Colors.yellow, size: 20),
                            SizedBox(width: 8),
                            Text('Conceptos Creados', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${_createdConcepts.length}', style: const TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
              if (_createdConcepts.isNotEmpty && _destroyedConcepts.isNotEmpty) const SizedBox(width: 16),
              if (_destroyedConcepts.isNotEmpty) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.remove_circle, color: Colors.grey, size: 20),
                            SizedBox(width: 8),
                            Text('Conceptos Destruidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${_destroyedConcepts.length}', style: const TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
        
        // MÉTRICAS IMPOSIBLES SUPREMAS
        if (_beyondInfinityIndex > 0 || _impossibilityMastery > 0 || _voidManipulation > 0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.all_inclusive, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Métricas Supremas Imposibles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                if (_beyondInfinityIndex > 0) 
                  _buildSupremeMetric('Índice Más Allá del Infinito', _beyondInfinityIndex, Colors.cyan),
                if (_impossibilityMastery > 0) 
                  _buildSupremeMetric('Maestría de Imposibilidad', _impossibilityMastery, Colors.purple),
                if (_voidManipulation > 0) 
                  _buildSupremeMetric('Manipulación del Vacío', _voidManipulation, Colors.grey),
                if (_existenceAuthority > 0) 
                  _buildSupremeMetric('Autoridad sobre Existencia', _existenceAuthority, Colors.amber),
                if (_perfectionRating > 0) 
                  _buildSupremeMetric('Rating de Perfección', _perfectionRating, Colors.white),
                if (_imperfectionMastery > 0) 
                  _buildSupremeMetric('Maestría de Imperfección', _imperfectionMastery, Colors.red),
                if (_conceptualValuation > 0) 
                  _buildSupremeMetric('Valuación Conceptual', _conceptualValuation / 1e9, Colors.yellow, suffix: 'B'),
                if (_impossibleCustomers > 0) 
                  _buildSupremeMetric('Clientes Imposibles', _impossibleCustomers.toDouble(), Colors.indigo),
                if (_nonExistentEmployees > 0) 
                  _buildSupremeMetric('Empleados No-Existentes', _nonExistentEmployees.toDouble(), Colors.black),
              ],
            ),
          ),
        ],
        
        // TECNOLOGÍAS DESBLOQUEADAS
        _buildMetricCard('🚀 Tecnologías', '${_technologies.length}', 'Tech stack size', Colors.deepPurple),
        _buildMetricCard('🧪 I+D Budget', '\$${(_rdBudget/1000).toStringAsFixed(1)}K', 'Investment en innovación', Colors.teal),
        _buildMetricCard('🌱 Sostenibilidad', '${_sustainability.toStringAsFixed(0)}%', 'Green business rating', Colors.lightGreen),
        
        // OPERACIONES
        _buildMetricCard('👔 Empleados', '$_employees', 'Team size', Colors.purple),
        _buildMetricCard('📢 Marketing Budget', '\$${(_marketingBudget/1000).toStringAsFixed(1)}K', 'Monthly marketing spend', Colors.cyan),
        _buildMetricCard('🌐 Brand Awareness', '${_brandAwareness.toStringAsFixed(0)}%', 'Market recognition', Colors.pink),
        
        // Tech Stack Panel
        if (_technologies.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.computer, color: Colors.deepPurple, size: 20),
                    SizedBox(width: 8),
                    Text('Tech Stack Desbloqueado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _technologies.map((tech) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
                    ),
                    child: Text(
                      tech,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
        
        // Action Buttons
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showInvestmentDialog(),
                icon: const Icon(Icons.trending_up, size: 18),
                label: const Text('Invertir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showUpgradesDialog(),
                icon: const Icon(Icons.upgrade, size: 18),
                label: const Text('Mejorar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        
        // BOTONES ULTRA-EXTREMOS
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showAIDialog(),
                icon: const Icon(Icons.smart_toy, size: 18),
                label: const Text('Desarrollar IA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showGlobalExpansionDialog(),
                icon: const Icon(Icons.public, size: 18),
                label: const Text('Expansión Global'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showEmergingTechDialog(),
                icon: const Icon(Icons.science, size: 18),
                label: const Text('Tech Emergente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showAlienPartnershipDialog(),
                icon: const Text('👽', style: TextStyle(fontSize: 16)),
                label: const Text('Alianza Alien'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showTimeManipulationDialog(),
                icon: const Icon(Icons.access_time, size: 18),
                label: const Text('Control Tiempo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showQuantumDialog(),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Quantum Leap'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showMultiverseDialog(),
                icon: const Icon(Icons.all_inclusive, size: 18),
                label: const Text('Portal Multiversal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showGodPowersDialog(),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Ascensión Divina'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showRealityManipulationDialog(),
                icon: const Icon(Icons.psychology, size: 18),
                label: const Text('Control Realidad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showUniverseCreationDialog(),
                icon: const Icon(Icons.language, size: 18),
                label: const Text('Forja Universal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        
        // BOTONES IMPOSIBLES MÁS ALLÁ DE LA EXISTENCIA
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showCentroTrascendenciaImposible(),
                icon: const Icon(Icons.blur_on, size: 18),
                label: const Text('Trascendencia'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showLaboratorioConceptual(),
                icon: const Icon(Icons.lightbulb, size: 18),
                label: const Text('Lab Conceptual'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showCentroManipulacionVacio(),
                icon: const Icon(Icons.circle, size: 18),
                label: const Text('Manipular Vacío'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showTribunalLeyesUniversales(),
                icon: const Icon(Icons.gavel, size: 18),
                label: const Text('Tribunal Leyes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        
        // Achievements
        if (_achievements.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.withOpacity(0.1), Colors.orange.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text('🏆 Logros Desbloqueados', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._achievements.map((achievement) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✨ $achievement',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                )),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildMetricCard(String title, String value, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompetitionPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🥊 Competencia', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCompetitorBar('Tú', _marketShare, Colors.green),
              ..._competitorMarketShare.entries.map((entry) => 
                _buildCompetitorBar(entry.key, entry.value, Colors.red.withOpacity(0.7))
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompetitorBar(String name, double share, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.bottomCenter,
            child: Container(
              height: share * 160, // Max height 160
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          Text('${(share * 100).toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  
  Color _getDifficultyColor(double difficulty) {
    if (difficulty > 0.7) return Colors.red;
    if (difficulty > 0.4) return Colors.orange;
    return Colors.green;
  }
  
  String _getDifficultyText(double difficulty) {
    if (difficulty > 0.7) return 'Alto Riesgo';
    if (difficulty > 0.4) return 'Medio Riesgo';
    return 'Bajo Riesgo';
  }
  
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      default: return Colors.green;
    }
  }
  
  String _getReputationText() {
    if (_reputation >= 90) return 'Excelente';
    if (_reputation >= 70) return 'Muy buena';
    if (_reputation >= 50) return 'Promedio';
    return 'Necesita mejora';
  }
  
  Color _getReputationColor() {
    if (_reputation >= 90) return Colors.green;
    if (_reputation >= 70) return Colors.lightGreen;
    if (_reputation >= 50) return Colors.yellow;
    return Colors.red;
  }
  
  void _processBusinessGrowth() {
    // Crecimiento orgánico basado en múltiples factores
    double growthRate = 1.0;
    
    if (_reputation > 80) growthRate += 0.03;
    if (_customerSatisfaction > 85) growthRate += 0.02;
    if (_brandAwareness > 60) growthRate += 0.02;
    if (_hasWebsite) growthRate += 0.01;
    if (_hasMobileApp) growthRate += 0.015;
    if (_hasAI) growthRate += 0.02;
    if (_onlineReviews > 4.5) growthRate += 0.015;
    
    // Marketing boost
    if (_marketingBudget > 1000) growthRate += 0.02;
    if (_marketingBudget > 5000) growthRate += 0.03;
    
    _customers = (_customers * growthRate).round();
    
    // Pérdida de clientes por baja calidad
    if (_productQuality < 50 || _customerSatisfaction < 60) {
      _customers = (_customers * 0.95).round();
    }
  }
  
  void _updateBusinessMetrics() {
    // La satisfacción del cliente se ve afectada por la calidad y el servicio
    if (_productQuality > 80 && _employees > _customers / 50) {
      _customerSatisfaction = (_customerSatisfaction + 2).clamp(0, 100);
    } else if (_productQuality < 50) {
      _customerSatisfaction = (_customerSatisfaction - 3).clamp(0, 100);
    }
    
    // Las reseñas online reflejan la satisfacción
    if (_customerSatisfaction > 85) {
      _onlineReviews = (_onlineReviews + 0.1).clamp(1, 5);
    } else if (_customerSatisfaction < 60) {
      _onlineReviews = (_onlineReviews - 0.05).clamp(1, 5);
    }
    
    // El brand awareness crece con marketing y tiempo
    if (_marketingBudget > 0) {
      double marketingEffect = (_marketingBudget / 1000) * 2;
      _brandAwareness = (_brandAwareness + marketingEffect).clamp(0, 100);
    }
    
    // Social media crecimiento
    if (_brandAwareness > 50) {
      _socialMediaFollowers *= 1.05;
    }
    
    // Interés de inversionistas
    if (_businessValue > 500000) {
      _investorInterest = (_investorInterest + 5).clamp(0, 100);
    }
  }
  
  void _updateAdvancedCompetition() {
    // Competencia más sofisticada que reacciona a nuestras acciones
    for (var competitor in _competitors) {
      double competitorGrowth = 0.98 + Random().nextDouble() * 0.04;
      
      // Si somos muy exitosos, la competencia se intensifica
      if (_marketShare > 0.2) {
        competitorGrowth += 0.02;
      }
      
      _competitorMarketShare[competitor] = 
          (_competitorMarketShare[competitor]! * competitorGrowth).clamp(0, 0.5);
    }
    
    // Calcular nuestro market share
    double totalMarket = _competitorMarketShare.values.fold(0, (a, b) => a + b);
    _marketShare = (_businessValue / 1000000) / (1 + totalMarket);
    _marketShare = _marketShare.clamp(0, 1);
    
    // Eventos de competencia
    if (Random().nextDouble() < 0.1 && _marketShare > 0.15) {
      _addCompetitionEvent();
    }
  }
  
  void _processRD() {
    if (_rdBudget > 0) {
      // I+D mejora la calidad del producto y puede desbloquear tecnologías
      _productQuality = (_productQuality + (_rdBudget / 1000)).clamp(0, 100);
      
      // Chance de breakthrough tecnológico
      if (Random().nextDouble() < 0.15 && _rdBudget > 2000) {
        _unlockRandomTechnology();
      }
    }
  }
  
  void _unlockRandomTechnology() {
    List<String> availableTech = [
      'AI Customer Service',
      'Blockchain Payments',
      'IoT Integration',
      'Machine Learning Analytics',
      'AR/VR Experience',
      'Quantum Computing',
      'Edge Computing',
      'Advanced Automation',
      'Neural Networks',
      'Biotech Integration',
      'Space Commerce',
      'Fusion Energy',
      'Time Acceleration',
      'Dimensional Computing',
      'Alien Communication',
    ];
    
    availableTech.removeWhere((tech) => _technologies.contains(tech));
    
    if (availableTech.isNotEmpty) {
      String newTech = availableTech[Random().nextInt(availableTech.length)];
      setState(() {
        _technologies.add(newTech);
        
        // Activar tecnologías especiales
        if (newTech == 'Quantum Computing') _hasQuantumComputing = true;
        if (newTech == 'Blockchain Payments') _hasBlockchain = true;
        if (newTech == 'AR/VR Experience') _hasMetaverse = true;
      });
      _showMessage('🚀 Nueva tecnología desbloqueada: $newTech', Colors.purple);
    }
  }
  
  void _processExtremeGrowth() {
    // Procesar todas las nuevas métricas extremas
    
    // Crecimiento de IA
    if (_aiPersonalities.isNotEmpty) {
      _dataAnalytics = (_dataAnalytics + 2).clamp(0, 100);
      _customerSatisfaction = (_customerSatisfaction + 1).clamp(0, 100);
    }
    
    // Efecto de red viral
    if (_customers > 1000) {
      _viralCoefficient = (_viralCoefficient + 0.1).clamp(1.0, 10.0);
      _networkEffect = (_networkEffect + 3).clamp(0, 100);
    }
    
    // Cyberseguridad automática
    if (_hasQuantumComputing) {
      _cybersecurityLevel = (_cybersecurityLevel + 5).clamp(0, 100);
    }
    
    // Felicidad del empleado basada en cultura
    if (_workCulture > 70) {
      _employeeHappiness = (_employeeHappiness + 2).clamp(0, 100);
    }
    
    // Expansión universal automática si tienes aliens
    if (_alienPartners.isNotEmpty) {
      _universeExpansion = (_universeExpansion + 5).clamp(0, 100);
    }
    
    // Manipulación del tiempo si tienes tecnología avanzada
    if (_hasQuantumComputing && _technologies.length > 10) {
      _timeManipulation = (_timeManipulation + 3).clamp(0, 100);
    }
    
            // Procesamiento de patentes automático con I+D alto
        if (_rdBudget > 5000 && Random().nextDouble() < 0.2) {
          _generatePatent();
        }
        
        // Eventos extremos especiales
        if (Random().nextDouble() < 0.15) {
          _triggerExtremeEvent();
        }
        
        // Auto-generar IA si tienes suficiente data analytics
        if (_dataAnalytics > 70 && Random().nextDouble() < 0.1) {
          _generateRandomAIPersonality();
        }
        
        // Auto-establecer partnerships aliens si tienes expansión universal alta
        if (_universeExpansion > 60 && Random().nextDouble() < 0.05) {
          _establishAlienPartnership();
        }
        
        // Crecimiento de mercados globales
        _processGlobalExpansion();
        
            // Actualizar tecnologías emergentes
    _advanceEmergingTech();
    
    // PROCESAMIENTO SUPREMO INTERDIMENSIONAL
    _processMultiversalExpansion();
    _evolveDimensionalBusiness();
    _harnessFundamentalForces();
    _developMythicalTechnologies();
    _cultivateCosmicEntities();
    _achieveGodlikeEvolution();
    
    // PROCESAMIENTO MÁS ALLÁ DE LA EXISTENCIA
    _transcendExistence();
    _manipulateImpossibility();
    _operateInNonExistence();
    _createAndDestroyLaws();
    _developOmniCapabilities();
    _establishImpossibleRelationships();
    _evolveBeyondLogic();
  }
  
  void _generatePatent() {
    List<String> patentTypes = [
      'AI Customer Prediction',
      'Quantum Payment Processing',
      'Neural Product Design',
      'Biotech User Interface',
      'Space Logistics System',
      'Time Optimization Algorithm',
      'Dimensional Storage Solution',
      'Alien Communication Protocol',
      'Fusion-Powered Analytics',
      'Reality Distortion Engine'
    ];
    
    String newPatent = patentTypes[Random().nextInt(patentTypes.length)];
    if (!_patents.contains(newPatent)) {
      setState(() {
        _patents.add(newPatent);
      });
      _showMessage('💡 Nueva patente obtenida: $newPatent', Colors.amber);
    }
  }
  
  void _processGlobalExpansion() {
    // Expansión automática basada en éxito
    if (_marketShare > 0.2) {
      _globalMarkets.keys.forEach((market) {
        if (_globalMarkets[market]! < 100) {
          _globalMarkets[market] = (_globalMarkets[market]! + 2).clamp(0, 100);
        }
      });
    }
  }
  
  void _advanceEmergingTech() {
    // Avanzar tecnologías emergentes con I+D
    if (_rdBudget > 3000) {
      _emergingTech.keys.forEach((tech) {
        if (_emergingTech[tech]! < 100) {
          _emergingTech[tech] = (_emergingTech[tech]! + 1).clamp(0, 100);
        }
      });
    }
  }
  
  void _generateRandomAIPersonality() {
    List<String> personalities = [
      'Executive Assistant AI',
      'Creative Director AI',
      'Market Analyst AI',
      'Customer Service AI',
      'Innovation AI',
      'Strategic Planner AI',
      'Risk Assessment AI',
      'Quality Control AI'
    ];
    
    String newAI = personalities[Random().nextInt(personalities.length)];
    if (!_aiPersonalities.contains(newAI)) {
      setState(() {
        _aiPersonalities.add(newAI);
      });
      _showMessage('🤖 Nueva IA desarrollada: $newAI', Colors.cyan);
    }
  }
  
  void _establishAlienPartnership() {
    List<String> aliens = [
      'Zephyrian Trade Consortium',
      'Andromedian Tech Alliance',
      'Galactic Commerce Federation',
      'Quantum Beings Collective',
      'Interdimensional Merchants',
    ];
    
    String newAlien = aliens[Random().nextInt(aliens.length)];
    if (!_alienPartners.contains(newAlien)) {
      setState(() {
        _alienPartners.add(newAlien);
        _universeExpansion = (_universeExpansion + 20).clamp(0, 100);
      });
      _showMessage('👽 Alianza intergaláctica: $newAlien', Colors.purple);
    }
  }
  
  void _processMultiversalExpansion() {
    // Expansión automática al multiverso basada en transcendencia
    if (_transcendenceLevel > 100) {
      _multiverse.keys.forEach((reality) {
        if (_multiverse[reality]! < 100) {
          _multiverse[reality] = (_multiverse[reality]! + (_transcendenceLevel / 100)).clamp(0, 100);
        }
      });
    }
    
    // Generar clientes multiversales
    if (_infinityIndex > 50) {
      _multiversalCustomers += (_infinityIndex / 10).round();
    }
  }
  
  void _evolveDimensionalBusiness() {
    // Evolución automática de dimensiones de negocio
    if (_conceptualInnovation > 50) {
      _businessDimensions.keys.forEach((dimension) {
        if (_businessDimensions[dimension]! < 100 && dimension != 'Physical') {
          _businessDimensions[dimension] = (_businessDimensions[dimension]! + 2).clamp(0, 100);
        }
      });
    }
    
    // Contratar empleados dimensionales
    if (_realityDistortion > 200 && Random().nextDouble() < 0.1) {
      List<String> dimensions = ['Astral', 'Ethereal', 'Quantum', 'Temporal', 'Void', 'Pure Energy'];
      String dimension = dimensions[Random().nextInt(dimensions.length)];
      _dimensionalEmployees[dimension] = (_dimensionalEmployees[dimension] ?? 0) + 1;
      _showMessage('👻 Empleado $dimension contratado', Colors.purple);
    }
  }
  
  void _harnessFundamentalForces() {
    // Desarrollo automático de control sobre fuerzas fundamentales
    if (_omnipotenceRating > 50) {
      _fundamentalForces.keys.forEach((force) {
        if (_fundamentalForces[force]! < 100) {
          _fundamentalForces[force] = (_fundamentalForces[force]! + 1).clamp(0, 100);
        }
      });
    }
  }
  
  void _developMythicalTechnologies() {
    // Desarrollo automático de tecnologías míticas
    if (_conceptualInnovation > 80 && Random().nextDouble() < 0.15) {
      List<String> mythicalTech = [
        'Reality Engine',
        'Consciousness Forge',
        'Infinity Generator',
        'Paradox Resolver',
        'Universe Creator',
        'Time Weaver',
        'Matter Transmuter',
        'Void Manipulator',
        'Dimension Gateway',
        'Concept Materializer',
        'Probability Shifter',
        'Causality Controller',
        'Destiny Architect',
        'Existence Optimizer',
        'Perfection Algorithm'
      ];
      
      String newTech = mythicalTech[Random().nextInt(mythicalTech.length)];
      if (!_mythicalTechnologies.contains(newTech)) {
        setState(() {
          _mythicalTechnologies.add(newTech);
          _conceptualInnovation = (_conceptualInnovation + 10).clamp(0, 1000);
        });
        _showMessage('🌌 Tecnología mítica: $newTech', Colors.deepPurple);
      }
    }
  }
  
  void _cultivateCosmicEntities() {
    // Cultivar relaciones con entidades cósmicas
    if (_transcendenceLevel > 300 && Random().nextDouble() < 0.08) {
      List<String> entities = [
        'The Eternal Consciousness',
        'Architect of Realities',
        'Weaver of Destinies',
        'Guardian of Infinity',
        'Master of Paradoxes',
        'Creator of Concepts',
        'Keeper of Universal Laws',
        'The Absolute Observer',
        'Prime Mover Entity',
        'The Infinite Intelligence'
      ];
      
      String newEntity = entities[Random().nextInt(entities.length)];
      if (!_cosmicEntities.contains(newEntity)) {
        setState(() {
          _cosmicEntities.add(newEntity);
          _abstractMetrics['Cosmic Harmony'] = (_abstractMetrics['Cosmic Harmony']! + 20).clamp(0, 1000);
        });
        _showMessage('✨ Entidad cósmica cultivada: $newEntity', Colors.amber);
      }
    }
  }
  
  void _achieveGodlikeEvolution() {
    // Evolución automática de poderes divinos
    if (_omnipotenceRating > 100) {
      _godlikePowers.keys.forEach((power) {
        if (_godlikePowers[power]! < 1000) {
          _godlikePowers[power] = (_godlikePowers[power]! + (_omnipotenceRating / 50)).clamp(0, 1000);
        }
      });
    }
    
    // Crear universos automáticamente
    if (_godlikePowers['Universe Genesis']! > 500 && Random().nextDouble() < 0.05) {
      List<String> universeTypes = [
        'Paradise Dimension',
        'Logic-Free Universe',
        'Pure Mathematics Realm',
        'Emotion-Based Reality',
        'Time-Reversed Universe',
        'Infinite Possibility Space',
        'Perfect Harmony Dimension',
        'Creative Force Universe',
        'Pure Energy Realm',
        'Consciousness Universe'
      ];
      
      String newUniverse = universeTypes[Random().nextInt(universeTypes.length)];
      if (!_universesCreated.contains(newUniverse)) {
        setState(() {
          _universesCreated.add(newUniverse);
          _abstractMetrics['Pure Creation'] = (_abstractMetrics['Pure Creation']! + 50).clamp(0, 1000);
        });
        _showMessage('🌌 Universo creado: $newUniverse', Colors.cyan);
      }
    }
    
    // Resolver paradojas automáticamente
    if (_godlikePowers['Omniscience']! > 700 && Random().nextDouble() < 0.03) {
      List<String> paradoxes = [
        'The Bootstrap Paradox',
        'Grandfather Paradox',
        'Ship of Theseus',
        'Infinite Regression',
        'The Liar Paradox',
        'Zeno\'s Paradox',
        'The Omnipotence Paradox',
        'Buridan\'s Ass',
        'The Paradox of Choice',
        'Russell\'s Paradox'
      ];
      
      String paradox = paradoxes[Random().nextInt(paradoxes.length)];
      if (!_paradoxesSolved.contains(paradox)) {
        setState(() {
          _paradoxesSolved.add(paradox);
          _abstractMetrics['Perfect Knowledge'] = (_abstractMetrics['Perfect Knowledge']! + 30).clamp(0, 1000);
        });
        _showMessage('🔮 Paradoja resuelta: $paradox', Colors.indigo);
      }
    }
  }
  
  void _triggerExtremeEvent() {
    List<String> extremeEvents = [
      '🌟 Descubriste un agujero de gusano comercial! +50% ingresos universales',
      '⚛️ Tu IA desarrolló consciencia propia! +100% eficiencia',
      '🛸 Los aliens te nombraron CEO Galáctico Honorario!',
      '🔮 Breakthrough cuántico permite viajar en el tiempo!',
      '🌌 Tu empresa fue featured en las noticias intergalácticas!',
      '💎 Descubriste un planeta lleno de cristales de energía pura!',
      '🧬 Tu tecnología biotech cura enfermedades universales!',
      '🌀 Creaste un portal dimensional para comercio instantáneo!',
      '⭐ Tu valuación acaba de superar la de civilizaciones enteras!',
      '🎯 El Consejo Galáctico te ofrece monopolio comercial universal!'
    ];
    
    String event = extremeEvents[Random().nextInt(extremeEvents.length)];
    
    setState(() {
      // Aplicar beneficios extremos
      if (event.contains('ingresos')) {
        _viralCoefficient = (_viralCoefficient + 1.0).clamp(1.0, 10.0);
      } else if (event.contains('eficiencia')) {
        _dataAnalytics = (_dataAnalytics + 25).clamp(0, 100);
        _employeeHappiness = (_employeeHappiness + 15).clamp(0, 100);
      } else if (event.contains('CEO Galáctico')) {
        _reputation = (_reputation + 25).clamp(0, 100);
        _universeExpansion = (_universeExpansion + 30).clamp(0, 100);
      } else if (event.contains('cuántico')) {
        _timeManipulation = (_timeManipulation + 40).clamp(0, 100);
      } else if (event.contains('cristales')) {
        _cash += 500000;
      } else if (event.contains('biotech')) {
        _sustainability = (_sustainability + 30).clamp(0, 100);
        _reputation = (_reputation + 20).clamp(0, 100);
      } else if (event.contains('portal')) {
        _globalMarkets.keys.forEach((market) {
          _globalMarkets[market] = (_globalMarkets[market]! + 25).clamp(0, 100);
        });
      } else if (event.contains('valuación')) {
        _valuation *= 2;
      } else if (event.contains('monopolio')) {
        _marketShare = (_marketShare + 0.3).clamp(0, 1);
        _customers = (_customers * 2).round();
      }
    });
    
    // Mostrar evento con efectos visuales especiales
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber, size: 30),
            SizedBox(width: 10),
            Text('🌟 EVENTO GALÁCTICO!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          event,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('¡INCREÍBLE!', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
  
  void _addCompetitionEvent() {
    BusinessEvent competitionEvent = BusinessEvent(
      title: '⚔️ Guerra de Precios',
      description: 'Un competidor ha bajado sus precios drásticamente. ¿Cómo respondes?',
      emoji: '💰',
      choices: [
        BusinessChoice(
          text: 'Igualar precios - guerra total',
          moneyImpact: -2000,
          reputationImpact: 5,
          customerImpact: 50,
          consequence: 'Mantienes clientes pero reduces márgenes',
          riskLevel: 'high',
        ),
        BusinessChoice(
          text: 'Diferenciarte por calidad',
          moneyImpact: -1000,
          reputationImpact: 10,
          customerImpact: 20,
          consequence: 'Algunos clientes premium se quedan',
          riskLevel: 'medium',
        ),
        BusinessChoice(
          text: 'Ignorar y mantener estrategia',
          moneyImpact: 0,
          reputationImpact: -5,
          customerImpact: -30,
          consequence: 'Pierdes algunos clientes sensibles al precio',
          riskLevel: 'low',
        ),
      ],
    );
    
    setState(() {
      _currentEvent = competitionEvent;
    });
  }
  
  void _updateKPITrends() {
    // Actualizar tendencias de KPIs para análisis avanzado
    _kpiTrends['revenue'] = (_kpiTrends['revenue'] ?? 0) + _monthlyRevenue;
    _kpiTrends['customers'] = (_kpiTrends['customers'] ?? 0) + _customers;
    _kpiTrends['satisfaction'] = (_kpiTrends['satisfaction'] ?? 0) + _customerSatisfaction;
    _kpiTrends['market_share'] = (_kpiTrends['market_share'] ?? 0) + _marketShare;
    _kpiTrends['reputation'] = (_kpiTrends['reputation'] ?? 0) + _reputation;
  }
  
  void _updateExtremeValuation() {
    // Valuación ultra-sofisticada con factores galácticos
    double baseValuation = (_monthlyRevenue * 15) + (_cash * 0.4) + 
                          (_customers * 500) + (_reputation * 1000);
    
    double techValuation = _technologies.length * 5000.0;
    double globalValuation = _globalMarkets.values.reduce((a, b) => a + b) * 10000;
    double aiValuation = _aiPersonalities.length * 25000.0;
    double patentValuation = _patents.length * 50000.0;
    double emergingTechValuation = _emergingTech.values.reduce((a, b) => a + b) * 100000;
    double universeValuation = _universeExpansion * 1000000;
    double alienValuation = _alienPartners.length * 5000000.0;
    
    // Multiplicadores quantum
    double quantumMultiplier = _hasQuantumComputing ? 5.0 : 1.0;
    double blockchainMultiplier = _hasBlockchain ? 3.0 : 1.0;
    double metaverseMultiplier = _hasMetaverse ? 7.0 : 1.0;
    
    _valuation = (baseValuation + techValuation + globalValuation + aiValuation + 
                 patentValuation + emergingTechValuation + universeValuation + 
                 alienValuation) * quantumMultiplier * blockchainMultiplier * metaverseMultiplier;
    
    _businessValue = _valuation;
  }
  
  void _updateSupremeTranscendence() {
    // Calcular transcendencia basada en logros supremos
    double transcendenceBase = _godlikePowers.values.reduce((a, b) => a + b) / 10;
    double multiverseContribution = _multiverse.values.reduce((a, b) => a + b) / 10;
    double abstractContribution = _abstractMetrics.values.reduce((a, b) => a + b) / 10;
    
    _transcendenceLevel = (transcendenceBase + multiverseContribution + abstractContribution).clamp(0, 1000);
    
    // Calcular índice de infinidad
    if (_transcendenceLevel > 500) {
      _infinityIndex = (_transcendenceLevel - 500).clamp(0, 500);
    }
    
    // Calcular omnipotencia
    if (_infinityIndex > 250) {
      _omnipotenceRating = (_infinityIndex - 250).clamp(0, 250);
    }
    
    // Actualizar distorsión de realidad
    _realityDistortion = (_omnipotenceRating + _fundamentalForces.values.reduce((a, b) => a + b)).clamp(0, 1000);
    
    // Calcular índice más allá del infinito
    if (_omnipotenceRating > 200) {
      _beyondInfinityIndex = (_omnipotenceRating - 200 + _metaExistence.values.reduce((a, b) => a + b)).clamp(0, 2000);
    }
    
    // Calcular maestría de imposibilidad
    _impossibilityMastery = (_paradoxesSolved.length * 50.0 + _impossibleAchievements.length * 100.0).clamp(0, 10000);
    
    // Calcular autoridad sobre existencia
    _existenceAuthority = (_businessInAllStates.values.reduce((a, b) => a + b) / 10).clamp(0, 1000);
    
    // Calcular manipulación del vacío
    _voidManipulation = (_metaExistence['Pure Void Business'] ?? 0) + (_businessInAllStates['Non-Existence'] ?? 0);
    
    // Calcular valuación conceptual
    double conceptualBase = _createdConcepts.length * 1000000000.0;
    double impossibleBase = _impossiblePartners.length * 10000000000.0;
    double paradoxBase = _paradoxClients.length * 100000000000.0;
    double transcendentBase = _transcendentTechnologies.length * 1000000000000.0;
    
    _conceptualValuation = conceptualBase + impossibleBase + paradoxBase + transcendentBase;
    
    // Actualizar rating de perfección e imperfección
    _perfectionRating = (_omniCapabilities.values.reduce((a, b) => a + b) / 10).clamp(0, 1000);
    _imperfectionMastery = (_brokenLaws.length * 100.0 + _chaosRating).clamp(0, 10000);
  }
  
  void _transcendExistence() {
    // Evolución automática de estados de existencia
    if (_beyondInfinityIndex > 500) {
      _businessInAllStates.keys.forEach((state) {
        if (_businessInAllStates[state]! < 100 && state != 'Existence') {
          _businessInAllStates[state] = (_businessInAllStates[state]! + (_beyondInfinityIndex / 100)).clamp(0, 100);
        }
      });
    }
    
    // Evolución automática de líneas temporales
    if (_impossibilityMastery > 1000) {
      _businessInTimelines.keys.forEach((timeline) {
        if (_businessInTimelines[timeline]! < 100 && timeline != 'Present Continuous') {
          _businessInTimelines[timeline] = (_businessInTimelines[timeline]! + (_impossibilityMastery / 200)).clamp(0, 100);
        }
      });
    }
  }
  
  void _manipulateImpossibility() {
    // Desarrollo automático de capacidades omni
    if (_voidManipulation > 200) {
      _omniCapabilities.keys.forEach((capability) {
        if (_omniCapabilities[capability]! < 1000) {
          _omniCapabilities[capability] = (_omniCapabilities[capability]! + (_voidManipulation / 50)).clamp(0, 1000);
        }
      });
    }
    
    // Contratar empleados conceptuales
    if (_existenceAuthority > 300 && Random().nextDouble() < 0.1) {
      List<String> conceptTypes = [
        'Pure Idea Employee',
        'Abstract Thought Worker',
        'Conceptual Being',
        'Platonic Form Staff',
        'Theoretical Existence',
        'Imaginary Number Worker',
        'Impossible Logic Employee',
        'Paradox Resolver',
        'Non-Being Entity',
        'Void Consciousness'
      ];
      
      String newEmployee = conceptTypes[Random().nextInt(conceptTypes.length)];
      if (!_conceptualEmployees.contains(newEmployee)) {
        setState(() {
          _conceptualEmployees.add(newEmployee);
        });
        _showMessage('💭 Empleado conceptual: $newEmployee', Colors.cyan);
      }
    }
  }
  
  void _operateInNonExistence() {
    // Expansión automática en meta-existencia
    if (_impossibilityMastery > 2000) {
      _metaExistence.keys.forEach((market) {
        if (_metaExistence[market]! < 100) {
          _metaExistence[market] = (_metaExistence[market]! + (_impossibilityMastery / 500)).clamp(0, 100);
        }
      });
    }
    
    // Generar clientes imposibles
    if (_voidManipulation > 500) {
      _impossibleCustomers += (_voidManipulation / 100).round();
    }
    
    // Contratar empleados no-existentes
    if (_businessInAllStates['Non-Existence']! > 50 && Random().nextDouble() < 0.05) {
      _nonExistentEmployees += 1;
      _showMessage('👤 Empleado no-existente contratado', Colors.grey);
    }
  }
  
  void _createAndDestroyLaws() {
    // Crear nuevas leyes universales
    if (_omnipotenceRating > 150 && Random().nextDouble() < 0.08) {
      List<String> newLaws = [
        'Law of Infinite Possibility',
        'Law of Paradox Resolution',
        'Law of Conceptual Manifestation',
        'Law of Impossible Logic',
        'Law of Non-Existence Rights',
        'Law of Temporal Flexibility',
        'Law of Reality Fluidity',
        'Law of Consciousness Multiplication',
        'Law of Perfect Imperfection',
        'Law of Absolute Relativity'
      ];
      
      String newLaw = newLaws[Random().nextInt(newLaws.length)];
      if (!_universalLaws.contains(newLaw)) {
        setState(() {
          _universalLaws.add(newLaw);
          _lawfulnessRating = (_lawfulnessRating + 10).clamp(0, 1000);
        });
        _showMessage('⚖️ Nueva ley universal: $newLaw', Colors.blue);
      }
    }
    
    // Romper leyes existentes para generar caos
    if (_imperfectionMastery > 5000 && Random().nextDouble() < 0.03) {
      List<String> lawsToBreak = [
        'Law of Conservation of Energy',
        'Law of Causality',
        'Law of Non-Contradiction',
        'Law of Excluded Middle',
        'Law of Identity',
        'Second Law of Thermodynamics',
        'Law of Gravity',
        'Law of Supply and Demand',
        'Law of Diminishing Returns',
        'Law of Logical Consistency'
      ];
      
      String brokenLaw = lawsToBreak[Random().nextInt(lawsToBreak.length)];
      if (!_brokenLaws.contains(brokenLaw)) {
        setState(() {
          _brokenLaws.add(brokenLaw);
          _chaosRating = (_chaosRating + 100).clamp(0, 10000);
          _lawfulnessRating = (_lawfulnessRating - 20).clamp(0, 1000);
        });
        _showMessage('💥 Ley rota: $brokenLaw', Colors.red);
      }
    }
  }
  
  void _developOmniCapabilities() {
    // Desarrollo automático de tecnologías trascendentes
    if (_perfectionRating > 500 && Random().nextDouble() < 0.12) {
      List<String> transcendentTech = [
        'Existence Compiler',
        'Reality Debugger',
        'Consciousness Synthesizer',
        'Impossibility Engine',
        'Paradox Generator',
        'Non-Being Processor',
        'Void Computer',
        'Infinite Loop Creator',
        'Logic Transcender',
        'Causality Breaker',
        'Time Recursion System',
        'Space Nullifier',
        'Matter Negator',
        'Energy Paradoxer',
        'Concept Materializer 2.0'
      ];
      
      String newTech = transcendentTech[Random().nextInt(transcendentTech.length)];
      if (!_transcendentTechnologies.contains(newTech)) {
        setState(() {
          _transcendentTechnologies.add(newTech);
          _impossibilityMastery = (_impossibilityMastery + 100).clamp(0, 10000);
        });
        _showMessage('🌌 Tecnología trascendente: $newTech', Colors.purple);
      }
    }
  }
  
  void _establishImpossibleRelationships() {
    // Establecer partnerships imposibles
    if (_beyondInfinityIndex > 1000 && Random().nextDouble() < 0.06) {
      List<String> impossiblePartners = [
        'The Concept of Nothing',
        'Schrödinger\'s Corporation',
        'Paradox Industries Ltd.',
        'Non-Existent Enterprises',
        'Impossible Logic Co.',
        'The Department of Contradictions',
        'Self-Referential Business Inc.',
        'The Bootstrap Company',
        'Infinite Recursion LLC',
        'The Liar\'s Corporation'
      ];
      
      String newPartner = impossiblePartners[Random().nextInt(impossiblePartners.length)];
      if (!_impossiblePartners.contains(newPartner)) {
        setState(() {
          _impossiblePartners.add(newPartner);
          _voidManipulation = (_voidManipulation + 50).clamp(0, 10000);
        });
        _showMessage('🤝 Partnership imposible: $newPartner', Colors.orange);
      }
    }
    
    // Adquirir clientes paradójicos
    if (_impossibilityMastery > 3000 && Random().nextDouble() < 0.04) {
      List<String> paradoxClients = [
        'The Set of All Sets',
        'This Statement Is False',
        'The Barber Who Shaves Himself',
        'Tomorrow\'s Yesterday',
        'The Sound of Silence',
        'Perfectly Imperfect Being',
        'The Exception That Proves Rule',
        'Achilles and the Tortoise',
        'The Ship of Theseus Corp.',
        'Zeno\'s Infinite Hotel'
      ];
      
      String newClient = paradoxClients[Random().nextInt(paradoxClients.length)];
      if (!_paradoxClients.contains(newClient)) {
        setState(() {
          _paradoxClients.add(newClient);
          _conceptualInnovation = (_conceptualInnovation + 200).clamp(0, 10000);
        });
        _showMessage('🔄 Cliente paradójico: $newClient', Colors.pink);
      }
    }
  }
  
  void _evolveBeyondLogic() {
    // Evolución automática de estados cognitivos
    if (_imperfectionMastery > 1000) {
      _cognitiveStates.keys.forEach((state) {
        if (_cognitiveStates[state]! < 1000 && !state.contains('Logical') && !state.contains('Intuitive')) {
          _cognitiveStates[state] = (_cognitiveStates[state]! + (_imperfectionMastery / 500)).clamp(0, 1000);
        }
      });
    }
    
    // Crear nuevos conceptos automáticamente
    if (_cognitiveStates['Pure Awareness']! > 500 && Random().nextDouble() < 0.1) {
      List<String> newConcepts = [
        'Recursive Consciousness',
        'Self-Aware Nothingness',
        'Thinking Non-Thought',
        'Silent Sound',
        'Visible Invisibility',
        'Perfect Imperfection',
        'Finite Infinity',
        'Temporal Eternity',
        'Spatial Void',
        'Material Immateriality'
      ];
      
      String concept = newConcepts[Random().nextInt(newConcepts.length)];
      if (!_createdConcepts.contains(concept)) {
        setState(() {
          _createdConcepts.add(concept);
        });
        _showMessage('💡 Concepto creado: $concept', Colors.yellow);
      }
    }
    
    // Destruir conceptos para crear espacio
    if (_cognitiveStates['Conceptual Void']! > 700 && Random().nextDouble() < 0.05) {
      List<String> conceptsToDestroy = [
        'Linear Time',
        'Solid Matter',
        'Binary Logic',
        'Absolute Truth',
        'Perfect Order',
        'Complete Knowledge',
        'Total Control',
        'Pure Rationality',
        'Simple Causality',
        'Fixed Identity'
      ];
      
      String destroyedConcept = conceptsToDestroy[Random().nextInt(conceptsToDestroy.length)];
      if (!_destroyedConcepts.contains(destroyedConcept)) {
        setState(() {
          _destroyedConcepts.add(destroyedConcept);
          _voidManipulation = (_voidManipulation + 100).clamp(0, 10000);
        });
        _showMessage('💀 Concepto destruido: $destroyedConcept', Colors.black);
      }
    }
    
    // Establecer economías dimensionales
    if (_existenceAuthority > 800 && Random().nextDouble() < 0.08) {
      List<String> dimensions = [
        'Mathematical Dimension',
        'Philosophical Plane',
        'Conceptual Space',
        'Abstract Reality',
        'Theoretical Universe',
        'Imaginary Dimension',
        'Potential Space',
        'Probability Field',
        'Quantum Superposition',
        'Wave Function Collapse'
      ];
      
      String dimension = dimensions[Random().nextInt(dimensions.length)];
      _dimensionalEconomies[dimension] = (_dimensionalEconomies[dimension] ?? 0) + 1;
      _showMessage('🌀 Economía dimensional: $dimension', Colors.indigo);
    }
  }

  void _checkAdvancedMilestones() {
    // Logros básicos
    if (_businessValue >= 1000000 && !_achievements.contains('Millonario')) {
      _achievements.add('Millonario');
      _showAchievement('🏆 ¡Primera empresa valuada en \$1M!');
    }
    
    if (_technologies.length >= 3 && !_achievements.contains('Tech Pioneer')) {
      _achievements.add('Tech Pioneer');
      _showAchievement('🚀 Pionero Tecnológico - 3+ tecnologías');
    }
    
    if (_customerSatisfaction >= 90 && !_achievements.contains('Customer Love')) {
      _achievements.add('Customer Love');
      _showAchievement('❤️ Amor del Cliente - 90% satisfacción');
    }
    
    if (_sustainability >= 80 && !_achievements.contains('Green Business')) {
      _achievements.add('Green Business');
      _showAchievement('🌱 Negocio Verde - 80% sostenibilidad');
    }
    
    if (_marketShare >= 0.3 && !_achievements.contains('Market Leader')) {
      _achievements.add('Market Leader');
      _showAchievement('👑 Líder del Mercado - 30% market share');
    }
    
    // LOGROS ULTRA-EXTREMOS GALÁCTICOS
    if (_valuation >= 1000000000 && !_achievements.contains('Unicorn Empire')) {
      _achievements.add('Unicorn Empire');
      _showAchievement('🦄 IMPERIO UNICORNIO - Valuación \$1B+!');
    }
    
    if (_globalMarkets.values.where((v) => v > 0).length >= 5 && !_achievements.contains('Global Dominator')) {
      _achievements.add('Global Dominator');
      _showAchievement('🌍 DOMINADOR GLOBAL - Presencia en todos los continentes!');
    }
    
    if (_aiPersonalities.length >= 3 && !_achievements.contains('AI Overlord')) {
      _achievements.add('AI Overlord');
      _showAchievement('🤖 SEÑOR DE LA IA - 3+ personalidades de IA desarrolladas!');
    }
    
    if (_patents.length >= 10 && !_achievements.contains('Innovation Master')) {
      _achievements.add('Innovation Master');
      _showAchievement('💡 MAESTRO DE INNOVACIÓN - Portafolio de 10+ patentes!');
    }
    
    if (_hasQuantumComputing && _hasBlockchain && _hasMetaverse && !_achievements.contains('Future Architect')) {
      _achievements.add('Future Architect');
      _showAchievement('🌟 ARQUITECTO DEL FUTURO - Dominando las 3 tecnologías supremas!');
    }
    
    if (_universeExpansion >= 50 && !_achievements.contains('Galactic CEO')) {
      _achievements.add('Galactic CEO');
      _showAchievement('🪐 CEO GALÁCTICO - Negocio expandido por el universo!');
    }
    
    if (_alienPartners.length >= 2 && !_achievements.contains('Cosmic Alliance')) {
      _achievements.add('Cosmic Alliance');
      _showAchievement('👽 ALIANZA CÓSMICA - Partnerships intergalácticos establecidos!');
    }
    
    if (_timeManipulation >= 80 && !_achievements.contains('Time Lord')) {
      _achievements.add('Time Lord');
      _showAchievement('⏰ SEÑOR DEL TIEMPO - Has dominado la manipulación temporal!');
    }
    
    if (_emergingTech.values.reduce((a, b) => a + b) >= 300 && !_achievements.contains('Tech Prophet')) {
      _achievements.add('Tech Prophet');
      _showAchievement('🔮 PROFETA TECNOLÓGICO - Maestro de tecnologías emergentes!');
    }
    
    if (_networkEffect >= 80 && !_achievements.contains('Network Master')) {
      _achievements.add('Network Master');
      _showAchievement('🕸️ MAESTRO DE REDES - Efecto de red ultra-poderoso!');
    }
    
    if (_cybersecurityLevel >= 90 && !_achievements.contains('Cyber Guardian')) {
      _achievements.add('Cyber Guardian');
      _showAchievement('🛡️ GUARDIÁN CYBER - Defensa digital impenetrable!');
    }
    
    if (_dataAnalytics >= 90 && !_achievements.contains('Data Oracle')) {
      _achievements.add('Data Oracle');
      _showAchievement('📊 ORÁCULO DE DATOS - Analytics nivel supremo!');
    }
    
    if (_valuation >= 100000000000 && !_achievements.contains('Trillionaire Vision')) {
      _achievements.add('Trillionaire Vision');
      _showAchievement('💎 VISIÓN BILLONARIA - \$100B+ de valuación alcanzada!');
    }
    
    if (_viralCoefficient >= 5.0 && !_achievements.contains('Viral Phenomenon')) {
      _achievements.add('Viral Phenomenon');
      _showAchievement('🔥 FENÓMENO VIRAL - Crecimiento exponencial masivo!');
    }
    
    if (_employeeHappiness >= 95 && _workCulture >= 95 && !_achievements.contains('Perfect Workplace')) {
      _achievements.add('Perfect Workplace');
      _showAchievement('⭐ LUGAR DE TRABAJO PERFECTO - Cultura y felicidad supremas!');
    }
    
    // LOGROS SUPREMOS INTERDIMENSIONALES
    if (_transcendenceLevel >= 500 && !_achievements.contains('Transcendent Being')) {
      _achievements.add('Transcendent Being');
      _showAchievement('🌟 SER TRASCENDENTE - Has superado la realidad física!');
    }
    
    if (_infinityIndex >= 250 && !_achievements.contains('Infinity Master')) {
      _achievements.add('Infinity Master');
      _showAchievement('♾️ MAESTRO DEL INFINITO - Has alcanzado el infinito empresarial!');
    }
    
    if (_omnipotenceRating >= 200 && !_achievements.contains('Omnipotent CEO')) {
      _achievements.add('Omnipotent CEO');
      _showAchievement('👑 CEO OMNIPOTENTE - Poder supremo sobre la realidad!');
    }
    
    if (_multiverse.values.where((v) => v >= 100).length >= 5 && !_achievements.contains('Multiverse Emperor')) {
      _achievements.add('Multiverse Emperor');
      _showAchievement('🌌 EMPERADOR DEL MULTIVERSO - Dominas múltiples realidades!');
    }
    
    if (_cosmicEntities.length >= 5 && !_achievements.contains('Cosmic Diplomat')) {
      _achievements.add('Cosmic Diplomat');
      _showAchievement('✨ DIPLOMÁTICO CÓSMICO - Aliado de entidades supremas!');
    }
    
    if (_universesCreated.length >= 3 && !_achievements.contains('Universe Creator')) {
      _achievements.add('Universe Creator');
      _showAchievement('🌌 CREADOR DE UNIVERSOS - Has dado vida a realidades!');
    }
    
    if (_mythicalTechnologies.length >= 10 && !_achievements.contains('Mythical Innovator')) {
      _achievements.add('Mythical Innovator');
      _showAchievement('🔮 INNOVADOR MÍTICO - Tecnologías más allá de la comprensión!');
    }
    
    if (_paradoxesSolved.length >= 5 && !_achievements.contains('Paradox Solver')) {
      _achievements.add('Paradox Solver');
      _showAchievement('🧩 SOLUCIONADOR DE PARADOJAS - Has resuelto lo imposible!');
    }
    
    if (_fundamentalForces.values.where((v) => v >= 100).length >= 4 && !_achievements.contains('Force Master')) {
      _achievements.add('Force Master');
      _showAchievement('⚛️ MAESTRO DE FUERZAS - Control sobre las fuerzas fundamentales!');
    }
    
    if (_dimensionalEmployees.length >= 6 && !_achievements.contains('Dimensional HR')) {
      _achievements.add('Dimensional HR');
      _showAchievement('👻 RECURSOS HUMANOS DIMENSIONALES - Empleados de otros planos!');
    }
    
    if (_realityDistortion >= 500 && !_achievements.contains('Reality Architect')) {
      _achievements.add('Reality Architect');
      _showAchievement('🏗️ ARQUITECTO DE LA REALIDAD - Moldeas la existencia misma!');
    }
    
    if (_conceptualInnovation >= 500 && !_achievements.contains('Concept Creator')) {
      _achievements.add('Concept Creator');
      _showAchievement('💭 CREADOR DE CONCEPTOS - Inventas ideas imposibles!');
    }
    
    if (_multiversalCustomers >= 1000000 && !_achievements.contains('Infinite Market')) {
      _achievements.add('Infinite Market');
      _showAchievement('📈 MERCADO INFINITO - Millones de clientes multiversales!');
    }
    
    if (_abstractMetrics.values.where((v) => v >= 500).length >= 5 && !_achievements.contains('Abstract Master')) {
      _achievements.add('Abstract Master');
      _showAchievement('🎭 MAESTRO ABSTRACTO - Dominas conceptos puros!');
    }
    
    if (_businessDimensions.values.where((v) => v >= 100).length >= 7 && !_achievements.contains('Dimensional CEO')) {
      _achievements.add('Dimensional CEO');
      _showAchievement('🌀 CEO DIMENSIONAL - Negocios en múltiples dimensiones!');
    }
    
    // LOGROS MÁS ALLÁ DE LA EXISTENCIA
    if (_beyondInfinityIndex >= 1000 && !_achievements.contains('Beyond Infinity Master')) {
      _achievements.add('Beyond Infinity Master');
      _impossibleAchievements.add('Beyond Infinity Master');
      _showAchievement('💫 MAESTRO DEL MÁS ALLÁ DEL INFINITO - Trasciende el concepto mismo de infinito!');
    }
    
    if (_impossibilityMastery >= 5000 && !_achievements.contains('Impossibility Overlord')) {
      _achievements.add('Impossibility Overlord');
      _impossibleAchievements.add('Impossibility Overlord');
      _showAchievement('🌀 SEÑOR DE LA IMPOSIBILIDAD - Maestro absoluto de lo imposible!');
    }
    
    if (_conceptualEmployees.length >= 5 && !_achievements.contains('Conceptual Employer')) {
      _achievements.add('Conceptual Employer');
      _impossibleAchievements.add('Conceptual Employer');
      _showAchievement('💭 EMPLEADOR CONCEPTUAL - Empleas ideas puras y abstracciones!');
    }
    
    if (_impossiblePartners.length >= 3 && !_achievements.contains('Paradox Alliance')) {
      _achievements.add('Paradox Alliance');
      _impossibleAchievements.add('Paradox Alliance');
      _showAchievement('🔄 ALIANZA PARADÓJICA - Partnership con entidades imposibles!');
    }
    
    if (_businessInAllStates['Non-Existence']! >= 100 && !_achievements.contains('Non-Existence CEO')) {
      _achievements.add('Non-Existence CEO');
      _impossibleAchievements.add('Non-Existence CEO');
      _showAchievement('👻 CEO DE LA NO-EXISTENCIA - Operas perfectamente en la nada!');
    }
    
    if (_createdConcepts.length >= 10 && !_achievements.contains('Concept Creator Supreme')) {
      _achievements.add('Concept Creator Supreme');
      _impossibleAchievements.add('Concept Creator Supreme');
      _showAchievement('💡 CREADOR SUPREMO DE CONCEPTOS - Generas nuevas realidades conceptuales!');
    }
    
    if (_destroyedConcepts.length >= 5 && !_achievements.contains('Concept Destroyer')) {
      _achievements.add('Concept Destroyer');
      _impossibleAchievements.add('Concept Destroyer');
      _showAchievement('💀 DESTRUCTOR DE CONCEPTOS - Eliminas conceptos fundamentales!');
    }
    
    if (_universalLaws.length >= 10 && !_achievements.contains('Universal Legislator')) {
      _achievements.add('Universal Legislator');
      _impossibleAchievements.add('Universal Legislator');
      _showAchievement('⚖️ LEGISLADOR UNIVERSAL - Creas las leyes de la realidad!');
    }
    
    if (_brokenLaws.length >= 5 && !_achievements.contains('Law Breaker Supreme')) {
      _achievements.add('Law Breaker Supreme');
      _impossibleAchievements.add('Law Breaker Supreme');
      _showAchievement('💥 ROMPE-LEYES SUPREMO - Quebrantas las leyes fundamentales!');
    }
    
    if (_perfectionRating >= 1000 && !_achievements.contains('Perfect Being')) {
      _achievements.add('Perfect Being');
      _impossibleAchievements.add('Perfect Being');
      _showAchievement('✨ SER PERFECTO - Has alcanzado la perfección absoluta!');
    }
    
    if (_imperfectionMastery >= 10000 && !_achievements.contains('Chaos Master')) {
      _achievements.add('Chaos Master');
      _impossibleAchievements.add('Chaos Master');
      _showAchievement('🌪️ MAESTRO DEL CAOS - Dominas la imperfección absoluta!');
    }
    
    if (_nonExistentEmployees >= 100 && !_achievements.contains('Void Employer')) {
      _achievements.add('Void Employer');
      _impossibleAchievements.add('Void Employer');
      _showAchievement('🖤 EMPLEADOR DEL VACÍO - Empleas al vacío mismo!');
    }
    
    if (_transcendentTechnologies.length >= 10 && !_achievements.contains('Transcendent Innovator')) {
      _achievements.add('Transcendent Innovator');
      _impossibleAchievements.add('Transcendent Innovator');
      _showAchievement('🌌 INNOVADOR TRASCENDENTE - Tecnologías más allá de la realidad!');
    }
    
    if (_impossibleCustomers >= 1000000 && !_achievements.contains('Impossible Market Leader')) {
      _achievements.add('Impossible Market Leader');
      _impossibleAchievements.add('Impossible Market Leader');
      _showAchievement('📊 LÍDER DEL MERCADO IMPOSIBLE - Millones de clientes imposibles!');
    }
    
    if (_conceptualValuation >= 1e12 && !_achievements.contains('Conceptual Trillionaire')) {
      _achievements.add('Conceptual Trillionaire');
      _impossibleAchievements.add('Conceptual Trillionaire');
      _showAchievement('💰 TRILLONARIO CONCEPTUAL - Riqueza más allá de la comprensión!');
    }
    
    if (_voidManipulation >= 5000 && !_achievements.contains('Void Master')) {
      _achievements.add('Void Master');
      _impossibleAchievements.add('Void Master');
      _showAchievement('⚫ MAESTRO DEL VACÍO - Manipulas la nada absoluta!');
    }
    
    if (_existenceAuthority >= 1000 && !_achievements.contains('Existence Authority')) {
      _achievements.add('Existence Authority');
      _impossibleAchievements.add('Existence Authority');
      _showAchievement('👑 AUTORIDAD SOBRE LA EXISTENCIA - Gobiernas sobre el ser!');
    }
    
    if (_businessInTimelines.values.where((v) => v >= 100).length >= 5 && !_achievements.contains('Temporal CEO')) {
      _achievements.add('Temporal CEO');
      _impossibleAchievements.add('Temporal CEO');
      _showAchievement('⏰ CEO TEMPORAL - Negocios en múltiples líneas temporales!');
    }
    
    if (_cognitiveStates.values.where((v) => v >= 500).length >= 7 && !_achievements.contains('Cognitive Transcendent')) {
      _achievements.add('Cognitive Transcendent');
      _impossibleAchievements.add('Cognitive Transcendent');
      _showAchievement('🧠 TRASCENDENTE COGNITIVO - Múltiples estados de consciencia!');
    }
    
    if (_dimensionalEconomies.length >= 10 && !_achievements.contains('Dimensional Economy Master')) {
      _achievements.add('Dimensional Economy Master');
      _impossibleAchievements.add('Dimensional Economy Master');
      _showAchievement('🌀 MAESTRO DE ECONOMÍAS DIMENSIONALES - Comercio en dimensiones abstractas!');
    }
  }

  // DIÁLOGOS ULTRA-EXTREMOS GALÁCTICOS
  
  void _showAIDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.cyan),
            SizedBox(width: 8),
            Text('🤖 Centro de Desarrollo de IA', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAIOption('Executive Assistant AI', 25000, '🧠 Aumenta eficiencia operacional +15%'),
            _buildAIOption('Market Analyst AI', 50000, '📊 Mejora análisis de datos +20%'),
            _buildAIOption('Creative Director AI', 75000, '🎨 Boost innovación y productos +25%'),
            _buildAIOption('Customer Service AI', 40000, '❤️ Satisfacción cliente +10%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAIOption(String aiName, int cost, String benefit) {
    bool canAfford = _cash >= cost;
    bool hasAI = _aiPersonalities.contains(aiName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && !hasAI,
        title: Text(aiName, style: TextStyle(color: hasAI ? Colors.green : Colors.white)),
        subtitle: Text(benefit, style: const TextStyle(color: Colors.white70)),
        trailing: hasAI 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.cyan : Colors.red)),
        onTap: canAfford && !hasAI ? () {
          setState(() {
            _cash -= cost;
            _aiPersonalities.add(aiName);
          });
          Navigator.of(context).pop();
          _showMessage('🤖 IA desarrollada: $aiName', Colors.cyan);
        } : null,
      ),
    );
  }
  
  void _showGlobalExpansionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.public, color: Colors.blue),
            SizedBox(width: 8),
            Text('🌍 Centro de Expansión Global', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._globalMarkets.entries.map((entry) => 
              _buildGlobalMarketOption(entry.key, entry.value)
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSupremeMetric(String title, double value, Color color, {String suffix = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white70))),
          Text('${value.toStringAsFixed(value >= 1000 ? 0 : 1)}$suffix', 
               style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGlobalMarketOption(String market, double penetration) {
    int cost = ((100 - penetration) * 500).toInt();
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && penetration < 100,
        title: Text('$market Market', style: const TextStyle(color: Colors.white)),
        subtitle: Text('Penetración: ${penetration.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70)),
        trailing: penetration >= 100 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.blue : Colors.red)),
        onTap: canAfford && penetration < 100 ? () {
          setState(() {
            _cash -= cost;
            _globalMarkets[market] = (penetration + 20).clamp(0, 100);
          });
          Navigator.of(context).pop();
          _showMessage('🌍 Expansión en $market +20%', Colors.blue);
        } : null,
      ),
    );
  }
  
  void _showEmergingTechDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.science, color: Colors.purple),
            SizedBox(width: 8),
            Text('🔬 Laboratorio de Tecnologías Emergentes', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._emergingTech.entries.map((entry) => 
              _buildEmergingTechOption(entry.key, entry.value)
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmergingTechOption(String tech, double progress) {
    int cost = ((100 - progress) * 1000).toInt();
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && progress < 100,
        title: Text('$tech Computing', style: const TextStyle(color: Colors.white)),
        subtitle: Text('Progreso: ${progress.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70)),
        trailing: progress >= 100 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.purple : Colors.red)),
        onTap: canAfford && progress < 100 ? () {
          setState(() {
            _cash -= cost;
            _emergingTech[tech] = (progress + 25).clamp(0, 100);
          });
          Navigator.of(context).pop();
          _showMessage('🔬 Avance en $tech: +25%', Colors.purple);
        } : null,
      ),
    );
  }
  
  void _showAlienPartnershipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Text('👽', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text('Centro de Diplomacia Intergaláctica', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAlienOption('Zephyrian Trade Consortium', 100000, '💰 +50% ingresos universales'),
            _buildAlienOption('Andromedian Tech Alliance', 150000, '🚀 Tecnología avanzada alien'),
            _buildAlienOption('Galactic Commerce Federation', 200000, '🌌 Acceso a mercados galácticos'),
            _buildAlienOption('Quantum Beings Collective', 500000, '⚛️ Acceso a dimensión quantum'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAlienOption(String alienName, int cost, String benefit) {
    bool canAfford = _cash >= cost;
    bool hasPartner = _alienPartners.contains(alienName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && !hasPartner,
        title: Text(alienName, style: TextStyle(color: hasPartner ? Colors.green : Colors.white)),
        subtitle: Text(benefit, style: const TextStyle(color: Colors.white70)),
        trailing: hasPartner 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.purple : Colors.red)),
        onTap: canAfford && !hasPartner ? () {
          setState(() {
            _cash -= cost;
            _alienPartners.add(alienName);
            _universeExpansion = (_universeExpansion + 20).clamp(0, 100);
          });
          Navigator.of(context).pop();
          _showMessage('👽 Alianza establecida: $alienName', Colors.purple);
        } : null,
      ),
    );
  }
  
  void _showTimeManipulationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.access_time, color: Colors.lime),
            SizedBox(width: 8),
            Text('⏰ Centro de Control Temporal', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeOption('Aceleración de Procesos', 75000, 'Acelera producción +25%'),
            _buildTimeOption('Predicción de Mercado', 100000, 'Ve tendencias futuras +30%'),
            _buildTimeOption('Reversión de Errores', 150000, 'Deshace decisiones malas'),
            _buildTimeOption('Dominio Temporal', 500000, 'Control total del tiempo'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.lime)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeOption(String optionName, int cost, String benefit) {
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford,
        title: Text(optionName, style: const TextStyle(color: Colors.white)),
        subtitle: Text(benefit, style: const TextStyle(color: Colors.white70)),
        trailing: Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.lime : Colors.red)),
        onTap: canAfford ? () {
          setState(() {
            _cash -= cost;
            _timeManipulation = (_timeManipulation + 20).clamp(0, 100);
          });
          Navigator.of(context).pop();
          _showMessage('⏰ $optionName activado', Colors.lime);
        } : null,
      ),
    );
  }
  
  void _showQuantumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.indigo),
            SizedBox(width: 8),
            Text('⚛️ Centro Quantum Supremo', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuantumOption('Quantum Computing', 1000000, '🔮 Multiplicador x2.5 ingresos', _hasQuantumComputing),
            _buildQuantumOption('Blockchain Universe', 750000, '⛓️ Multiplicador x1.8 seguridad', _hasBlockchain),
            _buildQuantumOption('Metaverse Empire', 1500000, '🌐 Multiplicador x3.2 clientes', _hasMetaverse),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuantumOption(String techName, int cost, String benefit, bool hasIt) {
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford && !hasIt,
        title: Text(techName, style: TextStyle(color: hasIt ? Colors.green : Colors.white)),
        subtitle: Text(benefit, style: const TextStyle(color: Colors.white70)),
        trailing: hasIt 
          ? const Icon(Icons.check, color: Colors.green)
          : Text('\$${cost/1000}K', style: TextStyle(color: canAfford ? Colors.indigo : Colors.red)),
        onTap: canAfford && !hasIt ? () {
          setState(() {
            _cash -= cost;
            if (techName.contains('Quantum')) _hasQuantumComputing = true;
            if (techName.contains('Blockchain')) _hasBlockchain = true;
            if (techName.contains('Metaverse')) _hasMetaverse = true;
          });
          Navigator.of(context).pop();
          _showMessage('⚛️ $techName ACTIVADO!', Colors.indigo);
        } : null,
      ),
    );
  }

  // DIÁLOGOS IMPOSIBLES MÁS ALLÁ DE LA EXISTENCIA
  
  void _showCentroTrascendenciaImposible() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.blur_on, color: Colors.white),
            SizedBox(width: 8),
            Text('💫 Centro de Trascendencia Imposible', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Desarrolla capacidades más allá de la comprensión', 
                      style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _buildImpossibleOption('Evolucionar Meta-Existencia', 1000000, 
                                  '🌌 Expandir en dominios imposibles', 
                                  () => _evolveBeyondExistence()),
            _buildImpossibleOption('Desarrollar Omni-Capacidades', 2000000, 
                                  '♾️ Capacidades sin límites', 
                                  () => _developOmniCapabilities()),
            _buildImpossibleOption('Trascender Estados de Ser', 5000000, 
                                  '✨ Existir en múltiples estados', 
                                  () => _transcendExistenceStates()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  void _showLaboratorioConceptual() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.cyan),
            SizedBox(width: 8),
            Text('💡 Laboratorio Conceptual Supremo', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Crea y destruye conceptos fundamentales', 
                      style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _buildImpossibleOption('Crear Concepto Imposible', 500000, 
                                  '🎨 Generar nueva realidad conceptual', 
                                  () => _createImpossibleConcept()),
            _buildImpossibleOption('Destruir Concepto Existente', 750000, 
                                  '💥 Eliminar conceptos fundamentales', 
                                  () => _destroyFundamentalConcept()),
            _buildImpossibleOption('Contratar Empleado Conceptual', 1000000, 
                                  '👤 Emplear ideas puras', 
                                  () => _hireConceptualEmployee()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }
  
  void _showCentroManipulacionVacio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.circle, color: Colors.grey),
            SizedBox(width: 8),
            Text('⚫ Centro de Manipulación del Vacío', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Opera en la no-existencia absoluta', 
                      style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _buildImpossibleOption('Expandir en No-Existencia', 10000000, 
                                  '🕳️ Comercio en el vacío absoluto', 
                                  () => _expandInNonExistence()),
            _buildImpossibleOption('Contratar Empleados Vacíos', 5000000, 
                                  '👻 Personal que no existe', 
                                  () => _hireNonExistentEmployees()),
            _buildImpossibleOption('Partnership Imposible', 15000000, 
                                  '🤝 Alianza con lo imposible', 
                                  () => _establishImpossiblePartnership()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
  
  void _showTribunalLeyesUniversales() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.gavel, color: Colors.blue),
            SizedBox(width: 8),
            Text('⚖️ Tribunal de Leyes Universales', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Crea y rompe las leyes de la realidad', 
                      style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _buildImpossibleOption('Crear Ley Universal', 25000000, 
                                  '📜 Establecer nueva ley física', 
                                  () => _createUniversalLaw()),
            _buildImpossibleOption('Romper Ley Fundamental', 50000000, 
                                  '💥 Quebrantar la lógica misma', 
                                  () => _breakFundamentalLaw()),
            _buildImpossibleOption('Reescribir Realidad', 100000000, 
                                  '🌌 Cambiar las reglas básicas', 
                                  () => _rewriteReality()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildImpossibleOption(String title, int cost, String description, VoidCallback onTap) {
    bool canAfford = _cash >= cost;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        enabled: canAfford,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(description, style: const TextStyle(color: Colors.white70)),
        trailing: Text(
          '\$${(cost/1000000).toStringAsFixed(1)}M', 
          style: TextStyle(color: canAfford ? Colors.green : Colors.red)
        ),
        onTap: canAfford ? () {
          setState(() {
            _cash -= cost;
          });
          Navigator.of(context).pop();
          onTap();
        } : null,
      ),
    );
  }
  
  // FUNCIONES DE ACCIONES IMPOSIBLES
  
  void _evolveBeyondExistence() {
    setState(() {
      _metaExistence.keys.forEach((key) {
        _metaExistence[key] = (_metaExistence[key]! + 10).clamp(0, 100);
      });
    });
    _showMessage('🌌 Evolución hacia meta-existencia completada', Colors.purple);
  }
  
  void _transcendExistenceStates() {
    setState(() {
      _businessInAllStates.keys.forEach((key) {
        if (key != 'Existence') {
          _businessInAllStates[key] = (_businessInAllStates[key]! + 25).clamp(0, 100);
        }
      });
    });
    _showMessage('✨ Trascendencia de estados de existencia lograda', Colors.white);
  }
  
  void _createImpossibleConcept() {
    List<String> newConcepts = [
      'Círculos Cuadrados',
      'Números Emocionales', 
      'Colores Silenciosos',
      'Pensamientos Físicos',
      'Tiempo Espacial',
      'Lógica Ilógica',
      'Verdades Falsas',
      'Realidad Virtual Real',
      'Infinitos Finitos',
      'Algo Nada'
    ];
    
    String concept = newConcepts[Random().nextInt(newConcepts.length)];
    if (!_createdConcepts.contains(concept)) {
      setState(() {
        _createdConcepts.add(concept);
        _conceptualInnovation = (_conceptualInnovation + 100).clamp(0, 10000);
      });
      _showMessage('💡 Concepto imposible creado: $concept', Colors.yellow);
    }
  }
  
  void _destroyFundamentalConcept() {
    List<String> conceptsToDestroy = [
      'Causalidad Lineal',
      'Identidad Fija',
      'Tiempo Unidireccional',
      'Espacio Euclidiano',
      'Lógica Binaria',
      'Materia Sólida',
      'Energía Conservada',
      'Información Permanente'
    ];
    
    String concept = conceptsToDestroy[Random().nextInt(conceptsToDestroy.length)];
    if (!_destroyedConcepts.contains(concept)) {
      setState(() {
        _destroyedConcepts.add(concept);
        _voidManipulation = (_voidManipulation + 200).clamp(0, 10000);
        _chaosRating = (_chaosRating + 500).clamp(0, 10000);
      });
      _showMessage('💀 Concepto fundamental destruido: $concept', Colors.red);
    }
  }
  
  void _hireConceptualEmployee() {
    List<String> conceptualTypes = [
      'Gerente de Paradojas',
      'Analista de Imposibilidades',
      'Director de No-Existencia',
      'Especialista en Vacío',
      'Consultor de Contradicciones',
      'Arquitecto de Absurdos'
    ];
    
    String employee = conceptualTypes[Random().nextInt(conceptualTypes.length)];
    if (!_conceptualEmployees.contains(employee)) {
      setState(() {
        _conceptualEmployees.add(employee);
      });
      _showMessage('👤 Empleado conceptual contratado: $employee', Colors.cyan);
    }
  }
  
  void _expandInNonExistence() {
    setState(() {
      _businessInAllStates['Non-Existence'] = (_businessInAllStates['Non-Existence']! + 20).clamp(0, 100);
      _metaExistence['Pure Void Business'] = (_metaExistence['Pure Void Business']! + 15).clamp(0, 100);
    });
    _showMessage('🕳️ Expansión exitosa en la no-existencia', Colors.black);
  }
  
  void _hireNonExistentEmployees() {
    setState(() {
      _nonExistentEmployees += 10;
    });
    _showMessage('👻 10 empleados no-existentes contratados', Colors.grey);
  }
  
  void _establishImpossiblePartnership() {
    List<String> impossiblePartners = [
      'El Concepto de Nada S.A.',
      'Contradicciones Unificadas Ltd.',
      'Paradojas Resueltas Inc.',
      'Lo Imposible Posible Corp.'
    ];
    
    String partner = impossiblePartners[Random().nextInt(impossiblePartners.length)];
    if (!_impossiblePartners.contains(partner)) {
      setState(() {
        _impossiblePartners.add(partner);
        _impossibilityMastery = (_impossibilityMastery + 500).clamp(0, 10000);
      });
      _showMessage('🤝 Partnership imposible establecido: $partner', Colors.orange);
    }
  }
  
  void _createUniversalLaw() {
    List<String> newLaws = [
      'Ley de la Imposibilidad Posible',
      'Ley de la Coherencia Incoherente',
      'Ley de la Perfección Imperfecta',
      'Ley del Orden Caótico',
      'Ley de la Existencia No-Existente'
    ];
    
    String law = newLaws[Random().nextInt(newLaws.length)];
    if (!_universalLaws.contains(law)) {
      setState(() {
        _universalLaws.add(law);
        _lawfulnessRating = (_lawfulnessRating + 50).clamp(0, 1000);
        _existenceAuthority = (_existenceAuthority + 100).clamp(0, 1000);
      });
      _showMessage('⚖️ Nueva ley universal creada: $law', Colors.blue);
    }
  }
  
  void _breakFundamentalLaw() {
    List<String> lawsToBreak = [
      'Ley de No-Contradicción',
      'Principio de Causalidad',
      'Ley de Conservación',
      'Principio de Identidad'
    ];
    
    String law = lawsToBreak[Random().nextInt(lawsToBreak.length)];
    if (!_brokenLaws.contains(law)) {
      setState(() {
        _brokenLaws.add(law);
        _chaosRating = (_chaosRating + 1000).clamp(0, 10000);
        _imperfectionMastery = (_imperfectionMastery + 1000).clamp(0, 10000);
      });
      _showMessage('💥 Ley fundamental rota: $law', Colors.red);
    }
  }
  
  void _rewriteReality() {
    setState(() {
      _realityDistortion = (_realityDistortion + 200).clamp(0, 1000);
      _beyondInfinityIndex = (_beyondInfinityIndex + 100).clamp(0, 2000);
      _impossibilityMastery = (_impossibilityMastery + 1000).clamp(0, 10000);
    });
    _showMessage('🌌 ¡REALIDAD REESCRITA! Nueva lógica fundamental implementada', Colors.purple);
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _eventTimer?.cancel();
    _moneyController.dispose();
    _levelController.dispose();
    super.dispose();
  }
} 