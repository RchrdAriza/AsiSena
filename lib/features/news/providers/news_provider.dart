import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/news_repository.dart';
import '../data/models/news_article.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) => NewsRepository());

final newsProvider = FutureProvider<List<NewsArticle>>((ref) {
  return ref.watch(newsRepositoryProvider).getNews();
});
