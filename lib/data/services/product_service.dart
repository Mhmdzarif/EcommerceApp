import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
import '../../core/exceptions.dart';
import '../models/product.dart';

class ProductService {
  final _dio = DioClient().dio;

  Future<List<Product>> getProducts() async {
    try {
      final r = await _dio.get('/products');
      return (r.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) { apiThrow(e); }
  }

  Future<Product> addProduct({required String name, required int priceCents, required int stock}) async {
    try {
      final r = await _dio.post('/products', data: {'name': name, 'price': priceCents, 'stock': stock});
      return Product.fromJson(r.data);
    } on DioException catch (e) { apiThrow(e); }
  }
}
