import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_client.dart';

class OrderService {
  Future<void> checkout(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.post(
        "/order/checkout",
        requiresAuth: true,
        body: data,
      );

      if (res.statusCode != 200) {
        throw Exception(res.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<dynamic>> getOrders() async {
    try {
      final res = await ApiClient.get("/order", requiresAuth: true);

      if (res.statusCode != 200) {
        throw Exception("Failed to load orders: ${res.body}");
      }

      return jsonDecode(res.body) as List<dynamic>;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOrderDetail(int id) async {
    try {
      final res = await ApiClient.get("/order/$id", requiresAuth: true);

      if (res.statusCode != 200) {
        throw Exception("Order not found");
      }

      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
