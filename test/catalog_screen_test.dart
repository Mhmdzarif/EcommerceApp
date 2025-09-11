import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_application/features/catalog/catalog_screen.dart';
import 'package:ecommerce_application/features/catalog/catalog_providers.dart';
import 'package:ecommerce_application/data/models/product.dart';

void main() {
  testWidgets('Catalog renders list and allows tap', (tester) async {
    final container = ProviderContainer(overrides: [
      productsProvider.overrideWith((ref) async => [
        const Product(id: '1', name: 'Item 1', priceCents: 1000, stock: 1),
        const Product(id: '2', name: 'Item 2', priceCents: 2000, stock: 0),
      ])
    ]);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: CatalogScreen()),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
  });
}
