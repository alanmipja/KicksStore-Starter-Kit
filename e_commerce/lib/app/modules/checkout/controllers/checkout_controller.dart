import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

class CourierOption {
  final String name;
  final String estimatedTime;
  final int cost;

  const CourierOption({
    required this.name,
    required this.estimatedTime,
    required this.cost,
  });
}

class CheckoutController extends GetxController {
  final CartController? _cartController;

  CheckoutController({CartController? cartController})
    : _cartController = cartController;

  CartController get cart {
    if (_cartController != null) return _cartController;
    return Get.find<CartController>();
  }

  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController notesController;
  late final TextEditingController couponController;

  final selectedCourierIndex = 0.obs;
  final selectedPaymentMethod = 0.obs;
  final discountAmount = 0.obs;
  final appliedCouponCode = ''.obs;
  final isLoading = false.obs;

  final List<CourierOption> courierOptions = const [
    CourierOption(
      name: 'JNE Reguler',
      estimatedTime: '2-3 hari kerja',
      cost: 25000,
    ),
    CourierOption(
      name: 'SiCepat BEST',
      estimatedTime: '1-2 hari kerja',
      cost: 22000,
    ),
    CourierOption(
      name: 'GoSend Instant',
      estimatedTime: 'Tiba hari ini (Instant 3-4 jam)',
      cost: 35000,
    ),
  ];

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    notesController = TextEditingController();
    couponController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    couponController.dispose();
    super.onClose();
  }

  void selectCourier(int index) {
    if (index >= 0 && index < courierOptions.length) {
      selectedCourierIndex.value = index;
    }
  }

  void selectPaymentMethod(int index) {
    if (index >= 0) selectedPaymentMethod.value = index;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama penerima wajib diisi';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    final clean = value.trim();
    if (!RegExp(r'^[0-9+]+$').hasMatch(clean)) {
      return 'Format nomor telepon tidak valid';
    }
    if (clean.replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat pengiriman wajib diisi';
    }
    if (value.trim().length < 10) {
      return 'Alamat lengkap minimal 10 karakter';
    }
    return null;
  }

  int get subtotal => cart.subtotal;
  int get tax => cart.tax;
  int get courierFee =>
      cart.items.isEmpty ? 0 : courierOptions[selectedCourierIndex.value].cost;
  int get promoDiscount => discountAmount.value;
  int get grandTotal => subtotal + tax + courierFee - promoDiscount < 0
      ? 0
      : subtotal + tax + courierFee - promoDiscount;

  String get formattedSubtotal => currencyFormatter.format(subtotal);
  String get formattedTax => currencyFormatter.format(tax);
  String get formattedCourierFee => currencyFormatter.format(courierFee);
  String get formattedGrandTotal => currencyFormatter.format(grandTotal);

  void applyCoupon(String couponCode) {
    final code = couponCode.trim().toUpperCase();
    if (code == 'SMKBISA' || code == 'KICKS10') {
      discountAmount.value = 25000;
      appliedCouponCode.value = code;
      Get.snackbar(
        'Kupon Berhasil Dipasang! 🎉',
        'Hemat Rp 25.000 untuk pesanan sneakers impianmu.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } else {
      discountAmount.value = 0;
      appliedCouponCode.value = '';
      Get.snackbar(
        'Kupon Tidak Valid',
        'Kode kupon promo tidak ditemukan atau telah kedaluwarsa.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> placeOrder() async {
    if (formKey.currentState?.validate() != true) {
      Get.snackbar(
        'Data Belum Lengkap',
        'Silakan lengkapi formulir pengiriman sebelum melanjutkan.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    await cart.clearCartAsync();
    isLoading.value = false;

    Get.defaultDialog(
      title: 'Pesanan Berhasil! 🎉',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: 'Terima kasih! Pesanan sneakers impianmu sedang diproses.',
      textConfirm: 'Lihat Riwayat Pesanan',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.back();
        Get.offAllNamed(Routes.ORDERS);
      },
    );
  }
}
