import 'package:flutter/material.dart';
import '../../screens/order_detail_screen.dart'; // 🔥 thêm

import 'order_status_badge.dart';
import 'order_images.dart';

class OrderCard extends StatelessWidget {
  final int id;
  final String status;
  final double total;
  final List images;
  const OrderCard({
    super.key,
    required this.id,
    required this.status,
    required this.total,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // 🔥 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#ORD-$id",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff137fec),
                ),
              ),
              OrderStatusBadge(status: status),
            ],
          ),

          const SizedBox(height: 10),

          OrderImages(images: images),

          const SizedBox(height: 10),

          // 🔥 TOTAL + BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 💰 FIX USD
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailScreen(orderId: id),
                    ),
                  );
                },
                child: const Text("View Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
