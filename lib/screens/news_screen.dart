import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/currency_helper.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  final List<NewsArticle> articles = const [
    NewsArticle(
      title: 'SpaceX debuta en bolsa: la mayor OPV de la historia',
      summary:
          'SpaceX recaudó \$75.000 millones a \$135 por acción (SPCX). En su primer día subió un 19% y superó los \$2 billones de valoración.',
      content: '''Space Exploration Technologies Corp. completó el 12 de junio de 2026 la mayor oferta pública inicial (OPV) de la historia: 555,6 millones de acciones a \$135 cada una, recaudando unos \$75.000 millones.

Las acciones cotizan en el Nasdaq bajo el ticker SPCX y también en Nasdaq Texas. El cierre del primer día fue de \$160,95 (+19%), lo que sitúa la valoración de la empresa en torno a \$2,1 billones — la sexta compañía más valiosa de EE.UU.

Contexto clave para inversores:
• Demanda récord: la OPV atrajo interés cuatro veces superior a las acciones ofertadas
• Musk como accionista principal: su participación vale cientos de miles de millones a este precio
• Sin beneficios aún: SpaceX genera ingresos muy inferiores a otras tech de valor similar
• Próximas OPV de IA: OpenAI y Anthropic también han presentado documentos confidenciales

Lección financiera: las OPV masivas pueden revalorizarse el primer día ("IPO pop"), pero conllevan alto riesgo. No inviertas dinero que no puedas permitirte perder.''',
      category: 'OPVs',
      time: '2 días',
      imageUrl: '🚀',
    ),
    NewsArticle(
      title: 'OpenAI y Anthropic preparan sus salidas a bolsa',
      summary:
          'Tras SpaceX, las dos grandes empresas de IA han presentado registros confidenciales. OpenAI buscaría más de \$60.000 millones.',
      content: '''El mercado de OPVs de 2026 está dominado por la inteligencia artificial. Tras el debut de SpaceX, la atención se centra en dos nuevas candidatas:

OpenAI
• Presentó registro confidencial en junio de 2026
• Podría buscar más de \$60.000 millones en una OPV
• Fecha prevista: finales de 2026 o principios de 2027

Anthropic
• Registro confidencial el 1 de junio de 2026
• Posible debut en octubre de 2026, según medios financieros

Otras OPV en el radar: Discord (registro en enero), Inspire Brands (Dunkin', Arby's…) y Databricks (posiblemente 2027).

Para el inversor retail:
• Las OPV de IA suelen valorarse por expectativas de crecimiento, no por beneficios actuales
• Los fondos indexados (ETF) no suelen incluir nuevas emisiones de inmediato
• Diversificar sigue siendo clave: no concentres todo en un solo sector, por muy popular que sea''',
      category: 'OPVs',
      time: '3 días',
      imageUrl: '🤖',
    ),
    NewsArticle(
      title: '100 días de conflicto en Irán: mercados bajo presión',
      summary:
          'El cierre del Estrecho de Ormuz dispara el petróleo (+36-50%) y la inflación global. El Banco Mundial recorta su previsión de crecimiento al 2,5%.',
      content: '''A mediados de junio de 2026 se cumplen 100 días de conflicto en Oriente Medio. El impacto económico es global:

Energía y comercio
• El Estrecho de Ormuz, por donde pasa ~20% del petróleo y GNL mundial, está prácticamente cerrado
• Brent cotiza ~36% por encima del nivel previo al conflicto; WTI ~50% más caro
• También se ven afectados fertilizantes, azufre y fosfatos

Crecimiento económico
• Banco Mundial: crecimiento global de 2,5% en 2026 (mínimo desde la pandemia)
• OCDE: hasta \$700.000 millones de pérdida potencial si el conflicto se prolonga
• Comercio mundial: desaceleración prevista en Q2-Q3 de 2026

Mercados bursátiles
• Caída inicial en muchas bolsas, pero el S&P 500 ha recuperado y marcado nuevos máximos
• Los bonos del Tesoro USA subieron de rendimiento por temor inflacionista
• El oro y activos refugio han atraído capital

Lección: los conflictos geopolíticos afectan precios de energía, inflación y tipos de interés — incluso cuando las bolsas parecen "mirar hacia otro lado".''',
      category: 'Conflictos',
      time: '1 semana',
      imageUrl: '⚔️',
    ),
    NewsArticle(
      title: 'Negociaciones de tregua impulsan las bolsas',
      summary:
          'Trump anunció un posible acuerdo con Irán; el S&P 500 subió 1,7% y el Brent cayó 4,2%. Teherán niega que haya un pacto cerrado.',
      content: '''El 12 de junio de 2026 las bolsas reaccionaron con fuerza a señales de una posible tregua en el conflicto con Irán:

Reacción de mercados
• S&P 500: +1,7% | Nasdaq: +2,5% | Dow Jones: +1,8%
• Brent: -4,2% hasta \$89,21/barril
• Los inversores apuestan a que el conflicto no escalará más

Estado de las negociaciones
• La Casa Blanca habla de un "gran acuerdo" para terminar la guerra
• Medios iraníes mencionan un borrador: suspensión de sanciones al petróleo iraní y reapertura del Ormuz a cambio de 60 días de negociación
• El Ministerio de Exteriores de Irán niega que haya un acuerdo inminente

Energía USA
• EE.UU. lideró las exportaciones de crudo en mayo (~10,5 M bbl/día)
• Rusia y Arabia Saudita exportaron menos por sanciones y el conflicto

Para el inversor: las noticias de paz o guerra mueven el petróleo en horas. Evita decisiones impulsivas basadas en un solo titular.''',
      category: 'Conflictos',
      time: '2 días',
      imageUrl: '🕊️',
    ),
    NewsArticle(
      title: 'El BCE sube tipos por primera vez en 3 años',
      summary:
          'Subida de 25 pb: el depósito pasa al 2,25%. La inflación en la eurozona alcanza el 3,2%, empujada por la energía (+10,9%).',
      content: '''El 11 de junio de 2026 el Banco Central Europeo rompió su ciclo de recortes y subió los tipos 25 puntos básicos por primera vez desde 2023:

Nuevos tipos (vigentes desde el 17 de junio)
• Facilidad de depósito: 2,25% (antes 2,00%)
• Operaciones principales de refinanciación: 2,40%
• Facilidad de crédito marginal: 2,65%

Motivo: la guerra en Oriente Medio
• Inflación de la eurozona: 3,2% en mayo (máximo desde 2023)
• Inflación de energía: 10,9%
• Inflación subyacente: 2,5% (también al alza)

Previsiones revisadas a la baja
• Crecimiento eurozona 2026: 0,8% (revisión a la baja)
• Inflación 2026: 3,0% | 2027: 2,3% | 2028: 2,0%

Christine Lagarde: "No nos comprometemos a una trayectoria concreta de tipos."

Impacto práctico: hipotecas variables, préstamos empresariales y ahorro en depósitos se verán afectados. Si tienes deuda a tipo variable, conviene revisar tu presupuesto.''',
      category: 'Política Monetaria',
      time: '3 días',
      imageUrl: '🏦',
    ),
    NewsArticle(
      title: 'La Fed mantiene tipos pero endurece el tono',
      summary:
          'Reunión FOMC 16-17 de junio. Tipos en 3,50-3,75%. Inflación USA al 4,2% por el shock energético; mercado vigila subidas futuras.',
      content: '''La Reserva Federal de EE.UU. celebra su reunión de junio (16-17) con el mercado en vilo:

Situación actual
• Tipos de referencia: 3,50% - 3,75%
• Probabilidad de subida inmediata: baja (~2% según mercados)
• Pero más del 60% de probabilidad de subida antes de fin de año

Inflación USA (mayo 2026)
• IPC interanual: 4,2% (subió desde 3,8% en abril)
• Energía: +23,5% interanual; gasolina +40,5%
• Empleo sólido: el mercado laboral sigue fuerte

Escenario "pausa hawkish"
• Sin recortes de tipos a corto plazo
• El dólar se mantiene fuerte frente a divisas con tipos más bajos
• El oro puede corregir si la Fed minimiza el riesgo inflacionista

Diferencia clave con Europa: el BCE ya subió tipos; la Fed espera más datos. Para préstamos en dólares o inversiones globales, esta divergencia importa.''',
      category: 'Política Monetaria',
      time: '1 día',
      imageUrl: '🇺🇸',
    ),
    NewsArticle(
      title: 'Petróleo e inflación: el doble golpe al bolsillo',
      summary:
          'El Brent sigue un 36% por encima de niveles pre-guerra. Alemania e India intervienen para contener precios de energía.',
      content: '''A pesar de las caídas recientes, el petróleo sigue muy por encima de los niveles previos al conflicto en Irán:

Precios actuales (contexto junio 2026)
• Brent: ~36% más caro que antes del conflicto
• WTI (USA): ~50% por encima del nivel pre-guera
• Picos intradía durante misiles, negociaciones y rumores de tregua

Efecto en la inflación
• Eurozona: energía +10,9% interanual en mayo
• USA: gasolina +40,5% interanual
• Alimentos y transporte suben por encadenamiento de costes

Respuestas gubernamentales
• Alemania e India han intervenido para limitar el impacto en consumidores
• Reservas estratégicas y subsidios temporales en varios países

Consejo financiero personal:
• Revisa tu presupuesto de transporte y calefacción
• Un fondo de emergencia de 3-6 meses es especialmente útil en periodos de inflación
• No abandones inversiones a largo plazo por pánico, pero sí ajusta gastos variables''',
      category: 'Commodities',
      time: '4 días',
      imageUrl: '🛢️',
    ),
    NewsArticle(
      title: 'Semiconductores e IA: el sector que resiste',
      summary:
          'El índice PHLX de semiconductores sube un 82% en 2026. La carrera por infraestructura de IA impulsa Nvidia, Broadcom y el sector tech.',
      content: '''Mientras el conflicto en Oriente Medio presiona la energía, el sector de semiconductores e IA vive un rally histórico:

Rendimiento 2026 (hasta junio)
• Índice PHLX Semiconductores: +81,8%
• Nasdaq-100: +15,4% (pese a la volatilidad reciente)
• La demanda de chips para centros de datos de IA no da señales de frenarse

Empresas destacadas
• Nvidia, Broadcom, AMD y TSMC entre las más beneficiadas
• SpaceX vincula su OPV al boom de IA (centros de datos en el espacio)
• OpenAI y Anthropic dependen de esta infraestructura para escalar

Riesgos a tener en cuenta
• Valoraciones muy elevadas: correcciones del 10-20% son posibles
• Concentración: pocos nombres arrastran índices enteros
• Regulación y tensiones comerciales USA-China siguen activas

Regla de diversificación: si inviertes en tech/IA, equilibra con otros sectores (salud, consumo, bonos) según tu perfil de riesgo.''',
      category: 'Tecnología',
      time: '3 días',
      imageUrl: '💻',
    ),
    NewsArticle(
      title: 'Energías renovables: oportunidad en medio del caos',
      summary:
          'El shock del petróleo acelera inversiones en solar y eólica. Europa apuesta por independencia energética tras la crisis del Ormuz.',
      content: '''El cierre del Estrecho de Ormuz ha reactivado el debate sobre independencia energética — y las renovables son protagonistas:

Por qué ahora
• Dependencia del petróleo y gas del Golfo expuesta como vulnerabilidad estratégica
• UE y varios países aceleran licitaciones solares y eólicas
• Almacenamiento (baterías) gana prioridad en planes de inversión

Inversiones en juego
• Solar: mayor cuota de nuevos proyectos en Europa y Asia
• Eólica offshore: expansión en el Mar del Norte y costas atlánticas
• Hidrógeno verde: proyectos piloto financiados con fondos públicos

Empresas del sector (referencia)
• NextEra Energy, Iberdrola, Ørsted, Enphase entre las más seguidas
• ETFs de energía limpia (ICLN, QCLN) permiten diversificar sin elegir una sola acción

Ojo: las renovables son inversión a largo plazo. No esperes ganancias rápidas como en una OPV de IA, pero pueden proteger tu cartera ante shocks de petróleo futuros.''',
      category: 'Energía',
      time: '5 días',
      imageUrl: '🌱',
    ),
    NewsArticle(
      title: 'Empleo sólido en EE.UU. complica la política de la Fed',
      summary:
          'El mercado laboral sigue fuerte pese al conflicto. Menos paro = menos presión para recortar tipos, aunque la inflación suba.',
      content: '''Los datos de empleo en EE.UU. siguen sorprendiendo al alza en junio de 2026, complicando la ecuación para la Reserva Federal:

Datos clave
• Creación de empleos por encima de lo esperado en los últimos meses
• Desempleo cerca del 4,1% — niveles históricamente bajos
• Salarios con presión al alza en sectores de servicios y construcción

El dilema de la Fed
• Empleo fuerte → economía resiliente → menos motivos para recortar tipos
• Inflación al 4,2% → presión para subir o mantener tipos altos más tiempo
• Resultado probable: "pausa hawkish" (sin recortes, tono duro)

Sectores que más contratan
• Salud y servicios sociales
• Ocio y hostelería
• Construcción residencial

Para tu cartera: un mercado laboral fuerte suele ser bueno para acciones a medio plazo, pero tipos altos perjudican a inmobiliario y empresas muy endeudadas.''',
      category: 'Economía',
      time: '1 semana',
      imageUrl: '👷',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B6B4B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.newspaper, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Noticias Financieras',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B6B4B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Text(
                    'Junio 2026 · OPVs, conflictos y mercados',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _NewsCard(article: article),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewsArticle {
  final String title;
  final String summary;
  final String content;
  final String category;
  final String time;
  final String imageUrl;

  const NewsArticle({
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.time,
    required this.imageUrl,
  });
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showArticleDetail(context, article),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        article.imageUrl,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B6B4B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B6B4B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hace ${article.time}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B6B4B),
                ),
              ),
              const SizedBox(height: 8),
              Consumer<AppProvider>(
                builder: (context, app, _) => Text(
                  context.localizeMoneyText(article.summary),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Leer más',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B6B4B),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF1B6B4B),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArticleDetail(BuildContext context, NewsArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticia'),
        backgroundColor: const Color(0xFF1B6B4B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B6B4B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                article.category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B6B4B),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hace ${article.time}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B6B4B),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  article.imageUrl,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<AppProvider>(
              builder: (context, app, _) => Text(
                CurrencyHelper.localizeLessonText(article.content, app.currency),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF1B6B4B),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Esta información es para fines educativos. Consulta con un asesor financiero antes de tomar decisiones de inversión.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 