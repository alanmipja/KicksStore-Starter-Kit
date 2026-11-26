import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/services/auth_service.dart';
import 'app/data/local/storage_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
