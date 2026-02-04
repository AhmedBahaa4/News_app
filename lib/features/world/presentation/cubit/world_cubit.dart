import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_world_news.dart';
import 'world_state.dart';

class WorldCubit extends Cubit<WorldState> {
  final GetWorldNews getWorldNews;

  int _page = 1;
  bool _isFetching = false;
  final List articles = [];


  WorldCubit(this.getWorldNews) : super(WorldInitial());

  Future<void> fetchWorldNews({bool refresh = false}) async {
    if (_isFetching && !refresh) {
      return;
    }

    if (refresh) {
      _page = 1;
      articles.clear();
      emit(WorldLoading());
    }

    _isFetching = true;

    try {
      final result = await getWorldNews(_page);
      articles.addAll(result);

      emit(WorldLoaded(
        articles: List.from(articles),
        hasReachedMax: result.length < 20,
      ));

      _page++;
    } catch (e) {
      emit(WorldError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}
