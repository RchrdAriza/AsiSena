class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String author;
  final String? imageUrl;
  final DateTime publishedAt;
  final List<String> tags;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.author,
    this.imageUrl,
    required this.publishedAt,
    this.tags = const [],
  });
}
