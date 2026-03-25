import 'package:flutter/material.dart';

class ProfileOrderStatus extends StatelessWidget {
  const ProfileOrderStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(Icons.payment, "To Pay"),
            _item(Icons.local_shipping, "To Ship"),
            _item(Icons.inventory, "Receive", badge: "2"),
            _item(Icons.star, "Rate"),
          ],
        ),
      ],
    );
  }

  Widget _item(IconData icon, String text, {String? badge}) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade200,
              child: Icon(icon),
            ),
            if (badge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
