import 'package:local_state_practice/features/article/article.dart';

class ArticleViewState {
  ArticleViewState({
    required this.articles,
    required this.isFiltered,
  });

  final List<Article> articles;
  final bool isFiltered;

  late final List<Article> displayArticles = isFiltered
      ? articles.where((article) => article.isPublished).toList()
      : articles;

  late final int totalCount = articles.length;
  late final int publishedCount = articles.where((a) => a.isPublished).length;
}
