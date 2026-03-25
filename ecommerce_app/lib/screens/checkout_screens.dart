import 'package:ecommerce_app/services/cart_service.dart';
import 'package:flutter/material.dart';

import '../widgets/checkout/address_section.dart';
import '../widgets/checkout/shipping_method_section.dart';
import '../widgets/checkout/payment_method_section.dart';
import '../widgets/checkout/order_summary_section.dart';
import '../widgets/checkout/checkout_bottom_bar.dart';
import '../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List cart;
  final double totalPrice;
  final String voucherCode;

  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.totalPrice,
    required this.voucherCode,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double shippingFee = 0;
  String paymentMethod = "COD";

  final orderService = OrderService();

  double get total => widget.totalPrice + shippingFee;

  // 🔥 map cart → backend
  List<Map<String, dynamic>> mapCart() {
    return widget.cart.map((e) {
      return {
        "variantId": e['variant']['id'], // 🔥 dùng id
        "quantity": e['quantity'],
      };
    }).toList();
  }

  // 🔥 checkout
  void handleCheckout() async {
    try {
      await orderService.checkout({
        "address": "HCM",
        "phone": "0123456789",
        "paymentMethod": paymentMethod,
        "voucherCode": widget.voucherCode,
        "shippingFee": shippingFee, // 🔥 PHẢI CÓ
        "items": mapCart(),
      });

      if (!mounted) return;

      // 🔥 clear backend
      await CartService().clearCart();

      // 🔥 clear local
      widget.cart.clear();

      // 👉 quay về cart
      Navigator.pop(context);
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Checkout lỗi ❌")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      appBar: AppBar(title: const Text("Checkout"), centerTitle: true),

      // 🔥 bottom bar
      bottomNavigationBar: CheckoutBottomBar(
        total: total,
        onCheckout: handleCheckout,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AddressSection(),

          const SizedBox(height: 12),

          ShippingMethodSection(
            onChanged: (fee) {
              setState(() {
                shippingFee = fee;
              });
            },
          ),

          const SizedBox(height: 12),

          PaymentMethodSection(
            onChanged: (method) {
              paymentMethod = method;
            },
          ),

          const SizedBox(height: 12),

          OrderSummarySection(
            subtotal: widget.totalPrice,
            shipping: shippingFee,
            total: total,
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
