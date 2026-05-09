class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final String imageUrl;
  final String? badge;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.badge,
  });
}
