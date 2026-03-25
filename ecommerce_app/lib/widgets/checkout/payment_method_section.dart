import 'package:flutter/material.dart';

class PaymentMethodSection extends StatefulWidget {
  final Function(String) onChanged;

  const PaymentMethodSection({super.key, required this.onChanged});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  String selected = "COD";

  Widget item(String value, IconData icon, String title) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () {
        setState(() => selected = value);
        widget.onChanged(value);
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
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
            if (isSelected) const Icon(Icons.check, color: Color(0xff137fec)),
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
            Icon(Icons.payment, color: Color(0xff137fec)),
            SizedBox(width: 6),
            Text(
              "Payment Method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),

        item("CARD", Icons.credit_card, "Credit Card"),
        item("WALLET", Icons.account_balance_wallet, "E-Wallet"),
        item("COD", Icons.money, "Cash on Delivery"),
      ],
    );
  }
}
