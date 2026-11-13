import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  HomeController get homeController => Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

  CartController get cartController => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  List<ProductModel> get wishlistItems => homeController.products
      .where((p) => homeController.favoriteIds.contains(p.id))
      .toList();

  void removeFromWishlist(String id) => homeController.favoriteIds.remove(id);

  void moveToCart(ProductModel product) {
    cartController.addItem(product);
    homeController.favoriteIds.remove(product.id);
  }
}
