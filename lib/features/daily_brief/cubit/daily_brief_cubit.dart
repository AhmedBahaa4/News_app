import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_brief/models/daily_brief_item.dart';
import 'package:news_app/features/daily_brief/daily_brief_service.dart';

part 'daily_brief_state.dart';

class DailyBriefCubit extends Cubit<DailyBriefState> {
  DailyBriefCubit(this._service) : super(DailyBriefInitial());

  final DailyBriefService _service;

  Future<void> loadBrief() async {
    emit(DailyBriefLoading());
    try {
      final items = await _service.fetchBrief();
      emit(DailyBriefLoaded(items));
    } catch (e) {
      emit(DailyBriefError(e.toString()));
    }
  }
}
