import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/cart_badge.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk'), actions: const [CartBadge()]),
      body: Obx(() {
        final p = controller.product.value;
        if (p == null) return const Center(child: Text('Produk tidak ditemukan'));
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.directions_run, size: 120),
            const SizedBox(height: 12),
            Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
            Text(p.formattedPrice,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepOrange)),
            const SizedBox(height: 8),
            Text(p.description),
            const SizedBox(height: 16),
            const Text('Ukuran', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: p.sizes
                  .map((s) => ChoiceChip(
                        label: Text(s),
                        selected: controller.selectedSize.value == s,
                        onSelected: (_) => controller.selectedSize.value = s,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: controller.decrement),
                Text('${controller.quantity.value}', style: const TextStyle(fontSize: 18)),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: controller.increment),
              ],
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: controller.addToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Tambah ke Keranjang'),
          ),
        ),
      ),
    );
  }
}
