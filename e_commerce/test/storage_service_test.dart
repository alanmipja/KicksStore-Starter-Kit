import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce/app/data/local/storage_service.dart';

Future<void> _dismissSnackbar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('persists theme changes and shows matching feedback', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService().init(initHive: false);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: storage.themeMode,
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    expect(storage.isDarkMode, isFalse);
    expect(storage.themeMode, ThemeMode.light);

    await storage.toggleTheme();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(storage.isDarkMode, isTrue);
    expect(storage.themeMode, ThemeMode.dark);
    expect(storage.prefs.getBool('is_dark_mode'), isTrue);
    expect(find.text('Mode Gelap Diaktifkan'), findsOneWidget);
    expect(
      find.text('Tampilan hemat daya dan nyaman untuk mata telah aktif.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    await _dismissSnackbar(tester);

    final restoredStorage = await StorageService().init(initHive: false);
    expect(restoredStorage.isDarkMode, isTrue);

    await storage.toggleTheme();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(storage.isDarkMode, isFalse);
    expect(storage.prefs.getBool('is_dark_mode'), isFalse);
    expect(find.text('Mode Terang Diaktifkan'), findsOneWidget);
    expect(
      find.text('Tampilan cerah bersemangat telah aktif.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    await _dismissSnackbar(tester);
  });
}
