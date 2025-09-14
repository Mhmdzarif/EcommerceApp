class Product {
  final String id;
  final String name;
  final int priceCents;
  final int stock;
  final String? thumbnailUrl;

  const Product({required this.id, required this.name, required this.priceCents, required this.stock, this.thumbnailUrl});

  bool get outOfStock => stock <= 0;
  bool get lowStock => stock > 0 && stock < 5;

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'].toString(),
    name: j['name'],
    priceCents: (() {
      final price = j['price'];
      if (price is int) return price;
      if (price is double) return (price * 100).round();
      if (price is String) {
        final intVal = int.tryParse(price);
        if (intVal != null) return intVal;
        final doubleVal = double.tryParse(price);
        if (doubleVal != null) return (doubleVal * 100).round();
        return 0;
      }
      return 0;
    })(),
    stock: (() {
      final stock = j['stock'];
      if (stock is int) return stock;
      if (stock is String) return int.tryParse(stock) ?? 0;
      if (stock is double) return stock.toInt();
      return 0;
    })(),
    thumbnailUrl: j['thumbnail'],
  );
}
