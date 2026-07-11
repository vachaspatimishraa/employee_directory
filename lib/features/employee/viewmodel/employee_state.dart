import '../model/employee_model.dart';

class EmployeeState {
  final List<EmployeeModel> allEmployees;
  final List<EmployeeModel> employees;
  final List<EmployeeModel> filteredEmployees;
  final List<EmployeeModel> favoriteEmployees;
  final bool isLoading;
  final bool isRefreshing;
  final bool isError;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;

  EmployeeState({
    this.allEmployees = const [],
    this.employees = const [],
    this.filteredEmployees = const [],
    this.favoriteEmployees = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isError = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMoreData = true,
  });

  EmployeeState copyWith({
    List<EmployeeModel>? allEmployees,
    List<EmployeeModel>? employees,
    List<EmployeeModel>? filteredEmployees,
    List<EmployeeModel>? favoriteEmployees,
    bool? isLoading,
    bool? isRefreshing,
    bool? isError,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return EmployeeState(
      allEmployees: allEmployees ?? this.allEmployees,
      employees: employees ?? this.employees,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
      favoriteEmployees: favoriteEmployees ?? this.favoriteEmployees,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isError: isError ?? this.isError,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}
