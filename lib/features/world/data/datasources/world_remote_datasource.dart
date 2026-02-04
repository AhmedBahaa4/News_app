

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/utils/app_constants.dart';
import '../models/article_model.dart';


abstract class WorldRemoteDataSource {
  Future<List<ArticleModel>> getWorldNews(int page);
}

class WorldRemoteDataSourceImpl implements WorldRemoteDataSource {
  WorldRemoteDataSourceImpl();

  @override
  Future<List<ArticleModel>> getWorldNews(int page) async {
    // نستخدم GNews API كبديل موثوق لصفحة World
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.gnewsBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final response = await dio.get(
      '/top-headlines',
      queryParameters: {
        'category': 'world',
        'lang': 'en',
        'max': 20,
        'page': page,
        'apikey': AppConstants.gnewsApiKey,
      },
    );

    debugPrint(response.data.toString());

    if (response.statusCode == 200 && response.data['articles'] != null) {
      return List<ArticleModel>.from(
        (response.data['articles'] as List)
            .map((e) => ArticleModel.fromMap(e)),
      );
    }

    throw Exception(
      'Error ${response.statusCode}: ${response.statusMessage ?? 'Unknown error'}',
    );
  }
}
// import 'package:news_app/core/network/news_api_client.dart';
// import 'package:news_app/core/utils/app_constants.dart';
// import 'package:news_app/features/home/models/top_hedlines_body.dart';
// import '../models/article_model.dart';

// class WorldRemoteDataSourceImpl implements WorldRemoteDataSource {
//   final NewsApiClient api;

//   WorldRemoteDataSourceImpl(this.api);

//   @override
//   Future<List<ArticleModel>> getWorldNews(int page) async {
//     final body = TopHedlinesBody(
//       category: 'world',
//       pageSize: 20,
//       page: page,
//     );

//     final response = await api.get(
//       AppConstants.topHeadlines,
//       queryParameters: body.toMap(),
//     );

//     return List<ArticleModel>.from(
//       response.data['articles'].map(
//         (e) => ArticleModel.fromMap(e),
//       ),
//     );
//   }
// }
