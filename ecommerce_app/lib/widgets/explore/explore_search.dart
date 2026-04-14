import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ProductProvider.dart';

class ExploreSearch extends StatefulWidget {
  const ExploreSearch({super.key});

  @override
  State<ExploreSearch> createState() => _ExploreSearchState();
}

class _ExploreSearchState extends State<ExploreSearch> {

  final controller = TextEditingController();
  Timer? _debounce;

  void onSearch(String value) {

    /// 🔥 debounce 300ms
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {

      context.read<ProductProvider>().fetchProducts(
        keyword: value,
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "Tìm sản phẩm...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}