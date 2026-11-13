import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  final products = <ProductModel>[
    const ProductModel(id: 'shoe-01', name: 'Nike Air Zoom Pegasus', category: 'Running', price: 1850000, description: 'Sepatu lari ringan dengan bantalan responsif untuk harian.'),
    const ProductModel(id: 'shoe-02', name: 'Adidas Ultraboost Light', category: 'Running', price: 2900000, description: 'Bantalan Boost generasi terbaru, nyaman untuk jarak jauh.'),
    const ProductModel(id: 'shoe-03', name: 'Converse Chuck 70', category: 'Casual', price: 1100000, description: 'Klasik kanvas untuk gaya santai sehari-hari.'),
    const ProductModel(id: 'shoe-04', name: 'Puma Suede Classic', category: 'Casual', price: 1250000, description: 'Siluet ikonik berbahan suede lembut.'),
    const ProductModel(id: 'shoe-05', name: 'New Balance 574', category: 'Lifestyle', price: 1650000, description: 'Perpaduan retro dan kenyamanan modern.'),
  ].obs;

  final favoriteIds = <String>{}.obs;

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  int get cartCount => cartController.totalItemCount;

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (!favoriteIds.remove(id)) favoriteIds.add(id);
  }

  void addToCart(ProductModel product) {
    cartController.addItem(product);
    Get.snackbar('Keranjang', '${product.name} ditambahkan',
        duration: const Duration(seconds: 1));
  }
}
