class Variant {
  final int id;
  final String color;
  final String size;
  final double price;
  final int stock;
  final List<String> images;

  Variant({
    required this.id,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    required this.images,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      color: json['color'],
      size: json['size'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
