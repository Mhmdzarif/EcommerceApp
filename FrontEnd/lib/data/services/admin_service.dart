import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
import '../../core/exceptions.dart' show apiThrow;
// import '../../core/exceptions.dart';
import '../models/order.dart';
import '../models/product.dart';

class AdminService {
  final _dio = DioClient().dio;

  Future<List<Order>> allOrders() async {
    try {
      final r = await _dio.get('/admin/orders');
      return (r.data as List).map((e) => Order.fromJson(e)).toList();
  } on DioException catch (e) { return apiThrow(e); }
  }

  Future<List<Product>> lowStock() async {
    try {
      final r = await _dio.get('/admin/low-stock');
      // Debug print to see the actual response
      // ignore: avoid_print
      print('admin/low-stock response: ' + r.data.toString());
      if (r.data is! List) {
        throw Exception(r.data is Map && r.data['message'] != null
            ? r.data['message']
            : 'Failed to load low stock products.');
      }
      return (r.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) { return apiThrow(e); }
  }
}
