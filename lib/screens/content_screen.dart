import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/progress_service.dart';
import 'achievements_screen.dart';
import 'statistics_screen.dart';
import 'quick_practice_screen.dart';
import 'settings_screen.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      Topic(
        title: 'Ahorros',
        icon: Icons.savings,
        iconBg: const Color(0xFFD6F5E3),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Métodos para ahorrar dinero y construir un fondo de emergencia.',
        pillColor: const Color(0xFF7ED957),
        pills: savingsPills,
      ),
      Topic(
        title: 'Impuestos',
        icon: Icons.receipt_long,
        iconBg: const Color(0xFFFFE6E6),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Entender los impuestos en España y cómo afectan a tus finanzas.',
        pillColor: const Color(0xFFFF6B6B),
        pills: taxesPills,
      ),
      Topic(
        title: 'Inversiones',
        icon: Icons.trending_up,
        iconBg: const Color(0xFFD6E8F5),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Diferentes tipos de inversiones y cómo empezar.',
        pillColor: const Color(0xFF7EC6F5),
        pills: investmentPills,
      ),
      Topic(
        title: 'Presupuesto',
        icon: Icons.attach_money,
        iconBg: const Color(0xFFFFF5D6),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Crear y mantener un presupuesto personal o familiar.',
        pillColor: const Color(0xFFFFE066),
        pills: budgetPills,
      ),
      Topic(
        title: 'Emprendimiento',
        icon: Icons.business,
        iconBg: const Color(0xFFE8D6F5),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Conceptos básicos para crear y administrar un negocio.',
        pillColor: const Color(0xFFB57EDC),
        pills: entrepreneurshipPills,
      ),
      Topic(
        title: 'Deudas y Crédito',
        icon: Icons.credit_card,
        iconBg: const Color(0xFFF5E6E6),
        iconColor: const Color(0xFF1B6B4B),
        description: 'Cómo manejar deudas y mejorar tu historial crediticio.',
        pillColor: const Color(0xFFFFA07A),
        pills: debtPills,
      ),
      Topic(
        title: 'Seguros y Protección',
        icon: Icons.shield,
        iconBg: const Color(0xFFE6F5F2),
        iconColor: const Color(0xFF1B6B4B),
        description: 'La importancia de los seguros y cómo elegirlos.',
        pillColor: const Color(0xFF7ED9C2),
        pills: insurancePills,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width < 1200 ? 16 : 20, 
                20, 
                MediaQuery.of(context).size.width < 1200 ? 16 : 20, 
                0
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: MediaQuery.of(context).size.width < 1200 ? 32 : 40),
                  SizedBox(width: MediaQuery.of(context).size.width < 1200 ? 8 : 12),
                  Expanded(
                    child: Text(
                      'Lecciones Financieras',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 1200 ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B6B4B),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        icon: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.menu,
                            color: Color(0xFF1B6B4B),
                            size: MediaQuery.of(context).size.width < 1200 ? 24 : 28,
                          ),
                        ),
                        padding: MediaQuery.of(context).size.width < 1200 ? EdgeInsets.all(4) : EdgeInsets.all(8),
                        constraints: MediaQuery.of(context).size.width < 1200 ? BoxConstraints(minWidth: 32, minHeight: 32) : null,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        onSelected: (value) {
                          switch (value) {
                            case 'achievements':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const AchievementsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                            case 'statistics':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const StatisticsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                            case 'quick_practice':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const QuickPracticeScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                            case 'settings':
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                ),
                              );
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'achievements',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.stars, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Logros', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'statistics',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.analytics, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Estadísticas', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'quick_practice',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.flash_on, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Práctica Rápida', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'settings',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Color(0xFF1B6B4B), size: 20),
                                  SizedBox(width: 12),
                                  Text('Ajustes', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tarjetas de progreso
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width < 1200 ? 16 : 20, 
                16, 
                MediaQuery.of(context).size.width < 1200 ? 16 : 20, 
                0
              ),
              child: Row(
                children: [
                  _ProgressCard(
                    title: 'Completadas',
                    value: '3/30',
                    color: Color(0xFF1B6B4B),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width < 1200 ? 12 : 16),
                  _ProgressCard(
                    title: 'Racha',
                    value: '3 días',
                    color: Color(0xFF1B6B4B),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Lista de categorías
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: topics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final t = topics[i];
                  return _LessonCard(
                    icon: t.icon,
                    iconBg: t.iconBg,
                    iconColor: t.iconColor,
                    title: t.title,
                    description: t.description,
                    pillColor: t.pillColor,
                    pillText: '5 píldoras educativas',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TopicDetailScreen(topic: t),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _ProgressCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width < 1200 ? 12 : 16, 
          horizontal: MediaQuery.of(context).size.width < 1200 ? 8 : 12
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width < 1200 ? 13 : 15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width < 1200 ? 18 : 20,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;
  final Color pillColor;
  final String pillText;
  final VoidCallback onTap;

  const _LessonCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.pillColor,
    required this.pillText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBg,
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1B6B4B),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: pillColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                pillText,
                style: TextStyle(
                  color: pillColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF1B6B4B)),
        onTap: onTap,
      ),
    );
  }
}

// Modelos de datos
class Topic {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String description;
  final Color pillColor;
  final List<EduPill> pills;
  Topic({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.description,
    required this.pillColor,
    required this.pills,
  });
}

class EduPill {
  final String type;
  final Color typeColor;
  final String title;
  final String shortDesc;
  final String content;
  final PillQuiz quiz;
  EduPill({
    required this.type,
    required this.typeColor,
    required this.title,
    required this.shortDesc,
    required this.content,
    required this.quiz,
  });
}

class PillQuiz {
  final String question;
  final List<String> options;
  final int correctIndex;
  PillQuiz({required this.question, required this.options, required this.correctIndex});
  
  // Método para obtener las opciones en orden aleatorio
  List<String> getShuffledOptions() {
    final shuffled = List<String>.from(options);
    shuffled.shuffle();
    return shuffled;
  }
  
  // Método para obtener el índice correcto después del shuffle
  int getCorrectIndexAfterShuffle(List<String> shuffledOptions) {
    final correctAnswer = options[correctIndex];
    return shuffledOptions.indexOf(correctAnswer);
  }
}

// --- PÍLDORAS POR TEMA (EJEMPLO REALISTA) ---
final List<EduPill> savingsPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED957),
    title: 'Regla 50/30/20',
    shortDesc: 'Aprende a distribuir tus ingresos para ahorrar de forma efectiva.',
    content: '''La regla 50/30/20 es una estrategia sencilla y popular en España para organizar tu presupuesto mensual:

- 50% de tus ingresos netos se destinan a necesidades básicas: alquiler o hipoteca (700-1.200 € en ciudades grandes), suministros (100 €), alimentación (250 €), transporte (50-100 €), salud.
- 30% a deseos: ocio, restaurantes, viajes, compras no esenciales.
- 20% a ahorro e inversión: fondo de emergencia, ahorro para objetivos, aportaciones a planes de pensiones, etc.

**¿Por qué es útil?**
Esta regla te ayuda a evitar el sobreendeudamiento y a crear el hábito del ahorro, muy importante en el contexto español donde la tasa de ahorro es baja respecto a Europa. Además, te permite tener un control claro de tus finanzas y priorizar lo realmente importante.

**Ejemplo práctico:**
Si cobras 1.600 € al mes (cerca del salario medio neto en España), deberías destinar 800€ a necesidades, 480€ a deseos y 320€ a ahorro. Si tus gastos fijos superan el 50%, revisa si puedes reducir alguno (por ejemplo, cambiando de compañía eléctrica o renegociando el alquiler).

**Consejos para aplicarla en España:**
- Automatiza el 20% de ahorro con una transferencia periódica a una cuenta de ahorro separada. Puedes hacerlo en bancos como Santander, BBVA, ING, CaixaBank o Sabadell, que ofrecen cuentas sin comisiones y permiten programar transferencias automáticas.
- Si tienes ingresos variables (por ejemplo, autónomos), calcula el porcentaje sobre tu ingreso medio de los últimos 6 meses.
- Revisa y ajusta los porcentajes según tu situación personal, pero nunca bajes del 10% de ahorro si es posible.

**Errores comunes:**
- No incluir todos los gastos en el cálculo (olvidar seguros, suscripciones, etc.).
- Usar el ahorro para gastos imprevistos no urgentes (vacaciones, tecnología).

**Recuerda:** La clave es la constancia y la revisión periódica de tu presupuesto.''',
    quiz: PillQuiz(
      question: '¿Qué porcentaje recomienda la regla 50/30/20 para el ahorro?',
      options: ['10%', '20%', '30%', '50%'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED957),
    title: 'Fondo de emergencia',
    shortDesc: 'Por qué necesitas un fondo de emergencia y cómo crearlo.',
    content: '''Un fondo de emergencia es la base de la seguridad financiera personal. En España, donde la temporalidad laboral es alta y los imprevistos (avería del coche, electrodomésticos, salud, etc.) pueden suponer un gran impacto, disponer de un fondo de emergencia es fundamental.

**¿Por qué es importante?**
Si pierdes tu empleo, el paro puede tardar semanas en llegar. Si tienes una avería en casa, el seguro puede no cubrirlo todo. Un fondo de emergencia te permite afrontar estos gastos sin recurrir a préstamos o tarjetas de crédito, evitando así el sobreendeudamiento.

**¿Cuánto ahorrar?**
Los expertos recomiendan entre 3 y 6 meses de gastos básicos (alquiler, suministros, comida, transporte). Si tus gastos son 1.000€/mes, deberías tener entre 3.000€ y 6.000€.

**¿Dónde guardarlo?**
Lo ideal es una cuenta separada, de fácil acceso pero que no uses para el día a día. Puedes abrir una cuenta de ahorro en Santander, BBVA, ING, CaixaBank o Openbank, todas ellas permiten separar el fondo y programar transferencias automáticas.

**Consejos prácticos:**
- Empieza poco a poco, aunque solo puedas ahorrar 20€ al mes.
- No uses el fondo para vacaciones o compras.
- Revisa tu fondo cada año y ajústalo si cambian tus gastos.

**Errores comunes:**
- Guardar el fondo en efectivo en casa (riesgo de robo/incendio).
- Invertirlo en productos con riesgo o sin liquidez (fondos, bolsa).

**Recuerda:** Un fondo de emergencia es tranquilidad y libertad.''',
    quiz: PillQuiz(
      question: '¿Cuántos meses de gastos recomienda tener en el fondo de emergencia en España?',
      options: ['1-2 meses', '3-6 meses', '12 meses', 'No es necesario'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED957),
    title: 'Ahorro automático',
    shortDesc: 'Automatiza tus ahorros para no olvidarte.',
    content: '''El ahorro automático consiste en programar una transferencia periódica (por ejemplo, el día después de cobrar la nómina) desde tu cuenta corriente a una cuenta de ahorro. Así, ahorras antes de gastar y evitas la tentación de gastar ese dinero.

**Ventajas en España:**
- Todos los grandes bancos (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) permiten programar transferencias automáticas gratis.
- Puedes usar cuentas de ahorro online que ofrecen rentabilidad y disponibilidad inmediata.
- El ahorro automático es clave para crear el hábito y no depender de la fuerza de voluntad.

**Consejo:** Empieza con una cantidad pequeña y ve aumentándola según tus posibilidades. Compara las condiciones de las cuentas de ahorro en varios bancos para elegir la que más te convenga.''',
    quiz: PillQuiz(
      question: '¿Cuál es la mejor forma de asegurar que ahorras cada mes?',
      options: ['Ahorrar lo que sobre', 'Automatizar el ahorro', 'No gastar nada', 'Pedir prestado'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED957),
    title: 'Evita gastos hormiga',
    shortDesc: 'Identifica y reduce pequeños gastos innecesarios.',
    content: '''Los gastos hormiga son pequeñas compras diarias que, sumadas, pueden suponer cientos de euros al año: cafés fuera de casa, snacks, apps, lotería, etc.

**Ejemplo español:** Si gastas 1,50€ en café cada día laboral, al mes son unos 30€ y al año más de 350€. Llevar café de casa o reducir estos gastos puede aumentar tu capacidad de ahorro.

**Consejo:** Revisa tus movimientos bancarios y anota estos pequeños gastos. Si eres cliente de Santander, BBVA, ING, CaixaBank o Sabadell, puedes usar la app de tu banco para categorizar tus gastos y detectar fácilmente estos importes. Así podrás identificar patrones y reducir gastos innecesarios.

**Errores comunes:**
- No revisar los movimientos bancarios con frecuencia.
- Pensar que los pequeños gastos no afectan al ahorro.

**Recuerda:** El primer paso para ahorrar es identificar en qué se va tu dinero.''',
    quiz: PillQuiz(
      question: '¿Qué son los "gastos hormiga"?',
      options: ['Grandes compras', 'Pequeños gastos frecuentes', 'Impuestos', 'Ahorros automáticos'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF7ED957),
    title: 'Reto de 30 días',
    shortDesc: 'Ahorra una pequeña cantidad cada día durante un mes.',
    content: '''El reto de 30 días consiste en ahorrar una cantidad fija o creciente cada día durante un mes. Por ejemplo, empieza ahorrando 1€ el primer día, 2€ el segundo, y así sucesivamente. Al final del mes, habrás ahorrado 465€.

**Variante española:** Puedes usar la funcionalidad "Mis Metas" de la app de Santander, BBVA, ING o Openbank para crear un objetivo de ahorro y seguir tu progreso día a día.

**Beneficio:** Este reto te ayuda a crear el hábito del ahorro y a ver resultados rápidamente. Puedes adaptar el reto a tu capacidad de ahorro y compartirlo con amigos o familiares para motivaros mutuamente.

**Errores comunes:**
- No mantener la constancia durante los 30 días.
- Usar el dinero ahorrado para gastos no planificados.

**Consejo:** Al terminar el reto, transfiere el dinero a tu fondo de emergencia o a una cuenta de ahorro para no gastarlo impulsivamente.''',
    quiz: PillQuiz(
      question: '¿Cuál es el objetivo principal del reto de 30 días?',
      options: ['Gastar más', 'Crear el hábito de ahorrar', 'Invertir en bolsa', 'Pagar deudas'],
      correctIndex: 1,
    ),
  ),
];

final List<EduPill> taxesPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFF6B6B),
    title: '¿Qué son los impuestos?',
    shortDesc: 'Conceptos básicos del sistema fiscal español.',
    content: '''Los impuestos son contribuciones obligatorias que pagamos al Estado para financiar servicios públicos como sanidad, educación, pensiones, infraestructuras y seguridad. En España, el sistema fiscal es progresivo, lo que significa que quienes más ganan, más pagan proporcionalmente.

**¿Por qué pagamos impuestos?**
Los impuestos financian servicios esenciales que benefician a toda la sociedad:
- **Sanidad pública:** Hospitales, médicos, medicamentos
- **Educación:** Escuelas, universidades, becas
- **Pensiones:** Jubilación de nuestros mayores
- **Infraestructuras:** Carreteras, transporte público, internet
- **Seguridad:** Policía, bomberos, ejército
- **Servicios sociales:** Ayudas a desempleados, dependencia

**Tipos principales de impuestos en España:**
- **IRPF (Impuesto sobre la Renta de las Personas Físicas):** Se paga por los ingresos del trabajo, rentas de capital, etc.
- **Seguridad Social:** Cotizaciones para pensiones, desempleo, sanidad
- **IVA (Impuesto sobre el Valor Añadido):** Se paga al comprar bienes y servicios
- **IBI (Impuesto sobre Bienes Inmuebles):** Se paga por tener una vivienda
- **Impuesto de Sociedades:** Para empresas
- **Impuestos especiales:** Gasolina, alcohol, tabaco

**¿Cómo funciona la progresividad?**
En España, el IRPF tiene tramos progresivos (totales estatal + autonómico):
- Hasta 12.450€: 19%
- 12.450€ - 20.200€: 24%
- 20.200€ - 35.200€: 30%
- 35.200€ - 60.000€: 37%
- 60.000€ - 300.000€: 45%
- Más de 300.000€: 47%

**Ejemplo práctico:**
María gana 30.000€ al año. Su IRPF se calcula así:
- Primeros 12.450€: 19% = 2.365,50€
- 12.450€ - 20.200€: 24% = 1.860€
- 20.200€ - 30.000€: 30% = 2.940€
- Total IRPF: 7.165,50€ (23,9% de su salario)

**Errores comunes:**
- Pensar que los impuestos son un "robo" sin entender su función social
- No declarar todos los ingresos
- No aprovechar las deducciones fiscales disponibles

**Consejo:** Los impuestos son el precio de vivir en sociedad. Es importante entenderlos para planificar mejor nuestras finanzas.''',
    quiz: PillQuiz(
      question: '¿Qué significa que el sistema fiscal español es progresivo?',
      options: ['Todos pagan lo mismo', 'Quienes más ganan, más pagan', 'Solo pagan los ricos', 'Los pobres pagan más'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFF6B6B),
    title: 'IRPF: El impuesto principal',
    shortDesc: 'Entiende cómo se calcula tu IRPF.',
    content: '''El IRPF (Impuesto sobre la Renta de las Personas Físicas) es el impuesto más importante que pagas como trabajador en España. Se calcula sobre todos tus ingresos: salario, rentas de capital, ganancias de inversiones, etc.

**¿Cómo se calcula el IRPF?**
1. **Base imponible:** Suma de todos tus ingresos menos las deducciones permitidas
2. **Aplicación de tramos:** Cada tramo de ingresos paga un porcentaje diferente
3. **Deducciones:** Se restan las deducciones autonómicas y estatales

**Tramos del IRPF 2024 (totales estatal + autonómico):**
- Hasta 12.450€: 19%
- 12.450€ - 20.200€: 24%
- 20.200€ - 35.200€: 30%
- 35.200€ - 60.000€: 37%
- 60.000€ - 300.000€: 45%
- Más de 300.000€: 47%

**Ejemplo detallado:**
Carlos gana 45.000€ al año. Su IRPF se calcula así:
- Primeros 12.450€: 19% = 2.365,50€
- 12.450€ - 20.200€: 24% = 1.860€
- 20.200€ - 35.200€: 30% = 4.500€
- 35.200€ - 45.000€: 37% = 3.626€
- Total IRPF: 12.351,50€

**Deducciones importantes:**
- **Deducciones por vivienda:** Hipoteca, alquiler
- **Deducciones por familia:** Hijos, familia numerosa
- **Deducciones por donaciones:** ONGs, fundaciones
- **Deducciones por inversiones:** Planes de pensiones, vivienda

**¿Cuándo se paga?**
- **Retenciones mensuales:** Tu empresa retiene una parte de tu nómina cada mes
- **Declaración anual:** En mayo/junio declaras y ajustas cuentas con Hacienda

**Consejos prácticos:**
- Guarda todos los justificantes de gastos deducibles
- Revisa tu declaración antes de presentarla
- Considera contratar un gestor si tu situación es compleja
- Aprovecha las deducciones disponibles en tu comunidad autónoma

**Errores comunes:**
- No declarar ingresos adicionales (freelance, alquileres)
- Olvidar deducciones importantes
- No revisar las retenciones de la empresa

**Recuerda:** El IRPF es complejo, pero entenderlo te ayudará a optimizar tu situación fiscal.''',
    quiz: PillQuiz(
      question: '¿En qué mes se presenta normalmente la declaración del IRPF?',
      options: ['Enero', 'Mayo/Junio', 'Diciembre', 'Marzo'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFF6B6B),
    title: 'Seguridad Social',
    shortDesc: 'Las cotizaciones que financian las pensiones.',
    content: '''La Seguridad Social es el sistema público que protege a los trabajadores en España. Se financia con las cotizaciones que pagan trabajadores y empresas, y proporciona cobertura en situaciones como jubilación, desempleo, enfermedad o maternidad.

**¿Qué cubre la Seguridad Social?**
- **Pensiones de jubilación:** Ingresos mensuales tras la jubilación
- **Prestación por desempleo:** Ayuda económica cuando pierdes el trabajo
- **Asistencia sanitaria:** Atención médica gratuita
- **Prestaciones por incapacidad:** Si no puedes trabajar temporal o permanentemente
- **Prestaciones por maternidad/paternidad:** Bajas por nacimiento o adopción
- **Prestaciones por muerte y supervivencia:** Pensiones de viudedad y orfandad

**¿Cuánto se paga?**
Las cotizaciones se calculan sobre tu base de cotización (similar al salario bruto):
- **Trabajador:** Aproximadamente 6,35% del salario
- **Empresa:** Aproximadamente 29,9% del salario
- **Total:** Alrededor del 36,25% del salario

**Ejemplo práctico:**
Ana gana 2.000€ brutos al mes:
- Cotización trabajador: 2.000€ × 6,35% = 127€
- Cotización empresa: 2.000€ × 29,9% = 598€
- Total cotizaciones: 725€
- Salario neto: 2.000€ - 127€ = 1.873€

**¿Cómo se calcula la pensión?**
La pensión se calcula con:
- **Años cotizados:** Mínimo 15 años, máximo 35 años
- **Base reguladora:** Media de las bases de cotización de los últimos 25 años
- **Porcentaje:** Depende de los años cotizados (mínimo 50%, máximo 100%)

**Ejemplo de pensión:**
Juan ha cotizado 35 años con una base media de 2.500€:
- Porcentaje: 100% (35 años cotizados)
- Pensión mensual: 2.500€ × 100% = 2.500€

**Situaciones especiales:**
- **Autónomos:** Pagan cuotas mensuales fijas o variables según ingresos
- **Trabajadores a tiempo parcial:** Cotizan proporcionalmente
- **Pluriempleo:** Se suman las cotizaciones de todos los trabajos

**Consejos importantes:**
- Revisa tu vida laboral regularmente en la web de la Seguridad Social
- Guarda todas las nóminas y contratos
- Infórmate sobre las prestaciones disponibles
- Considera complementar con planes de pensiones privados

**Errores comunes:**
- No revisar la vida laboral y detectar errores tarde
- No cotizar suficientes años para tener pensión completa
- No informarse sobre prestaciones disponibles

**Recuerda:** La Seguridad Social es tu red de seguridad. Es importante entender cómo funciona para planificar tu futuro.''',
    quiz: PillQuiz(
      question: '¿Cuál es el porcentaje aproximado que paga el trabajador en cotizaciones?',
      options: ['3%', '6,35%', '15%', '30%'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFF6B6B),
    title: 'IVA: El impuesto invisible',
    shortDesc: 'Cómo afecta el IVA a tus compras diarias.',
    content: '''El IVA (Impuesto sobre el Valor Añadido) es un impuesto indirecto que pagas cada vez que compras un bien o servicio. A diferencia del IRPF, no lo declaras tú directamente, sino que lo pagan las empresas y lo repercuten en el precio final.

**Tipos de IVA en España:**
- **IVA Superreducido (4%):** Productos de primera necesidad como pan, leche, frutas, verduras, libros, medicamentos
- **IVA Reducido (10%):** Alimentos básicos, vivienda de protección oficial, transporte público, servicios culturales
- **IVA General (21%):** La mayoría de bienes y servicios (ropa, tecnología, restaurantes, servicios profesionales)

**¿Cómo funciona?**
Cuando compras algo, el precio que ves ya incluye el IVA. Por ejemplo:
- Precio sin IVA: 100€
- IVA (21%): 21€
- Precio final: 121€

**Ejemplos prácticos:**
- **Pan (4% IVA):** 1€ + 0,04€ IVA = 1,04€ final
- **Leche (4% IVA):** 1,20€ + 0,048€ IVA = 1,25€ final
- **Libro (4% IVA):** 15€ + 0,60€ IVA = 15,60€ final
- **Transporte público (10% IVA):** 10€ + 1€ IVA = 11€ final
- **Ropa (21% IVA):** 50€ + 10,50€ IVA = 60,50€ final
- **Restaurante (10% IVA):** 30€ + 3€ IVA = 33€ final

**¿Cuánto IVA pagas al año?**
En una familia media española, el IVA puede representar entre 3.000€ y 6.000€ anuales, dependiendo del nivel de consumo.

**Estrategias para reducir el impacto del IVA:**
- **Prioriza productos con IVA reducido:** Alimentos básicos, transporte público
- **Compras online:** Algunos productos pueden tener IVA diferente
- **Compras al por mayor:** Puede reducir el impacto del IVA
- **Servicios profesionales:** Compara precios, el IVA es igual en todos

**¿Quién puede recuperar el IVA?**
- **Empresas:** Pueden deducir el IVA de sus compras
- **Exportadores:** IVA 0% en exportaciones
- **Autónomos:** Pueden deducir el IVA de sus gastos profesionales

**Errores comunes:**
- No tener en cuenta el IVA al planificar gastos
- Pensar que el IVA es opcional
- No guardar facturas para deducciones empresariales

**Consejos prácticos:**
- Siempre incluye el IVA en tus presupuestos
- Compara precios finales (con IVA incluido)
- Guarda las facturas importantes
- Considera el IVA al hacer compras grandes

**Recuerda:** El IVA está presente en casi todas tus compras. Entenderlo te ayudará a tomar mejores decisiones de consumo.''',
    quiz: PillQuiz(
      question: '¿Qué tipo de IVA se aplica a la mayoría de productos en España?',
      options: ['0%', '5%', '21%', '30%'],
      correctIndex: 2,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFF6B6B),
    title: 'Ejemplo completo: ¿Cuánto se lleva el Estado?',
    shortDesc: 'Cálculo real de impuestos sobre un salario español.',
    content: '''Vamos a hacer un cálculo completo de cuánto se lleva el Estado de un salario típico español. Este ejemplo te ayudará a entender el impacto real de los impuestos en tus finanzas.

**Ejemplo: María, 35 años, Madrid**
- **Salario bruto anual:** 35.000€
- **Salario bruto mensual:** 2.916,67€

**1. Cálculo de cotizaciones a la Seguridad Social:**
- Base de cotización: 2.916,67€
- Cotización trabajador (6,35%): 185,81€
- Cotización empresa (29,9%): 872,08€
- **Total cotizaciones mensuales:** 1.057,89€

**2. Cálculo del IRPF:**
- Primeros 12.450€: 19% = 2.365,50€
- 12.450€ - 20.200€: 24% = 1.860,00€
- 20.200€ - 35.000€: 30% = 4.440,00€
- **Total IRPF anual:** 8.665,50€
- **IRPF mensual:** 722,13€

**3. Salario neto mensual:**
- Salario bruto: 2.916,67€
- Cotizaciones: -185,81€
- IRPF: -722,13€
- **Salario neto:** 2.008,73€

**4. Impacto del IVA en gastos mensuales:**
María gasta aproximadamente 1.500€ al mes:
- Alimentación (10% IVA): 400€ + 40€ IVA = 440€
- Transporte (10% IVA): 50€ + 5€ IVA = 55€
- Ropa y tecnología (21% IVA): 300€ + 63€ IVA = 363€
- Restaurantes (10% IVA): 200€ + 20€ IVA = 220€
- Otros gastos (21% IVA): 550€ + 115,50€ IVA = 665,50€
- **Total IVA mensual:** 243,50€

**5. Resumen total de impuestos:**
- Cotizaciones mensuales: 185,81€
- IRPF mensual: 722,13€
- IVA mensual: 243,50€
- **Total impuestos mensuales:** 1.151,44€
- **Porcentaje sobre salario bruto:** 39,5%

**6. ¿Qué se queda María realmente?**
- Salario bruto mensual: 2.916,67€
- Total impuestos: -1.151,44€
- **Salario neto real:** 1.765,23€
- **Porcentaje que se queda:** 60,5%

**7. Otros impuestos anuales:**
- IBI (vivienda): 600€/año (50€/mes)
- Impuesto de circulación: 150€/año (12,50€/mes)
- **Total otros impuestos:** 62,50€/mes

**Resumen final:**
- **Salario bruto:** 2.916,67€
- **Total impuestos:** 1.213,94€ (41,6%)
- **Salario neto real:** 1.702,73€ (58,4%)

**¿Qué financia esto?**
- **Sanidad pública:** Atención médica gratuita
- **Educación:** Escuelas y universidades públicas
- **Pensiones:** Jubilación futura
- **Infraestructuras:** Carreteras, transporte público
- **Servicios sociales:** Ayudas, protección social

**Consejos para optimizar:**
- Aprovecha las deducciones fiscales disponibles
- Considera planes de pensiones para reducir IRPF
- Planifica gastos considerando el IVA
- Revisa tu declaración anual

**Recuerda:** Los impuestos son necesarios para mantener los servicios públicos. Entender cuánto pagas te ayuda a planificar mejor tus finanzas.''',
    quiz: PillQuiz(
      question: '¿Qué porcentaje aproximado se queda un trabajador de su salario bruto en España?',
      options: ['50%', '60%', '70-75%', '90%'],
      correctIndex: 1,
    ),
  ),
];

final List<EduPill> investmentPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7EC6F5),
    title: '¿Qué es invertir?',
    shortDesc: 'Conceptos básicos de inversión para principiantes.',
    content: '''Invertir es poner tu dinero a trabajar para ti, buscando obtener un rendimiento superior al de una cuenta corriente. En España, la cultura de la inversión está creciendo, pero aún existe mucho desconocimiento y miedo al riesgo.

**¿Por qué invertir?**
La inflación hace que el dinero pierda valor con el tiempo. Si dejas tus ahorros en una cuenta sin remunerar, cada año podrás comprar menos cosas con ellos. Invertir te permite combatir la inflación y hacer crecer tu patrimonio.

**Instrumentos de inversión en España:**
- **Depósitos a plazo:** Producto tradicional, bajo riesgo, pero actualmente con rentabilidades muy bajas. Disponibles en bancos como Santander, BBVA, CaixaBank, ING y Sabadell.
- **Fondos de inversión:** Permiten diversificar y acceder a mercados globales. Hay fondos de renta fija, variable, mixtos, etc. Bancos como Santander, BBVA, CaixaBank, ING y Openbank ofrecen una amplia gama de fondos adaptados a distintos perfiles. La inversión mínima suele ser de 100€ a 500€.
- **Acciones:** Comprar una parte de una empresa. Más riesgo, pero también más potencial de rentabilidad. Puedes invertir en la Bolsa española (IBEX 35) o internacional a través de bancos y brókers online.
- **Planes de pensiones:** Producto fiscalmente ventajoso para ahorrar a largo plazo para la jubilación. Santander, BBVA, CaixaBank y otros bancos ofrecen planes de pensiones con diferentes estrategias y comisiones.
- **Inmuebles:** Comprar para alquilar o vender. Requiere más capital y gestión, pero es muy habitual en España.

**Consejos prácticos:**
- Antes de invertir, define tu objetivo (comprar casa, jubilación, estudios hijos, etc.).
- Nunca inviertas dinero que puedas necesitar a corto plazo.
- Infórmate bien y compara productos. Consulta con tu banco (Santander, BBVA, ING, CaixaBank, Openbank, etc.) o un asesor financiero independiente.
- Ten en cuenta la fiscalidad: las ganancias de fondos y acciones tributan en el IRPF.

**Errores comunes:**
- Invertir por moda o por recomendaciones de amigos sin entender el producto.
- No diversificar (poner todo el dinero en un solo activo).
- No tener en cuenta las comisiones y la fiscalidad.

**Recuerda:** Invertir no es apostar. Es una estrategia a medio y largo plazo para mejorar tu futuro financiero.''',
    quiz: PillQuiz(
      question: '¿Cuál es el objetivo principal de invertir?',
      options: ['Gastar dinero', 'Obtener rendimientos', 'Ahorrar en casa', 'Evitar riesgos'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Diversificación',
    shortDesc: 'No pongas todos los huevos en la misma canasta.',
    content: '''Diversificar es repartir tu dinero entre diferentes tipos de activos (acciones, bonos, fondos, depósitos, etc.) y sectores. Así, si uno baja, otros pueden compensar las pérdidas.

**¿Por qué es importante?**
En España, muchos ahorradores concentran todo en vivienda o depósitos. Esto aumenta el riesgo si ese activo baja de valor. Diversificar reduce la volatilidad y protege tu patrimonio.

**Ejemplo práctico:**
Si tienes 10.000€, puedes repartir 4.000€ en fondos de renta fija, 3.000€ en fondos de renta variable, 2.000€ en un depósito a plazo y 1.000€ en acciones españolas. Bancos como Santander, BBVA, CaixaBank, ING y Openbank ofrecen carteras diversificadas y fondos perfilados para facilitar esta tarea.

**Consejos:**
- No inviertas solo en lo que conoces o te resulta cómodo.
- Revisa tu cartera al menos una vez al año y ajusta según tu edad y objetivos.
- Compara comisiones y servicios de varios bancos antes de decidir.

**Errores comunes:**
- Poner todo el dinero en acciones de una sola empresa (por ejemplo, Telefónica o Santander).
- No revisar la cartera y dejar que se descompense con el tiempo.

**Recuerda:** La diversificación es la mejor defensa contra la incertidumbre de los mercados.''',
    quiz: PillQuiz(
      question: '¿Para qué sirve la diversificación?',
      options: ['Aumentar el riesgo', 'Reducir el riesgo', 'Ganar menos', 'Pagar impuestos'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7EC6F5),
    title: 'Riesgo y rentabilidad',
    shortDesc: 'Entiende la relación entre riesgo y ganancia.',
    content: '''La relación entre riesgo y rentabilidad es fundamental en el mundo de las inversiones. En España, muchos ahorradores tradicionalmente han preferido productos de bajo riesgo (depósitos, cuentas de ahorro), pero esto ha limitado sus posibilidades de crecimiento patrimonial.

**¿Qué es el riesgo?**
El riesgo es la posibilidad de perder parte o todo el dinero invertido. En España, los productos financieros se clasifican en niveles de riesgo del 1 (muy bajo) al 7 (muy alto), según la normativa europea MiFID.

**Tipos de riesgo:**
- **Riesgo de mercado:** El valor de tu inversión puede bajar por cambios en los mercados. Por ejemplo, si inviertes en acciones del IBEX 35 y la bolsa española cae, tu inversión se devalúa.
- **Riesgo de crédito:** La entidad emisora (banco, empresa, gobierno) puede no devolver tu dinero. En España, los depósitos están garantizados hasta 100.000€ por el Fondo de Garantía de Depósitos.
- **Riesgo de liquidez:** No poder vender tu inversión cuando lo necesites sin perder dinero. Los fondos de inversión suelen ser líquidos, pero algunos productos estructurados pueden tener penalizaciones.
- **Riesgo de inflación:** Que el dinero pierda valor con el tiempo. Con la inflación actual en España (2-3%), si tu inversión no rinde al menos ese porcentaje, estás perdiendo poder adquisitivo.

**Relación riesgo-rentabilidad:**
- **Bajo riesgo (1-2):** Depósitos a plazo, cuentas remuneradas, letras del Tesoro. Rentabilidad: 0-2% anual. Ejemplo: Depósito Santander 12 meses al 2,5% TAE.
- **Riesgo medio-bajo (3-4):** Fondos de renta fija, bonos corporativos, planes de pensiones conservadores. Rentabilidad: 2-5% anual. Ejemplo: Fondo BBVA Renta Fija Euro.
- **Riesgo medio (4-5):** Fondos mixtos, fondos de renta variable europea, algunos ETFs. Rentabilidad: 4-8% anual. Ejemplo: Fondo CaixaBank Mixto Conservador.
- **Alto riesgo (6-7):** Acciones individuales, fondos de mercados emergentes, criptomonedas. Rentabilidad: muy variable, puede ser negativa o superior al 15% anual.

**¿Cómo determinar tu perfil de riesgo?**
Los bancos españoles (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) realizan un test de perfil de inversor que evalúa:
- Tu edad y horizonte temporal
- Tu experiencia en inversiones
- Tu capacidad de asumir pérdidas
- Tus objetivos financieros

**Consejos prácticos:**
- Nunca inviertas dinero que puedas necesitar a corto plazo (menos de 3 años).
- Si eres joven (20-40 años), puedes asumir más riesgo porque tienes tiempo para recuperarte.
- Si te acercas a la jubilación, prioriza la conservación del capital.
- Diversifica para reducir el riesgo total de tu cartera.

**Errores comunes:**
- Invertir solo en productos de bajo riesgo por miedo, perdiendo oportunidades de crecimiento.
- Invertir en productos de alto riesgo sin entenderlos, buscando ganancias rápidas.
- No revisar el perfil de riesgo de tus inversiones cuando cambian tus circunstancias.

**Ejemplo práctico español:**
María, 35 años, quiere ahorrar para la entrada de una casa en 5 años. Tiene 20.000€ y puede ahorrar 500€ al mes. Su perfil de riesgo es medio (4/7). Podría invertir:
- 60% en fondos mixtos (rentabilidad esperada 5-7% anual)
- 30% en fondos de renta fija (rentabilidad esperada 3-4% anual)
- 10% en cuentas remuneradas (liquidez inmediata)

**Recuerda:** El riesgo no es malo en sí mismo, pero debe ser proporcional a tu situación y objetivos.''',
    quiz: PillQuiz(
      question: '¿Qué suele ocurrir a mayor riesgo en una inversión?',
      options: ['Menor rentabilidad', 'Mayor rentabilidad potencial', 'Menos impuestos', 'Más seguridad'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Invierte a largo plazo',
    shortDesc: 'La paciencia es clave para invertir.',
    content: '''Invertir a largo plazo es una de las estrategias más efectivas para construir patrimonio. En España, la cultura del "dinero rápido" y la falta de educación financiera han llevado a muchos a buscar ganancias inmediatas, pero la historia demuestra que la paciencia es rentable.

**¿Por qué invertir a largo plazo?**
- **Reduce la volatilidad:** Los mercados suben y bajan a corto plazo, pero históricamente tienden a subir a largo plazo. El IBEX 35 ha tenido años malos (-25% en 2008), pero ha crecido un 7% anual de media desde su creación.
- **Permite aprovechar el interés compuesto:** Los beneficios se reinvierten y generan más beneficios. 10.000€ invertidos al 7% anual se convierten en 19.671€ en 10 años, 38.697€ en 20 años.
- **Reduce el impacto de las comisiones:** Las comisiones de entrada y salida de fondos (1-3%) tienen menos impacto si mantienes la inversión años.
- **Te da tiempo para recuperarte:** Si el mercado baja, tienes tiempo para esperar a que se recupere sin vender a pérdidas.

**Horizontes temporales recomendados:**
- **Corto plazo (1-3 años):** Cuentas remuneradas, depósitos a plazo, fondos de renta fija de corta duración. Ejemplo: Cuenta remunerada ING al 2,5% TAE.
- **Medio plazo (3-10 años):** Fondos mixtos, fondos de renta variable europea, planes de pensiones. Ejemplo: Fondo Santander Mixto Moderado.
- **Largo plazo (10+ años):** Fondos de renta variable global, ETFs, planes de pensiones agresivos. Ejemplo: Fondo BBVA Renta Variable Global.

**Estrategias para invertir a largo plazo:**
1. **Dollar-cost averaging (media de costes):** Invertir una cantidad fija cada mes, independientemente del precio. Así compras más cuando está barato y menos cuando está caro. Bancos como Santander, BBVA, ING, CaixaBank y Openbank permiten programar aportaciones automáticas a fondos.
2. **Revisión periódica:** Revisar tu cartera cada 6-12 meses para rebalancear (ajustar los porcentajes según tu estrategia).
3. **No dejarse llevar por las emociones:** No vender en pánico cuando el mercado baja ni comprar compulsivamente cuando sube.

**Productos españoles para largo plazo:**
- **Planes de pensiones:** Ventajas fiscales (reducción en la declaración de la renta) y horizonte largo. Santander, BBVA, CaixaBank, ING y otros bancos ofrecen planes con diferentes estrategias.
- **Fondos de inversión:** Amplia variedad de fondos para diferentes perfiles y horizontes temporales.
- **Seguros de ahorro:** Combinan ahorro con protección, aunque suelen tener comisiones más altas.

**Ejemplo práctico:**
Carlos, 28 años, invierte 200€ al mes en un fondo de renta variable global. Aunque algunos meses el fondo baja, mantiene la inversión. En 30 años, con una rentabilidad media del 7% anual, tendrá 227.000€, de los cuales solo 72.000€ serán sus aportaciones.

**Errores comunes:**
- Vender cuando el mercado baja por miedo a perder más dinero.
- No tener un horizonte temporal claro y cambiar de estrategia constantemente.
- Invertir dinero que necesitarás a corto plazo en productos de largo plazo.

**Consejos para mantener la disciplina:**
- Establece objetivos claros (jubilación, compra de vivienda, educación de hijos).
- Automatiza las inversiones para no depender de la fuerza de voluntad.
- No revisar constantemente el valor de tus inversiones (una vez al mes es suficiente).
- Ten un fondo de emergencia para no tener que vender inversiones en momentos inoportunos.

**Recuerda:** El tiempo es tu mejor aliado en las inversiones. Cuanto antes empieces, mejor.''',
    quiz: PillQuiz(
      question: '¿Por qué es recomendable invertir a largo plazo?',
      options: ['Para ganar dinero rápido', 'Para reducir la volatilidad', 'Para pagar menos impuestos', 'Para gastar más'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7EC6F5),
    title: 'Fondos de inversión',
    shortDesc: 'Aprende sobre uno de los productos más populares.',
    content: '''Los fondos de inversión son uno de los productos más populares en España para invertir. Permiten acceder a mercados globales con pequeñas cantidades de dinero y están gestionados por profesionales. En 2023, los españoles tenían más de 300.000 millones de euros invertidos en fondos.

**¿Qué es un fondo de inversión?**
Es un vehículo que reúne el dinero de muchos inversores para comprar una cartera diversificada de activos (acciones, bonos, inmuebles, etc.). Cada inversor posee participaciones del fondo proporcionales a su inversión.

**Tipos de fondos en España:**
- **Fondos de renta fija:** Invierten en bonos y deuda. Menor riesgo, menor rentabilidad esperada. Ejemplos: Fondo Santander Renta Fija Euro, Fondo BBVA Renta Fija España.
- **Fondos de renta variable:** Invierten en acciones. Mayor riesgo, mayor rentabilidad potencial. Ejemplos: Fondo CaixaBank Renta Variable España, Fondo ING Renta Variable Global.
- **Fondos mixtos:** Combinan renta fija y variable. Riesgo y rentabilidad intermedios. Ejemplos: Fondo Santander Mixto Conservador, Fondo BBVA Mixto Moderado.
- **Fondos de gestión pasiva (ETFs):** Replican índices como el IBEX 35 o el S&P 500. Comisiones más bajas. Ejemplos: ETF que replica el IBEX 35, ETF que replica el MSCI World.
- **Fondos temáticos:** Se especializan en sectores (tecnología, energías renovables, etc.). Mayor riesgo por concentración.

**Ventajas de los fondos:**
- **Diversificación:** Con 1.000€ puedes tener exposición a cientos de empresas o bonos.
- **Gestión profesional:** Expertos toman las decisiones de inversión.
- **Liquidez:** Puedes vender tus participaciones en cualquier momento (normalmente en 1-3 días).
- **Fiscalidad favorable:** No pagas impuestos hasta que vendes, y puedes traspasar entre fondos sin tributar.
- **Inversión mínima baja:** Desde 100€ en muchos fondos.

**Comisiones a tener en cuenta:**
- **Comisión de gestión:** Porcentaje anual del patrimonio (0,5-2%). Se descuenta automáticamente.
- **Comisión de suscripción/reembolso:** Al comprar o vender (0-5%). Muchos fondos no las cobran.
- **Comisión de depósito:** Por la custodia de los activos (0,1-0,3% anual).

**Cómo elegir un fondo:**
1. **Define tu perfil de riesgo:** Conservador, moderado o agresivo.
2. **Establece tu horizonte temporal:** Corto, medio o largo plazo.
3. **Compara fondos similares:** Mira la rentabilidad histórica, las comisiones y la volatilidad.
4. **Lee el folleto informativo:** Es obligatorio y contiene toda la información del fondo.

**Dónde comprar fondos:**
- **Bancos tradicionales:** Santander, BBVA, CaixaBank, Sabadell. Ventaja: asesoramiento personalizado. Desventaja: comisiones más altas.
- **Bancos online:** ING, Openbank, MyInvestor. Ventaja: comisiones más bajas. Desventaja: menos asesoramiento.
- **Plataformas independientes:** Renta 4, Self Bank, Indexa Capital. Ventaja: amplia oferta y comisiones competitivas.

**Ejemplo práctico:**
Ana, 35 años, quiere invertir 5.000€ con un perfil moderado. Elige un fondo mixto con 60% renta fija y 40% renta variable. Comisión de gestión: 1,5% anual. Rentabilidad esperada: 5-7% anual. Al cabo de 10 años, podría tener entre 7.500€ y 9.800€ (antes de impuestos).

**Errores comunes:**
- Elegir fondos solo por la rentabilidad pasada (no garantiza rentabilidad futura).
- No tener en cuenta las comisiones, que pueden reducir significativamente la rentabilidad.
- No diversificar (poner todo el dinero en un solo fondo).
- Vender en pánico cuando el fondo baja temporalmente.

**Consejos prácticos:**
- Empieza con fondos de gestión pasiva (ETFs) si quieres comisiones bajas.
- Considera fondos indexados que replican el mercado español o global.
- Revisa tu cartera de fondos al menos una vez al año.
- No inviertas en fondos que no entiendas completamente.

**Recuerda:** Los fondos de inversión son una excelente herramienta para diversificar y acceder a mercados globales, pero requieren tiempo y paciencia.''',
    quiz: PillQuiz(
      question: '¿Cuál es la principal ventaja de los fondos de inversión?',
      options: ['Garantía de rentabilidad', 'Diversificación', 'Sin comisiones', 'Liquidez inmediata'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Planes de pensiones',
    shortDesc: 'Ahorra para tu jubilación con ventajas fiscales.',
    content: '''Los planes de pensiones son productos de ahorro a largo plazo diseñados específicamente para la jubilación. En España, ofrecen ventajas fiscales importantes y son una herramienta fundamental para complementar la pensión pública, especialmente considerando que el sistema de pensiones español enfrenta desafíos demográficos.

**¿Qué es un plan de pensiones?**
Es un producto de ahorro que permite acumular capital para la jubilación con ventajas fiscales. El dinero se invierte en diferentes activos (renta fija, renta variable, inmuebles) según el perfil de riesgo elegido.

**Tipos de planes de pensiones en España:**
- **Planes de pensiones individuales:** Los contratas personalmente. Los ofrecen bancos (Santander, BBVA, CaixaBank, ING, Sabadell, Openbank), aseguradoras y gestoras independientes.
- **Planes de pensiones de empleo:** Los ofrece tu empresa a sus trabajadores. Pueden incluir aportaciones de la empresa.
- **Planes de pensiones asociados:** Los ofrecen sindicatos, colegios profesionales y asociaciones.

**Ventajas fiscales:**
- **Reducción en la declaración de la renta:** Puedes desgravar hasta 1.500€ anuales (2.000€ si tienes más de 50 años). Si tributas al 30%, ahorras 450€ en impuestos por cada 1.500€ aportados.
- **Crecimiento sin tributación:** Los beneficios no tributan hasta que rescates el plan.
- **Traspasos sin tributación:** Puedes cambiar de plan sin pagar impuestos.

**Cuándo puedes rescatar el plan:**
- Jubilación (edad legal o anticipada)
- Incapacidad permanente absoluta o gran invalidez
- Fallecimiento del partícipe
- Desempleo de larga duración (después de 2 años)
- Enfermedad grave
- A partir de 2025, en determinadas circunstancias (reforma pendiente)

**Cómo elegir un plan de pensiones:**
1. **Define tu perfil de riesgo:** Conservador, moderado o agresivo.
2. **Compara comisiones:** Gestión (0,5-2% anual), depósito (0,1-0,3% anual), suscripción/reembolso.
3. **Revisa la rentabilidad histórica:** Aunque no garantiza rentabilidad futura, da una idea del comportamiento.
4. **Considera la solvencia de la entidad:** Especialmente importante para planes de aseguradoras.

**Estrategias de aportación:**
- **Aportación mensual:** Ideal para crear el hábito. Puedes programar transferencias automáticas.
- **Aportación anual:** Útil para optimizar fiscalmente (aportar en diciembre para desgravar en ese año).
- **Aportación variable:** Según tus posibilidades económicas.

**Ejemplo práctico:**
Luis, 40 años, tributa al 30% y aporta 1.500€ anuales a un plan de pensiones. Ahorra 450€ en impuestos cada año. Si mantiene esta aportación hasta los 65 años, habrá aportado 37.500€ pero habrá ahorrado 11.250€ en impuestos. Con una rentabilidad del 5% anual, tendrá unos 85.000€ a los 65 años.

**Productos disponibles en España:**
- **Santander:** Plan Santander Futuro, con diferentes perfiles de riesgo.
- **BBVA:** Plan BBVA Jubilación, con estrategias adaptadas a la edad.
- **CaixaBank:** Plan CaixaBank Pensiones, con fondos de gestión activa y pasiva.
- **ING:** Plan ING Direct Pensiones, con comisiones competitivas.
- **Openbank:** Plan Openbank Pensiones, con gestión digital.

**Errores comunes:**
- No aprovechar la desgravación fiscal anual.
- Elegir planes con comisiones muy altas que reducen la rentabilidad.
- No revisar el plan periódicamente y ajustarlo según la edad.
- Rescatar el plan antes de tiempo (pierdes las ventajas fiscales).

**Consejos prácticos:**
- Empieza a aportar cuanto antes: el tiempo es tu mejor aliado.
- Aprovecha la desgravación fiscal máxima cada año.
- Revisa tu plan cada 2-3 años y ajusta el perfil de riesgo según tu edad.
- Considera diversificar entre varios planes o entidades.
- No uses el plan como fondo de emergencia (pierdes las ventajas fiscales).

**Fiscalidad del rescate:**
Cuando rescates el plan, tributarás como rendimientos del trabajo. Las cantidades rescatadas se integran en la base imponible del IRPF. Es importante planificar los rescates para optimizar la tributación.

**Recuerda:** Los planes de pensiones son una excelente herramienta para ahorrar para la jubilación con ventajas fiscales, pero requieren un horizonte de largo plazo.''',
    quiz: PillQuiz(
      question: '¿Cuál es la principal ventaja fiscal de los planes de pensiones?',
      options: ['No pagar impuestos', 'Desgravación en la declaración', 'Liquidez inmediata', 'Sin comisiones'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF7EC6F5),
    title: 'Simula una inversión',
    shortDesc: 'Elige un activo y sigue su evolución durante un mes.',
    content: '''Simular una inversión es una excelente forma de aprender sin arriesgar dinero real. Te permite entender cómo funcionan los mercados, qué factores influyen en los precios y cómo gestionar las emociones que surgen al invertir.

**¿Cómo hacer la simulación?**
1. **Elige un activo:** Puede ser una acción española (Telefónica, Santander, BBVA, Inditex), un fondo de inversión, un ETF que replique el IBEX 35, o incluso una criptomoneda.
2. **Define tu inversión:** Decide cuánto "invertirías" (por ejemplo, 1.000€) y cuándo comprarías.
3. **Registra el seguimiento:** Anota el precio cada semana y analiza los movimientos.
4. **Investiga:** Lee noticias sobre la empresa, el sector o el mercado para entender por qué sube o baja.

**Activos recomendados para principiantes:**
- **Acciones del IBEX 35:** Telefónica, Santander, BBVA, Inditex, Iberdrola. Son empresas grandes y estables.
- **ETFs:** ETF que replique el IBEX 35 (ISIN: ES0000000000) o el MSCI World (mercado global).
- **Fondos de inversión:** Fondo Santander Mixto Moderado, Fondo BBVA Renta Variable España.
- **Criptomonedas:** Bitcoin o Ethereum (solo para entender la volatilidad extrema).

**Herramientas para el seguimiento:**
- **Apps de bancos:** Santander, BBVA, ING, CaixaBank, Sabadell, Openbank tienen apps con cotizaciones en tiempo real.
- **Páginas web:** Investing.com, Yahoo Finance, Morningstar España.
- **Apps especializadas:** TradingView, Investing.com, Yahoo Finance.

**Qué registrar cada semana:**
- Fecha y precio de cierre
- Variación semanal (en euros y porcentaje)
- Noticias relevantes que afecten al activo
- Tu reacción emocional (¿te asustas si baja? ¿te emocionas si sube?)
- Factores que influyen (resultados empresariales, noticias macroeconómicas, etc.)

**Análisis que debes hacer:**
- **Análisis técnico básico:** ¿El precio está subiendo o bajando? ¿Hay tendencias?
- **Análisis fundamental:** ¿Cómo van los resultados de la empresa? ¿Qué dicen las noticias?
- **Análisis emocional:** ¿Cómo te sientes cuando sube o baja? ¿Te tentaría vender o comprar más?

**Ejemplo de seguimiento:**
Semana 1: Compras "acciones" de Santander a 3,50€. Inviertes 1.000€ = 285,7 acciones.
Semana 2: Precio 3,45€. Valor: 985,7€. Pérdida: 14,3€ (-1,43%). Noticia: Santander presenta resultados trimestrales.
Semana 3: Precio 3,60€. Valor: 1.028,6€. Ganancia: 28,6€ (+2,86%). Noticia: Subida general del sector bancario.

**Lecciones que aprenderás:**
- **Volatilidad:** Los precios suben y bajan constantemente, a veces sin razón aparente.
- **Importancia de la información:** Las noticias y resultados empresariales afectan los precios.
- **Emociones:** Es fácil dejarse llevar por el miedo (cuando baja) o la euforia (cuando sube).
- **Horizonte temporal:** A corto plazo hay mucha volatilidad, pero a largo plazo las tendencias son más claras.

**Errores que evitarás en el futuro:**
- Vender en pánico cuando el precio baja temporalmente.
- Comprar compulsivamente cuando el precio sube mucho.
- No investigar antes de invertir.
- No tener un plan de inversión claro.

**Después del mes:**
- Analiza tu comportamiento: ¿fuiste racional o emocional?
- Identifica patrones: ¿qué noticias afectaron más al precio?
- Reflexiona: ¿qué harías diferente con dinero real?
- Decide: ¿te sientes preparado para invertir realmente?

**Consejos para la simulación:**
- Trata la simulación como si fuera dinero real: toma decisiones serias.
- No hagas trampa: si "compras" a un precio, mantén ese precio aunque luego baje.
- Documenta todo: será útil para analizar tu comportamiento.
- Comparte la experiencia: habla con otros sobre lo que aprendes.

**Recuerda:** La simulación es una excelente herramienta de aprendizaje, pero las emociones reales son diferentes cuando hay dinero de por medio. Usa esta experiencia para desarrollar disciplina y conocimiento antes de invertir realmente.''',
    quiz: PillQuiz(
      question: '¿Qué debes hacer en este desafío?',
      options: ['Invertir dinero real', 'Simular y observar', 'Gastar más', 'No hacer nada'],
      correctIndex: 1,
    ),
  ),
];

final List<EduPill> budgetPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFE066),
    title: '¿Qué es un presupuesto?',
    shortDesc: 'La base de unas finanzas sanas.',
    content: '''Un presupuesto es una herramienta fundamental para tomar el control de tus finanzas. En España, muchas familias no llevan un control detallado de sus ingresos y gastos, lo que puede llevar a sorpresas desagradables a final de mes.

**¿Por qué hacer un presupuesto?**
Te permite saber exactamente cuánto dinero entra y sale cada mes, identificar gastos innecesarios y planificar para el futuro (vacaciones, imprevistos, compras importantes).

**Cómo hacerlo:**
- Anota todos tus ingresos (nómina, ayudas, alquileres, etc.). El salario medio neto en España ronda los 1.600€ al mes.
- Enumera todos tus gastos fijos (alquiler o hipoteca: 700-1.200€, suministros: 100€, alimentación: 250€, transporte: 50-100€, seguros, etc.) y variables (ocio, restaurantes, compras).
- Resta los gastos a los ingresos. Si el resultado es negativo, revisa en qué puedes recortar.

**Herramientas útiles:**
- Usa una hoja de cálculo, una app de finanzas (Fintonic, MoneyWiz) o la propia app de tu banco (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank permiten categorizar gastos y ver gráficos).

**Errores comunes:**
- Olvidar gastos anuales o trimestrales (impuestos, seguros, matrículas).
- No revisar el presupuesto cada mes.

**Consejo:** Involucra a toda la familia en la elaboración del presupuesto para que todos sean conscientes de la situación y colaboren en el ahorro.''',
    quiz: PillQuiz(
      question: '¿Para qué sirve un presupuesto?',
      options: ['Gastar más', 'Organizar ingresos y gastos', 'Pagar impuestos', 'Ahorrar menos'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFE066),
    title: 'Registra tus gastos',
    shortDesc: 'Llevar un registro ayuda a identificar fugas de dinero.',
    content: '''Registrar todos tus gastos, por pequeños que sean, es clave para detectar en qué se va tu dinero. En España, los gastos hormiga (cafés, lotería, snacks, apps) pueden sumar más de 500€ al año.

**¿Cómo hacerlo?**
- Guarda los tickets y revisa los movimientos de tu cuenta bancaria.
- Usa apps como Fintonic o la app de tu banco (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) para categorizar automáticamente los gastos.
- Hazlo cada día o al menos una vez por semana para no olvidar nada.

**Ventajas:**
- Descubrirás gastos que puedes eliminar o reducir.
- Te ayudará a negociar mejores tarifas (teléfono, luz, seguros).

**Errores comunes:**
- Dejar de registrar los gastos después de unos días.
- No ser honesto contigo mismo (no apuntar compras "capricho").

**Consejo:** Hazlo un hábito, como lavarte los dientes. ¡La constancia es la clave!''',
    quiz: PillQuiz(
      question: '¿Por qué es útil registrar tus gastos?',
      options: ['Para gastar más', 'Para identificar fugas', 'Para pagar menos', 'Para invertir'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFE066),
    title: 'Prioriza necesidades',
    shortDesc: 'Diferencia entre necesidades y deseos.',
    content: '''Una de las claves del éxito financiero es saber distinguir entre necesidades (lo imprescindible para vivir) y deseos (lo que te gustaría tener pero no es esencial).

**Ejemplos de necesidades:**
- Vivienda, comida, suministros, transporte, salud.

**Ejemplos de deseos:**
- Restaurantes, ropa de marca, tecnología, viajes, ocio.

**¿Por qué es importante?**
En épocas de crisis o cuando el dinero escasea, priorizar las necesidades te permite mantener la estabilidad y evitar deudas innecesarias.

**Consejos:**
- Haz una lista de tus gastos y marca cuáles son necesidades y cuáles deseos.
- Si tienes que recortar, empieza por los deseos.

**Errores comunes:**
- Justificar deseos como necesidades ("necesito el último móvil para trabajar").
- Gastar primero en deseos y luego no llegar a fin de mes.

**Recuerda:** Satisfacer primero las necesidades te da tranquilidad y libertad para disfrutar de los deseos cuando sea posible.''',
    quiz: PillQuiz(
      question: '¿Qué debes cubrir primero en tu presupuesto?',
      options: ['Deseos', 'Necesidades básicas', 'Viajes', 'Tecnología'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFE066),
    title: 'Ajusta tu presupuesto',
    shortDesc: 'Revisa y ajusta tu presupuesto cada mes.',
    content: '''La vida cambia y tu presupuesto también debe hacerlo. Un mes puedes tener un gasto extra (ITV, dentista, comunión) y otro mes un ingreso extra (devolución de Hacienda, paga extra).

**¿Cómo ajustarlo?**
- Revisa tus ingresos y gastos cada mes.
- Si has gastado más de lo previsto, analiza por qué y corrige para el mes siguiente.
- Si has ahorrado más, decide si lo destinas a un objetivo (viaje, fondo de emergencia, inversión).

**Herramientas útiles:**
- Usa la app de tu banco (Santander, BBVA, ING, CaixaBank, Sabadell, Openbank) para ver gráficos y tendencias.
- Haz una reunión familiar mensual para revisar el presupuesto.

**Errores comunes:**
- No ajustar el presupuesto y repetir los mismos errores cada mes.
- No tener en cuenta los gastos estacionales (Navidad, vuelta al cole, vacaciones).

**Consejo:** Sé flexible, pero no pierdas de vista tus objetivos a largo plazo.''',
    quiz: PillQuiz(
      question: '¿Cada cuánto debes revisar tu presupuesto?',
      options: ['Cada año', 'Cada mes', 'Nunca', 'Cada semana'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFFFE066),
    title: 'Crea tu presupuesto',
    shortDesc: 'Haz tu propio presupuesto mensual.',
    content: '''El mejor ejercicio para aprender a gestionar tu dinero es crear tu propio presupuesto desde cero.

**¿Cómo hacerlo?**
1. Anota todos tus ingresos y gastos durante un mes.
2. Clasifica los gastos en necesidades y deseos.
3. Busca al menos un gasto que puedas reducir o eliminar.
4. Fija un objetivo de ahorro mensual (aunque sea pequeño).

**Herramientas:**
- Usa una hoja de cálculo, una libreta o una app.
- Bancos como Santander, BBVA, ING, CaixaBank, Sabadell y Openbank ofrecen plantillas y recursos en sus webs para ayudarte.

**Errores comunes:**
- No ser realista (subestimar gastos, sobreestimar ingresos).
- No revisar el presupuesto después de crearlo.

**Consejo:** Comparte tu presupuesto con alguien de confianza para recibir feedback y motivación.''',
    quiz: PillQuiz(
      question: '¿Qué herramienta puedes usar para hacer tu presupuesto?',
      options: ['Hoja de cálculo', 'Red social', 'Juego', 'Ninguna'],
      correctIndex: 0,
    ),
  ),
];

final List<EduPill> entrepreneurshipPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFB57EDC),
    title: '¿Qué es emprender?',
    shortDesc: 'Conceptos básicos de emprendimiento.',
    content: '''Emprender significa crear un negocio propio, asumir riesgos y buscar oportunidades para ofrecer productos o servicios que resuelvan problemas o satisfagan necesidades. En España, el emprendimiento ha crecido en la última década, aunque sigue habiendo barreras culturales y administrativas.

**¿Por qué emprender?**
- Para ser tu propio jefe y tomar tus propias decisiones.
- Para desarrollar una idea innovadora o mejorar algo que ya existe.
- Para tener flexibilidad y potencial de mayores ingresos a largo plazo.

**Pasos para emprender en España:**
1. Detecta una oportunidad: observa tu entorno, escucha a la gente, identifica problemas sin resolver.
2. Elabora un plan de negocio: define tu propuesta de valor, público objetivo, competencia, modelo de ingresos y gastos.
3. Elige la forma jurídica: autónomo, sociedad limitada, cooperativa, etc. Cada una tiene ventajas e inconvenientes fiscales y legales.
4. Busca financiación: ahorros propios, préstamos bancarios (Santander, BBVA, CaixaBank, Sabadell, ING y Openbank tienen líneas para emprendedores), ayudas públicas (ENISA, ICO, programas autonómicos), inversores privados.
5. Da de alta tu actividad: tramita el alta en Hacienda y Seguridad Social, y cumple con la normativa sectorial.

**Errores comunes:**
- No validar la idea antes de invertir mucho dinero.
- No calcular bien los costes y los impuestos (cuota de autónomos desde 80€ a 294€ según ingresos, IVA, IRPF, etc.).
- No separar las finanzas personales de las del negocio.

**Consejo:** Rodéate de otros emprendedores, busca asesoramiento en cámaras de comercio, asociaciones y bancos, y no temas fracasar: cada error es un aprendizaje.''',
    quiz: PillQuiz(
      question: '¿Qué significa emprender?',
      options: ['Crear un negocio', 'Gastar dinero', 'Ahorrar', 'Invertir'],
      correctIndex: 0,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFB57EDC),
    title: 'Detecta oportunidades',
    shortDesc: 'Observa problemas y necesidades a tu alrededor.',
    content: '''Detectar oportunidades es el primer paso para emprender con éxito. En España, muchos negocios surgen de necesidades locales o cambios en la sociedad (digitalización, envejecimiento, sostenibilidad).

**¿Cómo detectar oportunidades?**
- Escucha a tus amigos, familiares y clientes potenciales: ¿de qué se quejan? ¿Qué les gustaría que existiera?
- Observa tendencias: digitalización, economía verde, envejecimiento de la población, turismo sostenible.
- Analiza la competencia: ¿qué hacen bien y qué podrías mejorar?

**Ejemplo español:** El auge de las apps de reparto, los negocios de comida saludable o los servicios para mayores son respuestas a cambios sociales en España.

**Errores comunes:**
- Emprender solo por moda, sin analizar si hay demanda real.
- No adaptar la idea al contexto local (idioma, cultura, legislación).

**Consejo:** Haz encuestas, prototipos y prueba tu idea con clientes reales antes de invertir mucho dinero. Consulta recursos de bancos como Santander, BBVA, y Openbank, así como cámaras de comercio y asociaciones de emprendedores.''',
    quiz: PillQuiz(
      question: '¿Qué hace un buen emprendedor?',
      options: ['Ignora problemas', 'Detecta oportunidades', 'Gasta mucho', 'No escucha'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFB57EDC),
    title: 'Plan de negocio',
    shortDesc: 'La importancia de planificar antes de empezar.',
    content: '''Un plan de negocio es el documento que recoge la idea, el análisis de mercado, la estrategia, los recursos necesarios y las previsiones económicas de tu proyecto. En España, es fundamental para solicitar financiación (bancos, ayudas públicas) y para tener claro el camino a seguir.

**¿Qué debe incluir un buen plan de negocio?**
- Descripción de la idea y propuesta de valor.
- Análisis de mercado: clientes, competencia, tendencias.
- Estrategia comercial y de marketing.
- Plan de operaciones: recursos humanos, proveedores, logística.
- Previsión de ingresos, gastos y beneficios.
- Análisis de riesgos y plan de contingencia.

**Consejos prácticos:**
- Usa plantillas gratuitas (Santander, BBVA, CaixaBank).
- Sé realista con las cifras y no sobreestimes los ingresos.
- Pide feedback a otros emprendedores o mentores.

**Errores comunes:**
- No actualizar el plan cuando cambian las circunstancias.
- Hacerlo solo para pedir un préstamo y luego olvidarlo.

**Recuerda:** Un buen plan de negocio es tu hoja de ruta y te ayuda a anticipar problemas antes de que ocurran.''',
    quiz: PillQuiz(
      question: '¿Para qué sirve un plan de negocio?',
      options: ['Para improvisar', 'Para planificar y guiar el negocio', 'Para gastar más', 'Para evitar clientes'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFB57EDC),
    title: 'Aprende de los errores',
    shortDesc: 'El fracaso es parte del aprendizaje.',
    content: '''En el mundo del emprendimiento, el error y el fracaso son inevitables y forman parte del proceso de aprendizaje. En España, la cultura del miedo al fracaso está cambiando, pero aún cuesta asumirlo como algo natural.

**¿Por qué es importante aprender de los errores?**
- Cada error te da información valiosa para mejorar tu negocio.
- Los grandes emprendedores han fracasado varias veces antes de tener éxito.
- Compartir tus errores con otros puede ayudarles a no cometer los mismos.

**Consejos prácticos:**
- Analiza cada error: ¿qué salió mal? ¿qué podrías haber hecho diferente?
- No te castigues: céntrate en la solución, no en el problema.
- Rodéate de una red de apoyo (otros emprendedores, asociaciones, mentores, bancos como Santander, BBVA, CaixaBank, ING, Sabadell, Openbank que ofrecen asesoramiento).

**Errores comunes:**
- Ocultar los errores por vergüenza.
- No cambiar nada después de un fracaso.

**Recuerda:** El fracaso no es el final, es una oportunidad para empezar de nuevo con más experiencia.''',
    quiz: PillQuiz(
      question: '¿Qué debes hacer si fracasas en tu emprendimiento?',
      options: ['Rendirse', 'Aprender y mejorar', 'Ignorar', 'Culpar a otros'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFB57EDC),
    title: 'Crea tu pitch',
    shortDesc: 'Resume tu idea de negocio en 1 minuto.',
    content: '''Un pitch es una presentación breve y clara de tu negocio, pensada para captar la atención de inversores, clientes o colaboradores. En España, cada vez es más habitual participar en concursos de pitch o presentaciones ante inversores.

**¿Cómo hacer un buen pitch?**
- Explica el problema que resuelves y por qué es importante.
- Presenta tu solución de forma sencilla y atractiva.
- Habla de tu equipo y por qué sois los mejores para llevarlo a cabo.
- Muestra el potencial de crecimiento y el modelo de negocio.
- Termina con una llamada a la acción (invertir, colaborar, probar el producto).

**Consejos prácticos:**
- Practica tu pitch hasta poder hacerlo en menos de 1 minuto.
- Usa ejemplos y datos concretos.
- Adapta el mensaje al público (inversores, clientes, jurado).
- Consulta recursos y programas de aceleración de bancos como Santander, BBVA, CaixaBank, Sabadell, ING y Openbank, así como de cámaras de comercio y asociaciones de emprendedores.

**Errores comunes:**
- Hablar demasiado de la idea y poco del mercado o del equipo.
- No transmitir pasión ni confianza.

**Recuerda:** Un buen pitch puede abrirte muchas puertas, pero solo si eres capaz de transmitir tu visión de forma clara y convincente.''',
    quiz: PillQuiz(
      question: '¿Qué es un pitch?',
      options: ['Un plan largo', 'Una presentación breve', 'Un producto', 'Un cliente'],
      correctIndex: 1,
    ),
  ),
];

final List<EduPill> debtPills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFA07A),
    title: 'Deuda buena vs mala',
    shortDesc: 'No todas las deudas son iguales.',
    content: '''En España, como en otros países, no todas las deudas son iguales. Es fundamental distinguir entre deuda buena y deuda mala para tomar decisiones financieras inteligentes.

**Deuda buena:**
- Es la que te ayuda a generar ingresos o a aumentar tu patrimonio a largo plazo.
- Ejemplos: hipoteca para comprar una vivienda habitual (tipo fijo o variable, con bancos como Santander, BBVA, CaixaBank, ING, Sabadell, Openbank), préstamo para estudios universitarios o máster, financiación para montar un negocio rentable.
- Suele tener tipos de interés bajos (hipotecas desde el 2,5% TAE en 2024) y plazos largos.

**Deuda mala:**
- Es la que se utiliza para consumir bienes o servicios que no generan valor a futuro.
- Ejemplos: compras con tarjeta de crédito a plazos, préstamos rápidos para vacaciones, financiar un coche de alta gama sin necesitarlo.
- Suele tener intereses altos (tarjetas de crédito 15-25% TAE, préstamos rápidos hasta 30% TAE) y puede llevarte al sobreendeudamiento.

**Consejos prácticos:**
- Antes de pedir un préstamo, pregúntate: ¿esto me ayudará a mejorar mi situación financiera en el futuro?
- Compara siempre las condiciones (TAE, comisiones, plazos) entre bancos. Santander, BBVA, CaixaBank, ING, Sabadell y Openbank ofrecen simuladores online para comparar préstamos.

**Errores comunes:**
- Pedir préstamos para tapar otros préstamos (efecto bola de nieve).
- No leer la letra pequeña de los contratos.

**Recuerda:** La deuda puede ser una herramienta útil si se usa con cabeza, pero puede convertirse en un problema si se abusa de ella.''',
    quiz: PillQuiz(
      question: '¿Cuál es un ejemplo de deuda buena?',
      options: ['Tarjeta de crédito', 'Hipoteca para vivienda', 'Préstamo para vacaciones', 'Compra de ropa'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFA07A),
    title: 'Método bola de nieve',
    shortDesc: 'Ordena tus deudas y págales en orden.',
    content: '''El método bola de nieve es una estrategia muy eficaz para salir de deudas, especialmente si tienes varias a la vez (tarjetas, préstamos personales, etc.).

**¿Cómo funciona?**
1. Haz una lista de todas tus deudas, de menor a mayor importe pendiente.
2. Paga el mínimo en todas, excepto en la más pequeña, a la que destinas todo el dinero extra que puedas.
3. Cuando la liquides, pasa al siguiente préstamo más pequeño, y así sucesivamente.

**Ventajas:**
- Te motiva ver resultados rápidos (deudas que desaparecen).
- Libera dinero para atacar la siguiente deuda.

**Ejemplo español:** Si tienes una tarjeta de crédito con 500€, un préstamo personal de 2.000€ y una deuda familiar de 1.000€, empieza por la tarjeta, luego la deuda familiar y por último el préstamo. Puedes usar la app de tu banco (Santander, BBVA, CaixaBank, ING, Sabadell, Openbank) para programar pagos automáticos y no olvidar ninguna cuota.

**Errores comunes:**
- No dejar de usar las tarjetas mientras pagas las deudas.
- No ajustar el presupuesto para evitar nuevas deudas.

**Consejo:** Si tienes dudas, consulta con el servicio de atención al cliente de tu banco o con asociaciones de ayuda al endeudado como ADICAE, OCU o la propia banca online.''',
    quiz: PillQuiz(
      question: '¿Qué deuda debes pagar primero con el método bola de nieve?',
      options: ['La más grande', 'La más pequeña', 'La de menor interés', 'La de mayor interés'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFFFFA07A),
    title: 'Historial crediticio',
    shortDesc: 'La importancia de un buen historial.',
    content: '''El historial crediticio es el registro de cómo has gestionado tus deudas y pagos a lo largo del tiempo. En España, este historial es consultado por bancos y entidades financieras antes de concederte un préstamo, una hipoteca o incluso un contrato de telefonía.

**¿Por qué es importante?**
- Un buen historial te permite acceder a mejores condiciones de financiación (intereses más bajos, mayor importe, menos comisiones).
- Un mal historial (impagos, retrasos, deudas en ASNEF) puede cerrarte muchas puertas.

**¿Cómo se construye y mantiene?**
- Paga siempre tus recibos y cuotas a tiempo.
- No abuses de las tarjetas de crédito ni de los préstamos rápidos.
- Si tienes problemas para pagar, habla con tu banco antes de que la deuda se agrave. Santander, BBVA, CaixaBank, ING, Sabadell y Openbank ofrecen servicios de asesoramiento para clientes con dificultades.

**Errores comunes:**
- Ignorar cartas o avisos de impago.
- Pedir préstamos a nombre de otra persona.

**Consejo:** Consulta tu historial en ficheros como ASNEF o CIRBE (Banco de España) para saber si tienes incidencias. Los bancos pueden ayudarte a mejorar tu perfil crediticio con productos adaptados y consejos personalizados.''',
    quiz: PillQuiz(
      question: '¿Por qué es importante el historial crediticio?',
      options: ['Para obtener mejores préstamos', 'Para gastar más', 'Para evitar ahorrar', 'No es importante'],
      correctIndex: 0,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFFFFA07A),
    title: 'Evita el sobreendeudamiento',
    shortDesc: 'No pidas más de lo que puedes pagar.',
    content: '''El sobreendeudamiento ocurre cuando tus deudas superan tu capacidad de pago. En España, esto puede llevar a embargos, inclusión en listas de morosos y graves problemas financieros y personales.

**¿Cómo evitarlo?**
- No pidas préstamos para cubrir otros préstamos (efecto bola de nieve).
- Calcula tu ratio de endeudamiento: la suma de tus cuotas mensuales no debe superar el 35-40% de tus ingresos netos. Compara ofertas de bancos como Santander, BBVA, CaixaBank, ING, Sabadell y Openbank.

**Errores comunes:**
- Usar tarjetas de crédito para gastos cotidianos y no pagar el total a fin de mes.
- No tener un fondo de emergencia y recurrir siempre al crédito.

**Consejo:** Si ya tienes problemas, acude a tu banco o a asociaciones de ayuda al endeudado (ADICAE, OCU) para buscar soluciones antes de que sea tarde.''',
    quiz: PillQuiz(
      question: '¿Qué debes evitar al usar crédito?',
      options: ['Pedir más de lo necesario', 'Pagar a tiempo', 'Comparar opciones', 'Ahorrar'],
      correctIndex: 0,
    ),
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFFFFA07A),
    title: 'Auditoría de deudas',
    shortDesc: 'Haz una lista de todas tus deudas.',
    content: '''Hacer una auditoría de deudas es el primer paso para tomar el control de tu situación financiera. Consiste en recopilar toda la información sobre tus deudas y analizarla para tomar decisiones.

**¿Cómo hacerla?**
1. Haz una lista de todas tus deudas: importe pendiente, tipo de interés, cuota mensual, plazo restante, entidad.
2. Ordena las deudas por importe, tipo de interés o urgencia.
3. Calcula el total de tu deuda y el coste mensual.
4. Analiza si puedes renegociar condiciones, reunificar deudas o buscar mejores ofertas. Bancos como Santander, BBVA, CaixaBank, ING, Sabadell y Openbank ofrecen simuladores y asesores para ayudarte a gestionar tus deudas.

**Errores comunes:**
- Olvidar deudas pequeñas (tarjetas, tiendas, familiares).
- No revisar los extractos bancarios y contratos.

**Consejo:** Usa una hoja de cálculo o una app para llevar el control. Consulta con tu banco y con asociaciones de consumidores para encontrar la mejor solución a tu caso.''',
    quiz: PillQuiz(
      question: '¿Para qué sirve una auditoría de deudas?',
      options: ['Para gastar más', 'Para conocer y priorizar pagos', 'Para pedir más préstamos', 'No sirve'],
      correctIndex: 1,
    ),
  ),
];

final List<EduPill> insurancePills = [
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED9C2),
    title: '¿Qué es un seguro?',
    shortDesc: 'Protege tu patrimonio y tu salud.',
    content: '''Un seguro es un contrato por el cual una compañía (aseguradora) se compromete a indemnizarte o prestarte un servicio si ocurre un evento adverso (accidente, robo, enfermedad, etc.), a cambio del pago de una prima.

**¿Por qué son importantes los seguros en España?**
- El sistema público cubre muchas cosas (salud, pensiones), pero no todo. Un seguro te protege ante imprevistos que pueden tener un gran impacto económico.
- Ejemplo: un seguro de hogar cubre daños por incendio, robo o agua; un seguro de salud te da acceso rápido a especialistas; un seguro de vida protege a tu familia si tú faltas.

**Tipos de seguros más comunes:**
- Seguro de hogar: obligatorio si tienes hipoteca. Cubre daños materiales y responsabilidad civil. Ofrecido por bancos como Santander, BBVA, CaixaBank, Sabadell y aseguradoras como Mapfre, Mutua Madrileña, Línea Directa.
- Seguro de salud: complementa la sanidad pública, permite elegir médico y hospital. Compara ofertas de Santander, Adeslas, Sanitas, DKV, Asisa, BBVA, CaixaBank, ING, Sabadell.
- Seguro de vida: garantiza un capital a tus beneficiarios en caso de fallecimiento. Disponible en Santander, BBVA, CaixaBank, Sabadell, Mapfre, Mutua Madrileña, etc.
- Seguro de coche: obligatorio para circular. Elige entre terceros, terceros ampliado o todo riesgo. Compara precios y coberturas en bancos y aseguradoras.

**Errores comunes:**
- Contratar seguros sin comparar coberturas y precios.
- No revisar las condiciones y exclusiones.
- No actualizar los capitales asegurados con el tiempo.

**Consejo:** Antes de contratar, pide varias ofertas (Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Mutua Madrileña, Línea Directa, etc.) y revisa bien qué cubre y qué no. Un seguro barato puede salir caro si no cubre lo que necesitas.''',
    quiz: PillQuiz(
      question: '¿Cuál es la función principal de un seguro?',
      options: ['Ganar dinero', 'Proteger ante imprevistos', 'Ahorrar', 'Invertir'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED9C2),
    title: 'Seguro de salud',
    shortDesc: 'La importancia de estar cubierto.',
    content: '''En España, la sanidad pública es de calidad, pero en ocasiones hay listas de espera largas o no se cubren ciertos tratamientos. Un seguro de salud privado te permite acceder más rápido a especialistas, pruebas diagnósticas y tratamientos.

**Ventajas de un seguro de salud privado:**
- Elección de médico y hospital.
- Rapidez en consultas y operaciones.
- Cobertura de servicios no incluidos en la sanidad pública (fisioterapia, psicología, etc.).

**Errores comunes:**
- Contratar el seguro solo por el precio, sin mirar coberturas.
- No declarar enfermedades preexistentes (puede ser motivo de exclusión).

**Consejo:** Compara varias compañías y bancos (Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Sanitas, Adeslas, DKV, Asisa, Mutua Madrileña) y elige la que mejor se adapte a tus necesidades y presupuesto. Lee bien las condiciones y periodos de carencia.''',
    quiz: PillQuiz(
      question: '¿Por qué es importante el seguro de salud?',
      options: ['Por obligación', 'Para evitar deudas por emergencias', 'Para viajar', 'No es importante'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'LECCIÓN',
    typeColor: Color(0xFF7ED9C2),
    title: 'Seguro de vida',
    shortDesc: 'Protege a tu familia en caso de fallecimiento.',
    content: '''El seguro de vida es un producto que garantiza un capital o una renta a los beneficiarios designados en caso de fallecimiento del asegurado. En España, es especialmente recomendable si tienes hijos, pareja o personas a tu cargo.

**¿Por qué contratar un seguro de vida?**
- Para que tu familia pueda mantener su nivel de vida si tú faltas.
- Para cubrir deudas pendientes (hipoteca, préstamos).
- Para dejar un respaldo económico ante imprevistos graves.

**Tipos de seguro de vida:**
- Riesgo puro: solo cubre fallecimiento.
- Vida ahorro: combina protección y ahorro/inversión.

**Errores comunes:**
- No actualizar los beneficiarios tras cambios familiares (divorcio, nacimiento de hijos).
- Contratar un capital insuficiente.

**Consejo:** Calcula bien el capital necesario (deudas + gastos familiares x años) y revisa las condiciones cada cierto tiempo. Santander, BBVA, CaixaBank, Sabadell, Mapfre, Mutua Madrileña y otras entidades ofrecen simuladores online para ayudarte.''',
    quiz: PillQuiz(
      question: '¿Para quién es útil el seguro de vida?',
      options: ['Solo para solteros', 'Para quienes tienen dependientes', 'Para todos', 'No es útil'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'CONSEJO',
    typeColor: Color(0xFF7ED9C2),
    title: 'Compara seguros',
    shortDesc: 'No todos los seguros son iguales.',
    content: '''No todos los seguros ofrecen las mismas coberturas ni cuestan lo mismo. Comparar es fundamental para no pagar de más ni quedarte corto de protección.

**¿Qué debes comparar?**
- Coberturas incluidas y excluidas.
- Límites de indemnización y franquicias.
- Precio de la prima y posibles subidas.
- Servicio de atención al cliente y facilidad de gestión de siniestros.

**Errores comunes:**
- Contratar el seguro más barato sin mirar coberturas.
- No preguntar por las exclusiones (lo que NO cubre el seguro).

**Consejo:** Usa comparadores online, pide varias ofertas y consulta opiniones de otros clientes. Bancos y aseguradoras como Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Mutua Madrileña, Línea Directa y otras tienen simuladores y atención personalizada.''',
    quiz: PillQuiz(
      question: '¿Qué debes hacer antes de contratar un seguro?',
      options: ['Contratar el primero', 'Comparar opciones', 'No leer condiciones', 'Pagar más'],
      correctIndex: 1,
    ),
  ),
  EduPill(
    type: 'DESAFÍO',
    typeColor: Color(0xFF7ED9C2),
    title: 'Revisa tus pólizas',
    shortDesc: 'Asegúrate de estar bien cubierto.',
    content: '''Revisar tus pólizas de seguro periódicamente es clave para no llevarte sorpresas desagradables cuando más lo necesitas.

**¿Por qué revisarlas?**
- Tu situación personal cambia (nacimiento de hijos, mudanza, compra de coche nuevo, etc.).
- Las condiciones y precios de los seguros pueden variar cada año.
- Puedes encontrar mejores ofertas o coberturas más adecuadas.

**¿Cómo hacerlo?**
- Haz una lista de todos tus seguros (hogar, vida, salud, coche, etc.).
- Revisa las coberturas, capitales asegurados y exclusiones.
- Contacta con tu aseguradora o banco (Santander, BBVA, CaixaBank, ING, Sabadell, Mapfre, Mutua Madrileña, Línea Directa, etc.) para resolver dudas o actualizar datos.

**Errores comunes:**
- No revisar nunca las pólizas y descubrir tarde que no cubren lo necesario.
- Pagar de más por coberturas que no necesitas.

**Consejo:** Marca en tu calendario una fecha al año para revisar todos tus seguros. Puedes pedir ayuda a tu banco, aseguradora o corredor de seguros para comparar y actualizar tus pólizas.''',
    quiz: PillQuiz(
      question: '¿Por qué revisar tus pólizas regularmente?',
      options: ['Por costumbre', 'Para actualizar coberturas', 'Para pagar más', 'No es necesario'],
      correctIndex: 1,
    ),
  ),
];

// --- PANTALLA DE DETALLE DE TEMA ---
class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF7),
      appBar: AppBar(
        backgroundColor: topic.pillColor,
        foregroundColor: Colors.white,
        title: Text(topic.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topic.pills.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final pill = topic.pills[i];
          return _PillCard(pill: pill);
        },
      ),
    );
  }
}

class _PillCard extends StatefulWidget {
  final EduPill pill;
  const _PillCard({required this.pill});

  @override
  State<_PillCard> createState() => _PillCardState();
}

class _PillCardState extends State<_PillCard> {
  bool expanded = false;
  int? selected;
  bool? correct;
  List<String>? shuffledOptions;
  int? correctIndexAfterShuffle;

  @override
  Widget build(BuildContext context) {
    final pill = widget.pill;
    
    // Generar opciones mezcladas cuando se expande por primera vez
    if (expanded && shuffledOptions == null) {
      shuffledOptions = pill.quiz.getShuffledOptions();
      correctIndexAfterShuffle = pill.quiz.getCorrectIndexAfterShuffle(shuffledOptions!);
    }
    
    // Resetear cuando se colapsa
    if (!expanded) {
      shuffledOptions = null;
      correctIndexAfterShuffle = null;
      selected = null;
      correct = null;
    }
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: pill.typeColor.withOpacity(0.13),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: pill.typeColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: pill.typeColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    pill.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pill.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: pill.typeColor.darken(0.2),
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: pill.typeColor.darken(0.2),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                pill.shortDesc,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            onTap: () => setState(() => expanded = !expanded),
          ),
          if (expanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                pill.content,
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test rápido:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: pill.typeColor.darken(0.2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pill.quiz.question,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(shuffledOptions!.length, (i) {
                    final isSelected = selected == i;
                    final isCorrect = correct == true && isSelected;
                    final isWrong = correct == false && isSelected;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCorrect
                              ? Colors.green
                              : isWrong
                                  ? Colors.red
                                  : Colors.white,
                          foregroundColor: isCorrect || isWrong
                              ? Colors.white
                              : pill.typeColor.darken(0.2),
                          side: BorderSide(color: pill.typeColor.withOpacity(0.3)),
                          elevation: 0,
                        ),
                        onPressed: correct == null
                            ? () {
                                setState(() {
                                  selected = i;
                                  correct = i == correctIndexAfterShuffle;
                                });
                              }
                            : null,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            shuffledOptions![i],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (correct != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            correct! ? Icons.check_circle : Icons.cancel,
                            color: correct! ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            correct! ? '¡Correcto!' : 'Incorrecto',
                            style: TextStyle(
                              color: correct! ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- EXTENSIÓN PARA OSCURECER COLOR ---
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}