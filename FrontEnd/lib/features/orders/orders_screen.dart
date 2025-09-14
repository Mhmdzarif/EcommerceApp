import '../auth/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:intl/intl.dart';
import '../../../core/formatters.dart';
import '../../../widgets/empty_state.dart';
import 'orders_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);
    return FutureBuilder<String?>(
      future: authRepo.getRole(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data == 'ADMIN';
        if (isAdmin) {
          return const Scaffold(
            body: Center(child: Text('Admins do not have user orders.')),
          );
        }
        final ordersAsync = ref.watch(myOrdersProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Orders'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/catalog'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await ref.read(authActionsProvider).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => ref.refresh(myOrdersProvider.future),
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) return const EmptyState(title: 'No orders yet', subtitle: 'Place your first order from the catalog.');
                return ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final o = orders[i];
                    return ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text('Order #${o.id}'),
                      subtitle: Text(DateFormat.yMMMd().add_jm().format(o.createdAt)),
                      trailing: Text(formatCents(o.totalCents)),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        );
      },
    );
  }
}
