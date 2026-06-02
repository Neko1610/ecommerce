import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/CartProvider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final totalItems = context.watch<CartProvider>().totalItems;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🛍 LOGO
          Row(
            children: [
              Image.asset(
                "assets/logo/vexo_logo1.png",
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),

              const SizedBox(width: 10),

              const Text(
                "VEXO",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff137fec),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
