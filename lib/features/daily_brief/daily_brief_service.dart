import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/network/news_api_client.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/daily_brief/models/daily_brief_item.dart';
import 'package:news_app/features/home/models/top_hedlines_body.dart';

/// Fetches a short daily brief by mixing top headlines + business/tech focus,
/// then generating a tiny summary from description/content.
class DailyBriefService {
  final NewsApiClient api;
  DailyBriefService({NewsApiClient? apiClient}) : api = apiClient ?? NewsApiClient();

  Future<List<DailyBriefItem>> fetchBrief() async {
    final top = await api.get(
      AppConstants.topHeadlines,
      queryParameters:
          const TopHedlinesBody(category: 'general', page: 1, pageSize: 6).toMap(),
    );
    final everything = await api.get(
      AppConstants.everything,
      queryParameters: {
        'q': 'technology OR business',
        'pageSize': 6,
        'page': 1,
        'sortBy': 'publishedAt',
      },
    );

    final articles = <Article>[];
    if (top.data['articles'] is List) {
      articles.addAll(
        (top.data['articles'] as List)
            .map((e) => Article.fromMap(e as Map<String, dynamic>)),
      );
    }
    if (everything.data['articles'] is List) {
      articles.addAll(
        (everything.data['articles'] as List)
            .map((e) => Article.fromMap(e as Map<String, dynamic>)),
      );
    }

    return articles.take(10).map((a) {
      final text = [a.description, a.content]
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .join(' ');
      final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
      final summary = sentences.take(3).join(' ');
      return DailyBriefItem(
        article: a,
        summary: summary.isEmpty ? (a.title ?? '') : summary,
      );
    }).toList();
  }
}
