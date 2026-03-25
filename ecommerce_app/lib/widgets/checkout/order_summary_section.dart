import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  Widget row(
    String title,
    double value,
    NumberFormat usd, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          usd.format(value), // 🔥 FIX
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usd = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          row("Subtotal", subtotal, usd),
          const SizedBox(height: 6),
          row("Shipping", shipping, usd),
          const Divider(),
          row("Total", total, usd, bold: true),
        ],
      ),
    );
  }
}
