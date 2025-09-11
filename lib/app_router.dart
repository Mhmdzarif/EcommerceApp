import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/catalog/catalog_screen.dart';
import 'features/catalog/product_details_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/orders/orders_screen.dart';
import 'features/admin/admin_screen.dart';
import '../core/router_refresh.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.read(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/catalog',
    refreshListenable: GoRouterRefreshStream(ref.watch(authStateChangesProvider)),
    redirect: (ctx, state) async {
      final isLogged = await authRepo.isLoggedIn();
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!isLogged && !loggingIn) return '/login';
      if (isLogged && loggingIn) return '/catalog';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/catalog', builder: (_, __) => const CatalogScreen()),
      GoRoute(path: '/product/:id', builder: (ctx, s) {
        final id = s.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      }),
      GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
      GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminScreen()),
    ],
  );
});
