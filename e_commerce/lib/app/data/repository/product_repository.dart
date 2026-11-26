import 'package:e_commerce/app/core/network/dio_exception.dart';
import 'package:e_commerce/app/core/network/result.dart';
import 'package:e_commerce/app/data/local/product_local_datasource.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/data/remote/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
  List<ProductModel> getWishlist();
  Future<bool> toggleWishlist(ProductModel product);
  Future<void> clearWishlist();
  bool isFavorite(String productId);
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(
    this._remoteDataSource, [
    ProductLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource;

  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource? _localDataSource;
  final Map<String, ProductModel> _memoryWishlist = {};

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();
      if (products.isNotEmpty) {
        await _localDataSource?.cacheProducts(products);
      }
      return Success(products);
    } on NetworkFailure catch (error) {
      final cached = _localDataSource?.getCachedProducts();
      if (cached != null && cached.isNotEmpty) return Success(cached);
      return Failure(error.message);
    } catch (error) {
      final cached = _localDataSource?.getCachedProducts();
      if (cached != null && cached.isNotEmpty) return Success(cached);
      return Failure('Gagal memuat katalog produk: $error');
    }
  }

  @override
  List<ProductModel> getWishlist() =>
      _localDataSource?.getWishlist() ?? _memoryWishlist.values.toList();

  @override
  Future<bool> toggleWishlist(ProductModel product) async {
    final local = _localDataSource;
    if (local != null) {
      if (local.isFavorite(product.id)) {
        await local.removeFromWishlist(product.id);
        return false;
      }
      await local.saveToWishlist(product);
      return true;
    }
    if (_memoryWishlist.containsKey(product.id)) {
      _memoryWishlist.remove(product.id);
      return false;
    }
    _memoryWishlist[product.id] = product.copyWith(isFavorite: true);
    return true;
  }

  @override
  Future<void> clearWishlist() async {
    await _localDataSource?.clearWishlist();
    _memoryWishlist.clear();
  }

  @override
  bool isFavorite(String productId) =>
      _localDataSource?.isFavorite(productId) ??
      _memoryWishlist.containsKey(productId);
}
