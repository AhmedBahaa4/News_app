import '../../domain/entities/article.dart';

abstract class WorldState {}

class WorldInitial extends WorldState {}

class WorldLoading extends WorldState {}

class WorldLoaded extends WorldState {
  final List<Article> articles;
  final bool hasReachedMax;

  WorldLoaded({
    required this.articles,
    required this.hasReachedMax,
  });
}

class WorldError extends WorldState {
  final String message;
  WorldError(this.message);
}
