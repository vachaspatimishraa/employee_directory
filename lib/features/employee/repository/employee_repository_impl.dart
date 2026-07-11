import '../datasource/local_datasource.dart';
import '../model/employee_model.dart';
import 'employee_repository.dart';
import '../../../core/utils/logger.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final LocalDatasource _localDatasource;

  EmployeeRepositoryImpl(this._localDatasource);

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    AppLogger.d('EmployeeRepository: Fetching from local datasource');
    return await _localDatasource.getCachedEmployees();
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final employee = await _localDatasource.getEmployeeById(id);
    if (employee != null) {
      final updated = employee.copyWith(isFavorite: !employee.isFavorite);
      await _localDatasource.updateEmployee(updated);
    }
  }

  @override
  Future<List<EmployeeModel>> getFavorites() async {
    return await _localDatasource.getFavoriteEmployees();
  }

  @override
  Future<EmployeeModel?> getEmployeeDetails(int id) async {
    return await _localDatasource.getEmployeeById(id);
  }

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    await _localDatasource.updateEmployee(employee);
  }

  @override
  Future<void> deleteEmployee(int id) async {
    await _localDatasource.deleteEmployee(id);
  }
}
