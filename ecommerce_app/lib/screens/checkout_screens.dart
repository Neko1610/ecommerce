import 'dart:convert';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/checkout/address_section.dart';
import '../widgets/checkout/shipping_method_section.dart';
import '../widgets/checkout/payment_method_section.dart';
import '../widgets/checkout/order_summary_section.dart';
import '../widgets/checkout/checkout_bottom_bar.dart';
import '../services/order_service.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cart;
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
  double baseShipping = 0;

  int? selectedAddressId;
  String paymentMethod = "COD";

  final orderService = OrderService();

  double get total => widget.totalPrice + shippingFee;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<void> calculateShipping(int addressId) async {
    if (selectedAddressId == addressId) return;

    final token = await getToken();

    final res = await http.post(
      Uri.parse("http://10.0.2.2:8080/api/shipping/calculate/$addressId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.body.isEmpty) return;

    final data = jsonDecode(res.body);

    if (!mounted) return;

    final fee = data['fee'];
    double vnd = fee is num ? fee.toDouble() : 0;

    /// 🔥 delay để tránh setState during build
    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      setState(() {
        selectedAddressId = addressId;
        baseShipping = vnd / 24000; // USD
        shippingFee = baseShipping;
      });
    });
  }

  List<Map<String, dynamic>> mapCart() {
    return widget.cart.map((e) {
      return {"variantId": e.variantId, "quantity": e.quantity};
    }).toList();
  }

  void handleCheckout() async {
    if (selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn địa chỉ")),
      );
      return;
    }

    try {
      await orderService.checkout({
        "addressId": selectedAddressId,
        "phone": "0123456789",
        "paymentMethod": paymentMethod,
        "voucherCode": widget.voucherCode,
        "items": mapCart(),
      });

      if (!mounted) return;

      await CartService().clearCart();
      widget.cart.clear();

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đặt hàng thành công ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Checkout lỗi ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),

      bottomNavigationBar: CheckoutBottomBar(
        total: total,
        onCheckout: selectedAddressId == null ? null : handleCheckout,
      ),

      /// 🔥 KHÔNG dùng ListView
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddressSection(
              onSelect: calculateShipping,
            ),

            const SizedBox(height: 12),

            ShippingMethodSection(
              baseFee: baseShipping,
              onChanged: (fee) {
                /// 🔥 delay tránh crash
                Future.delayed(Duration.zero, () {
                  if (!mounted) return;

                  setState(() {
                    shippingFee = fee;
                  });
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
      ),
    );
  }
}