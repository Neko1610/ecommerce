import 'package:flutter/material.dart';

class VoucherInput extends StatefulWidget {
  final Function(String) onApply;

  const VoucherInput({super.key, required this.onApply});

  @override
  State<VoucherInput> createState() => _VoucherInputState();
}

class _VoucherInputState extends State<VoucherInput> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Have a promo code?",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Enter code here",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(width: 8),

            GestureDetector(
              onTap: () {
                widget.onApply(controller.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Color(0xff137fec).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Apply",
                  style: TextStyle(
                    color: Color(0xff137fec),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
