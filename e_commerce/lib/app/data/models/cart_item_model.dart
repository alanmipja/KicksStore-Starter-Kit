import 'package:intl/intl.dart';

import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String selectedSize;
  int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  int get subtotal => product.price * quantity;

  String get formattedSubtotal => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(subtotal);

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    String? selectedSize,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final productMap = map['product'];
    return CartItemModel(
      id: map['id'] as String? ?? '',
      product: ProductModel.fromMap(
        productMap is Map ? Map<String, dynamic>.from(productMap) : const {},
      ),
      selectedSize: map['selectedSize'] as String? ?? '42',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'selectedSize': selectedSize,
      'quantity': quantity,
    };
  }
}
