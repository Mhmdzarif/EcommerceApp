import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final _storage = const FlutterSecureStorage();

class AuthRepository {
  final _svc = AuthService();
  final _controller = StreamController<String?>.broadcast();

  Stream<String?> get tokenStream => _controller.stream;

  Future<void> register(String email, String password, String role) async {
    await _svc.register(RegisterRequest(email, password, role));
  }


  Future<void> login(String email, String password) async {
    final res = await _svc.login(LoginRequest(email, password));
    await _storage.write(key: 'token', value: res.token);
    await _storage.write(key: 'role', value: res.role);
    _controller.add(res.token);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }


  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'role');
    _controller.add(null);
  }

  Future<bool> isLoggedIn() async => (await _storage.read(key: 'token')) != null;
}

final authRepositoryProvider = Provider((_) => AuthRepository());
final authStateChangesProvider = Provider<Stream<String?>>((ref) {
  return ref.read(authRepositoryProvider).tokenStream;
});
