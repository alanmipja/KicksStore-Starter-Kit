import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/modules/home/controllers/home_controller.dart';

class DetailController extends GetxController {
  // Sesi 02: State Reaktif Halaman Detail Produk
  final product = <String, dynamic>{}.obs;
  final quantity = 1.obs;
  final selectedSize = '42'.obs;
  final isFavorite = false.obs;

  // Daftar Ukuran Sepatu Tersedia
  final availableSizes = ['40', '41', '42', '43', '44'];

  @override
  void onInit() {
    super.onInit();
    // Menangkap data argumen yang dikirim dari HomeView
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      product.assignAll(Get.arguments as Map<String, dynamic>);
      // Cek apakah item ini sudah ada di daftar wishlist HomeController
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        isFavorite.value = homeController.isFavorite(product['id'] ?? '');
      }
    } else {
      // Fallback data default jika dibuka tanpa argumen
      product.assignAll({
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
      });
    }
  }

  // Tambah jumlah kuantitas
  void incrementQuantity() {
    quantity.value++;
  }

  // Kurangi jumlah kuantitas (minimal 1)
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Ganti ukuran sepatu aktif
  void changeSize(String size) {
    selectedSize.value = size;
  }

  // Toggle status favorit di halaman detail
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().toggleFavorite(product['id'] ?? '');
    }
  }

  // Tambah ke keranjang belanja
  void addToCart() {
    // Sinkronkan cart badge di HomeController
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.cartCount.value += quantity.value;
    }

    Get.snackbar(
      'Berhasil Ditambahkan',
      '${quantity.value} pasang ${product['name']} (Ukuran ${selectedSize.value}) dimasukkan ke keranjang belanja!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    );
  }
}