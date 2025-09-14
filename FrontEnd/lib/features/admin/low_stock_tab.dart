import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../widgets/empty_state.dart';
import 'admin_providers.dart';
import '../catalog/product_card.dart';

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
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return ProductCard(
                product: p,
                onTap: () {},
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
