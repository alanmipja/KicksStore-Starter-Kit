import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class DetailController extends GetxController {
  final product = Rx<ProductModel?>(null);
  final quantity = 1.obs;
  final selectedSize = '42'.obs;

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is ProductModel) {
      product.value = arg;
    } else if (arg is Map<String, dynamic>) {
      product.value = ProductModel.fromMap(arg);
    }
  }

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    if (product.value == null) return;
    cartController.addItem(
      product.value!,
      quantity: quantity.value,
      size: selectedSize.value,
    );
    Get.snackbar('Keranjang', 'Berhasil ditambahkan',
        duration: const Duration(seconds: 1));
  }
}
