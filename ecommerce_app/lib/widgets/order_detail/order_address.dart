import 'package:flutter/material.dart';

class OrderAddress extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderAddress({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 6),
              Text(
                "Thông tin người nhận",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order['receiverName'] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order['phone'] ?? ""),
          Text(order['address'] ?? ""),
        ],
      ),
    );
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
