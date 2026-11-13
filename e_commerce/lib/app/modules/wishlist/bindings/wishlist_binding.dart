import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
