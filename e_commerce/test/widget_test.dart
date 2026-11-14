import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce/app/modules/login/controllers/login_controller.dart';
import 'package:e_commerce/app/modules/register/controllers/register_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginController validation', () {
    final controller = LoginController();

    test('validates required and well-formed email addresses', () {
      expect(controller.validateEmail('  '), 'Alamat email wajib diisi');
      expect(controller.validateEmail('not-an-email'), isNotNull);
      expect(controller.validateEmail('user@example.com'), isNull);
    });

    test('requires a six-character password containing a number', () {
      expect(
        controller.validatePassword('abc1'),
        'Kata sandi minimal 6 karakter',
      );
      expect(
        controller.validatePassword('rahasia'),
        'Kata sandi harus mengandung minimal 1 angka (0-9)',
      );
      expect(controller.validatePassword('rahasia1'), isNull);
    });
  });

  group('RegisterController validation', () {
    late RegisterController controller;

    setUp(() {
      controller = RegisterController();
      controller.onInit();
    });

    tearDown(() {
      controller.onClose();
    });

    test('validates names and matching passwords', () {
      expect(controller.validateName(' Al '), 'Nama minimal 3 karakter');
      expect(controller.validateName(' Alan '), isNull);
      expect(
        controller.validateConfirmPassword(''),
        'Konfirmasi kata sandi wajib diisi',
      );

      controller.passwordController.text = 'sepatubaru1';
      expect(
        controller.validateConfirmPassword('sepatubaru'),
        'Konfirmasi kata sandi tidak cocok dengan sandi di atas',
      );
      expect(controller.validateConfirmPassword('sepatubaru1'), isNull);
    });

    test('requires a six-character password containing a number', () {
      expect(
        controller.validatePassword('sepatubaru'),
        'Kata sandi harus mengandung minimal 1 angka (0-9)',
      );
      expect(controller.validatePassword('sepatubaru1'), isNull);
    });
  });

  test('cart groups items by product and shoe size', () {
    final controller = CartController();
    const product = ProductModel(
      id: 'shoe-01',
      name: 'Test sneaker',
      category: 'Running',
      price: 1000000,
      rating: 4.8,
      reviewCount: 10,
      imageUrl: '',
      description: '',
    );

    controller.addItem(product, size: '42');
    controller.addItem(product, quantity: 2, size: '42');
    controller.addItem(product, size: '41');

    expect(controller.items, hasLength(2));
    expect(controller.items.first.id, 'shoe-01_42');
    expect(controller.items.first.quantity, 3);
    expect(controller.items.last.id, 'shoe-01_41');
  });
}
