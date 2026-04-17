import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_client.dart';

class FlashSaleService {
  Future<List<Map<String, dynamic>>> getFlashSales() async {
    try {
      final res = await ApiClient.get("/flash-sales");
      if (res.statusCode != 200) {
        throw Exception("Failed to load flash sales: ${res.body}");
      }

      final data = jsonDecode(res.body);
      if (data is List) {
        return data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      debugPrint(e.toString());
      return <Map<String, dynamic>>[];
    }
  }
}
