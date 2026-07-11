import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employee_directory/features/employee/datasource/local_datasource.dart';
import 'package:employee_directory/features/employee/repository/employee_repository_impl.dart';
import 'package:employee_directory/features/employee/model/employee_model.dart';

class MockLocalDatasource extends Mock implements LocalDatasource {}

void main() {
  late MockLocalDatasource localDatasource;
  late EmployeeRepositoryImpl repository;

  setUp(() {
    localDatasource = MockLocalDatasource();
    repository = EmployeeRepositoryImpl(localDatasource);
  });

  group('EmployeeRepository Tests', () {
    final mockEmployees = [
      EmployeeModel(id: 1, name: 'Alice', email: 'alice@example.com'),
      EmployeeModel(id: 2, name: 'Bob', email: 'bob@example.com'),
    ];

    test('getEmployees fetches from local datasource', () async {
      when(() => localDatasource.getCachedEmployees()).thenAnswer((_) async => mockEmployees);

      final result = await repository.getEmployees();

      expect(result, mockEmployees);
      verify(() => localDatasource.getCachedEmployees()).called(1);
    });

    test('addEmployee updates local datasource', () async {
      final newEmp = EmployeeModel(id: 3, name: 'Charlie', email: 'charlie@example.com');
      when(() => localDatasource.updateEmployee(any())).thenAnswer((_) async {});

      await repository.addEmployee(newEmp);

      verify(() => localDatasource.updateEmployee(newEmp)).called(1);
    });

    test('deleteEmployee removes from local datasource', () async {
      when(() => localDatasource.deleteEmployee(any())).thenAnswer((_) async {});

      await repository.deleteEmployee(1);

      verify(() => localDatasource.deleteEmployee(1)).called(1);
    });
  });
}
