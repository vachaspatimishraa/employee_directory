import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/shared_pref_service.dart';
import '../../../core/services/theme_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in main');
});

final sharedPrefServiceProvider = Provider<SharedPrefService>((ref) {
  return SharedPrefService(ref.watch(sharedPreferencesProvider));
});

final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService(ref.watch(sharedPrefServiceProvider));
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeNotifier(this._themeService) : super(_themeService.themeMode);

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _themeService.updateThemeMode(newMode);
    state = newMode;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(themeServiceProvider));
});
