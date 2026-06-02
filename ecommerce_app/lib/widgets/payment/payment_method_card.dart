import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodCard extends StatelessWidget {
  final bool isDark;
  final String number;
  final String expiry;

  const PaymentMethodCard({
    super.key,
    required this.isDark,
    required this.number,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xff0F172A), const Color(0xff1E293B)]
              : [const Color(0xff2563EB), const Color(0xff1E3A8A)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.contactless_rounded,
                  color: Colors.white,
                ),
              ),

              Container(
                width: 52,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            'SỐ THẺ',
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '•••• •••• •••• $number',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHỦ THẺ',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'NGUYEN VAN A',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'HẾT HẠN',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    expiry,
                    style: GoogleFonts.plusJakartaSans(
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
}
