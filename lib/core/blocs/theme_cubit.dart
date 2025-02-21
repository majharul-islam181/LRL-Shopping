import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  /// Loads theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool("isDarkMode") ?? false;
    emit(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  /// Toggles theme and saves preference
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = state.brightness == Brightness.dark;
    ThemeData newTheme = isDarkMode ? AppTheme.lightTheme : AppTheme.darkTheme;
    await prefs.setBool("isDarkMode", !isDarkMode);
    emit(newTheme);
  }
}
