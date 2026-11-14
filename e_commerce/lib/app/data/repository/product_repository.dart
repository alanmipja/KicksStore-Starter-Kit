import 'package:e_commerce/app/core/network/dio_exception.dart';
import 'package:e_commerce/app/core/network/result.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/data/remote/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();
      return Success(products);
    } on NetworkFailure catch (error) {
      return Failure(error.message);
    } catch (error) {
      return Failure('Gagal memuat katalog produk: $error');
    }
  }
}
