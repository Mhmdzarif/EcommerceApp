import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/shimmer_box.dart';
import 'catalog_providers.dart';
import 'product_card.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => context.go('/cart')),
          IconButton(icon: const Icon(Icons.receipt_long), onPressed: () => context.go('/orders')),
          IconButton(icon: const Icon(Icons.admin_panel_settings), onPressed: () => context.go('/admin')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(productsProvider.future),
        child: productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return const EmptyState(title: 'No products', subtitle: 'Check back later.');
            }
            final width = MediaQuery.of(context).size.width;
            final crossAxis = width >= 600 ? 3 : 2;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) => ProductCard(
                product: products[i],
                onTap: () => context.go('/product/${products[i].id}'),
              ),
            );
          },
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.7),
            itemCount: 6,
            itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: double.infinity),
          ),
          error: (e, _) => ListView(children: [Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e'))]),
        ),
      ),
    );
  }
}
