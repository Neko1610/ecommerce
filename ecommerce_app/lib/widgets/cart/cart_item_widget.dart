import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import 'quantity_selector.dart';

class CartItemWidget extends StatelessWidget {
  final dynamic item;
  final Function(int) onUpdate;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final variant = item['variant'] ?? {};
    final product = variant['product'] ?? {};

    final cartId = item['id'];
    final qty = item['quantity'];
    final image = variant['images'] != null && variant['images'].isNotEmpty
        ? variant['images'][0]
        : "https://picsum.photos/80";
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 🖼 IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(Icons.image),
                ),
              ),

              SizedBox(width: 12),

              // 📄 INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${variant['size']} • ${variant['color']}",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "\$${variant['price']}",
                      style: TextStyle(
                        color: Color(0xff137fec),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ➕➖
              QuantitySelector(
                quantity: qty,

                onIncrease: () async {
                  final newQty = qty + 1;

                  // ✅ update UI trước (mượt)
                  onUpdate(newQty);

                  // ✅ call API sau
                  await CartService().updateQuantity(cartId, newQty);
                },

                onDecrease: () async {
                  if (qty <= 1) return;

                  final newQty = qty - 1;

                  onUpdate(newQty);

                  await CartService().updateQuantity(cartId, newQty);
                },
              ),
            ],
          ),

          // ❌ DELETE
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                await CartService().deleteItem(cartId);

                onDelete(); // remove local
              },
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
