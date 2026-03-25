import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/variant.dart';
import '../services/product_service.dart';

import '../widgets/product_detail/image_slider.dart';
import '../widgets/product_detail/product_info.dart';
import '../widgets/product_detail/color_selector.dart';
import '../widgets/product_detail/size_selector.dart';
import '../widgets/product_detail/description_widget.dart';
import '../widgets/product_detail/bottom_action_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _service = ProductService();

  Product? product;
  bool isLoading = true;

  String selectedColor = "";
  String selectedSize = "";
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final data = await _service.getProductById(widget.productId);

      setState(() {
        product = data;
        selectedColor = data.colors.isNotEmpty ? data.colors.first : "";
        selectedSize = data.sizes.isNotEmpty ? data.sizes.first : "";
        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= VARIANT =================
  Variant? getSelectedVariant() {
    try {
      return product!.variants.firstWhere(
        (v) => v.color == selectedColor && v.size == selectedSize,
      );
    } catch (e) {
      return null;
    }
  }

  // ================= IMAGE SAFE =================
  String getCurrentImage() {
    final variant = getSelectedVariant();

    if (variant != null && variant.images.isNotEmpty) {
      return variant.images.first;
    }

    return "https://via.placeholder.com/300";
  }

  // ================= SIZE FILTER =================
  List<String> getAvailableSizes() {
    return product!.variants
        .where((v) => v.color == selectedColor)
        .map((v) => v.size)
        .toSet()
        .toList();
  }

  // ================= API ADD CART =================
  Future<void> addToCartApi(int variantId) async {
    final token = await getToken();

    final url = Uri.parse("http://10.0.2.2:8080/api/cart/add");

    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"variantId": variantId, "quantity": 1}),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to add cart");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      // 🔝 APP BAR
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // 📦 BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(image: getCurrentImage()),

            ProductInfo(product: product!, variant: getSelectedVariant()),

            // 🎨 COLOR
            if (product!.colors.isNotEmpty)
              ColorSelector(
                colors: product!.colors,
                selectedColor: selectedColor,
                onSelect: (c) {
                  setState(() {
                    selectedColor = c;

                    final sizes = getAvailableSizes();
                    if (!sizes.contains(selectedSize)) {
                      selectedSize = sizes.isNotEmpty ? sizes.first : "";
                    }
                  });
                },
              ),

            // 🔢 SIZE
            if (product!.sizes.isNotEmpty)
              SizeSelector(
                sizes: product!.sizes,
                availableSizes: getAvailableSizes(),
                selectedSize: selectedSize,
                onSelect: (s) => setState(() => selectedSize = s),
              ),

            DescriptionWidget(text: product!.description),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // 🛒 BOTTOM
      bottomNavigationBar: BottomActionBar(
        onAddToCart: () async {
          if (selectedColor.isEmpty || selectedSize.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select size & color")),
            );
            return;
          }

          final variant = getSelectedVariant();

          if (variant == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Variant not found")));
            return;
          }

          try {
            await addToCartApi(variant.id);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Added to cart"),
                action: SnackBarAction(
                  label: "View",
                  onPressed: () {
                    Navigator.pushNamed(context, "/cart");
                  },
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: $e")));
          }
        },
      ),
    );
  }
}
