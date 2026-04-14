import 'dart:convert';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  final String baseUrl = "http://10.0.2.2:8080/api/cart";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<List<CartItem>> getCart() async {
    final token = await getToken();

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(res.body);

    return (data as List).map((e) => CartItem.fromJson(e)).toList();
  }
  

  Future<void> updateQuantity(int id, int qty) async {
    final token = await getToken();

    await http.put(
      Uri.parse("$baseUrl/$id?qty=$qty"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<void> deleteItem(int id) async {
    final token = await getToken();

    await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }


  Future<void> clearCart() async {
    final token = await getToken();

    await http.delete(
      Uri.parse("$baseUrl/clear"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

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

  Future<void> addToCart({
    required int variantId,
    required int quantity,
  }) async {
    final token = await getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/add"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"variantId": variantId, "quantity": quantity}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Add to cart failed: ${res.body}");
    }
  }
  
}
