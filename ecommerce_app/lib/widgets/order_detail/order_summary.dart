import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderSummary extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    final total = order['total'] ?? 0;
    final shipping = order['shipping'] ?? 0;
    final tax = order['tax'] ?? 0;
    final subtotal = total - shipping - tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row("Tạm tính", format.format(subtotal)),
          _row("Vận chuyển", format.format(shipping)),
          _row("Thuế", format.format(tax)),
          const Divider(color: Colors.white24),
          _row("Tổng", format.format(total), isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isBold ? Colors.black : Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
