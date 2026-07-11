import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/isar_service.dart';
import 'core/database/isar_provider.dart';
import 'features/settings/provider/theme_provider.dart';
import 'app/app.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize Isar
    final isarService = IsarService();
    await isarService.init();

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          isarServiceProvider.overrideWithValue(isarService),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize the app: $e'),
          ),
        ),
      ),
    );
  }
}
