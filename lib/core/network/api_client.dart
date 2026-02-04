import 'package:dio/dio.dart';
import 'package:news_app/core/utils/app_constants.dart';


class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl, // مهم جداً
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Authorization': 'Bearer ${AppConstants.apiKey}',
              'Content-Type': 'application/json',
            },
          ),
        );

Future<Response<T>> get<T>(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options, // ضيف هذا السطر
}) async {
  final response = await _dio.get<T>(
    path,
    queryParameters: queryParameters,
    options: options, // استخدمه هنا
  );
  return response;
}


  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response;
  }
}
