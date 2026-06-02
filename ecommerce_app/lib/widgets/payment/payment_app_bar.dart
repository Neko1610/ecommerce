import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentAppBar extends StatelessWidget {
  const PaymentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          height: 72,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              0.75,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed:
                      () => Navigator.pop(
                        context,
                      ),
                  icon: const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  'Thanh toán',
                  style:
                      GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
