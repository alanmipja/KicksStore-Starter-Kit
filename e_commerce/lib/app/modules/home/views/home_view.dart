import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/cart_badge.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Sepatu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Get.toNamed('/wishlist'),
          ),
          const CartBadge(),
        ],
      ),
      body: Obx(() => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final product = controller.products[i];
              return Card(
                child: ListTile(
                  onTap: () => Get.toNamed('/detail', arguments: product),
                  leading: const Icon(Icons.directions_run, size: 36),
                  title: Text(product.name),
                  subtitle: Text('${product.category} • ${product.formattedPrice}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => IconButton(
                            icon: Icon(
                              controller.isFavorite(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () => controller.toggleFavorite(product.id),
                          )),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => controller.addToCart(product),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
