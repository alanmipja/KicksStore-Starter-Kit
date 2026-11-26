import 'package:hive_ce/hive.dart';

import 'package:e_commerce/app/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  List<ProductModel> getCachedProducts();
  Future<void> saveToWishlist(ProductModel product);
  Future<void> removeFromWishlist(String productId);
  Future<void> clearWishlist();
  List<ProductModel> getWishlist();
  bool isFavorite(String productId);
  Stream<BoxEvent> watchWishlist();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productsBoxName = 'products_box';
  static const String wishlistBoxName = 'wishlist_box';

  Box<ProductModel> get _productsBox => Hive.box<ProductModel>(productsBoxName);
  Box<ProductModel> get _wishlistBox => Hive.box<ProductModel>(wishlistBoxName);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _productsBox.putAll({
      for (final product in products) product.id: product,
    });
  }

  @override
  List<ProductModel> getCachedProducts() =>
      _productsBox.values.toList(growable: false);

  @override
  Future<void> saveToWishlist(ProductModel product) =>
      _wishlistBox.put(product.id, product.copyWith(isFavorite: true));

  @override
  Future<void> removeFromWishlist(String productId) =>
      _wishlistBox.delete(productId);

  @override
  Future<void> clearWishlist() => _wishlistBox.clear();

  @override
  List<ProductModel> getWishlist() =>
      _wishlistBox.values.toList(growable: false);

  @override
  bool isFavorite(String productId) => _wishlistBox.containsKey(productId);

  @override
  Stream<BoxEvent> watchWishlist() => _wishlistBox.watch();
}
