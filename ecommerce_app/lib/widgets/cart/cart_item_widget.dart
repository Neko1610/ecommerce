import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../models/cart_item.dart';

import 'quantity_selector.dart';

class CartItemWidget extends StatelessWidget {
  final Function(int) onUpdate;
  final VoidCallback onDelete;
  final CartItem item;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cartId = item.variantId;
    final qty = item.quantity;

    final name = item.productName;
    final image = item.productImage;
    final price = item.price;
    final color = item.color;
    final size = item.size;

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
              /// 🖼 IMAGE
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

              /// 📄 INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.w600)),

                    SizedBox(height: 4),

                    Text(
                      "$size • $color",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "\$${price.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: Color(0xff137fec),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// ➕➖
              QuantitySelector(
                quantity: qty,
                onIncrease: () async {
                  final newQty = qty + 1;
                  onUpdate(newQty);
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

          /// ❌ DELETE
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                await CartService().deleteItem(cartId);
                onDelete();
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
