import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  final ProductRepository _productRepository;

  WishlistController([ProductRepository? productRepository])
    : _productRepository = productRepository ?? Get.find<ProductRepository>();

  HomeController get homeController => Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController(Get.find<ProductRepository>()));

  CartController get cartController => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  final RxList<ProductModel> wishlist = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  List<ProductModel> get wishlistItems => wishlist;

  void loadWishlist() {
    wishlist.assignAll(_productRepository.getWishlist());
  }

  Future<void> removeFromWishlist(String id) async {
    final item = wishlist.firstWhereOrNull((product) => product.id == id);
    if (item == null) return;
    await _productRepository.toggleWishlist(item);
    loadWishlist();
    if (Get.isRegistered<HomeController>()) {
      homeController.favoriteIds.remove(id);
    }
  }

  void clearWishlist() {
    Get.defaultDialog(
      title: 'Kosongkan Wishlist?',
      titleStyle: const TextStyle(
        color: Color(0xFFEF4444),
        fontWeight: FontWeight.bold,
      ),
      middleText:
          'Apakah Anda yakin ingin menghapus seluruh sepatu favorit dari memori penyimpanan lokal?',
      textCancel: 'Batal',
      cancelTextColor: const Color(0xFF6B7280),
      textConfirm: 'Hapus Semua',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () async {
        if (Hive.isBoxOpen('wishlist_box')) {
          await Hive.box<ProductModel>('wishlist_box').clear();
        } else {
          await _productRepository.clearWishlist();
        }
        wishlist.clear();
        if (Get.isRegistered<HomeController>()) {
          homeController.favoriteIds.clear();
        }
        Get.back();
        Get.snackbar(
          'Wishlist Dikosongkan',
          'Seluruh produk favorit berhasil dihapus dari penyimpanan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  void moveToCart(ProductModel product) {
    cartController.addItem(product);
    homeController.favoriteIds.remove(product.id);
    removeFromWishlist(product.id);
  }
}
