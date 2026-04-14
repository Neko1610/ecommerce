import 'package:flutter/material.dart';

class WishlistEmpty extends StatelessWidget {
  const WishlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("No favorites yet"),
        ],
      ),
    );
  }
}