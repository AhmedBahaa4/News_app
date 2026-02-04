part of 'daily_brief_cubit.dart';

abstract class DailyBriefState {}

class DailyBriefInitial extends DailyBriefState {}
class DailyBriefLoading extends DailyBriefState {}
class DailyBriefError extends DailyBriefState {
  final String message;
  DailyBriefError(this.message);
}
class DailyBriefLoaded extends DailyBriefState {
  final List<DailyBriefItem> items;
  DailyBriefLoaded(this.items);
}
