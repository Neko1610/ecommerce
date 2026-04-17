import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryService {
  static const baseUrl = "http://10.0.2.2:8080/api";

  static Future<List<Category>> getCategories() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/categories"));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => Category.fromJson(e)).toList();
      }

      throw Exception("Failed to load categories");
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
