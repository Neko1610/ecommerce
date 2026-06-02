import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';

class OrderSummary extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final subtotal = (order['subtotal'] as num?)?.toDouble() ?? 0;
    final discount = (order['discount'] as num?)?.toDouble() ?? 0;
    final shipping =
        (order['shippingFee'] as num?)?.toDouble() ??
        (order['shipping'] as num?)?.toDouble() ??
        0;
    final total = toVND(subtotal - discount) + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row("Tạm tính", formatVND(subtotal)),
          if (discount > 0) _row("Giảm giá", formatVND(-discount)),
          _row("Vận chuyển", formatRawVND(shipping)),
          const Divider(color: Colors.white24),
          _row("Tổng", formatRawVND(total), isBold: true),
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
