class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final int unitPriceCents;
  const OrderItem({required this.productId, required this.name, required this.quantity, required this.unitPriceCents});

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
    productId: j['productId'].toString(),
    name: j['name'],
    quantity: j['quantity'],
    unitPriceCents: (j['price'] as num).toInt(),
  );
}

class Order {
  final String id;
  final DateTime createdAt;
  final int totalCents;
  final List<OrderItem> items;

  const Order({required this.id, required this.createdAt, required this.totalCents, required this.items});

  factory Order.fromJson(Map<String, dynamic> j) => Order(
    id: j['id'].toString(),
    createdAt: DateTime.parse(j['createdAt']),
    totalCents: (j['total'] as num).toInt(),
    items: (j['items'] is List)
        ? (j['items'] as List).map((e) => OrderItem.fromJson(e)).toList()
        : <OrderItem>[],
  );
}
