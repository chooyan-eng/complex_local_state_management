import 'package:flutter/material.dart';
import 'package:local_state_practice/articles.dart';
import 'package:local_state_practice/features/article/article_view_state.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool _isFiltered = false;

  @override
  Widget build(BuildContext context) {
    final viewState = ArticleViewState(
      articles: ArticlesScope.of(context)!.articles,
      isFiltered: _isFiltered,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: Icon(_isFiltered ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() => _isFiltered = !_isFiltered);
            },
            tooltip: 'Toggle published articles only',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Total: ${viewState.totalCount}'),
                Text('Published: ${viewState.publishedCount}'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewState.displayArticles.length,
              itemBuilder: (context, index) {
                final article = viewState.displayArticles[index];
                return ListTile(
                  title: Text(article.title),
                  trailing: article.isPublished
                      ? const Icon(Icons.public, color: Colors.green)
                      : const Icon(Icons.private_connectivity,
                          color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
