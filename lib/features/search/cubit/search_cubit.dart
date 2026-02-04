import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/search/models/search_body.dart';
import 'package:news_app/features/search/services/search_services.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  final searchservices = SearchServices();
  
  Future<void> search(String keyWord, {String? category}) async {
    emit(Searching());
    try {
      final query = [
        if (keyWord.trim().isNotEmpty) keyWord.trim(),
        if (category != null && category.toLowerCase() != 'all')
          category.trim().toLowerCase()
      ].join(' ').trim();

      final body = SearchBody(q: query.isNotEmpty ? query : 'news');
      final response = await searchservices.search(body);
  
      emit(SearchResultLoaded(response.articles ?? []));
     
    } catch (e) {
      emit(SearchResultEror(e.toString()));
    }
  }
}
