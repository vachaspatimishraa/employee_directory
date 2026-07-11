import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/employee_model.dart';
import 'employee_provider.dart';

final favoriteEmployeesProvider = Provider<List<EmployeeModel>>((ref) {
  final employeeState = ref.watch(employeeViewModelProvider);
  return employeeState.favoriteEmployees;
});
