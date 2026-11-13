import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/cart_badge.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist'), actions: const [CartBadge()]),
      body: Obx(() {
        final items = controller.wishlistItems;
        if (items.isEmpty) {
          return const Center(child: Text('Belum ada sepatu favorit'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final p = items[i];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.directions_run, size: 36),
                title: Text(p.name),
                subtitle: Text(p.formattedPrice),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeFromWishlist(p.id),
                    ),
                    FilledButton(
                      onPressed: () => controller.moveToCart(p),
                      child: const Text('Ke Keranjang'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
