import 'package:get/get.dart';

import '../../home/bindings/home_binding.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding.registerDependencies();
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
