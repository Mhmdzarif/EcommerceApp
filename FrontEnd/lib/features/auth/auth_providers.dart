import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';

final authStatusProvider = FutureProvider<bool>((ref) => ref.read(authRepositoryProvider).isLoggedIn());

final authActionsProvider = Provider((ref) {
  final repo = ref.read(authRepositoryProvider);
  return (
    register: (String email, String password, String role) => repo.register(email, password, role),
    login: (String email, String password) => repo.login(email, password),
    logout: () => repo.logout(),
  );
});
