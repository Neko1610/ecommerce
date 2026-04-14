import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'wishlist_item_card.dart';

class WishlistGrid extends StatelessWidget {
  final List<Product> products;

  const WishlistGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return WishlistItemCard(product: products[index]);
      },
    );
  }
}