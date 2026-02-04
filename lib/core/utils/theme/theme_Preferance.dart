
// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/core/utils/app_constants.dart';
class ThemePreferences {
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isDarkMode, isDark);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isDarkMode) ?? false;
  }

  

}
