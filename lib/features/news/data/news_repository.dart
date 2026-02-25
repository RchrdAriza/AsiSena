import 'models/news_article.dart';

class NewsRepository {
  Future<List<NewsArticle>> getNews() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      NewsArticle(
        id: '1',
        title: 'Inscripciones abiertas para nuevos programas TIC',
        summary: 'El SENA abre inscripciones para programas de tecnología en el primer trimestre.',
        content: 'Se abrieron las inscripciones para los programas de Análisis y Desarrollo de Software, '
            'Redes de Computadores y Animación Digital. Los interesados pueden inscribirse a través de SOFIA Plus.',
        author: 'Comunicaciones SENA',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['Inscripciones', 'TIC'],
      ),
      NewsArticle(
        id: '2',
        title: 'Jornada de bienestar estudiantil este viernes',
        summary: 'Actividades deportivas, culturales y de salud para todos los aprendices.',
        content: 'Este viernes se realizará la jornada integral de bienestar con actividades de salud, '
            'deporte y cultura. Todos los aprendices están invitados a participar.',
        author: 'Bienestar al Aprendiz',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['Bienestar', 'Eventos'],
      ),
      NewsArticle(
        id: '3',
        title: 'Actualización del calendario académico 2026',
        summary: 'Consulta las nuevas fechas de inicio y finalización de trimestres.',
        content: 'Se ha publicado la actualización del calendario académico para 2026. '
            'Revisa las fechas de trimestres, recesos y eventos institucionales en la cartelera.',
        author: 'Coordinación Académica',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['Académico', 'Calendario'],
      ),
      NewsArticle(
        id: '4',
        title: 'Convocatoria para monitores de formación',
        summary: 'Se buscan aprendices destacados para el programa de monitores.',
        content: 'El programa de monitores busca aprendices con excelente rendimiento académico y habilidades '
            'de liderazgo. Los interesados deben tener un promedio superior a 4.0.',
        author: 'Coordinación Académica',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['Convocatoria', 'Monitores'],
      ),
      NewsArticle(
        id: '5',
        title: 'Nuevos convenios internacionales de pasantía',
        summary: 'Oportunidades de formación en empresas de México, Chile y España.',
        content: 'El SENA firmó nuevos convenios para que aprendices realicen sus pasantías en empresas '
            'de tecnología en México, Chile y España.',
        author: 'Relaciones Internacionales',
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['Internacional', 'Pasantías'],
      ),
    ];
  }
}
