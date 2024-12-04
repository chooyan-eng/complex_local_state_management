import 'package:flutter/material.dart';
import 'package:local_state_practice/articles.dart';
import 'package:local_state_practice/features/article/article.dart';
import 'package:local_state_practice/features/article/article_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ArticlesScope(
        articles: [
          Article(
            title: 'Article 1',
            isPublished: true,
          ),
          Article(
            title: 'Article 2',
            isPublished: false,
          ),
          Article(
            title: 'Article 3',
            isPublished: true,
          ),
        ],
        child: ArticlePage(),
      ),
    );
  }
}
