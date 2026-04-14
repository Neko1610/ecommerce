import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'checkout_screens.dart';
import '../widgets/cart/cart_item_widget.dart';
import '../widgets/cart/cart_header.dart';
import '../widgets/cart/cart_summary.dart';
import '../widgets/cart/voucher_input.dart';
import '../widgets/cart/cart_bottom_bar.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
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

      setState(() {
        items = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // 🔥 APPLY VOUCHER
  void applyVoucher(String code) async {
    try {
      final subtotal = getSubtotal();
      final res = await _service.applyVoucher(code, subtotal);

      setState(() {
        discountPercent = res['discountPercent'];
        appliedCode = code;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Applied $code")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Voucher lỗi")));
    }
  }

  // 🔥 UPDATE QUANTITY
  Future<void> updateQty(CartItem item, int newQty) async {
    try {
      await _service.updateQuantity(item.variantId, newQty);

      setState(() {
        final index = items.indexOf(item);
        items[index] = item.copyWith(quantity: newQty);
      });
    } catch (e) {
      print(e);
    }
  }

  // 🔥 DELETE ITEM
Future<void> deleteItem(CartItem item) async {
  try {
    await _service.deleteItem(item.id);

    setState(() {
      items.removeWhere((i) => i.id == item.id);
    });
  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      bottomNavigationBar: CartBottomBar(
        total: getTotal(),

        // 🔥 CHECKOUT
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
                    ? const Center(child: Text("Giỏ hàng trống 🛒"))
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ...items.map((e) => CartItemWidget(
                                item: e,
                                onUpdate: (newQty) =>
                                    updateQty(e, newQty),
                                onDelete: () => deleteItem(e),
                              )),

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