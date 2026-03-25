import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback onAddToCart;

  const BottomActionBar({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onAddToCart,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xff137fec), width: 2),
              ),
              child: Text("Add to Cart"),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff137fec),
              ),
              child: Text("Buy Now"),
            ),
          ),
        ],
      ),
    );
  }
}
