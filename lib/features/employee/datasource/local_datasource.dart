import 'package:isar/isar.dart';
import '../model/employee_model.dart';

abstract class LocalDatasource {
  Future<List<EmployeeModel>> getCachedEmployees();
  Future<void> cacheEmployees(List<EmployeeModel> employees);
  Future<void> updateEmployee(EmployeeModel employee);
  Future<List<EmployeeModel>> getFavoriteEmployees();
  Future<EmployeeModel?> getEmployeeById(int id);
}

class LocalDatasourceImpl implements LocalDatasource {
  final Isar _isar;

  LocalDatasourceImpl(this._isar);

  @override
  Future<List<EmployeeModel>> getCachedEmployees() async {
    return await _isar.employeeModels.where().findAll();
  }

  @override
  Future<void> cacheEmployees(List<EmployeeModel> employees) async {
    await _isar.writeTxn(() async {
      // Preserve favorite flags when caching new/updated ones from remote
      for (var emp in employees) {
        final existing = await _isar.employeeModels.get(emp.id);
        if (existing != null) {
          emp.isFavorite = existing.isFavorite;
        }
      }
      await _isar.employeeModels.putAll(employees);
    });
  }

  @override
  Future<void> updateEmployee(EmployeeModel employee) async {
    await _isar.writeTxn(() async {
      await _isar.employeeModels.put(employee);
    });
  }

  @override
  Future<List<EmployeeModel>> getFavoriteEmployees() async {
    return await _isar.employeeModels.filter().isFavoriteEqualTo(true).findAll();
  }

  @override
  Future<EmployeeModel?> getEmployeeById(int id) async {
    return await _isar.employeeModels.get(id);
  }
}
