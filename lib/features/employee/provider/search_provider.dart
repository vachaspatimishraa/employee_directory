import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/employee_model.dart';
import 'employee_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredEmployeesProvider = Provider<List<EmployeeModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final employeeState = ref.watch(employeeViewModelProvider);

  final employees = employeeState.employees;
  if (query.isEmpty) {
    return employees;
  }
  return employees.where((employee) {
    final name = employee.name?.toLowerCase() ?? '';
    final email = employee.email?.toLowerCase() ?? '';
    return name.contains(query) || email.contains(query);
  }).toList();
});
