import '../model/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeModel>> getEmployees({bool forceRefresh = false});
  Future<void> toggleFavorite(int id);
  Future<List<EmployeeModel>> getFavorites();
  Future<EmployeeModel?> getEmployeeDetails(int id);
}
