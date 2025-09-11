import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/formatters.dart';
import '../../../widgets/empty_state.dart';
import 'admin_providers.dart';

class AllOrdersTab extends ConsumerWidget {
  const AllOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(adminOrdersProvider.future),
      child: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) return const EmptyState(title: 'No orders', subtitle: 'No orders have been placed yet.');
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) {
              final o = orders[i];
              return ListTile(
                leading: const Icon(Icons.receipt),
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
    );
  }
}
