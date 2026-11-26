import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/services/auth_service.dart';
import 'package:e_commerce/app/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService? _authService;

  AuthMiddleware({AuthService? authService}) : _authService = authService;

  AuthService get auth =>
      _authService ??
      (Get.isRegistered<AuthService>()
          ? AuthService.to
          : throw StateError('AuthService belum diinisialisasi.'));

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!auth.isLoggedIn.value) {
      auth.redirectRoute = route;
      if (!Get.testMode && Get.overlayContext != null) {
        Get.snackbar(
          'Akses Dibatasi',
          'Silakan masuk akun terlebih dahulu untuk melanjutkan proses pemesanan.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF1E293B),
          colorText: Colors.white,
          icon: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.orangeAccent,
          ),
        );
      }
      return const RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}
