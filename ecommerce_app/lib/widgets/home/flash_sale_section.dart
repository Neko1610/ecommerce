import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/ProductProvider.dart';
import '../../screens/product_detail_screen.dart';
import '../../services/flash_sale_service.dart';

class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key});

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  final FlashSaleService _flashSaleService = FlashSaleService();
  bool isLoading = true;
  bool hasFlashSale = false;

  @override
  void initState() {
    super.initState();
    loadFlashSales();
  }

  Future<void> loadFlashSales() async {
    try {
      final sales = await _flashSaleService.getFlashSales();
      if (!mounted) return;

      setState(() {
        hasFlashSale = sales.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;

      setState(() {
        hasFlashSale = false;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final flashProducts = provider.products.where((product) {
          return product.variants.any((variant) => variant.flashSale);
        }).toList();

        if (isLoading && flashProducts.isEmpty) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff137fec),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        if (flashProducts.isEmpty && !hasFlashSale) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff137fec),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "FLASH SALE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: flashProducts.length,
                  itemBuilder: (_, i) {
                    final product = flashProducts[i];
                    final variant = product.variants.firstWhere(
                      (item) => item.flashSale,
                      orElse: () => product.variants.first,
                    );

                    return _FlashSaleCard(
                      product: product,
                      price: variant.price,
                      oldPrice: variant.oldPrice,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlashSaleCard extends StatelessWidget {
  final Product product;
  final double price;
  final double? oldPrice;

  const _FlashSaleCard({
    required this.product,
    required this.price,
    required this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "\$${price.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (oldPrice != null && oldPrice! > price)
              Text(
                "\$${oldPrice!.toStringAsFixed(0)}",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
