import 'package:flutter/material.dart';

class WishlistHeader extends StatelessWidget {
  final int count;

  const WishlistHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Your Saved Items ($count)",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          TextButton(
            onPressed: () {},
            child: const Text("Share"),
          )
        ],
      ),
    );
  }
}