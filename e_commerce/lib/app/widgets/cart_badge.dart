import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/cart/controllers/cart_controller.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController(), permanent: true);
    return Obx(() => Badge(
          isLabelVisible: cart.totalItemCount > 0,
          label: Text('${cart.totalItemCount}'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ));
  }
}
