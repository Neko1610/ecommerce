import 'package:flutter/material.dart';

class PaymentCardPreview extends StatelessWidget {
  final String cardNumber;
  final String holderName;
  final String expiry;

  const PaymentCardPreview({
    super.key,
    required this.cardNumber,
    required this.holderName,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff137fec),
            Color(0xff1d4ed8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.contactless,
                color: Colors.white,
                size: 38,
              ),
              Row(
                children: [
                  _box(0.2),
                  const SizedBox(width: 8),
                  _box(0.4),
                ],
              ),
            ],
          ),

          const Spacer(),

          Text(
            cardNumber.isEmpty
                ? '•••• •••• •••• ••••'
                : cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color:
                          Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    holderName.isEmpty
                        ? 'YOUR NAME'
                        : holderName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color:
                          Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    expiry.isEmpty
                        ? 'MM/YY'
                        : expiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _box(double opacity) {
    return Container(
      width: 40,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}