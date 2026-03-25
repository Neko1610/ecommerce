import 'package:flutter/material.dart';

class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff137fec),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FLASH SALE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, i) {
                return Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 10),
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
