import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Default to light mode
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify all listeners to rebuild
  }
}
