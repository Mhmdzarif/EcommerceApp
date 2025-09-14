import '../auth/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_snackbar.dart';
import 'cart_providers.dart';
import '../catalog/catalog_providers.dart';
import '../orders/orders_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);
    return FutureBuilder<String?>(
      future: authRepo.getRole(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data == 'ADMIN';
        if (isAdmin) {
          return const Scaffold(
            body: Center(child: Text('Admins do not have a cart.')),
          );
        }
        final cart = ref.watch(cartProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
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
          body: cart.items.isEmpty
              ? const EmptyState(title: 'Your cart is empty', subtitle: 'Find items in the catalog.')
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (_, i) {
                          final item = cart.items[i];
                          return ListTile(
                            leading: CircleAvatar(child: Text(item.product.name.characters.first.toUpperCase())),
                            title: Text(item.product.name),
                            subtitle: Text('${formatCents(item.product.priceCents)} x ${item.quantity}'),
                            trailing: SizedBox(
                              width: 140,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(onPressed: () => ref.read(cartProvider.notifier).remove(item.product, 1), icon: const Icon(Icons.remove)),
                                  Text('${item.quantity}'),
                                  IconButton(onPressed: item.product.stock <= item.quantity ? null : () => ref.read(cartProvider.notifier).add(item.product, 1), icon: const Icon(Icons.add)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('Subtotal'), Text(formatCents(cart.subtotalCents)),
                          ]),
                          const SizedBox(height: 4),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('Tax'), Text(formatCents(cart.taxCents)),
                          ]),
                          const Divider(),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(formatCents(cart.totalCents), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 12),
                          Consumer(builder: (context, ref, _) {
                            bool isPlacing = false;
                            return StatefulBuilder(
                              builder: (context, setState) => FilledButton(
                                onPressed: isPlacing
                                    ? null
                                    : () async {
                                        setState(() => isPlacing = true);
                                        try {
                                          final cart = ref.read(cartProvider);
                                          if (cart.items.isEmpty) throw Exception('Cart is empty');
                                          final repo = ref.read(orderRepoProvider);
                                          await repo.placeOrder(cart.toOrderPayload());
                                          ref.read(cartProvider.notifier).clear();
                                          ref.refresh(productsProvider.future);
                                          ref.refresh(myOrdersProvider.future);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Order has been placed successfully!')),
                                            );
                                          }
                                        } catch (e) {
                                          final msg = (e is Exception && e.toString().isNotEmpty && e.toString() != 'Exception: null')
                                            ? e.toString().replaceFirst('Exception: ', '')
                                            : 'Failed to place order. Please try again.';
                                          showErrorSnackBar(context, msg);
                                        } finally {
                                          setState(() => isPlacing = false);
                                        }
                                      },
                                child: isPlacing
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Text('Place Order'),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
