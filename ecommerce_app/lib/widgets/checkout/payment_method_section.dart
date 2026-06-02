import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/payment_method_model.dart';
import '../../providers/PaymentProvider.dart';
import '../../screens/payment_methods_screen.dart';

class PaymentMethodSection extends StatelessWidget {
  final Function(String) onChanged;

  const PaymentMethodSection({super.key, required this.onChanged});

  Widget item({
    required BuildContext context,
    required String value,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(12),

        margin: const EdgeInsets.only(bottom: 10),

        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xff137fec) : Colors.grey.shade300,
          ),

          borderRadius: BorderRadius.circular(12),

          color: isSelected ? const Color(0xffe8f1ff) : Colors.white,
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
    final paymentProvider = context.watch<PaymentProvider>();

    final selected = paymentProvider.selectedMethod;

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

        /// CARD
        item(
          context: context,

          value: "CARD",

          icon: Icons.credit_card,

          title: selected?.type == PaymentType.creditCard
              ? selected!.subtitle
              : "Credit Card",

          isSelected: selected?.type == PaymentType.creditCard,

          onTap: () async {
            await Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
            );

            if (!context.mounted) return;

            final updated = context.read<PaymentProvider>().selectedMethod;

            if (updated?.type == PaymentType.creditCard) {
              onChanged("CARD");
            }
          },
        ),

        /// WALLET
        item(
          context: context,

          value: "WALLET",

          icon: Icons.account_balance_wallet,

          title:
              selected?.type == PaymentType.momo ||
                  selected?.type == PaymentType.zaloPay
              ? selected!.title
              : "E-Wallet",

          isSelected:
              selected?.type == PaymentType.momo ||
              selected?.type == PaymentType.zaloPay,

          onTap: () async {
            await Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
            );

            if (!context.mounted) return;

            final updated = context.read<PaymentProvider>().selectedMethod;

            if (updated?.type == PaymentType.momo ||
                updated?.type == PaymentType.zaloPay) {
              onChanged("WALLET");
            }
          },
        ),

        /// COD
        item(
          context: context,

          value: "COD",

          icon: Icons.money,

          title: "Cash on Delivery",

          isSelected: selected == null,

          onTap: () {
            paymentProvider.clearSelectedMethod();

            onChanged("COD");
          },
        ),
      ],
    );
  }
}
