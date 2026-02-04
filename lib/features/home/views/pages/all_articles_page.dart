import 'package:flutter/material.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';

class AllArticlesPage extends StatelessWidget {
  final String title;
  final List<Article> articles;

  const AllArticlesPage({
    super.key,
    required this.title,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: articles.isEmpty
          ? const Center(child: Text('No articles to show'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (_, i) => ArticleWidgetItem(
                article: articles[i],
                isSmaller: false,
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: articles.length,
            ),
    );
  }
}
