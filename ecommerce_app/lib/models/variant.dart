class Variant {
  final int id;
  final String color;
  final String size;
  final double price;
  final double? oldPrice; 
  final int stock;
  final List<String> images;

  Variant({
    required this.id,
    required this.color,
    required this.size,
    required this.price,
    this.oldPrice,
    required this.stock,
    required this.images,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      color: json['color'],
      size: json['size'],
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice']).toDouble()
          : null, 
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}