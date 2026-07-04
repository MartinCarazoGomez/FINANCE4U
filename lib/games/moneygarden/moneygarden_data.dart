import 'package:flutter/material.dart';

/// Datos estáticos de MoneyGarden: tarjetas educativas, diálogos del mentor
/// (Coach Kai) y opciones de avatar. Separados de la lógica del motor.

class Flashcard {
  final String id;
  final String emoji;
  final String title;
  final String body;
  final String example;

  const Flashcard({
    required this.id,
    required this.emoji,
    required this.title,
    required this.body,
    required this.example,
  });
}

/// IDs de disparadores de tarjetas (una sola vez por partida).
class CardTrigger {
  static const variableCost = 'variable_cost';
  static const fixedCost = 'fixed_cost';
  static const taxes = 'taxes';
  static const credit = 'credit';
  static const savings = 'savings';
}

const kFlashcards = <String, Flashcard>{
  CardTrigger.variableCost: Flashcard(
    id: CardTrigger.variableCost,
    emoji: '📦',
    title: 'Gasto variable',
    body: 'Este gasto depende de ti. Cuanta más mercancía compras para vender, '
        'más gastas ahora, pero también más puedes ganar después.',
    example:
        'Si compras más bocadillos para vender en el recreo, gastas más en '
        'ingredientes, pero puedes vender más.',
  ),
  CardTrigger.fixedCost: Flashcard(
    id: CardTrigger.fixedCost,
    emoji: '🏠',
    title: 'Gasto fijo',
    body: 'Este gasto no perdona. Lo tienes que pagar cada mes, vendas mucho '
        'o poco.',
    example:
        'El alquiler de un local se paga igual aunque ese mes vendas menos.',
  ),
  CardTrigger.taxes: Flashcard(
    id: CardTrigger.taxes,
    emoji: '🏛️',
    title: 'Impuestos',
    body: 'Una parte va a lo de todos. Cuando ganas dinero, entregas una parte '
        'al Estado, que la usa para colegios, hospitales y carreteras.',
    example:
        'Es como poner una moneda en un bote común que luego se usa para '
        'arreglar el parque del barrio.',
  ),
  CardTrigger.credit: Flashcard(
    id: CardTrigger.credit,
    emoji: '🏦',
    title: 'Crédito',
    body: 'Pedir prestado tiene un precio. Cuando alguien te presta dinero, '
        'luego devuelves más de lo que te prestaron: ese extra es el interés.',
    example:
        'Si un amigo te presta 10 y le devuelves 11, ese 1 de más es el coste '
        'de que te ayudara.',
  ),
  CardTrigger.savings: Flashcard(
    id: CardTrigger.savings,
    emoji: '🐷',
    title: 'Ahorro',
    body: 'Guarda antes de gastar. Apartar una parte de lo que ganas te protege '
        'cuando llega un mes malo o un gasto inesperado.',
    example:
        'Guardar parte de tu paga semanal para cuando quieras algo especial '
        'sin tener que pedirlo.',
  ),
};

class MentorLine {
  final String text;
  const MentorLine(this.text);
}

/// Onboarding narrativo del Mes 1 (Coach Kai).
const kOnboarding = <MentorLine>[
  MentorLine(
    '¡Hola! Soy Coach Kai 🧢 y voy a ayudarte a levantar tu propio negocio.',
  ),
  MentorLine(
    'Acabas de abrir un pequeño puesto de ropa. Tú decides qué comprar, a '
        'quién vender y cómo cuidar tu dinero.',
  ),
  MentorLine(
    'El objetivo: que tu negocio sobreviva y crezca durante 12 meses sin '
        'quedarte sin dinero.',
  ),
  MentorLine(
    'Es sencillo: compras camisetas al proveedor, las vendes a tus clientes, '
        'y cada mes pagas tus gastos.',
  ),
  MentorLine(
    'Tienes 100 monedas y muchas ganas. ¿Empezamos? 🚀',
  ),
];

/// Frases contextuales del mentor por evento.
class MentorSays {
  static const firstBuy =
      'Buena elección. Acabas de invertir tu dinero en producto para vender. '
      'Cuanto más compres, más podrás vender... pero también gastas más ahora. '
      'Encuentra tu equilibrio.';
  static const firstSell =
      '¡Ahí está tu primera venta! ¿Ves cómo el dinero que ganas viene directo '
      'de tu esfuerzo? Sigue así.';
  static const firstFixed =
      'Este pago te toca cada mes, vendas mucho o poco. Es tu gasto fijo. '
      'Tenlo siempre en cuenta antes de gastar de más.';
  static const monthClose =
      'Has comprado, vendido y pagado tus gastos como un profesional. '
      'Vamos a ver cómo te ha ido.';
  static const needMoreSales =
      'Aún no has vendido lo suficiente este mes. ¡Ve a la tienda y atiende a '
      'más clientes antes de cerrar!';
  static const impago =
      'No te ha llegado para pagar. No pasa nada, pero baja tu reputación y '
      'vendrán menos clientes. Intenta vender más el mes que viene.';
}

/// Opciones de avatar para personalización.
class AvatarOption {
  final String emoji;
  final String label;
  const AvatarOption(this.emoji, this.label);
}

const kAvatarOptions = <AvatarOption>[
  AvatarOption('🧑', 'Álex'),
  AvatarOption('👩', 'Lucía'),
  AvatarOption('👨', 'Marco'),
  AvatarOption('🧑‍🦱', 'Sam'),
  AvatarOption('👧', 'Nora'),
  AvatarOption('👦', 'Leo'),
  AvatarOption('🧑‍🦰', 'Robin'),
  AvatarOption('🧕', 'Aya'),
];

/// Paleta MoneyGarden (vaporwave suave, apto para 10-18 años).
class MgColors {
  static const bg = Color(0xFF141B2E);
  static const bgSoft = Color(0xFF1E2A44);
  static const green = Color(0xFF3DDC84);
  static const cyan = Color(0xFF35D6ED);
  static const magenta = Color(0xFFFF6FB5);
  static const yellow = Color(0xFFFFD34E);
  static const coin = Color(0xFFFFC531);
}
