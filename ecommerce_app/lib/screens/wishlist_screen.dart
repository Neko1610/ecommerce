import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/WishlistProvider.dart';
import '../providers/ProductProvider.dart';
import '../widgets/wishlist/wishlist_header.dart';
import '../widgets/wishlist/wishlist_grid.dart';
import '../widgets/wishlist/wishlist_empty.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      appBar: AppBar(
        title: const Text("Wishlist"),
        elevation: 0,
      ),

      body: Consumer2<WishlistProvider, ProductProvider>(
        builder: (context, wishlist, productProvider, _) {

          final products = productProvider.products
              .where((p) => wishlist.isFavorite(p.id))
              .toList();

          return Column(
            children: [

              /// 🔥 HEADER
              WishlistHeader(count: products.length),

              /// 🔥 CONTENT
              Expanded(
                child: products.isEmpty
                    ? const WishlistEmpty()
                    : WishlistGrid(products: products),
              ),
            ],
          );
        },
      ),
    );
  }
}