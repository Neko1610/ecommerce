import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../screens/product_detail_screen.dart';
import '../../providers/WishlistProvider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    final variant = product.variants.isNotEmpty
        ? product.variants.first
        : null;

    final price = variant?.price ?? product.minPrice;
    final oldPrice = variant?.oldPrice;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          children: [

            /// 🔥 IMAGE + ❤️
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.image,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// ❤️ WISHLIST
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlist, _) {
                        final isFav =
                            wishlist.isFavorite(product.id);

                        return GestureDetector(
                          onTap: () {
                            wishlist.toggle(product.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFav
                                  ? Colors.red
                                  : Colors.grey,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 INFO
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// NAME
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// PRICE
                  Text(
                    "\$${price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Color(0xff137fec),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// OLD PRICE
                  if (oldPrice != null)
                    Text(
                      "\$${oldPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}