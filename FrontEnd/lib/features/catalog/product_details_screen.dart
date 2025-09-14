import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/formatters.dart';
import '../../../data/models/product.dart';
import '../../../widgets/error_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../cart/cart_providers.dart';
import 'catalog_providers.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.read(authRepositoryProvider);
    return FutureBuilder<String?>(
      future: authRepo.getRole(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data == 'ADMIN';
        final productsAsync = ref.watch(productsProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Product'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/catalog'),
            ),
          ),
          body: productsAsync.when(
            data: (products) {
              final product = products.firstWhere((p) => p.id == widget.productId, orElse: () => Product(id: '', name: 'Not found', priceCents: 0, stock: 0));
              if (product.id.isEmpty) return const Center(child: Text('Product not found'));
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: product.thumbnailUrl != null
                        ? Image.network(product.thumbnailUrl!, fit: BoxFit.cover)
                        : Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16),
                  Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(formatCents(product.priceCents), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Stock: ${product.stock}'),
                  const SizedBox(height: 16),
                  if (!isAdmin)
                    Row(
                      children: [
                        IconButton(onPressed: product.outOfStock ? null : () => setState(() => qty = (qty - 1).clamp(1, product.stock)), icon: const Icon(Icons.remove)),
                        Text('$qty'),
                        IconButton(onPressed: product.outOfStock ? null : () => setState(() => qty = (qty + 1).clamp(1, product.stock)), icon: const Icon(Icons.add)),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: product.outOfStock ? null : () {
                            ref.read(cartProvider.notifier).add(product, qty);
                            showErrorSnackBar(context, 'Added to cart');
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: Text(product.outOfStock ? 'Out of stock' : 'Add to cart'),
                        ),
                      ],
                    ),
                  if (isAdmin)
                    const Center(child: Text('Admins cannot add to cart.')),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        );
      },
    );
  }
}
