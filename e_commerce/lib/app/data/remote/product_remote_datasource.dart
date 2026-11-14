import 'package:e_commerce/app/core/network/dio_client.dart';
import 'package:e_commerce/app/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dioClient.get('/products/category/mens-shoes');
    final data = response.data;

    if (data is! Map || data['products'] is! List) {
      throw const FormatException(
        'Format katalog produk dari server tidak valid.',
      );
    }

    final products = data['products'] as List;
    return products
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Data produk dari server tidak valid.');
          }
          return ProductModel.fromJson(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
  }
}
