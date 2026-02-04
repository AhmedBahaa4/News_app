import 'package:flutter/material.dart';

import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';

class RecommendationListWidget extends StatelessWidget {
  final List<Article> articles;
  const RecommendationListWidget({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 8),

      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        final article = articles[index];

        return ArticleWidgetItem(article: article);
      },
    );
  }
}
