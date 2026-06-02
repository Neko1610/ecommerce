import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/price_helper.dart';
import '../../models/product.dart';
import '../../models/variant.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final Variant? variant;

  const ProductInfo({super.key, required this.product, required this.variant});

  @override
  Widget build(BuildContext context) {
    final price = PriceHelper.getEffectivePrice(product, variant);
    final oldPrice = PriceHelper.getOriginalPrice(product, variant);
    final isFlashSale = variant?.flashSale == true;
    final discountPercent = PriceHelper.getDiscountPercent(product, variant);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                formatVND(price),
                style: TextStyle(
                  color: isFlashSale ? Colors.red : const Color(0xff137fec),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (oldPrice > price) ...[
                const SizedBox(width: 8),
                Text(
                  formatVND(oldPrice),
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff137fec).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "-$discountPercent%",
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
