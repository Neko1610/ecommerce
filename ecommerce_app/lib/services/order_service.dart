import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  final String baseUrl = "http://10.0.2.2:8080/api/order";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<void> checkout(Map<String, dynamic> data) async {
    final token = await getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/checkout"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  Future<List<dynamic>> getOrders() async {
    final token = await getToken();

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getOrderDetail(int id) async {
    final token = await getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Order not found");
    }

    return jsonDecode(res.body);
  }
}
