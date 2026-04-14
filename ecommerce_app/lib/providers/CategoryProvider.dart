import '../services/category_service.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> categories = [];
  int? selectedCategoryId;

  Future<void> fetchCategories() async {
    categories = await CategoryService.getCategories();
    notifyListeners();
  }

  void selectCategory(int id) {
    selectedCategoryId = id;
    notifyListeners();
  }
}