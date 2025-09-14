import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => 'ApiException($statusCode): $message';
}

Never apiThrow(DioException e) {
  String message;
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      message = 'Connection timed out. Please check your internet connection.';
      break;
    case DioExceptionType.badResponse:
      message = e.response?.data?['message']?.toString() ?? 'An unexpected error occurred.';
      break;
    default:
      message = 'A network error occurred. Please try again.';
  }
  throw ApiException(message, statusCode: e.response?.statusCode);
}
