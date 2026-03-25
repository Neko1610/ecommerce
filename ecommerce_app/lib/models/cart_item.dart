class CartItem {
  final int productId;
  final String name;
  final String image;
  final double price;
  final String color;
  final String size;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.color,
    required this.size,
    this.quantity = 1,
  });

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      image: image,
      price: price,
      color: color,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "name": name,
    "image": image,
    "price": price,
    "color": color,
    "size": size,
    "quantity": quantity,
  };
}
