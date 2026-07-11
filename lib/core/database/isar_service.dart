import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/employee/model/employee_model.dart';
import '../../features/auth/model/admin_user_model.dart';

class IsarService {
  late final Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [EmployeeModelSchema, AdminUserModelSchema],
      directory: dir.path,
    );
  }
}
