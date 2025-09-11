import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';

final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.read(OrderRepository() as ProviderListenable);
  return repo.myOrders();
});
