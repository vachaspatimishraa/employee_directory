import '../model/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeModel>> getEmployees();
  Future<void> toggleFavorite(int id);
  Future<List<EmployeeModel>> getFavorites();
  Future<EmployeeModel?> getEmployeeDetails(int id);
  Future<void> addEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(int id);
}
