import 'package:get/get.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final items = <CartItemModel>[].obs;

  void addItem(ProductModel product, {int quantity = 1, String size = '42'}) {
    final itemId = '${product.id}_$size';
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    } else {
      items.add(
        CartItemModel(
          id: itemId,
          product: product,
          selectedSize: size,
          quantity: quantity,
        ),
      );
    }
  }

  void increaseQuantity(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
  }

  void decreaseQuantity(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final q = items[index].quantity - 1;
    if (q <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: q);
    }
  }

  void removeItem(String id) => items.removeWhere((e) => e.id == id);

  int get totalItemCount => items.fold(0, (sum, e) => sum + e.quantity);
  int get subtotal => items.fold(0, (sum, e) => sum + e.subtotal);
  int get tax => (subtotal * 0.11).round();
  int get shippingFee => (subtotal == 0 || subtotal >= 2000000) ? 0 : 20000;
  int get totalAmount => subtotal + tax + shippingFee;
}
