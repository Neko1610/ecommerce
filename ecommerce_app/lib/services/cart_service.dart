import 'dart:convert';

import 'package:ecommerce_app/models/cart_item.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';

class CartService {
  Future<List<CartItem>> getCart() async {
    try {
      final res = await ApiClient.get("/cart", requiresAuth: true);
      if (res.statusCode != 200) {
        throw Exception("Failed to load cart: ${res.body}");
      }

      final data = jsonDecode(res.body);
      return (data as List).map((e) => CartItem.fromJson(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateQuantity(int cartItemId, int qty) async {
    try {
      final res = await ApiClient.put(
        "/cart/$cartItemId?qty=$qty",
        requiresAuth: true,
      );
      if (res.statusCode != 200) {
        throw Exception("Update cart failed: ${res.body}");
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteItem(int cartItemId) async {
    try {
      final res = await ApiClient.delete(
        "/cart/$cartItemId",
        requiresAuth: true,
      );
      if (res.statusCode != 200) {
        throw Exception("Delete cart item failed: ${res.body}");
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      final res = await ApiClient.delete("/cart/clear", requiresAuth: true);
      if (res.statusCode != 200) {
        throw Exception("Clear cart failed: ${res.body}");
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> applyVoucher(
    String code,
    double subtotal,
  ) async {
    try {
      final res = await ApiClient.post(
        "/vouchers/apply",
        body: {"code": code, "subtotal": subtotal},
      );

      if (res.statusCode != 200) {
        throw Exception(res.body);
      }

      return jsonDecode(res.body);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addToCart({
    required int variantId,
    required int quantity,
  }) async {
    try {
      final res = await ApiClient.post(
        "/cart/add",
        requiresAuth: true,
        body: {"variantId": variantId, "quantity": quantity},
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception("Add to cart failed: ${res.body}");
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
