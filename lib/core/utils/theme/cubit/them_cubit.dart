import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/services/theme_preferences.dart';


class ThemeCubit extends Cubit<bool> {
  final ThemePreferences preferences;

  ThemeCubit(this.preferences) : super(false) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final isDark = await preferences.getTheme();
    emit(isDark);
  }

  Future<void> toggleTheme() async {
    final newTheme = !state;
    emit(newTheme);
    await preferences.saveTheme(newTheme);
  }
}
