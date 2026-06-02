import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/momo_response.dart';

class MomoService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/momo';

  static Future<MomoResponse> createPayment(int amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return MomoResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Create payment failed');
  }
}
