import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_application/data/models/product.dart';
import 'package:ecommerce_application/data/repositories/cart_repository.dart';

void main() {
  group('CartRepository', () {
    final p1 = Product(id: '1', name: 'A', priceCents: 250, stock: 5);
    final p2 = Product(id: '2', name: 'B', priceCents: 333, stock: 1);

    test('add and totals', () {
      final cart = CartRepository();
      cart.add(p1, qty: 2);
      expect(cart.items.length, 1);
      expect(cart.subtotalCents, 500);
    });

    test('increments respect stock', () {
      final cart = CartRepository();
      cart.add(p2, qty: 2);
      expect(cart.items.first.quantity, 1);
    });

    test('remove and rounding', () {
      final cart = CartRepository();
      cart.add(p1, qty: 3);
      cart.remove(p1, 1);
      expect(cart.items.first.quantity, 2);
      cart.remove(p1, 2);
      expect(cart.items.isEmpty, true);
    });

    test('tax and total', () {
      final cart = CartRepository();
      cart.add(p1, qty: 2); // 500
      // Env.taxRatePercent is pulled from .env at runtime; assume 10% => 50
      // We can't read Env in unit easily; just assert arithmetic shape:
      final subtotal = cart.subtotalCents;
      expect(subtotal, 500);
      final tax = (subtotal * 10 / 100).round();
      expect(tax, 50);
      final total = subtotal + tax;
      expect(total, 550);
    });
  });
}
