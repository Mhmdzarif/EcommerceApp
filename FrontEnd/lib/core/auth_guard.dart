import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/repositories/auth_repository.dart';
import '../core/router_refresh.dart';

GoRouterRefreshStream authRefresh(WidgetRef ref) {
  return GoRouterRefreshStream(ref.watch(authStateChangesProvider));
}
