import 'package:dio/dio.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/home/models/top_hedlines_body.dart';

class HomeServices {
  final aDio = Dio();
  Future<NewsApiResponse> getTopHeadlines(TopHedlinesBody body) async {
    try {
      aDio.options.baseUrl = AppConstants.baseUrl; // Set the base URL
      final headers = {
        'Authorization': 'Bearer ${AppConstants.apiKey}',
      }; // Set the headers
      final response = await aDio.get(
        AppConstants.topHeadlines,
        queryParameters: body.toMap(),
        options: Options(headers: headers),
      ); // Make the GET request
      if (response.statusCode == 200) {
        return NewsApiResponse.fromMap(response.data);
      } else {
        throw Exception(response.statusMessage);
      } // Parse and return the response
    } catch (e) {
      rethrow;
    }
  }
}
