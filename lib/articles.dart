import 'package:flutter/material.dart';
import 'package:local_state_practice/features/article/article.dart';

class ArticlesScope extends InheritedWidget {
  const ArticlesScope({
    super.key,
    required this.articles,
    required super.child,
  });

  final List<Article> articles;

  static ArticlesScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ArticlesScope>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
