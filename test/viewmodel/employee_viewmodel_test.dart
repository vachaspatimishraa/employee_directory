import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employee_directory/features/employee/viewmodel/employee_viewmodel.dart';
import 'package:employee_directory/features/employee/repository/employee_repository.dart';
import 'package:employee_directory/features/employee/model/employee_model.dart';
import 'package:employee_directory/core/network/connectivity_service.dart';

class MockEmployeeRepository extends Mock implements EmployeeRepository {}
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockEmployeeRepository mockRepository;
  late MockConnectivityService mockConnectivityService;
  late EmployeeViewModel viewModel;

  final mockEmployees = List.generate(
    10,
    (index) => EmployeeModel(
      id: index + 1,
      name: 'Employee ${index + 1}',
      email: 'employee${index + 1}@example.com',
      isFavorite: false,
    ),
  );

  setUp(() {
    mockRepository = MockEmployeeRepository();
    mockConnectivityService = MockConnectivityService();
    
    when(() => mockConnectivityService.connectivityStream).thenAnswer((_) => const Stream.empty());
    when(() => mockConnectivityService.isConnected).thenAnswer((_) async => true);
    when(() => mockRepository.getEmployees(forceRefresh: any(named: 'forceRefresh'))).thenAnswer((_) async => mockEmployees);

    viewModel = EmployeeViewModel(mockRepository, mockConnectivityService);
  });

  group('EmployeeViewModel Tests', () {
    test('Initial loading state is active and loads page 1 (5 items)', () async {
      await Future.delayed(Duration.zero);
      
      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.employees.length, 5);
      expect(state.filteredEmployees.length, 5);
      expect(state.hasMoreData, true);
    });

    test('managePagination increments to page 2 (loads remaining 5 items)', () async {
      await Future.delayed(Duration.zero);
      
      viewModel.managePagination();
      
      final state = viewModel.state;
      expect(state.currentPage, 2);
      expect(state.employees.length, 10);
      expect(state.hasMoreData, false);
    });

    test('searchEmployees filters the list correctly', () async {
      await Future.delayed(Duration.zero);
      
      viewModel.searchEmployees('Employee 2');
      
      final state = viewModel.state;
      expect(state.filteredEmployees.length, 1);
      expect(state.filteredEmployees.first.name, 'Employee 2');
    });

    test('toggleFavorite updates repository and syncs lists', () async {
      await Future.delayed(Duration.zero);
      
      final updatedEmployees = List<EmployeeModel>.from(mockEmployees);
      updatedEmployees[0] = updatedEmployees[0].copyWith(isFavorite: true);
      
      when(() => mockRepository.toggleFavorite(1)).thenAnswer((_) async => {});
      when(() => mockRepository.getEmployees(forceRefresh: any(named: 'forceRefresh'))).thenAnswer((_) async => updatedEmployees);
      
      await viewModel.toggleFavorite(1);
      
      expect(viewModel.state.favoriteEmployees.length, 1);
      expect(viewModel.state.favoriteEmployees.first.id, 1);
    });
  });
}
