import 'package:flutter/material.dart';

import 'payment_input_decoration.dart';

class BankSectionWidget extends StatelessWidget {
  final TextEditingController bankNameController;

  final TextEditingController bankAccountController;

  final TextEditingController bankHolderController;

  const BankSectionWidget({
    super.key,
    required this.bankNameController,
    required this.bankAccountController,
    required this.bankHolderController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _label('Tên ngân hàng'),

          TextFormField(
            controller: bankNameController,
            decoration: paymentInputDecoration(
              hint: 'VD: Vietcombank',
            ),
          ),

          const SizedBox(height: 18),

          _label('Số tài khoản'),

          TextFormField(
            controller: bankAccountController,
            keyboardType: TextInputType.number,
            decoration: paymentInputDecoration(
              hint: 'Nhập số tài khoản',
            ),
          ),

          const SizedBox(height: 18),

          _label('Tên chủ tài khoản'),

          TextFormField(
            controller: bankHolderController,
            decoration: paymentInputDecoration(
              hint: 'NGUYEN VAN A',
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}