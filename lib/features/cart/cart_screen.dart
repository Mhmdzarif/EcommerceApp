import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_snackbar.dart';
import 'cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                      final placing = ref.watch(placeOrderProvider(const Object()));
                      return FilledButton(
                        onPressed: placing.isLoading
                            ? null
                            : () async {
                                try {
                                  await ref.refresh(placeOrderProvider(const Object()).future);
                                  if (context.mounted) showErrorSnackBar(context, 'Order placed!');
                                } catch (e) {
                                  showErrorSnackBar(context, e.toString());
                                  // Suggest refresh on stock errors
                                }
                              },
                        child: placing.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Place Order'),
                      );
                    }),
                  ]),
                ),
              ],
            ),
    );
  }
}
