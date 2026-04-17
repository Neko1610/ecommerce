import 'package:flutter/material.dart';

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
    final qty = item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.productImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item.size} • ${item.color}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "\$${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Color(0xff137fec),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              QuantitySelector(
                quantity: qty,
                onIncrease: () {
                  onUpdate(qty + 1);
                },
                onDecrease: () {
                  if (qty <= 1) return;
                  onUpdate(qty - 1);
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
