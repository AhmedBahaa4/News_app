import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/models/bookmark_article.dart';

class BookmarkApiService {
  final Dio dio;

  BookmarkApiService(this.dio);

  /// جلب كل المفضلات
  Future<List<BookmarkArticle>> getMyBookmarks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not logged in');
    }

    final token = await user.getIdToken(true);

    final response = await dio.get(
      '/bookmarks',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List data = response.data as List;
    return data
        .map((json) => BookmarkArticle.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// إضافة خبر للمفضلة
  Future<void> addBookmark(BookmarkArticle article) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not logged in');
    }

    final token = await user.getIdToken(true);

    await dio.post(
      '/bookmarks',
      data: {
        ...article.toMap(),
        // أرسل المفتاحين newsUrl و url لضمان التوافق
        'url': article.url,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  /// إزالة خبر من المفضلة
  Future<void> removeBookmark(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();

    await dio.delete(
      '/bookmarks',
      // دعم newsUrl أو url في الـ backend
      data: {'newsUrl': url, 'url': url},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
