import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
// import '../../core/exceptions.dart';
import '../models/user.dart';

// TODO: Replace with your actual apiThrow implementation or import
dynamic apiThrow(DioException e) {
  throw e;
}

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<RegisterResponse> register(RegisterRequest req) async {
    try {
      final r = await _dio.post('/auth/register', data: {
        'email': req.email,
        'password': req.password,
        'role': req.role,
      });
      if (r.data == null || r.data is! Map<String, dynamic>) {
        throw Exception('Invalid response data');
      }
      return RegisterResponse.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return apiThrow(e);
    }
  }

  Future<LoginResponse> login(LoginRequest req) async {
    try {
      final r = await _dio.post(
        '/auth/login',
        data: {'email': req.email, 'password': req.password},
        options: Options(
          sendTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 20),
        ),
      );
      if (r.data == null || r.data is! Map<String, dynamic>) {
        throw Exception('Invalid response data');
      }
      return LoginResponse.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return apiThrow(e);
    }
  }
}
