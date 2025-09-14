import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
// import '../../core/exceptions.dart';
import '../models/order.dart';

// TODO: Replace with your actual apiThrow implementation or import
dynamic apiThrow(DioException e) {
  throw e;
}

class OrderService {
  final Dio _dio = DioClient().dio;

  Future<Order> placeOrder(List<Map<String, dynamic>> items) async {
    try {
      final r = await _dio.post('/orders', data: { 'items': items });
      if (r.data == null || r.data is! Map<String, dynamic>) {
        throw Exception('Invalid response data');
      }
      return Order.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return apiThrow(e);
    }
  }

  Future<List<Order>> myOrders() async {
    try {
      final r = await _dio.get('/orders/me');
      final data = r.data;
      // Debug print to see the actual response structure
      // ignore: avoid_print
      print('orders/me response: ' + data.toString());
      List<dynamic>? listData;
      if (data == null) {
        listData = <dynamic>[];
      } else if (data is List) {
        listData = data;
      } else if (data is Map && data.values.isNotEmpty && data.values.first is List) {
        listData = data.values.first as List;
      } else {
        listData = <dynamic>[];
      }
      return listData
          .map((e) => Order.fromJson(
              e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      return apiThrow(e);
    }
  }
}
