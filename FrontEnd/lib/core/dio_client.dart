import 'package:dio/dio.dart';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/env.dart';


class DioClient {
  final Dio dio;

  DioClient._internal(this.dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
          }
          return handler.next(e);
        },
      ),
    );
  }

  static DioClient? _instance;

  factory DioClient() {
    return _instance ??= DioClient._internal(
      Dio(
        BaseOptions(
          baseUrl: Env.apiBase,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
    );
  }
} 