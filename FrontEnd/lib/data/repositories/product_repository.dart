import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  final _svc = ProductService();

  Future<List<Product>> getProducts() => _svc.getProducts();

  Future<Product> add(String name, int priceCents, int stock, [String? description, String? thumbnail]) =>
      _svc.addProduct(name: name, priceCents: priceCents, stock: stock, description: description, thumbnail: thumbnail);
}
