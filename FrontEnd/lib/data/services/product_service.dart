import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
import '../../core/exceptions.dart' show apiThrow;
import '../models/product.dart';


class ProductService {
  final Dio _dio = DioClient().dio;

  Future<List<Product>> getProducts() async {
    try {
      final r = await _dio.get('/products');
      if (r.data == null || r.data is! List) {
        throw Exception('Invalid response data');
      }
      final data = r.data as List<dynamic>;
      return data
          .map((e) => Product.fromJson(
              e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      return apiThrow(e);
    }
  }

  Future<Product> addProduct({
    required String name,
    required int priceCents,
    required int stock,
    String? description,
    String? thumbnail,
  }) async {
    try {
      final r = await _dio.post(
        '/products',
        data: {
          'name': name,
          'price': priceCents,
          'stock': stock,
          'description': description,
          'thumbnail': thumbnail,
        },
      );
      if (r.data == null || r.data is! Map<String, dynamic>) {
        throw Exception('Invalid response data');
      }
      return Product.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return apiThrow(e);
    }
  }
}
