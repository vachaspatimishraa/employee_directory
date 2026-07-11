import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class SharedPrefService {
  final SharedPreferences _prefs;

  SharedPrefService(this._prefs);

  Future<bool> saveEmail(String email) async {
    return await _prefs.setString(StorageKeys.loginEmail, email);
  }

  String? getEmail() {
    return _prefs.getString(StorageKeys.loginEmail);
  }

  Future<bool> removeEmail() async {
    return await _prefs.remove(StorageKeys.loginEmail);
  }

  bool getIsDarkMode() {
    return _prefs.getBool(StorageKeys.themeMode) ?? false;
  }

  Future<bool> setIsDarkMode(bool value) async {
    return await _prefs.setBool(StorageKeys.themeMode, value);
  }

  Future<bool> saveAdminProfile(String jsonStr) async {
    return await _prefs.setString(StorageKeys.adminProfile, jsonStr);
  }

  String? getAdminProfile() {
    return _prefs.getString(StorageKeys.adminProfile);
  }
}
