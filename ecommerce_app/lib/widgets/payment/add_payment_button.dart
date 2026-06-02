
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPaymentButton extends StatelessWidget {
  const AddPaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 26,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.7,
        ),
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color: const Color(
            0xffDCE1EB,
          ),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xffDBEAFE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xff137FEC),
              size: 30,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Thêm phương thức mới',
            style:
                GoogleFonts.plusJakartaSans(
              fontWeight:
                  FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
