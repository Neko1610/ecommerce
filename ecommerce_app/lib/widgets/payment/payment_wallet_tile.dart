import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentWalletTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const PaymentWalletTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 14,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Icon(
              Icons
                  .account_balance_wallet_rounded,
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
                  style:
                      GoogleFonts.plusJakartaSans(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green
                      .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(
                    100,
                  ),
                ),
                child: Text(
                  'ĐÃ LIÊN KẾT',
                  style:
                      GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
