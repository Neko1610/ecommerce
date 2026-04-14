import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ProductProvider.dart';

class ExploreTrending extends StatelessWidget {
  const ExploreTrending({super.key});

  @override
  Widget build(BuildContext context) {
    final trends = [
      "iPhone 15",
      "Giày chạy bộ",
      "Tai nghe",
      "Laptop",
      "Sạc dự phòng",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 TITLE
          Row(
            children: const [
              Icon(Icons.trending_up, color: Colors.orange, size: 20),
              SizedBox(width: 6),
              Text(
                "Xu hướng tìm kiếm",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 CHIP LIST
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: trends.map((e) {
              return GestureDetector(
                onTap: () {
                  /// 👉 SEARCH
                  context.read<ProductProvider>().fetchProducts(
                    keyword: e,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}