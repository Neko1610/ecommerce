class CartItem {
  final int id;
  final int variantId;

  final String productName;
  final String productImage;

  final String color;
  final String size;

  final double price;
  final int stock;

  final int quantity;

  CartItem({
    required this.id,
    required this.variantId,
    required this.productName,
    required this.productImage,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    this.quantity = 1,
  });

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      variantId: variantId,
      productName: productName,
      productImage: productImage,
      color: color,
      size: size,
      price: price,
      stock: stock,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    "variantId": variantId,
    "quantity": quantity,
  };
  factory CartItem.fromJson(Map<String, dynamic> json) {
  return CartItem(
    id: json['id'],
    variantId: json['variantId'],
    productName: json['productName'],
    productImage: json['productImage'],
    color: json['color'],
    size: json['size'],
    price: (json['price']).toDouble(),
    stock: json['stock'],
    quantity: json['quantity'],
  );
}
}