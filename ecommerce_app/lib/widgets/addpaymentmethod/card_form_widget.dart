import 'package:flutter/material.dart';

import 'payment_input_decoration.dart';

class CardFormWidget extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController holderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  final VoidCallback onChanged;

  const CardFormWidget({
    super.key,
    required this.cardNumberController,
    required this.holderController,
    required this.expiryController,
    required this.cvvController,
    required this.onChanged,
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
          _label('Số thẻ'),

          TextFormField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            onChanged: (_) => onChanged(),
            decoration: paymentInputDecoration(
              hint: '0000 0000 0000 0000',
              suffixIcon: const Icon(Icons.credit_card),
            ),
          ),

          const SizedBox(height: 18),

          _label('Tên chủ thẻ'),

          TextFormField(
            controller: holderController,
            onChanged: (_) => onChanged(),
            decoration: paymentInputDecoration(
              hint: 'NGUYEN VAN A',
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _label('Ngày hết hạn'),

                    TextFormField(
                      controller: expiryController,
                      onChanged: (_) => onChanged(),
                      decoration: paymentInputDecoration(
                        hint: 'MM/YY',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  children: [
                    _label('Mã CVV'),

                    TextFormField(
                      controller: cvvController,
                      obscureText: true,
                      keyboardType:
                          TextInputType.number,
                      decoration: paymentInputDecoration(
                        hint: '•••',
                      ),
                    ),
                  ],
                ),
              ),
            ],
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