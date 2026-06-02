import 'package:flutter/material.dart';

import '../../../models/payment_method_model.dart';
import 'payment_input_decoration.dart';

class WalletSectionWidget extends StatelessWidget {
  final PaymentType selectedWallet;

  final TextEditingController phoneController;

  final Function(PaymentType) onChanged;

  const WalletSectionWidget({
    super.key,
    required this.selectedWallet,
    required this.phoneController,
    required this.onChanged,
  });

  static const primaryColor = Color(0xff137fec);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _walletTile(
          title: 'Ví MoMo',
          subtitle: 'Liên kết tài khoản ví',
          color: Colors.pink,
          icon: Icons.account_balance_wallet,
          type: PaymentType.momo,
        ),

        const SizedBox(height: 16),

        _walletTile(
          title: 'ZaloPay',
          subtitle: 'Thanh toán nhanh',
          color: Colors.blue,
          icon: Icons.wallet,
          type: PaymentType.zaloPay,
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: paymentInputDecoration(
              hint: 'Nhập số điện thoại ví',
            ),
          ),
        ),
      ],
    );
  }

  Widget _walletTile({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required PaymentType type,
  }) {
    final selected = selectedWallet == type;

    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}