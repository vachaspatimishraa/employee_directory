import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/database/isar_provider.dart';
import '../datasource/remote_datasource.dart';
import '../datasource/local_datasource.dart';
import '../repository/employee_repository.dart';
import '../repository/employee_repository_impl.dart';
import '../viewmodel/employee_state.dart';
import '../viewmodel/employee_viewmodel.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final remoteDatasourceProvider = Provider<RemoteDatasource>((ref) {
  return RemoteDatasourceImpl(ref.read(dioClientProvider));
});

final localDatasourceProvider = Provider<LocalDatasource>((ref) {
  return LocalDatasourceImpl(ref.read(isarProvider));
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(
    ref.read(remoteDatasourceProvider),
    ref.read(localDatasourceProvider),
    ref.read(connectivityServiceProvider),
  );
});

final employeeViewModelProvider = StateNotifierProvider<EmployeeViewModel, EmployeeState>((ref) {
  return EmployeeViewModel(
    ref.watch(employeeRepositoryProvider),
    ref.watch(connectivityServiceProvider),
  );
});
