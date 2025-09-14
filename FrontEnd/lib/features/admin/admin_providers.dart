import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order.dart';
import '../../data/models/product.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/product_repository.dart';


final productRepoProvider = Provider((_) => ProductRepository());
final adminRepoProvider = Provider((_) => AdminRepository());
final adminOrdersProvider = FutureProvider<List<Order>>((ref) => ref.read(adminRepoProvider).allOrders());
final adminLowStockProvider = FutureProvider<List<Product>>((ref) => ref.read(adminRepoProvider).lowStock());

final addProductProvider = FutureProvider.family<void, ({String name, int priceCents, int stock, String? description, String? thumbnail})>((ref, payload) async {
  final repo = ref.read(productRepoProvider);
  await repo.add(payload.name, payload.priceCents, payload.stock, payload.description, payload.thumbnail);
  ref.invalidate(adminLowStockProvider);
});
