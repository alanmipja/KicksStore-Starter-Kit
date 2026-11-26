import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../../data/local/cart_local_datasource.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartLocalDataSource>()) {
      Get.lazyPut<CartLocalDataSource>(() => CartLocalDataSourceImpl());
    }
    if (!Get.isRegistered<CartController>()) {
      Get.put(
        CartController(localDataSource: Get.find<CartLocalDataSource>()),
        permanent: true,
      );
    }
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(cartController: Get.find<CartController>()),
    );
  }
}
