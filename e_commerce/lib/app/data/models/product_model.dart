import 'package:intl/intl.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  String get formattedPrice => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(price);

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    String? description,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
      price: (map['price'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawName = json['title'] ?? json['name'] ?? 'Sepatu Sneakers';
    final rawCategory = (json['category'] ?? 'Lifestyle').toString().trim();
    final rawPrice = _parseNumber(json['price'])?.toInt() ?? 150000;
    final reviews = json['reviews'];
    final reviewCount = reviews is List
        ? reviews.length
        : _parseNumber(json['reviewCount'])?.toInt() ?? 0;

    return ProductModel(
      id: rawId?.toString() ?? 'prod-${DateTime.now().millisecondsSinceEpoch}',
      name: rawName.toString(),
      category: rawCategory.isEmpty
          ? 'General'
          : '${rawCategory[0].toUpperCase()}${rawCategory.substring(1)}',
      price: rawPrice < 1000 ? rawPrice * 15000 : rawPrice,
      rating: _parseNumber(json['rating'])?.toDouble() ?? 4.8,
      reviewCount: reviewCount,
      imageUrl:
          (json['thumbnail'] ??
                  json['imageUrl'] ??
                  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80')
              .toString(),
      description:
          (json['description'] ?? 'Sepatu sneakers berkualitas tinggi.')
              .toString(),
      isFavorite: json['isFavorite'] is bool
          ? json['isFavorite'] as bool
          : false,
    );
  }

  static num? _parseNumber(Object? value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'description': description,
      'isFavorite': isFavorite,
    };
  }
}
