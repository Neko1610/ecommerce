import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ProductProvider.dart';
import '../home/product_card.dart';

class ExploreProductGrid extends StatelessWidget {
  const ExploreProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final products = provider.products;

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (products.isEmpty) {
          return const Center(child: Text("No products"));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}