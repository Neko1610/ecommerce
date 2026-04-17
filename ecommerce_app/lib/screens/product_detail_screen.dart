import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/variant.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../widgets/product_detail/bottom_action_bar.dart';
import '../widgets/product_detail/color_selector.dart';
import '../widgets/product_detail/description_widget.dart';
import '../widgets/product_detail/image_slider.dart';
import '../widgets/product_detail/product_info.dart';
import '../widgets/product_detail/size_selector.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _service = ProductService();
  final CartService _cartService = CartService();

  Product? product;
  bool isLoading = true;

  String selectedColor = "";
  String selectedSize = "";

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final data = await _service.getProductById(widget.productId);
      if (!mounted) return;

      setState(() {
        product = data;
        selectedColor = data.colors.isNotEmpty ? data.colors.first : "";
        selectedSize = data.sizes.isNotEmpty ? data.sizes.first : "";
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Variant? getSelectedVariant() {
    try {
      return product!.variants.firstWhere(
        (v) => v.color == selectedColor && v.size == selectedSize,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  String getCurrentImage() {
    final variant = getSelectedVariant();

    if (variant != null && variant.images.isNotEmpty) {
      return variant.images.first;
    }

    return "https://via.placeholder.com/300";
  }

  List<String> getAvailableSizes() {
    return product!.variants
        .where((v) => v.color == selectedColor)
        .map((v) => v.size)
        .toSet()
        .toList();
  }

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
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(image: getCurrentImage()),
            ProductInfo(product: product!, variant: getSelectedVariant()),
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
      bottomNavigationBar: BottomActionBar(
        onAddToCart: () async {
          final messenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);

          if (selectedColor.isEmpty || selectedSize.isEmpty) {
            messenger.showSnackBar(
              const SnackBar(content: Text("Please select size & color")),
            );
            return;
          }

          final variant = getSelectedVariant();
          if (variant == null) {
            messenger.showSnackBar(
              const SnackBar(content: Text("Variant not found")),
            );
            return;
          }

          try {
            await _cartService.addToCart(variantId: variant.id, quantity: 1);
            if (!mounted) return;

            messenger.showSnackBar(
              SnackBar(
                content: const Text("Added to cart"),
                action: SnackBarAction(
                  label: "View",
                  onPressed: () {
                    navigator.pushNamed("/cart");
                  },
                ),
              ),
            );
          } catch (e) {
            if (!mounted) return;
            messenger.showSnackBar(SnackBar(content: Text("Error: $e")));
          }
        },
      ),
    );
  }
}
