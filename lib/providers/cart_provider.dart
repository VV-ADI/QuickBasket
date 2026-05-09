import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../core/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartProvider extends ChangeNotifier {
  late Box<CartItem> _box;
  bool _initialized = false;

  List<CartItem> get items => _initialized ? _box.values.toList() : [];

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get deliveryFee =>
      subtotal >= AppConstants.freeDeliveryThreshold
          ? 0.0
          : AppConstants.deliveryFee;

  double get total => subtotal + deliveryFee;

  Future<void> init() async {
    _box = await Hive.openBox<CartItem>('cart');
    _initialized = true;
    notifyListeners();
  }

  int quantityOf(int productId) {
    final item = _box.get(productId);
    return item?.quantity ?? 0;
  }

  Future<void> addProduct(Product product) async {
    final existing = _box.get(product.id);
    if (existing != null) {
      existing.quantity++;
      await existing.save();
    } else {
      await _box.put(
        product.id,
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          unit: product.unit,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> removeProduct(Product product) async {
    final existing = _box.get(product.id);
    if (existing != null) {
      if (existing.quantity > 1) {
        existing.quantity--;
        await existing.save();
      } else {
        await existing.delete();
      }
    }
    notifyListeners();
  }

  Future<void> deleteItem(CartItem item) async {
    await item.delete();
    notifyListeners();
  }

  Future<void> incrementItem(CartItem item) async {
    item.quantity++;
    await item.save();
    notifyListeners();
  }

  Future<void> decrementItem(CartItem item) async {
    if (item.quantity > 1) {
      item.quantity--;
      await item.save();
    } else {
      await item.delete();
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    await _box.clear();
    notifyListeners();
  }
}
