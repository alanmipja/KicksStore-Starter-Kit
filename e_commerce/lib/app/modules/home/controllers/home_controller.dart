import 'package:get/get.dart';

import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;
  final categories = const ['Semua', 'Running', 'Basketball', 'Lifestyle'];

  final products = <ProductModel>[
    const ProductModel(
      id: 'shoe-01',
      name: 'Nike Air Jordan 1 High OG',
      category: 'Basketball',
      price: 2499000,
      rating: 4.9,
      reviewCount: 312,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=800&q=80',
      description:
          'Sepatu legendaris dengan material kulit premium, bantalan Air-Sole klasik, dan sol traksi karet tangguh untuk gaya hidup dan performa maksimal.',
    ),
    const ProductModel(
      id: 'shoe-02',
      name: 'Nike Air Max 270',
      category: 'Lifestyle',
      price: 1899000,
      rating: 4.8,
      reviewCount: 186,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      description:
          'Sneakers ringan dengan bantalan responsif dan desain modern untuk kenyamanan sehari-hari.',
    ),
    const ProductModel(
      id: 'shoe-03',
      name: 'Adidas Ultraboost',
      category: 'Running',
      price: 2199000,
      rating: 4.7,
      reviewCount: 154,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      description:
          'Sepatu lari dengan bantalan empuk dan upper fleksibel untuk menemani setiap langkah.',
    ),
    const ProductModel(
      id: 'shoe-04',
      name: 'New Balance 574',
      category: 'Lifestyle',
      price: 1599000,
      rating: 4.8,
      reviewCount: 98,
      imageUrl:
          'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3?auto=format&fit=crop&w=800&q=80',
      description:
          'Sneakers klasik dengan material pilihan dan kenyamanan untuk aktivitas kasual.',
    ),
  ].obs;

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  int get cartCount => cartController.totalItemCount;

  List<ProductModel> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products.toList();

    return products
        .where((product) => product.category == category)
        .toList();
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (!favoriteIds.remove(productId)) {
      favoriteIds.add(productId);
    }
  }

  void changeCategory(String category) {
    if (categories.contains(category)) {
      selectedCategory.value = category;
    }
  }

  void openDetail(ProductModel product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }

  void addToCart(ProductModel product) {
    cartController.addItem(product);
    Get.snackbar(
      'Keranjang',
      '${product.name} ditambahkan ke keranjang.',
      duration: const Duration(seconds: 1),
    );
  }
}
