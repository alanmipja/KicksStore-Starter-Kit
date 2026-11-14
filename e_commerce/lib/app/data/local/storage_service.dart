import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';

class StorageService extends GetxService {
  static const String _themeKey = 'is_dark_mode';

  late final SharedPreferences _prefs;
  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  SharedPreferences get prefs => _prefs;

  Future<StorageService> init({bool initHive = true}) async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;

    if (initHive) {
      await Hive.initFlutter();
    }

    return this;
  }

  Future<void> toggleTheme() async {
    final nextIsDarkMode = !_isDarkMode.value;
    final wasSaved = await _prefs.setBool(_themeKey, nextIsDarkMode);
    if (!wasSaved) {
      throw StateError('Gagal menyimpan preferensi tema.');
    }

    _isDarkMode.value = nextIsDarkMode;
    Get.changeThemeMode(themeMode);

    final isDarkMode = _isDarkMode.value;
    Get.snackbar(
      isDarkMode ? 'Mode Gelap Diaktifkan' : 'Mode Terang Diaktifkan',
      isDarkMode
          ? 'Tampilan hemat daya dan nyaman untuk mata telah aktif.'
          : 'Tampilan cerah bersemangat telah aktif.',
      backgroundColor: isDarkMode ? const Color(0xFF1E293B) : AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      borderRadius: 12,
      icon: Icon(
        isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: isDarkMode ? AppColors.accent : Colors.white,
      ),
    );
  }
}
