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
            children: const [
              Icon(Icons.shopping_bag, color: Color(0xff137fec), size: 28),
              SizedBox(width: 8),
              Text(
                "SwiftCart",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff137fec),
                ),
              ),
            ],
          ),

          // 🔔 + 🛒
          Row(
            children: [
              const Icon(Icons.notifications),

              const SizedBox(width: 12),

              // 🛒 CART ICON + BADGE
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/cart");
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart, size: 26),

                    // 🔴 BADGE
                    if (totalItems > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$totalItems",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
