import '../../../core/services/shared_pref_service.dart';

class AuthRepository {
  final SharedPrefService _sharedPrefService;

  AuthRepository(this._sharedPrefService);

  Future<void> saveEmail(String email) async {
    await _sharedPrefService.saveEmail(email);
  }

  String? getEmail() {
    return _sharedPrefService.getEmail();
  }

  Future<void> logout() async {
    await _sharedPrefService.removeEmail();
  }
}
