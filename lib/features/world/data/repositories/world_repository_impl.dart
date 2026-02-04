import 'package:news_app/features/world/data/datasources/world_remote_datasource.dart';

import '../../domain/entities/article.dart';
import '../../domain/repositories/world_repository.dart';


class WorldRepositoryImpl implements WorldRepository {
  final WorldRemoteDataSource remoteDataSource;

  WorldRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Article>> getWorldNews(int page) {
    return remoteDataSource.getWorldNews(page);
  }
}
