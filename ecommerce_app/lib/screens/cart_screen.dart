import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../widgets/cart/cart_bottom_bar.dart';
import '../widgets/cart/cart_header.dart';
import '../widgets/cart/cart_item_widget.dart';
import '../widgets/cart/cart_summary.dart';
import '../widgets/cart/voucher_input.dart';
import 'checkout_screens.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _service = CartService();

  double discountPercent = 0;
  String appliedCode = "";

  List<CartItem> items = [];
  bool isLoading = true;

  double getSubtotal() {
    return items.fold(0, (sum, e) => sum + e.price * e.quantity);
  }

  double getTotal() {
    final subtotal = getSubtotal();
    final discount = subtotal * discountPercent / 100;
    return subtotal - discount;
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final data = await _service.getCart();
      if (!mounted) return;

      setState(() {
        items = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void applyVoucher(String code) async {
    try {
      final subtotal = getSubtotal();
      final res = await _service.applyVoucher(code, subtotal);
      if (!mounted) return;

      setState(() {
        discountPercent = (res['discountPercent'] ?? 0).toDouble();
        appliedCode = code;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Applied $code")));
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Voucher error")));
    }
  }

  Future<void> updateQty(CartItem item, int newQty) async {
    try {
      await _service.updateQuantity(item.id, newQty);
      if (!mounted) return;

      setState(() {
        final index = items.indexOf(item);
        items[index] = item.copyWith(quantity: newQty);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteItem(CartItem item) async {
    try {
      await _service.deleteItem(item.id);
      if (!mounted) return;

      setState(() {
        items.removeWhere((i) => i.id == item.id);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),
      bottomNavigationBar: CartBottomBar(
        total: getTotal(),
        onCheckout: items.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutScreen(
                      cart: items,
                      totalPrice: getTotal(),
                      voucherCode: appliedCode,
                    ),
                  ),
                ).then((_) => loadCart());
              },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              CartHeader(),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("Cart is empty"))
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ...items.map(
                            (e) => CartItemWidget(
                              item: e,
                              onUpdate: (newQty) => updateQty(e, newQty),
                              onDelete: () => deleteItem(e),
                            ),
                          ),
                          const SizedBox(height: 20),
                          VoucherInput(onApply: applyVoucher),
                          const SizedBox(height: 20),
                          CartSummary(
                            items: items,
                            discountPercent: discountPercent,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
