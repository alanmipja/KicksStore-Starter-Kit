import 'package:hive_ce/hive.dart';

import 'package:e_commerce/app/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<void> saveCartItem(CartItemModel item);
  Future<void> removeCartItem(String itemId);
  Future<void> clearCart();
  List<CartItemModel> getCartItems();
  Stream<BoxEvent> watchCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String cartBoxName = 'cart_box';

  Box<CartItemModel> get _cartBox => Hive.box<CartItemModel>(cartBoxName);

  @override
  Future<void> saveCartItem(CartItemModel item) => _cartBox.put(item.id, item);

  @override
  Future<void> removeCartItem(String itemId) => _cartBox.delete(itemId);

  @override
  Future<void> clearCart() => _cartBox.clear();

  @override
  List<CartItemModel> getCartItems() => _cartBox.values.toList(growable: false);

  @override
  Stream<BoxEvent> watchCart() => _cartBox.watch();
}
