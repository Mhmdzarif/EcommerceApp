import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/env.dart';
import 'exceptions.dart';

final _storage = const FlutterSecureStorage();

class DioClient {
  Dio dio;

  DioClient._internal(this.dio);

  static DioClient? _instance;

  factory DioClient() {
    if (_instance != null) return _instance!;
    final dio = Dio(BaseOptions(baseUrl: Env.apiBase, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 20)));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'token');
        }
        handler.next(e);
      },
    ));
    _instance = DioClient._internal(dio);
    return _instance!;
  }
}

Never apiThrow(DioException e) {
  final msg = e.response?.data is Map<String, dynamic>
      ? (e.response?.data['message']?.toString() ?? e.message)
      : e.message;
  throw ApiException(msg ?? 'Network error', statusCode: e.response?.statusCode);
}
