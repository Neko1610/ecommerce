import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
            /// IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            /// INFO
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category", // sau này có thể lấy từ API
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),

                  SizedBox(height: 2),

                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      color: Color(0xff137fec),
                      fontWeight: FontWeight.bold,
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
