import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentNoteBox extends StatelessWidget {
  const PaymentNoteBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xffEBEDF7),
        borderRadius:
            BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xff137FEC),
              ),

              const SizedBox(width: 10),

              Text(
                'Lưu ý quan trọng',
                style:
                    GoogleFonts.plusJakartaSans(
                  fontWeight:
                      FontWeight.w800,
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          _buildNote(
            'Chúng tôi sẽ tự động trừ tiền từ phương thức mặc định.',
          ),

          _buildNote(
            'Hạn mức thanh toán tùy thuộc ngân hàng hoặc ví điện tử.',
          ),

          _buildNote(
            'Không chia sẻ mã OTP hoặc mã PIN cho bất kỳ ai.',
          ),
        ],
      ),
    );
  }

  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 4,
            ),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Colors.black54,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
