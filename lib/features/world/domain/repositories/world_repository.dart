import '../entities/article.dart';

abstract class WorldRepository {
  Future<List<Article>> getWorldNews(int page);
}
