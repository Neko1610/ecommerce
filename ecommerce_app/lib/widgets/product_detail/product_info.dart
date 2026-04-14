import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/variant.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final Variant? variant;

  const ProductInfo({
    super.key,
    required this.product,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {

    /// ✅ giá đúng
    final price = variant?.price ?? product.minPrice;

    /// ✅ giá cũ theo variant
    final oldPrice = variant?.oldPrice;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 8),

          /// 🔥 NAME
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              /// 🔥 PRICE
              Text(
                "\$${price.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Color(0xff137fec),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// 🔥 OLD PRICE + DISCOUNT (THEO VARIANT)
              if (oldPrice != null) ...[

                const SizedBox(width: 8),

                Text(
                  "\$${oldPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 6),

                /// % giảm
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xff137fec).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "-${(((oldPrice - price) / oldPrice) * 100).round()}%",
                    style: const TextStyle(
                      color: Color(0xff137fec),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}