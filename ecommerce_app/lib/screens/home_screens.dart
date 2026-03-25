import 'package:flutter/material.dart';
import '../widgets/home/header_widget.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/banner_widget.dart';
import '../widgets/home/category_grid.dart';
import '../widgets/home/flash_sale_section.dart';
import '../widgets/home/product_card.dart';
import '../models/product.dart';
import '../services/product_service.dart';

import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 🔥 cache API
  late Future<List<Product>> productFuture;

  // 🔥 cache UI
  late Widget homeScreen;

  @override
  void initState() {
    super.initState();
    productFuture = ProductService().getProducts();
    homeScreen = _buildHome();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      homeScreen,
      homeScreen, // Explore tạm
      CartScreen(),
      homeScreen, // Wishlist tạm
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),
      body: screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xff137fec),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: "Shop"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // 🔥 HOME UI
  Widget _buildHome() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            SearchBarWidget(),
            BannerWidget(),
            CategoryGrid(),
            FlashSaleSection(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recommended",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  FutureBuilder<List<Product>>(
                    future: productFuture,
                    builder: (context, snapshot) {
                      // 🔄 loading
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // ❌ error
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Failed to load products"),
                        );
                      }

                      final products = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
