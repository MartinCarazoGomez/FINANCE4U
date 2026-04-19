import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  final List<NewsArticle> articles = const [
    NewsArticle(
      title: 'Mercados globales bajo presión por tensiones geopolíticas',
      summary: 'Los mercados internacionales reaccionaron a los recientes acontecimientos, generando volatilidad en las bolsas.',
      content: '''Los mercados bursátiles globales experimentan una nueva jornada de volatilidad debido a las crecientes tensiones geopolíticas en diferentes regiones del mundo.

El índice S&P 500 cerró con una caída del 1.2%, mientras que el Nasdaq registró pérdidas del 1.8%. En Europa, el Euro Stoxx 50 descendió un 1.5%.

Los inversores buscan refugio en activos seguros como los bonos del tesoro estadounidense y el oro, que han mostrado un comportamiento alcista en las últimas sesiones.

Los analistas recomiendan cautela y diversificación en las carteras de inversión durante este período de incertidumbre.''',
      category: 'Mercados',
      time: '2 horas',
      imageUrl: '📈',
    ),
    NewsArticle(
      title: 'La Fed y el BCE mantienen cautela con los tipos de interés',
      summary: 'Los bancos centrales mantienen sus tasas ante señales mixtas de inflación y crecimiento económico.',
      content: '''La Reserva Federal estadounidense y el Banco Central Europeo han decidido mantener sus tipos de interés sin cambios en sus últimas reuniones.

La Fed mantiene su tasa de referencia entre 5.25% y 5.50%, mientras que el BCE conserva su tasa de depósito en 4.00%.

Las decisiones responden a datos económicos mixtos que muestran una inflación que, aunque descendente, aún permanece por encima de los objetivos del 2%.

Jerome Powell, presidente de la Fed, indicó que "necesitamos más evidencia de que la inflación se dirige de manera sostenible hacia nuestro objetivo del 2%".

El mercado espera posibles recortes de tasas para el próximo trimestre, dependiendo de la evolución de los datos económicos.''',
      category: 'Política Monetaria',
      time: '4 horas',
      imageUrl: '🏦',
    ),
    NewsArticle(
      title: 'Empleo en EE.UU. supera expectativas',
      summary: 'La economía estadounidense sumó más empleos de lo esperado, manteniendo estable el mercado laboral.',
      content: '''El informe de empleos no agrícolas de Estados Unidos sorprendió positivamente al mercado, con la creación de 254,000 nuevos puestos de trabajo en el último mes.

La cifra superó ampliamente las expectativas de los analistas, que proyectaban 180,000 nuevos empleos.

La tasa de desempleo se mantiene en 4.1%, cerca de mínimos históricos, lo que refleja la fortaleza del mercado laboral estadounidense.

Los sectores que más contribuyeron al crecimiento fueron:
• Servicios de salud (+54,000)
• Ocio y hospitalidad (+78,000)
• Construcción (+25,000)

Esta fortaleza en el empleo podría influir en las decisiones futuras de política monetaria de la Reserva Federal.''',
      category: 'Economía',
      time: '6 horas',
      imageUrl: '👷',
    ),
    NewsArticle(
      title: 'El oro alcanza nuevos máximos históricos',
      summary: 'Los metales preciosos continúan su tendencia alcista impulsados por la debilidad del dólar.',
      content: '''El precio del oro alcanzó un nuevo récord histórico al superar los \$2,685 por onza troy, impulsado por múltiples factores fundamentales.

Factores que impulsan el oro:
• Debilidad del dólar estadounidense
• Incertidumbre geopolítica global
• Expectativas de recortes en tasas de interés
• Compras de bancos centrales

La plata también registra ganancias significativas, cotizando en \$32.45 por onza, su nivel más alto en los últimos meses.

Los analistas sugieren que el oro podría continuar su tendencia alcista, con algunos proyectando objetivos de \$2,800 por onza en el corto plazo.

Para inversores retail, los ETFs de oro y las monedas de oro físico se han convertido en opciones populares de diversificación.''',
      category: 'Commodities',
      time: '8 horas',
      imageUrl: '🥇',
    ),
    NewsArticle(
      title: 'Criptomonedas repuntan tras aprobación de nuevos ETFs',
      summary: 'Bitcoin y Ethereum muestran signos de recuperación después de semanas de volatilidad.',
      content: '''Las criptomonedas experimentan una jornada positiva tras el anuncio de la aprobación de varios ETFs de criptomonedas por parte de reguladores.

Bitcoin (BTC) subió un 5.8% para cotizar en \$67,200, mientras que Ethereum (ETH) ganó un 7.2% alcanzando \$2,680.

Desarrollos clave:
• Aprobación de 3 nuevos ETFs de Bitcoin al contado
• Mayor adopción institucional de criptomonedas
• Regulación más clara en mercados europeos

Los volúmenes de trading se incrementaron significativamente, superando los \$45,000 millones en las últimas 24 horas.

Analistas técnicos señalan que Bitcoin podría estar formando un patrón alcista que podría llevarlo hacia los \$75,000 en las próximas semanas.''',
      category: 'Criptomonedas',
      time: '10 horas',
      imageUrl: '₿',
    ),
    NewsArticle(
      title: 'Inflación en Europa muestra signos de estabilización',
      summary: 'Los datos de inflación de la Eurozona se mantienen cerca del objetivo del 2% del BCE.',
      content: '''La inflación anual en la Eurozona se situó en 2.4% en el último mes, ligeramente por encima del objetivo del 2% del Banco Central Europeo.

Datos destacados por país:
• Alemania: 2.1%
• Francia: 2.5%
• Italia: 2.3%
• España: 2.7%

La inflación subyacente, que excluye energía y alimentos, se mantiene en 2.7%, mostrando una tendencia descendente gradual.

Christine Lagarde, presidenta del BCE, indicó que "la tendencia de la inflación es alentadora, pero necesitamos mantener la vigilancia".

Los mercados interpretan estos datos como una señal de que las políticas monetarias restrictivas están funcionando, lo que podría abrir la puerta a futuros recortes de tasas.''',
      category: 'Inflación',
      time: '12 horas',
      imageUrl: '📊',
    ),
    NewsArticle(
      title: 'Sector tecnológico lidera las ganancias bursátiles',
      summary: 'Las acciones de tecnología registran su mejor semana en meses impulsadas por resultados corporativos.',
      content: '''El sector tecnológico registró ganancias significativas esta semana, liderado por los resultados trimestrales mejor a lo esperado de las principales empresas.

Destacados de la semana:
• Apple (AAPL): +6.2%
• Microsoft (MSFT): +4.8%
• Google (GOOGL): +5.1%
• Amazon (AMZN): +3.9%

Los ingresos del sector superaron las expectativas en un 12% promedio, impulsados por:
- Crecimiento en servicios en la nube
- Mayor adopción de inteligencia artificial
- Fortaleza en el segmento móvil

El índice Nasdaq-100 acumula ganancias del 8.2% en lo que va del mes, recuperando terreno perdido en sesiones anteriores.

Los analistas mantienen perspectivas optimistas para el sector, citando la continua innovación y expansión en nuevos mercados.''',
      category: 'Tecnología',
      time: '1 día',
      imageUrl: '💻',
    ),
    NewsArticle(
      title: 'Energías renovables atraen inversión récord',
      summary: 'El sector de energías limpias recibe \$180,000 millones en inversiones durante el último trimestre.',
      content: '''Las inversiones en energías renovables alcanzaron niveles récord en el último trimestre, con \$180,000 millones destinados a proyectos de energía limpia a nivel global.

Distribución de inversiones:
• Solar: 45% (\$81,000 millones)
• Eólica: 30% (\$54,000 millones)
• Hidráulica: 15% (\$27,000 millones)
• Otras renovables: 10% (\$18,000 millones)

China lidera las inversiones con \$67,000 millones, seguida por Estados Unidos (\$34,000 millones) y Europa (\$28,000 millones).

Las empresas del sector han mostrado un rendimiento sobresaliente en bolsa:
• NextEra Energy: +15.3%
• First Solar: +22.1%
• Vestas Wind Systems: +18.7%

Los analistas proyectan que esta tendencia continuará debido a políticas gubernamentales favorables y la disminución de costos de tecnologías limpias.''',
      category: 'Energía',
      time: '1 día',
      imageUrl: '🌱',
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
            child: Row(
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
              Text(
                article.summary,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
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
            Text(
              article.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
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