// Sistema de puntos y recompensas
class GameRewards {
  static const Map<String, int> pointsPerLevel = {
    'budget_master': 100,
    'credit_score': 150,
    'debt_destroyer': 200,
    'emergency_fund': 250,
    'entrepreneur': 300,
    'trading': 350,
    'real_estate': 400,
    'insurance': 450,
    'retirement': 500,
    'smart_shopper': 550,
  };

  static const Map<String, String> powerUps = {
    'budget_master': '💰 Extra Income: Añade ingresos extra por un mes',
    'credit_score': '📊 Score Boost: Mejora temporal del credit score',
    'debt_destroyer': '💥 Debt Freeze: Congela intereses por un mes',
    'emergency_fund': '🛡️ Safety Net: Protección contra emergencias',
    'entrepreneur': '🚀 Business Boost: Mejora temporal de ventas',
    'trading': '📈 Market Insight: Información privilegiada del mercado',
    'real_estate': '🏠 Property Bonus: Descuento en compra de propiedades',
    'insurance': '🛡️ Coverage Plus: Cobertura adicional temporal',
    'retirement': '🌅 Future Vision: Vista previa de inversiones futuras',
    'smart_shopper': '🛒 Discount Master: Descuentos especiales',
  };
} 