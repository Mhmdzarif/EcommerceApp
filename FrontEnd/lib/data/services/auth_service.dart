import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
import '../../core/exceptions.dart';
import '../models/user.dart';

class AuthService {
  final _dio = DioClient().dio;

  Future<RegisterResponse> register(RegisterRequest req) async {
    try {
      final r = await _dio.post('/auth/register', data: {'email': req.email, 'password': req.password});
      return RegisterResponse.fromJson(r.data);
    } on DioException catch (e) { apiThrow(e); }
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
      return LoginResponse.fromJson(r.data);
    } on DioException catch (e) { apiThrow(e); }
  }
}
