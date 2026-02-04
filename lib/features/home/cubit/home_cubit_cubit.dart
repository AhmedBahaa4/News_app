import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/local_database_by_sharedPreferance.dart';
// import 'package:news_app/core/models/local_database_services.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/models/top_hedlines_body.dart';
import 'package:news_app/features/home/services/home_services.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeCubitInitial());
  final homeservices = HomeServices();
  //bookmark by hive
  // final localDatabaseServices = LocalDatabaseServices();
  //...............................................................
  //bookmark by shared preferences
  final localDatabaseServices = LocalDatabaseBySharedPreferences();

  Future<void> getTopHeadlines() async {
    emit(TopHeadlinesLoading());
    try {
      final body = const TopHedlinesBody(
        category: 'business',
        page: 1,
        pageSize: 8,
      );
      final result = await homeservices.getTopHeadlines(body);
      emit(TopHeadlinesLoaded(result.articles));
    } catch (e) {
      emit(TopHeadlinesError(e.toString()));
    }
  }

  Future<void> getRecommendationItems() async {
    emit(RecommendedNewsLoading());
    final body = const TopHedlinesBody(page: 1, pageSize: 15);
    try {
      final result = await homeservices.getTopHeadlines(body);
      emit(RecommendedNewsLoaded(result.articles));
    } catch (e) {
      emit(RecommendedNewsError(e.toString()));
    }
  }

  // bookmark by shared preferences

  Future<void> setBookmark(Article article) async {
    emit(BookmarkLoading());

    try {
      final bookmarks = await localDatabaseServices.getStringList(
        AppConstants.bookmarksKey,
      );
      final List<Article> bookmarkArticles = [];
      if (bookmarks != null) {
        for (final bookmarkArticleString in bookmarks) {
          final bookmarkArticle = Article.fromJson(bookmarkArticleString);
          bookmarkArticles.add(bookmarkArticle);
        }
      }
    final  isFound =
        bookmarkArticles.any((a) => a.title == article.title);

      if (isFound) {
     final index =
        bookmarkArticles.indexWhere((a) => a.title == article.title);
        bookmarkArticles.remove(bookmarkArticles[index]);
        await localDatabaseServices.setStringList(
          AppConstants.bookmarksKey,
          bookmarkArticles.map((article) => article.toJson()).toList(),
        );
        emit(BookmarkRemoved());
      } else {
        bookmarkArticles.add(article);
        await localDatabaseServices.setStringList(
          AppConstants.bookmarksKey,
          bookmarkArticles.map((article) => article.toJson()).toList(),
        );
        emit(BookmarkAdded());
      }
       } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }
}
//  if(bookmarks != null){
        // final List<String> updatedBookmarks = List<String>.from(bookmarks);
        // updatedBookmarks.add(article.toJson());
        // await localDatabaseServices.setStringList(
        //   AppConstants.bookmarksKey,
        //   updatedBookmarks,
        // );