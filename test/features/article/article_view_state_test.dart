import 'package:flutter_test/flutter_test.dart';
import 'package:local_state_practice/features/article/article.dart';
import 'package:local_state_practice/features/article/article_view_state.dart';

void main() {
  group('when three articles are given initially', () {
    const articles = [
      Article(title: 'Article 1', isPublished: true),
      Article(title: 'Article 2', isPublished: false),
      Article(title: 'Article 3', isPublished: true),
    ];

    test('displayArticles shows all articles when isFiltered is false', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: false,
      );

      expect(state.displayArticles.length, 3);
      expect(state.displayArticles, articles);
    });

    test(
        'displayArticles shows only published articles when isFiltered is true',
        () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: true,
      );

      expect(state.displayArticles.length, 2);
      expect(
          state.displayArticles.every((article) => article.isPublished), true);
    });

    test('totalCount returns 3 when not filtered', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: false,
      );

      expect(state.totalCount, 3);
    });

    test('publishedCount returns 2 when filtered', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: false,
      );

      expect(state.publishedCount, 2);
    });
  });

  group('when empty articles are given initially', () {
    const articles = <Article>[];

    test('displayArticles returns empty list when isFiltered is false', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: false,
      );

      expect(state.displayArticles.isEmpty, true);
    });

    test('displayArticles returns empty list when isFiltered is true', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: true,
      );

      expect(state.displayArticles.isEmpty, true);
    });

    test('totalCount returns zero', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: false,
      );

      expect(state.totalCount, 0);
    });

    test('publishedCount returns zero', () {
      final state = ArticleViewState(
        articles: articles,
        isFiltered: false,
      );

      expect(state.publishedCount, 0);
    });
  });
}
