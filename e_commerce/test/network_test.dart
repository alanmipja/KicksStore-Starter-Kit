import 'package:dio/dio.dart';
import 'package:e_commerce/app/core/network/dio_exception.dart';
import 'package:e_commerce/app/core/network/result.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/data/repository/product_repository.dart';
import 'package:e_commerce/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this.result);

  final Result<List<ProductModel>, String> result;

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async => result;
}

void main() {
  test('deserializes DummyJSON product fields defensively', () {
    final product = ProductModel.fromJson({
      'id': 42,
      'title': 'Running Shoe',
      'category': 'mens-shoes',
      'price': '49',
      'rating': 5,
      'thumbnail': 'https://example.com/shoe.jpg',
      'reviews': [{}, {}],
    });

    expect(product.id, '42');
    expect(product.name, 'Running Shoe');
    expect(product.category, 'Mens-shoes');
    expect(product.price, 735000);
    expect(product.rating, 5.0);
    expect(product.reviewCount, 2);
    expect(product.imageUrl, 'https://example.com/shoe.jpg');
  });

  testWidgets('shows success and offline feedback after refreshes', (
    tester,
  ) async {
    final product = ProductModel.fromJson({
      'id': 1,
      'title': 'Running Shoe',
      'price': 50,
    });
    final successController = HomeController(
      _FakeProductRepository(Success([product])),
    );

    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: SizedBox.shrink())),
    );
    await successController.fetchProducts();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Katalog Berhasil Diperbarui'), findsOneWidget);
    expect(
      find.text('Berhasil mengunduh 1 sepatu terbaru dari server!'),
      findsOneWidget,
    );
    expect(successController.products.single.id, '1');
    expect(successController.isLoading.value, isFalse);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final offlineController = HomeController(
      _FakeProductRepository(const Failure('server tidak terjangkau')),
    );
    final previousProducts = offlineController.products.toList();

    await offlineController.fetchProducts();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Mode Offline'), findsOneWidget);
    expect(
      find.text(
        'Koneksi ke server terputus. Produk yang sudah tampil tetap tersedia.',
      ),
      findsOneWidget,
    );
    expect(offlineController.products, previousProducts);
    expect(offlineController.errorMessage.value, 'server tidak terjangkau');
    expect(offlineController.isLoading.value, isFalse);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  test('maps Dio timeout errors to a readable network failure', () {
    final failure = ErrorHandler.handle(
      DioException(
        requestOptions: RequestOptions(path: '/products'),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    expect(failure.code, -1);
    expect(
      failure.message,
      'Waktu koneksi habis (Timeout). Periksa koneksi internet Anda.',
    );
  });
}
