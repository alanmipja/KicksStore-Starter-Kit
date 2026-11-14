import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final product = Rx<ProductModel?>(null);
  final quantity = 1.obs;
  final selectedSize = '42'.obs;
  final isFavorite = false.obs;
  final availableSizes = ['40', '41', '42', '43', '44'];

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
    final currentProduct = product.value;
    if (currentProduct != null) {
      isFavorite.value = Get.isRegistered<HomeController>()
          ? Get.find<HomeController>().isFavorite(currentProduct.id)
          : currentProduct.isFavorite;
    }
  }

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void toggleFavorite() {
    final currentProduct = product.value;
    if (currentProduct == null) return;

    isFavorite.toggle();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().toggleFavorite(currentProduct.id);
    }
  }

  void addToCart() {
    if (product.value == null) return;
    cartController.addItem(
      product.value!,
      quantity: quantity.value,
      size: selectedSize.value,
    );
    Get.snackbar(
      'Keranjang',
      'Berhasil ditambahkan',
      duration: const Duration(seconds: 1),
    );
  }
}
