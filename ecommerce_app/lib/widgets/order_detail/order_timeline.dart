import 'package:flutter/material.dart';

class OrderTimeline extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? "";

    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lộ trình vận chuyển",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _buildStep("Đã đặt hàng", true),
          _buildStep("Đã xác nhận", true),
          _buildStep(
            "Đang xử lý",
            _isProcessing(status),
            isCurrent: status == "PROCESSING",
          ),
          _buildStep(
            "Đang giao hàng",
            status == "SHIPPING",
            isCurrent: status == "SHIPPING",
          ),
          _buildStep("Đã nhận hàng", status == "DELIVERED"),
        ],
      ),
    );
  }

  bool _isProcessing(String status) {
    return status == "PROCESSING" ||
        status == "SHIPPING" ||
        status == "DELIVERED";
  }

  Widget _buildStep(String title, bool done, {bool isCurrent = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LINE + DOT
        Column(
          children: [
            Container(width: 2, height: 10, color: Colors.grey.shade300),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? Colors.blue : Colors.grey.shade300,
              ),
              child: done
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            Container(width: 2, height: 40, color: Colors.grey.shade300),
          ],
        ),

        const SizedBox(width: 10),

        /// TEXT / BOX
        Expanded(
          child: isCurrent
              ? Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    title,
                    style: TextStyle(color: done ? Colors.black : Colors.grey),
                  ),
                ),
        ),
      ],
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
