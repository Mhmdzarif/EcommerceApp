import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order.dart';
import '../../data/models/product.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/product_repository.dart';


final adminRepoProvider = Provider((_) => AdminRepository());
final adminOrdersProvider = FutureProvider<List<Order>>((ref) => ref.read(adminRepoProvider).allOrders());
final adminLowStockProvider = FutureProvider<List<Product>>((ref) => ref.read(adminRepoProvider).lowStock());

final addProductProvider = FutureProvider.family<void, ({String name, int priceCents, int stock})>((ref, payload) async {
  final repo = ref.read(ProductRepository() as ProviderListenable);
  await repo.add(payload.name, payload.priceCents, payload.stock);
});
