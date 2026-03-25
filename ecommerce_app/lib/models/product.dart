import 'variant.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final double? oldPrice;
  final String description;
  final String image;
  final List<String> colors;
  final List<String> sizes;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.image,
    required this.colors,
    required this.sizes,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantList = (json['variants'] as List? ?? [])
        .map((v) => Variant.fromJson(v))
        .toList();

    final colors = variantList.map((v) => v.color).toSet().toList();

    final sizes = variantList.map((v) => v.size).toSet().toList();

    return Product(
      id: json['id'],
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      price: (json['price'] ?? 0).toDouble(), // ✅ FIX
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice']).toDouble()
          : null, // ✅ THÊM
      description: json['description'] ?? "",
      colors: colors,
      sizes: sizes,
      variants: variantList,
    );
  }
}
