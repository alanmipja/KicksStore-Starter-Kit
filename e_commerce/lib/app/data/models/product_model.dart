String formatRupiah(int value) {
  final s = value.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp $b';
}

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final int price;
  final List<String> sizes;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.sizes = const ['40', '41', '42', '43', '44'],
  });

  String get formattedPrice => formatRupiah(price);

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        description: map['description'] as String,
        price: map['price'] as int,
        sizes: List<String>.from(map['sizes'] ?? const ['40', '41', '42', '43', '44']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'sizes': sizes,
      };
}
