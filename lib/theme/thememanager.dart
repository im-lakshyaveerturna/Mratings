import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeManager with ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get thememode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

}
