part of 'bookmark_cubit.dart';


// sealed class BookmarkState {}

// final class BookmarkInitial extends BookmarkState {
  

// }

// final class BookmarkLoading extends BookmarkState {}

// final class BookmarkSuccess extends BookmarkState {
//    final String url;
//   BookmarkSuccess(this.url);
// }

// final class BookmarkRemoved extends BookmarkState {
//   final String url;
//   BookmarkRemoved(this.url);
// }

// final class BookmarkError extends BookmarkState {
//   final String message;
//   BookmarkError(this.message);
// }
// class BookmarkLoaded extends BookmarkState {
//   final List<Article> bookmarks; // بدل Set<String>
//   BookmarkLoaded(this.bookmarks);
// }
sealed class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<BookmarkArticle> bookmarks;
  BookmarkLoaded(this.bookmarks);
}



class BookmarkError extends BookmarkState {
  final String message;
  BookmarkError(this.message);
}
