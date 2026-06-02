import 'package:flutter/material.dart';

import '../../screens/add_payment_method_screen.dart';

class PaymentTabs extends StatelessWidget {
  final PaymentTab selectedTab;
  final Function(PaymentTab) onChanged;

  const PaymentTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  static const primaryColor = Color(0xff137fec);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _item('Thẻ', PaymentTab.card),
          _item('Ví điện tử', PaymentTab.wallet),
          _item('Ngân hàng', PaymentTab.bank),
        ],
      ),
    );
  }

  Widget _item(
    String title,
    PaymentTab tab,
  ) {
    final selected = selectedTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: selected
                ? primaryColor.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected
                    ? primaryColor
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}