import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';

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
    double value, {
    bool bold = false,
    bool rawVND = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          rawVND ? formatRawVND(value) : formatVND(value),
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          row("Subtotal", subtotal),
          const SizedBox(height: 6),
          row("Shipping", shipping, rawVND: true),
          const Divider(),
          row("Total", total, bold: true, rawVND: true),
        ],
      ),
    );
  }
}
