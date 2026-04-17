import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class ProductService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token")?.trim();

    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty && token != "null")
        "Authorization":
            "Bearer ${token.startsWith("Bearer ") ? token.substring(7).trim() : token}",
    };
  }

  Future<List<Product>> getProducts({int? categoryId, String? keyword}) async {
    try {
      final headers = await _getHeaders();

      String url = "$baseUrl/products";
      final query = <String>[];

      if (categoryId != null) {
        query.add("categoryId=$categoryId");
      }

      if (keyword != null && keyword.isNotEmpty) {
        query.add("keyword=$keyword");
      }

      if (query.isNotEmpty) {
        url += "?${query.join("&")}";
      }

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Product.fromJson(e)).toList();
      }

      throw Exception("Failed to load products: ${response.statusCode}");
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse("$baseUrl/products/$id"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }

      throw Exception("Failed to load product");
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
