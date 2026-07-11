import 'package:flutter/material.dart';
import 'shared_pref_service.dart';

class ThemeService {
  final SharedPrefService _sharedPrefService;

  ThemeService(this._sharedPrefService);

  ThemeMode get themeMode {
    final isDark = _sharedPrefService.getIsDarkMode();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final isDark = themeMode == ThemeMode.dark;
    await _sharedPrefService.setIsDarkMode(isDark);
  }
}
