import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/order_repository.dart';

final cartRepoProvider = Provider((_) => CartRepository());
final orderRepoProvider = Provider((_) => OrderRepository());

class CartNotifier extends StateNotifier<CartRepository> {
  CartNotifier() : super(CartRepository());

  void add(Product p, int qty) => state.add(p, qty: qty);
  void remove(Product p, int qty) => state.remove(p, qty);
  void setQty(Product p, int qty) => state.setQty(p, qty);
  void removeProduct(String id) => state.removeProduct(id);
  void clear() => state.clear();
}

final cartProvider = StateNotifierProvider<CartNotifier, CartRepository>((_) => CartNotifier());

final placeOrderProvider = FutureProvider.family<void, void>((ref, _) async {
  final cart = ref.read(cartProvider);
  if (cart.items.isEmpty) throw Exception('Cart is empty');
  final repo = ref.read(orderRepoProvider);
  await repo.placeOrder(cart.toOrderPayload());
  ref.read(cartProvider.notifier).clear();
});
