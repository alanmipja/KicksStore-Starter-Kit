import 'package:get/get.dart';

import 'package:e_commerce/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final cartCount = 0.obs;
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;

  final categories = const ['Semua', 'Running', 'Basketball', 'Lifestyle'];

  final products = <Map<String, dynamic>>[
    {
      'id': 'shoe-01',
      'name': 'Nike Air Jordan 1 High OG',
      'category': 'Basketball',
      'price': 2499000,
      'rating': 4.9,
      'reviewCount': 312,
      'imageUrl':
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=800&q=80',
      'description':
          'Sepatu legendaris dengan material kulit premium, bantalan Air-Sole klasik, dan sol traksi karet tangguh untuk gaya hidup dan performa maksimal.',
    },
    {
      'id': 'shoe-02',
      'name': 'Nike Air Max 270',
      'category': 'Lifestyle',
      'price': 1899000,
      'rating': 4.8,
      'reviewCount': 186,
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      'description':
          'Sneakers ringan dengan bantalan responsif dan desain modern untuk kenyamanan sehari-hari.',
    },
    {
      'id': 'shoe-03',
      'name': 'Adidas Ultraboost',
      'category': 'Running',
      'price': 2199000,
      'rating': 4.7,
      'reviewCount': 154,
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      'description':
          'Sepatu lari dengan bantalan empuk dan upper fleksibel untuk menemani setiap langkah.',
    },
    {
      'id': 'shoe-04',
      'name': 'New Balance 574',
      'category': 'Lifestyle',
      'price': 1599000,
      'rating': 4.8,
      'reviewCount': 98,
      'imageUrl':
          'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3?auto=format&fit=crop&w=800&q=80',
      'description':
          'Sneakers klasik dengan material pilihan dan kenyamanan untuk aktivitas kasual.',
    },
  ].obs;

  List<Map<String, dynamic>> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products.toList();

    return products
        .where((product) => product['category'] == category)
        .toList();
  }

  bool isFavorite(Object? productId) {
    final id = productId?.toString();
    return id != null && favoriteIds.contains(id);
  }

  void toggleFavorite(Object? productId) {
    final id = productId?.toString();
    if (id == null || id.isEmpty) return;

    if (!favoriteIds.add(id)) {
      favoriteIds.remove(id);
    }
  }

  void changeCategory(String category) {
    if (categories.contains(category)) {
      selectedCategory.value = category;
    }
  }

  void openDetail(Map<String, dynamic> product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }

  void addToCart(Map<String, dynamic> product) {
    cartCount.value++;
    Get.snackbar(
      'Berhasil Ditambahkan',
      '${product['name']} dimasukkan ke keranjang belanja!',
    );
  }
}
