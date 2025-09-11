import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../widgets/empty_state.dart';
import 'admin_providers.dart';

class LowStockTab extends ConsumerWidget {
  const LowStockTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowAsync = ref.watch(adminLowStockProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(adminLowStockProvider.future),
      child: lowAsync.when(
        data: (items) {
          if (items.isEmpty) return const EmptyState(title: 'No low-stock items', subtitle: 'All good for now.');
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) {
              final p = items[i];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('Stock: ${p.stock}'),
                trailing: Text(formatCents(p.priceCents)),
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
