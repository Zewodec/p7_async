import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel with ChangeNotifier {
  static const String _isDarkThemeKey = 'dark_theme';
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeModel() {
    _loadThemeFromPrefs();
  }

  void _loadThemeFromPrefs() async {
    await SharedPreferences.getInstance().then((prefs) => _isDarkTheme = prefs.getBool(_isDarkThemeKey) ?? false);
    notifyListeners();
  }

  ThemeData get currentTheme =>
      _isDarkTheme ? ThemeData.dark() : ThemeData.light();

  void toggleTheme(bool isDark) async {
    _isDarkTheme = isDark;
    await SharedPreferences.getInstance().then((prefs) => prefs.setBool(_isDarkThemeKey, _isDarkTheme));
    notifyListeners();
  }
}
