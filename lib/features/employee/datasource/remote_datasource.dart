import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../model/employee_model.dart';

abstract class RemoteDatasource {
  Future<List<EmployeeModel>> fetchEmployees();
}

class RemoteDatasourceImpl implements RemoteDatasource {
  final DioClient _dioClient;

  RemoteDatasourceImpl(this._dioClient);

  @override
  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await _dioClient.get(ApiConstants.users);
    final data = response.data as List;
    return data.map((json) => EmployeeModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
