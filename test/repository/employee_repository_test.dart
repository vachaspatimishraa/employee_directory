import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employee_directory/features/employee/datasource/remote_datasource.dart';
import 'package:employee_directory/features/employee/datasource/local_datasource.dart';
import 'package:employee_directory/features/employee/repository/employee_repository_impl.dart';
import 'package:employee_directory/features/employee/model/employee_model.dart';
import 'package:employee_directory/core/network/connectivity_service.dart';

class MockRemoteDatasource extends Mock implements RemoteDatasource {}
class MockLocalDatasource extends Mock implements LocalDatasource {}
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockRemoteDatasource remoteDatasource;
  late MockLocalDatasource localDatasource;
  late MockConnectivityService connectivityService;
  late EmployeeRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockRemoteDatasource();
    localDatasource = MockLocalDatasource();
    connectivityService = MockConnectivityService();
    repository = EmployeeRepositoryImpl(remoteDatasource, localDatasource, connectivityService);
  });

  group('EmployeeRepository Tests', () {
    final mockEmployees = [
      EmployeeModel(id: 1, name: 'Alice', email: 'alice@example.com'),
      EmployeeModel(id: 2, name: 'Bob', email: 'bob@example.com'),
    ];

    test('getEmployees fetches and caches when online', () async {
      when(() => connectivityService.isConnected).thenAnswer((_) async => true);
      when(() => remoteDatasource.fetchEmployees()).thenAnswer((_) async => mockEmployees);
      when(() => localDatasource.cacheEmployees(any())).thenAnswer((_) async {});
      when(() => localDatasource.getCachedEmployees()).thenAnswer((_) async => mockEmployees);

      final result = await repository.getEmployees(forceRefresh: true);

      expect(result, mockEmployees);
      verify(() => remoteDatasource.fetchEmployees()).called(1);
      verify(() => localDatasource.cacheEmployees(mockEmployees)).called(1);
    });

    test('getEmployees returns cached data when offline', () async {
      when(() => connectivityService.isConnected).thenAnswer((_) async => false);
      when(() => localDatasource.getCachedEmployees()).thenAnswer((_) async => mockEmployees);

      final result = await repository.getEmployees();

      expect(result, mockEmployees);
      verifyNever(() => remoteDatasource.fetchEmployees());
    });
  });
}
