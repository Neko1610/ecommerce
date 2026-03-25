import 'package:flutter/material.dart';

import '../services/order_service.dart';
import '../widgets/order/order_card.dart';
import '../widgets/order/order_filter_tabs.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final OrderService _service = OrderService();

  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data = await _service.getOrders();

      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),
      appBar: AppBar(title: const Text("Order History"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : Column(
              children: [
                const OrderFilterTabs(),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (_, i) {
                      final o = orders[i];

                      return OrderCard(
                        id: o['id'],
                        status: o['status'] ?? "Pending",
                        total: (o['total'] as num?)?.toDouble() ?? 0,
                        images: o['images'] ?? [],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
