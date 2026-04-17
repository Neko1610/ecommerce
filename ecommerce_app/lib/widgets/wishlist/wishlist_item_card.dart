import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/WishlistProvider.dart';
import '../../services/cart_service.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final variant = product.variants.isNotEmpty ? product.variants.first : null;
    final price = variant?.price ?? product.minPrice;
    final oldPrice = variant?.oldPrice;
    final isFlashSale = variant?.flashSale == true;
    final isOutOfStock = variant?.stock == 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: Image.network(
                    product.image,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      context.read<WishlistProvider>().toggle(product.id);
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite, color: Colors.red, size: 18),
                    ),
                  ),
                ),
                if (oldPrice != null && oldPrice > price)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "-${(((oldPrice - price) / oldPrice) * 100).round()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (isOutOfStock)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Out of Stock",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "\$${price.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: isFlashSale
                            ? Colors.red
                            : const Color(0xff137fec),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (oldPrice != null && oldPrice > price) ...[
                      const SizedBox(width: 6),
                      Text(
                        "\$${oldPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (variant == null || isOutOfStock)
                        ? null
                        : () async {
                            try {
                              await CartService().addToCart(
                                variantId: variant.id,
                                quantity: 1,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to cart"),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            }
                          },
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
