import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';
import '../cart/cart_providers.dart';

final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.read(orderRepoProvider);
  return repo.myOrders();
});
