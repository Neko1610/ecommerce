import 'package:flutter/material.dart';
import '../services/order_service.dart';

import '../widgets/order_detail/order_header.dart';
import '../widgets/order_detail/order_timeline.dart';
import '../widgets/order_detail/order_address.dart';
import '../widgets/order_detail/order_items.dart';
import '../widgets/order_detail/order_summary.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final service = OrderService();

  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await service.getOrderDetail(widget.orderId);

      setState(() {
        data = res;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final order = data?['order'] ?? {};
    final items = data?['items'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),
      appBar: AppBar(title: const Text("Chi tiết đơn hàng"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            OrderHeader(order: order),
            const SizedBox(height: 12),

            OrderTimeline(order: order),
            const SizedBox(height: 12),

            OrderAddress(order: order),
            const SizedBox(height: 12),

            OrderItems(items: items),
            const SizedBox(height: 12),

            OrderSummary(order: order),
          ],
        ),
      ),
    );
  }
}
