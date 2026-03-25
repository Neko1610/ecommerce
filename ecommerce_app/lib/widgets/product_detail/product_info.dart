import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/variant.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final Variant? variant;

  const ProductInfo({super.key, required this.product, required this.variant});

  @override
  Widget build(BuildContext context) {
    final price = variant?.price ?? product.price;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),

          Text(
            product.name,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              /// 🔥 GIÁ THEO VARIANT
              Text(
                "\$${price.toStringAsFixed(0)}",
                style: TextStyle(
                  color: Color(0xff137fec),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// nếu có giảm giá
              if (product.oldPrice != null) ...[
                SizedBox(width: 8),

                Text(
                  "\$${product.oldPrice!.toStringAsFixed(0)}",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(width: 6),

                /// % giảm (dùng price variant)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xff137fec).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "-${(((product.oldPrice! - price) / product.oldPrice!) * 100).round()}%",
                    style: TextStyle(
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
