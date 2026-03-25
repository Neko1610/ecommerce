import 'package:flutter/material.dart';

class OrderFilterTabs extends StatelessWidget {
  const OrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _tab("All", true),
          _tab("Processing", false),
          _tab("Delivered", false),
          _tab("Cancelled", false),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(text),
        backgroundColor: active
            ? const Color(0xff137fec)
            : Colors.grey.shade200,
        labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
      ),
    );
  }
}
