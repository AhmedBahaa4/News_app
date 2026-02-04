import '../entities/article.dart';
import '../repositories/world_repository.dart';

class GetWorldNews {
  final WorldRepository repository;

  GetWorldNews(this.repository);

  Future<List<Article>> call(int page) {
    return repository.getWorldNews(page);
  }
}
