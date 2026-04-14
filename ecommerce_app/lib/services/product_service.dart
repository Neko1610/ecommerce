import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<List<Product>> getProducts({int? categoryId, String? keyword}) async {
    final headers = await _getHeaders();

    String url = "$baseUrl/products";

    List<String> query = [];

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
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  }

  Future<Product> getProductById(int id) async {
    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/products/$id"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load product");
    }
  }
}
