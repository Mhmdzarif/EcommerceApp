import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
import '../../core/exceptions.dart';
import '../models/order.dart';

class OrderService {
  final _dio = DioClient().dio;

  Future<Order> placeOrder(List<Map<String, dynamic>> items) async {
    try {
      final r = await _dio.post('/orders', data: {'items': items});
      return Order.fromJson(r.data);
    } on DioException catch (e) { apiThrow(e); }
  }

  Future<List<Order>> myOrders() async {
    try {
      final r = await _dio.get('/orders/me');
      return (r.data as List).map((e) => Order.fromJson(e)).toList();
    } on DioException catch (e) { apiThrow(e); }
  }
}
