import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/employee_repository.dart';
import '../../../core/network/connectivity_service.dart';
import '../../auth/repository/auth_repository.dart';
import 'employee_state.dart';
import '../model/employee_model.dart';

class EmployeeViewModel extends StateNotifier<EmployeeState> {
  final EmployeeRepository _repository;
  final ConnectivityService _connectivityService;
  final AuthRepository _authRepository;
  String _currentQuery = '';
  bool _showOnlyFavorites = false;

  EmployeeViewModel(
    this._repository,
    this._connectivityService,
    this._authRepository,
  ) : super(EmployeeState()) {
    loadEmployees();
    _monitorConnection();
  }

  void _monitorConnection() {
    _connectivityService.connectivityStream.listen((isOnline) {
      state = state.copyWith(isOffline: !isOnline);
    });
  }

  Future<void> loadEmployees({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, isError: false, errorMessage: null);
    try {
      final isOnline = await _connectivityService.isConnected;
      final data = await _repository.getEmployees(forceRefresh: forceRefresh);
      
      _updatePagedState(allData: data, page: 1, isOffline: !isOnline);
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: true, errorMessage: e.toString());
    }
  }

  Future<void> refreshEmployees() async {
    state = state.copyWith(isRefreshing: true);
    try {
      final isOnline = await _connectivityService.isConnected;
      final data = await _repository.getEmployees(forceRefresh: true);
      _updatePagedState(allData: data, page: 1, isOffline: !isOnline);
    } catch (e) {
      state = state.copyWith(isError: true, errorMessage: e.toString());
    } finally {
      state = state.copyWith(isRefreshing: false);
    }
  }

  void managePagination() {
    if (!state.hasMoreData || state.isLoading || _currentQuery.isNotEmpty || _showOnlyFavorites) return;
    final nextPage = state.currentPage + 1;
    _updatePagedState(allData: state.allEmployees, page: nextPage);
  }

  void searchEmployees(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  void toggleFavoritesFilter(bool showFavorites) {
    _showOnlyFavorites = showFavorites;
    _applyFilters();
  }

  Future<void> toggleFavorite(int id) async {
    await _repository.toggleFavorite(id);
    final updatedList = await _repository.getEmployees();
    _updatePagedState(allData: updatedList, page: state.currentPage);
  }

  void _updatePagedState({required List<EmployeeModel> allData, required int page, bool? isOffline}) {
    final adminEmail = _authRepository.getEmail()?.toLowerCase().trim();
    
    // Filter out administrator
    final filteredData = allData.where((emp) {
      return emp.email?.toLowerCase().trim() != adminEmail;
    }).toList();

    final limit = page * 5;
    final hasMore = filteredData.length > limit;
    
    final sliced = filteredData.take(limit).toList();
    
    state = state.copyWith(
      allEmployees: filteredData,
      employees: sliced,
      currentPage: page,
      hasMoreData: hasMore,
      isOffline: isOffline ?? state.isOffline,
      isLoading: false,
    );
    _applyFilters();
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    await _repository.addEmployee(employee);
    await loadEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
    await loadEmployees();
  }

  void _applyFilters() {
    final favorites = state.allEmployees.where((emp) => emp.isFavorite).toList();
    
    List<EmployeeModel> baseList;
    if (_showOnlyFavorites) {
      baseList = favorites;
    } else if (_currentQuery.isNotEmpty) {
      baseList = state.allEmployees;
    } else {
      baseList = state.employees;
    }
    
    if (_currentQuery.isNotEmpty) {
      final q = _currentQuery.toLowerCase();
      baseList = baseList.where((emp) {
        final name = emp.name?.toLowerCase() ?? '';
        final email = emp.email?.toLowerCase() ?? '';
        final company = emp.company?.name?.toLowerCase() ?? '';
        return name.contains(q) || email.contains(q) || company.contains(q);
      }).toList();
    }
    
    state = state.copyWith(
      filteredEmployees: baseList,
      favoriteEmployees: favorites,
    );
  }
}
