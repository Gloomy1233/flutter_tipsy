import 'package:flutter/material.dart';

class ThemeController extends InheritedWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const ThemeController({
    Key? key,
    required this.themeMode,
    required this.toggleTheme,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeController>();
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}
