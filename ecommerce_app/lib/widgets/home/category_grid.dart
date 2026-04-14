import 'package:ecommerce_app/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/CategoryProvider.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, catProvider, _) {
        final categories = catProvider.categories;

        if (categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected =
                  catProvider.selectedCategoryId == cat.id;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CategoryScreen(category: cat),
    ),
  );
},
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue
                            : Colors.blue.shade50,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        _getIcon(cat.name),
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                        size: 22,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.blue
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case "electronics":
        return Icons.devices;
      case "fashion":
        return Icons.checkroom;
      case "home":
        return Icons.chair;
      case "beauty":
        return Icons.face;
      default:
        return Icons.category;
    }
  }
}