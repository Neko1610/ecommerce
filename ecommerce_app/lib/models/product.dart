import 'variant.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String image;

  /// ✅ dùng cho list
  final double minPrice;
  final double maxPrice;

  final List<String> colors;
  final List<String> sizes;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.minPrice,
    required this.maxPrice,
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
      description: json['description'] ?? "",
      image: json['image'] ?? "",

      /// ✅ lấy từ backend
      minPrice: (json['minPrice'] ?? 0).toDouble(),
      maxPrice: (json['maxPrice'] ?? 0).toDouble(),

      colors: colors,
      sizes: sizes,
      variants: variantList,
    );
  }
}