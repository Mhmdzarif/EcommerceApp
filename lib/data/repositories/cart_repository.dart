import 'package:collection/collection.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../../core/env.dart';

class CartRepository {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void add(Product p, {int qty = 1}) {
    if (p.stock <= 0) return;
    final idx = _items.indexWhere((e) => e.product.id == p.id);
    if (idx == -1) {
      _items.add(CartItem(product: p, quantity: qty.clamp(1, p.stock)));
    } else {
      final current = _items[idx];
      final newQty = (current.quantity + qty).clamp(1, p.stock);
      _items[idx] = current.copyWith(quantity: newQty);
    }
  }

  void remove(Product p, int i, {int qty = 1}) {
    final idx = _items.indexWhere((e) => e.product.id == p.id);
    if (idx == -1) return;
    final current = _items[idx];
    final newQty = current.quantity - qty;
    if (newQty <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx] = current.copyWith(quantity: newQty);
    }
  }

  void setQty(Product p, int qty) {
    final idx = _items.indexWhere((e) => e.product.id == p.id);
    if (idx == -1) {
      if (qty > 0 && qty <= p.stock) _items.add(CartItem(product: p, quantity: qty));
    } else {
      if (qty <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx] = _items[idx].copyWith(quantity: qty.clamp(1, p.stock));
      }
    }
  }

  void removeProduct(String productId) {
    _items.removeWhere((e) => e.product.id == productId);
  }

  int get subtotalCents => _items.fold(0, (acc, e) => acc + e.subtotalCents);

  int get taxCents => (subtotalCents * Env.taxRatePercent / 100).round();

  int get totalCents => subtotalCents + taxCents;

  List<Map<String, dynamic>> toOrderPayload() =>
      _items.map((e) => {'productId': e.product.id, 'quantity': e.quantity}).toList();

  void clear() => _items.clear();
}
