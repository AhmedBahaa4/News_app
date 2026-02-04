part of 'search_cubit.dart';

sealed class SearchState {
  const SearchState();
}

final class SearchInitial extends SearchState {}

//



final class SearchResultLoaded extends SearchState {
  final List<Article> articles;
  const SearchResultLoaded(this.articles);
}

final class SearchResultEror extends SearchState {
  final String message;

  SearchResultEror(this.message);
}

//
final class Searching extends SearchState {}
