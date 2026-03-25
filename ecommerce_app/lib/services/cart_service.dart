import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  final String baseUrl = "http://10.0.2.2:8080/api/cart";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  // 🛒 GET CART
  Future<List<dynamic>> getCart() async {
    final token = await getToken();

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  // 🔄 UPDATE QTY
  Future<void> updateQuantity(int id, int qty) async {
    final token = await getToken();

    await http.put(
      Uri.parse("$baseUrl/$id?qty=$qty"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // ❌ DELETE ITEM
  Future<void> deleteItem(int id) async {
    final token = await getToken();

    await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // 🧹 CLEAR CART
  Future<void> clearCart() async {
    final token = await getToken();

    await http.delete(
      Uri.parse("$baseUrl/clear"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // 🎟 APPLY VOUCHER
  Future<Map<String, dynamic>> applyVoucher(
    String code,
    double subtotal,
  ) async {
    final res = await http.post(
      Uri.parse("http://10.0.2.2:8080/api/voucher/apply"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code": code, "subtotal": subtotal}),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    return jsonDecode(res.body);
  }
}
