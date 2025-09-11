import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/formatters.dart';
import '../../../widgets/empty_state.dart';
import 'orders_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
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
  }
}
