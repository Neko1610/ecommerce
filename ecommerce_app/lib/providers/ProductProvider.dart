import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Product> products = [];
  bool isLoading = false;
  String? error;

Future<void> fetchProducts({
  int? categoryId,
  String? keyword,
}) async {
  try {
    isLoading = true;
    error = null;
    notifyListeners();

    products = await ProductService().getProducts(
      categoryId: categoryId,
      keyword: keyword,
    );
  } catch (e) {
    error = e.toString();
  }

  isLoading = false;
  notifyListeners();
}
}
