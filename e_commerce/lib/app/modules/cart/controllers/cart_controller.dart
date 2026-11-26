import 'package:get/get.dart';

import '../../../data/local/cart_local_datasource.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final CartLocalDataSource? _localDataSource;

  CartController({CartLocalDataSource? localDataSource})
    : _localDataSource = localDataSource;

  final items = <CartItemModel>[].obs;

  CartLocalDataSource? get _dataSource {
    if (_localDataSource != null) return _localDataSource;
    if (Get.isRegistered<CartLocalDataSource>()) {
      return Get.find<CartLocalDataSource>();
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    final savedItems = _dataSource?.getCartItems();
    if (savedItems != null && savedItems.isNotEmpty) {
      items.assignAll(savedItems);
    }
  }

  Future<void> addItem(
    ProductModel product, {
    int quantity = 1,
    String size = '42',
  }) async {
    final itemId = '${product.id}_$size';
    final index = items.indexWhere((item) => item.id == itemId);
    CartItemModel savedItem;
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
      savedItem = items[index];
    } else {
      savedItem = CartItemModel(
        id: itemId,
        product: product,
        selectedSize: size,
        quantity: quantity,
      );
      items.add(savedItem);
    }
    await _dataSource?.saveCartItem(savedItem);
  }

  Future<void> increaseQuantity(String id) async {
    final index = items.indexWhere((e) => e.id == id);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    await _dataSource?.saveCartItem(items[index]);
  }

  Future<void> decreaseQuantity(String id) async {
    final index = items.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final q = items[index].quantity - 1;
    if (q <= 0) {
      items.removeAt(index);
      await _dataSource?.removeCartItem(id);
    } else {
      items[index] = items[index].copyWith(quantity: q);
      await _dataSource?.saveCartItem(items[index]);
    }
  }

  Future<void> removeItem(String id) async {
    items.removeWhere((e) => e.id == id);
    await _dataSource?.removeCartItem(id);
  }

  Future<void> clearCartAsync() async {
    items.clear();
    await _dataSource?.clearCart();
  }

  int get totalItemCount => items.fold(0, (sum, e) => sum + e.quantity);
  int get subtotal => items.fold(0, (sum, e) => sum + e.subtotal);
  int get tax => (subtotal * 0.11).round();
  int get shippingFee => (subtotal == 0 || subtotal >= 2000000) ? 0 : 20000;
  int get totalAmount => subtotal + tax + shippingFee;
}
