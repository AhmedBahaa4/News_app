import 'package:dio/dio.dart';
import '../utils/app_constants.dart';

class NewsApiClient {
  final Dio _dio;

  NewsApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl, // https://newsapi.org
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Authorization': 'Bearer ${AppConstants.apiKey}',
            },
          ),
        );

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }
}
