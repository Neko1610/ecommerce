import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ProductProvider.dart';
import '../providers/CategoryProvider.dart';

import '../widgets/explore/explore_search.dart';
import '../widgets/explore/explore_trending.dart';
import '../widgets/explore/explore_product_grid.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts();
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ExploreSearch(),
              ExploreTrending(),
              ExploreProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}