import 'package:flutter/material.dart';

import '../../models/payment_method_model.dart';

class WalletTile extends StatelessWidget {
  final PaymentMethodModel payment;

  final bool isSelected;

  final VoidCallback onTap;

  const WalletTile({
    super.key,
    required this.payment,
    required this.isSelected,
    required this.onTap,
  });

  Color get walletColor {
    switch (payment.type) {
      case PaymentType.momo:
        return const Color(0xffA50064);

      case PaymentType.zaloPay:
        return const Color(0xff0068FF);

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: 1.5,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: walletColor.withValues(alpha: 0.1),

                borderRadius: BorderRadius.circular(16),
              ),

              alignment: Alignment.center,

              child: Text(
                payment.title.substring(0, 2),

                style: TextStyle(
                  color: walletColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    payment.title,

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    payment.subtitle,

                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
