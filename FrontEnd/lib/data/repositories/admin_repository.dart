import '../models/order.dart';
import '../models/product.dart';
import '../services/admin_service.dart';

class AdminRepository {
  final _svc = AdminService();

  Future<List<Order>> allOrders() => _svc.allOrders();
  Future<List<Product>> lowStock() => _svc.lowStock();
}
