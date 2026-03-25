import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.devices, "name": "Electronics"},
      {"icon": Icons.checkroom, "name": "Fashion"},
      {"icon": Icons.chair, "name": "Home"},
      {"icon": Icons.face, "name": "Beauty"},
    ];

    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(categories[index]["icon"] as IconData),
              ),
              SizedBox(height: 6),
              Text(
                categories[index]["name"].toString(),
                style: TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );
  }
}
