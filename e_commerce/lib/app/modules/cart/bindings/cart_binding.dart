import 'package:get/get.dart';

import '../../../data/local/cart_local_datasource.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartLocalDataSource>()) {
      Get.lazyPut<CartLocalDataSource>(() => CartLocalDataSourceImpl());
    }
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(
        CartController(localDataSource: Get.find<CartLocalDataSource>()),
        permanent: true,
      );
    }
  }
}
