import 'package:isar/isar.dart';
import '../../../core/services/shared_pref_service.dart';
import '../model/admin_user_model.dart';

class AuthRepository {
  final SharedPrefService _sharedPrefService;
  final Isar _isar;

  AuthRepository(this._sharedPrefService, this._isar);

  Future<void> saveEmail(String email) async {
    await _sharedPrefService.saveEmail(email);
  }

  String? getEmail() {
    return _sharedPrefService.getEmail();
  }

  Future<void> logout() async {
    await _sharedPrefService.removeEmail();
  }

  Future<AdminUserModel?> getUserByEmail(String email) async {
    return await _isar.adminUserModels.filter().emailEqualTo(email, caseSensitive: false).findFirst();
  }

  Future<void> createUser(String email, String password) async {
    final user = AdminUserModel(email: email, password: password);
    await _isar.writeTxn(() async {
      await _isar.adminUserModels.put(user);
    });
  }

  Future<void> updateAdminUser(AdminUserModel user) async {
    await _isar.writeTxn(() async {
      await _isar.adminUserModels.put(user);
    });
  }
}
