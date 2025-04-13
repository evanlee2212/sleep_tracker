import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeManager() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final userPreference = await SharedPreferences.getInstance();
    final currentTheme = userPreference.getString('theme');

    if (currentTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (currentTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final userPreference = await SharedPreferences.getInstance();
    await userPreference.setString('theme', isDark ? 'dark' : 'light');
  }
}