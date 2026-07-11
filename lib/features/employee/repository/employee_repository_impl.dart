import '../datasource/remote_datasource.dart';
import '../datasource/local_datasource.dart';
import '../model/employee_model.dart';
import 'employee_repository.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/utils/logger.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;
  final ConnectivityService _connectivityService;

  EmployeeRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._connectivityService,
  );

  @override
  Future<List<EmployeeModel>> getEmployees({bool forceRefresh = false}) async {
    final isOnline = await _connectivityService.isConnected;
    AppLogger.d('EmployeeRepository: forceRefresh=$forceRefresh, isOnline=$isOnline');

    if (!isOnline) {
      final cached = await _localDatasource.getCachedEmployees();
      if (cached.isNotEmpty) {
        AppLogger.d('Serving cached data offline');
        return cached;
      }
      throw Exception('No internet connection and no cached data available.');
    }

    if (forceRefresh) {
      try {
        final remoteData = await _remoteDatasource.fetchEmployees();
        if (remoteData.isEmpty) {
          throw Exception('No employees found on server.');
        }
        await _localDatasource.cacheEmployees(remoteData);
      } catch (e) {
        AppLogger.e('Failed to fetch from remote, serving cache', e);
        final cached = await _localDatasource.getCachedEmployees();
        if (cached.isNotEmpty) {
          return cached;
        }
        rethrow;
      }
    } else {
      final cached = await _localDatasource.getCachedEmployees();
      if (cached.isNotEmpty) {
        return cached;
      }
      try {
        final remoteData = await _remoteDatasource.fetchEmployees();
        if (remoteData.isEmpty) {
          throw Exception('No employees found on server.');
        }
        await _localDatasource.cacheEmployees(remoteData);
      } catch (e) {
        AppLogger.e('Failed to fetch from remote', e);
        throw Exception('Failed to load employees: $e');
      }
    }

    return await _localDatasource.getCachedEmployees();
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final employee = await _localDatasource.getEmployeeById(id);
    if (employee != null) {
      final updated = employee.copyWith(isFavorite: !employee.isFavorite);
      await _localDatasource.updateEmployee(updated);
    }
  }

  @override
  Future<List<EmployeeModel>> getFavorites() async {
    return await _localDatasource.getFavoriteEmployees();
  }

  @override
  Future<EmployeeModel?> getEmployeeDetails(int id) async {
    return await _localDatasource.getEmployeeById(id);
  }
}
