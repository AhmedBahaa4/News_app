import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/models/bookmark_article.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/services/bookmark_api_service.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkApiService service;

  final Set<String> _bookmarkedUrls = {};
  bool _hasLoaded = false;

  BookmarkCubit(this.service) : super(BookmarkInitial());

  bool isBookmarked(String url) => _bookmarkedUrls.contains(url);

  Future<void> fetchBookmarks() async {
    if (_hasLoaded) {
      return;
    }

    emit(BookmarkLoading());

    try {
      final box = Hive.box<BookmarkArticle>('bookmarksBox');

      // 📴 Offline
      final local = box.values.toList();
      _bookmarkedUrls
        ..clear()
        ..addAll(local.map((e) => e.url));
      emit(BookmarkLoaded(local));

      // 🌐 Online
      final remote = await service.getMyBookmarks();

      await box.clear();
      for (final b in remote) {
        await box.put(b.url, b);
      }

      _bookmarkedUrls
        ..clear()
        ..addAll(remote.map((e) => e.url));

      emit(BookmarkLoaded(remote));
      _hasLoaded = true;
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> toggleBookmark(Article article) async {
    final url = article.url;
    if (url == null) {
      return;
    }

    final box = Hive.box<BookmarkArticle>('bookmarksBox');

    try {
      if (_bookmarkedUrls.contains(url)) {
        await service.removeBookmark(url);
        await box.delete(url);
        _bookmarkedUrls.remove(url);
      } else {
        final bookmark = BookmarkArticle.fromArticle(article);
        await service.addBookmark(bookmark);
        await box.put(url, bookmark);
        _bookmarkedUrls.add(url);
      }

      emit(BookmarkLoaded(box.values.toList()));
    } catch (e) {
      emit(BookmarkError(e.toString()));
      rethrow;
    }
  }

  void reset() {
    _bookmarkedUrls.clear();
    _hasLoaded = false;
    Hive.box<BookmarkArticle>('bookmarksBox').clear();
    emit(BookmarkInitial());
  }
}
