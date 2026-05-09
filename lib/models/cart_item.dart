import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String unit;

  @HiveField(5)
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unit,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;
}
