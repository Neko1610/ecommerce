import 'package:flutter/material.dart';

class EmptyPaymentState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyPaymentState({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(28),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xff137fec,
                ).withValues(alpha: 0.1),
              ),

              child: const Icon(
                Icons.credit_card_off,
                size: 42,
                color: Color(0xff137fec),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No payment methods',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Add a wallet or card for faster checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Payment Method',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}