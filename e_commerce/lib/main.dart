import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/services/auth_service.dart';
import 'app/data/local/storage_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // AuthService akan menggunakan SharedPreferences sebagai fallback lokal.
  }
  final storageService = await Get.putAsync<StorageService>(
    () => StorageService().init(),
  );
  await Get.putAsync<AuthService>(
    () => AuthService().init(prefs: storageService.prefs),
  );

  runApp(
    GetMaterialApp(
      title: "KicksStore",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.themeMode,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
