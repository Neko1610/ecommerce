import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'checkout_screens.dart';
import '../widgets/cart/cart_item_widget.dart';
import '../widgets/cart/cart_header.dart';
import '../widgets/cart/cart_summary.dart';
import '../widgets/cart/voucher_input.dart';
import '../widgets/cart/cart_bottom_bar.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _service = CartService();
  double discountPercent = 0;
  String appliedCode = "";
  List items = [];
  bool isLoading = true;
  double getSubtotal() {
    double total = 0;

    for (var item in items) {
      total += item['variant']['price'] * item['quantity'];
    }

    return total;
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
    final data = await _service.getCart();

    setState(() {
      items = data;
      isLoading = false;
    });
  }

  void applyVoucher(String code) async {
    try {
      final subtotal = getSubtotal();

      final res = await CartService().applyVoucher(code, subtotal);

      setState(() {
        discountPercent = res['discountPercent'];
        appliedCode = code;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Applied $code")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xfff6f7f8),
      bottomNavigationBar: CartBottomBar(
        total: getTotal(),
        onCheckout: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(
                cart: items,
                totalPrice: getTotal(),
                voucherCode: appliedCode,
              ),
            ),
          ).then((_) {
            setState(() {});
          });
        },
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              CartHeader(),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    ...items.map(
                      (e) => CartItemWidget(
                        item: e,

                        // 🔥 update local quantity
                        onUpdate: (newQty) {
                          setState(() {
                            e['quantity'] = newQty;
                          });
                        },

                        // ❌ delete local
                        onDelete: () {
                          setState(() {
                            items.remove(e);
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    VoucherInput(onApply: applyVoucher),
                    SizedBox(height: 20),
                    CartSummary(items: items, discountPercent: discountPercent),
                    SizedBox(height: 100),
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
