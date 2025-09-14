// import 'package:flutter/material.dart';
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
      final role = isLogged ? (await authRepo.getRole()) : null;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!isLogged && !loggingIn) return '/login';
      if (isLogged && loggingIn) {
        if (role == 'ADMIN') return '/admin';
        return '/catalog';
      }
      // Prevent users from accessing admin screens and vice versa
      if (isLogged && role == 'USER' && state.matchedLocation.startsWith('/admin')) {
        return '/catalog';
      }
      if (isLogged && role == 'ADMIN' && (
        state.matchedLocation.startsWith('/catalog') ||
        state.matchedLocation.startsWith('/cart') ||
        state.matchedLocation.startsWith('/orders') ||
        state.matchedLocation.startsWith('/product')
      )) {
        return '/admin';
      }
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
