import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../screens/order_list_screen.dart';

class ProfileStats extends StatefulWidget {
  const ProfileStats({super.key});

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  int orderCount = 0;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data = await OrderService().getOrders(); // 🔥 không userId

      setState(() {
        orderCount = data.length;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _item(
          context,
          value: orderCount.toString(), // 🔥 dynamic
          label: "Orders",
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderListScreen()),
            ).then((_) {
              loadOrders();
            });
          },
        ),
        _item(context, value: "04", label: "Vouchers", color: Colors.orange),
        _item(context, value: "850", label: "Points", color: Colors.black),
      ],
    );
  }

  Widget _item(
    BuildContext context, {
    required String value,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
