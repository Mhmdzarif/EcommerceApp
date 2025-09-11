class Product {
  final String id;
  final String name;
  final int priceCents;
  final int stock;
  final String? thumbnailUrl;

  const Product({required this.id, required this.name, required this.priceCents, required this.stock, this.thumbnailUrl});

  bool get outOfStock => stock <= 0;

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'].toString(),
    name: j['name'],
    priceCents: (j['price'] as num).toInt(), // backend sends smallest unit
    stock: j['stock'] ?? 0,
    thumbnailUrl: j['thumbnail'],
  );
}
