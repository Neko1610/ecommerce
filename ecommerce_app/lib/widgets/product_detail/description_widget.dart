import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  final String text;

  const DescriptionWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(text, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
