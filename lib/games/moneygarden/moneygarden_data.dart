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

/// Opciones de avatar para personalización (estilo selección de personaje AAA).
/// Los stats son puramente cosméticos: dan personalidad, no cambian la partida.
class AvatarOption {
  final String emoji;
  final String label;
  final String title;
  final String bio;
  final Color color;
  final String image;
  final int vision; // 1-5
  final int carisma; // 1-5
  final int audacia; // 1-5
  const AvatarOption(
    this.emoji,
    this.label, {
    required this.title,
    required this.bio,
    required this.color,
    required this.image,
    required this.vision,
    required this.carisma,
    required this.audacia,
  });
}

// Todos los personajes reparten 9 puntos entre visión, carisma y audacia,
// y ninguna combinación se repite: cada uno tiene un perfil único.
const kAvatarOptions = <AvatarOption>[
  AvatarOption('🧑', 'Álex',
      title: 'El Equilibrado',
      bio: 'Ni un euro de más, ni una oportunidad de menos. Siempre en calma.',
      color: Color(0xFF35D6ED),
      image: 'assets/moneygarden/mg_char_alex.jpg',
      vision: 3,
      carisma: 3,
      audacia: 3),
  AvatarOption('👩', 'Lucía',
      title: 'La Estratega',
      bio: 'Planea cada mes como una partida de ajedrez. Nada la sorprende.',
      color: Color(0xFFFF6FB5),
      image: 'assets/moneygarden/mg_char_lucia.jpg',
      vision: 5,
      carisma: 2,
      audacia: 2),
  AvatarOption('👨', 'Marco',
      title: 'El Negociador',
      bio: 'Consigue el mejor precio hasta en el mercadillo. Pura labia.',
      color: Color(0xFFFFD34E),
      image: 'assets/moneygarden/mg_char_marco.jpg',
      vision: 1,
      carisma: 5,
      audacia: 3),
  AvatarOption('👧', 'Nora',
      title: 'La Visionaria',
      bio: 'Apunta lejos y ahorra hoy. Su hucha es legendaria.',
      color: Color(0xFF3DDC84),
      image: 'assets/moneygarden/mg_char_nora.jpg',
      vision: 4,
      carisma: 2,
      audacia: 3),
  AvatarOption('👦', 'Leo',
      title: 'El Audaz',
      bio: 'Sin miedo al riesgo. A veces gana mucho... y a veces aprende mucho.',
      color: Color(0xFFFF8A5C),
      image: 'assets/moneygarden/mg_char_leo.jpg',
      vision: 2,
      carisma: 2,
      audacia: 5),
  AvatarOption('🧑‍🦰', 'Robin',
      title: 'El Analista',
      bio: 'Los números le hablan. Nunca paga de más una factura.',
      color: Color(0xFF5CC8FF),
      image: 'assets/moneygarden/mg_char_robin.jpg',
      vision: 4,
      carisma: 1,
      audacia: 4),
  AvatarOption('🧕', 'Aya',
      title: 'La Constante',
      bio: 'Paso a paso, mes a mes. La disciplina es su superpoder.',
      color: Color(0xFFFFC531),
      image: 'assets/moneygarden/mg_char_aya.jpg',
      vision: 3,
      carisma: 4,
      audacia: 2),
  AvatarOption('🧑🏿', 'André',
      title: 'El Líder',
      bio: 'Cuando habla, el equipo escucha. Nació para dirigir.',
      color: Color(0xFF4D7CFE),
      image: 'assets/moneygarden/mg_char_andre.jpg',
      vision: 2,
      carisma: 4,
      audacia: 3),
  AvatarOption('👨🏿‍🦱', 'Kofi',
      title: 'El Emprendedor',
      bio: 'Cada problema es una idea de negocio esperando su momento.',
      color: Color(0xFF2EE6C8),
      image: 'assets/moneygarden/mg_char_kofi.jpg',
      vision: 3,
      carisma: 2,
      audacia: 4),
  AvatarOption('🧔🏽', 'Omar',
      title: 'El Prudente',
      bio: 'Piensa dos veces, gasta una. La paciencia siempre paga.',
      color: Color(0xFF58C97B),
      image: 'assets/moneygarden/mg_char_omar.jpg',
      vision: 4,
      carisma: 3,
      audacia: 2),
  AvatarOption('👨🏻', 'Wei',
      title: 'El Metódico',
      bio: 'Método, orden y visión a largo plazo. Nunca improvisa.',
      color: Color(0xFFE85D5D),
      image: 'assets/moneygarden/mg_char_wei.jpg',
      vision: 5,
      carisma: 1,
      audacia: 3),
  AvatarOption('🧑🏻', 'Kenji',
      title: 'El Disciplinado',
      bio: 'Rutina impecable, cuentas impecables. La constancia es su camino.',
      color: Color(0xFFB8C6DB),
      image: 'assets/moneygarden/mg_char_kenji.jpg',
      vision: 2,
      carisma: 3,
      audacia: 4),
  AvatarOption('👩🏿', 'Amara',
      title: 'La Carismática',
      bio: 'Ilumina la sala al entrar. Vender es su lenguaje natural.',
      color: Color(0xFFC44DFF),
      image: 'assets/moneygarden/mg_char_amara.jpg',
      vision: 2,
      carisma: 5,
      audacia: 2),
  AvatarOption('👱‍♀️', 'Katya',
      title: 'La Calculadora',
      bio: 'Fría con los números, implacable con las gangas.',
      color: Color(0xFF9BE8FF),
      image: 'assets/moneygarden/mg_char_katya.jpg',
      vision: 5,
      carisma: 3,
      audacia: 1),
  AvatarOption('👩🏽', 'Valentina',
      title: 'La Apasionada',
      bio: 'Pone el corazón en todo, hasta en su presupuesto.',
      color: Color(0xFFFF3D71),
      image: 'assets/moneygarden/mg_char_valentina.jpg',
      vision: 1,
      carisma: 4,
      audacia: 4),
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
