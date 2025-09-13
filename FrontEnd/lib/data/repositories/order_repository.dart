import '../models/order.dart';
import '../services/order_service.dart';

class OrderRepository {
  final _svc = OrderService();

  Future<Order> placeOrder(List<Map<String, dynamic>> items) => _svc.placeOrder(items);

  Future<List<Order>> myOrders() => _svc.myOrders();
}
