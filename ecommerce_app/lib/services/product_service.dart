import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  // 🔥 GET TOKEN
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // ================= GET ALL =================
  Future<List<Product>> getProducts() async {
    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/products"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  }

  // ================= GET BY ID =================
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
