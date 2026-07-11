import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({required this.message, this.statusCode});

  factory NetworkException.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request to API server was cancelled');
      case DioExceptionType.connectionTimeout:
        return NetworkException(message: 'Connection timeout with API server');
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Receive timeout in connection with API server');
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Send timeout in connection with API server');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final statusMessage = dioException.response?.statusMessage;
        return NetworkException(
          message: 'Received invalid status code: $statusCode ($statusMessage)',
          statusCode: statusCode,
        );
      default:
        return NetworkException(message: 'Something went wrong');
    }
  }

  @override
  String toString() => message;
}
