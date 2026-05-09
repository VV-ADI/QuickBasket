import 'cart_item.dart';

class Order {
  final String orderId;
  final List<CartItem> items;
  final double total;
  final String address;
  final String paymentMethod;
  final DateTime placedAt;

  Order({
    required this.orderId,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.placedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
