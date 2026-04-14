import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/ProductProvider.dart';
import '../widgets/home/product_card.dart';

// widgets đã tách
import '../widgets/category/category_banner.dart';
import '../widgets/category/category_filtter.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int? selectedSubId;

  @override
  void initState() {
    super.initState();

    // 🔥 load ALL product của parent
    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts(
        categoryId: widget.category.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final subs = widget.category.children;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      appBar: AppBar(title: Text(widget.category.name), elevation: 0),

      body: Column(
        children: [
          // 🔥 BANNER (CHỈ CHA)
          CategoryBanner(imageUrl: _getBanner()),

          // 🔥 SUBCATEGORY FILTER
          SubCategoryFilter(
            subs: subs,
            selectedSubId: selectedSubId,
            onSelect: (id) {
              setState(() => selectedSubId = id);

              context.read<ProductProvider>().fetchProducts(
                categoryId: id ?? widget.category.id,
              );
            },
          ),

          // 🔥 PRODUCT LIST
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                final products = provider.products;

                // ⏳ loading
                if (products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            ),
          ),
        ],
      ),
    );
  }

  String _getBanner() {
    return widget.category.banner?.isNotEmpty == true
        ? widget.category.banner!
        : "https://picsum.photos/800/300";
  }
}
