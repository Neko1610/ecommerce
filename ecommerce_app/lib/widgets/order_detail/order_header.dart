import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mã đơn hàng",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "#ORD-${order['id'] ?? ''}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _statusChip(order['status']),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                _formatDate(order['createdAt']),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String? status) {
    Color color = Colors.blue;

    switch (status) {
      case "PENDING":
        color = Colors.orange;
        break;
      case "PROCESSING":
        color = Colors.blue;
        break;
      case "SHIPPING":
        color = Colors.purple;
        break;
      case "DELIVERED":
        color = Colors.green;
        break;
      case "CANCELLED":
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status ?? "", style: TextStyle(color: color, fontSize: 11)),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return "";
    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (e) {
      return date;
    }
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
