import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/currency_helper.dart';

const List<NewsArticle> kNewsArticles = [
  NewsArticle(
    title: 'Fed (29 jul): tipos en 3,50%–3,75% con votación 9–3',
    summary:
        'La última reunión de la Fed mantuvo tipos, pero con 3 votos a favor de subir 25 pb por inflación persistente.',
    content: '''Corte al 10 de agosto de 2026: la última reunión de la Fed (29 de julio) dejó un mensaje claro.

Decisión
• Tipo oficial sin cambios: 3,50%–3,75%
• Votación: 9–3
• Tres miembros prefirieron subir +0,25%

Qué significa
• La Fed no recorta: sigue priorizando volver al 2% de inflación
• El comité está más dividido que en meses anteriores
• Mercados de bonos y bolsa reaccionan con más volatilidad por menor guía futura

Impacto práctico
• Hipotecas variables y crédito al consumo siguen tensionados
• Las tecnológicas respiran si no hay subida inmediata, pero el riesgo no desaparece
• El IPC de agosto será clave para la reunión de septiembre

Conclusión: pausa no es giro dovish. Es “esperar y ver” con sesgo antiinflación.''',
    category: 'Política Monetaria',
    time: 'hoy',
    imageUrl: '🏦',
  ),
  NewsArticle(
    title: 'El hedge fund de Aschenbrenner entra en crisis de liquidez',
    summary:
        'Situational Awareness sufrió pérdidas muy fuertes en posiciones de IA, activó ventas aceleradas de cartera y reabrió el debate sobre apalancamiento.',
    content: '''Corte al 10 de agosto de 2026: la noticia relevante no es el evento social, sino la situación de su hedge fund.

Qué pasó
• Su fondo (Situational Awareness) registró pérdidas severas en pocas semanas
• La caída en activos ligados a infraestructura IA y posiciones concentradas tensionó márgenes
• Se aceleraron ventas de parte de la cartera para ganar liquidez

Por qué importa al mercado
• Recordatorio de que incluso tesis potentes pueden romperse con apalancamiento alto
• El desapalancamiento forzado puede contagiar precios en otros valores del sector
• Sube la volatilidad y la sensibilidad a rumores de flujo y financiación

Lección para retail
• “Convicción” no sustituye gestión de riesgo
• Evita concentrar cartera en un solo tema (aunque esté de moda)
• Mira liquidez, deuda y tamaño de posición antes que titulares

Conclusión: el caso Aschenbrenner es, sobre todo, una lección de riesgo de concentración y apalancamiento.''',
    category: 'Tecnología',
    time: 'hoy',
    imageUrl: '🤖',
  ),
  NewsArticle(
    title: '10 ago: petróleo tenso por Ormuz, Brent en zona \$84–86',
    summary:
        'El bloqueo prolongado mantiene presión sobre energía e inflación global; bolsas mixtas y primas de riesgo elevadas.',
    content: '''Lunes 10 de agosto de 2026. El mercado energético sigue bajo presión:

Precios
• Brent: entorno \$84–86
• WTI: alrededor de \$80
• Alta sensibilidad a cada avance o bloqueo diplomático

Efectos en cadena
• Transporte y logística más caros
• Presión en inflación de bienes básicos
• Mayor incertidumbre sobre el ritmo de recortes/subidas de tipos

Para tus finanzas
• Revisa gastos variables (combustible, ocio y compras impulsivas)
• Prioriza fondo de emergencia
• Evita cambiar una cartera de largo plazo por un solo titular diario''',
    category: 'Commodities',
    time: 'hoy',
    imageUrl: '🛢️',
  ),
  NewsArticle(
    title: 'Mercado pendiente del IPC de EE.UU. del 12 de agosto',
    summary:
        'El dato de inflación de julio puede inclinar la balanza de la Fed hacia mantener o endurecer en septiembre.',
    content: '''Esta semana el dato clave es el IPC de EE.UU. (12 de agosto):

Qué mira el mercado
• Inflación general: si cede o se estanca
• Subyacente: señal de tendencia real
• Relación con energía: petróleo caro puede contaminar próximos meses

Escenarios
• IPC mejor de lo esperado: cae probabilidad de subida de tipos
• IPC peor de lo esperado: sube la presión para endurecer política

Regla útil
• Un dato no hace tendencia
• Mira 3–6 meses de dirección, no una sola lectura''',
    category: 'Política Monetaria',
    time: 'hoy',
    imageUrl: '📊',
  ),
  NewsArticle(
    title: 'Empleo débil en EE.UU. enfría parte del discurso hawkish',
    summary:
        'Nóminas más flojas y revisiones a la baja reducen apuestas de subida inmediata, aunque inflación sigue por encima del objetivo.',
    content: '''Tras el último informe laboral de EE.UU.:

Señales
• Creación de empleo por debajo de expectativas
• Revisiones a la baja en meses previos
• Menor convicción de subida en septiembre

Dilema macro
• Inflación aún elevada
• Mercado laboral perdiendo fuerza
• Fed dividida entre enfriar precios y no dañar actividad

Para familias
• Crédito aún caro
• Más valor en liquidez y colchón de seguridad''',
    category: 'Economía',
    time: '2 días',
    imageUrl: '👷',
  ),
  NewsArticle(
    title: 'Wall Street en máximos recientes, pero con volatilidad alta',
    summary:
        'S&P 500 cerca de récords y sesiones mixtas por el cruce entre empleo débil, petróleo caro y dudas sobre tipos.',
    content: '''Foto de mercado al 10 de agosto:

Drivers
• Menos presión de tipos por empleo flojo
• Más nervios por energía y geopolítica
• Rotación rápida entre sectores

Sectores
• Tecnología: favorecida cuando caen rendimientos
• Energía: sensible al crudo
• Consumo: sufre si suben gasolina y financiación

Conclusión
• Récord de índice no equivale a “todo barato”
• Mantener diversificación sigue siendo clave''',
    category: 'Mercados',
    time: '1 día',
    imageUrl: '📈',
  ),
  NewsArticle(
    title: 'Semiconductores e IA mantienen liderazgo en 2026',
    summary:
        'La demanda de centros de datos y memoria sigue fuerte, aunque el riesgo de correcciones por valoración continúa elevado.',
    content: '''Tema estructural de 2026:

Fortalezas
• Inversión masiva en capacidad de cómputo
• Pedidos sólidos en chips y memoria
• Beneficios fuertes en varias líderes del sector

Riesgos
• Valoraciones exigentes
• Dependencia de pocas mega-cap
• Volatilidad alta ante noticias de tipos o regulación

Regla práctica
• Exposición sí, concentración extrema no''',
    category: 'Tecnología',
    time: '3 días',
    imageUrl: '💻',
  ),
  NewsArticle(
    title: 'Europa: inflación energética y BCE en modo prudente',
    summary:
        'La eurozona combina crecimiento débil con energía cara; el BCE mantiene enfoque reunión a reunión.',
    content: '''En la eurozona, el equilibrio sigue delicado:

Panorama
• Energía todavía tensionada
• Crecimiento moderado
• Crédito más caro que en ciclos anteriores

Impacto al bolsillo
• Hipotecas variables sensibles al Euribor
• Mejor remuneración en depósitos frente a años previos
• Empresas más selectivas al invertir

Qué hacer
• Revisa deuda, liquidez y gasto fijo antes de asumir más riesgo''',
    category: 'Política Monetaria',
    time: '3 días',
    imageUrl: '🇪🇺',
  ),
  NewsArticle(
    title: 'Renovables ganan peso estratégico tras meses de shock',
    summary:
        'La seguridad energética acelera planes en solar, eólica y almacenamiento en Europa y EE.UU.',
    content: '''La transición energética sigue siendo eje inversor de largo plazo:

Catalizadores
• Riesgo geopolítico en combustibles fósiles
• Nuevas licitaciones y capex en redes y baterías
• Mayor foco en independencia energética

Para inversor minorista
• Mejor visión de 5–10 años que de semanas
• Diversificar vía fondos/ETF puede reducir riesgo específico
• Evitar entrar solo por FOMO''',
    category: 'Energía',
    time: '4 días',
    imageUrl: '🌱',
  ),
  NewsArticle(
    title: 'Oro y bonos vuelven a usarse como cobertura',
    summary:
        'Con inflación incierta y geopolítica activa, crece la demanda de activos defensivos en carteras mixtas.',
    content: '''En agosto de 2026, los activos refugio vuelven al radar:

Qué se ve
• Oro más demandado en días de tensión
• Bonos con movimientos bruscos por expectativas de Fed
• Dólar oscilando según macro y riesgo global

Uso inteligente
• Cobertura parcial, no sustituto de toda la cartera
• Mantener diversificación por clases de activo
• Evitar decisiones emocionales de corto plazo''',
    category: 'Mercados',
    time: '5 días',
    imageUrl: '🥇',
  ),
];

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  List<NewsArticle> get articles => kNewsArticles;

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
                    '10 de agosto de 2026 · Ormuz, Fed e inflación',
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

  String get timeLabel {
    if (time == 'hoy' || time == 'ayer') return time[0].toUpperCase() + time.substring(1);
    return 'Hace $time';
  }
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
                          article.timeLabel,
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
              article.timeLabel,
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