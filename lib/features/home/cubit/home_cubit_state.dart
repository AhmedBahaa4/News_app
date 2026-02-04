part of 'home_cubit_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeCubitInitial extends HomeState {}

// New states for Top Headlines
final class TopHeadlinesLoading extends HomeState {}

final class TopHeadlinesLoaded extends HomeState {
  final List<Article>? articles;
  const TopHeadlinesLoaded(this.articles);
}

final class TopHeadlinesError extends HomeState {
  final String message;
  const TopHeadlinesError(this.message);
}

//  New states for Recommended News
final class RecommendedNewsLoading extends HomeState {}

final class RecommendedNewsLoaded extends HomeState {
  final List<Article>? articles;
  const RecommendedNewsLoaded(this.articles);
}

final class RecommendedNewsError extends HomeState {
  final String message;
  const RecommendedNewsError(this.message);
}

//  My bookmark
final class BookmarkLoading   extends HomeState {}
final class BookmarkAdded extends HomeState {}

final class BookmarkRemoved extends HomeState {}

final class BookmarkError extends HomeState {
  final String message;

  BookmarkError(this.message);
}
