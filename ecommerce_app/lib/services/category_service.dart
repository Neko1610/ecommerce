import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  static const baseUrl = "http://10.0.2.2:8080/api";

  static Future<List<Category>> getCategories() async {
    final res = await http.get(Uri.parse("$baseUrl/categories"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      return data
          .map<Category>((e) => Category.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}