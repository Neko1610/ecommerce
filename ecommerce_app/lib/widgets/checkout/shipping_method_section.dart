import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShippingMethodSection extends StatefulWidget {
  final Function(double) onChanged;

  const ShippingMethodSection({super.key, required this.onChanged});

  @override
  State<ShippingMethodSection> createState() => _ShippingMethodSectionState();
}

class _ShippingMethodSectionState extends State<ShippingMethodSection> {
  String selected = "standard";

  final usd = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  Widget item(String value, String title, String sub, double price) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () {
        setState(() => selected = value);
        widget.onChanged(price);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xff137fec) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Color(0xffe8f1ff) : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              usd.format(price), // 🔥 FIX
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.local_shipping, color: Color(0xff137fec)),
            SizedBox(width: 6),
            Text(
              "Shipping Method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),

        item("standard", "Standard", "3-5 days", 2),
        item("express", "Express", "1 day", 10),
      ],
    );
  }
}
