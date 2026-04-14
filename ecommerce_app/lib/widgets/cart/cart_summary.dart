import 'package:flutter/material.dart';
import '../../models/cart_item.dart'; // 🔥 thêm dòng này

class CartSummary extends StatelessWidget {
  final List<CartItem> items; // 🔥 FIX
  final double discountPercent;

  const CartSummary({
    super.key,
    required this.items,
    required this.discountPercent,
  });

  double getSubtotal() {
    double total = 0;

    for (var item in items) {
      total += item.price * item.quantity; // 🔥 FIX
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = getSubtotal();
    final discount = subtotal * (discountPercent / 100);
    final total = subtotal - discount;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row("Subtotal", subtotal),
          _row("Shipping", 0),
          _row("Discount", -discount),
          Divider(),
          _row("Total Price", total, isBold: true),
        ],
      ),
    );
  }

  Widget _row(String title, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value == 0 && title == "Shipping"
              ? "Free"
              : "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: value < 0 ? Colors.red : null,
          ),
        ),
      ],
    );
  }
}