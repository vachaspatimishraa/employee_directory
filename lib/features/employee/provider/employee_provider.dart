import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_provider.dart';
import '../datasource/local_datasource.dart';
import '../repository/employee_repository.dart';
import '../repository/employee_repository_impl.dart';
import '../viewmodel/employee_state.dart';
import '../viewmodel/employee_viewmodel.dart';
import '../../auth/provider/auth_provider.dart';

final localDatasourceProvider = Provider<LocalDatasource>((ref) {
  return LocalDatasourceImpl(ref.read(isarProvider));
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(
    ref.read(localDatasourceProvider),
  );
});

final employeeViewModelProvider = StateNotifierProvider<EmployeeViewModel, EmployeeState>((ref) {
  return EmployeeViewModel(
    ref.watch(employeeRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
});
