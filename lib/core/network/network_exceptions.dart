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
        return NetworkException(message: 'Connection timeout. Please check your internet connection.');
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Server response timeout. Please try again.');
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Request timeout. Please try again.');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final statusMessage = dioException.response?.statusMessage;
        if (statusCode == 500) {
          return NetworkException(
            message: 'Server error. Please try again later.',
            statusCode: statusCode,
          );
        } else if (statusCode == 404) {
          return NetworkException(
            message: 'Resource not found.',
            statusCode: statusCode,
          );
        } else if (statusCode == 401) {
          return NetworkException(
            message: 'Unauthorized access.',
            statusCode: statusCode,
          );
        }
        return NetworkException(
          message: 'Received invalid status code: $statusCode ($statusMessage)',
          statusCode: statusCode,
        );
      default:
        return NetworkException(message: 'Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}
