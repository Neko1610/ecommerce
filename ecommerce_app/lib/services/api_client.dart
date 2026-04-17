import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = "http://10.0.2.2:8080/api";

  static Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token")?.trim();
    if (token == null || token.isEmpty || token == "null") {
      return null;
    }
    return token.startsWith("Bearer ") ? token.substring(7).trim() : token;
  }

  static Future<Map<String, String>> _headers({
    bool requiresAuth = false,
    bool isJson = true,
  }) async {
    final token = await _token();
    final headers = <String, String>{};

    if (isJson) {
      headers["Content-Type"] = "application/json";
    }

    if (requiresAuth) {
      if (token == null) {
        throw Exception("Token is missing");
      }
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  static Uri uri(String path) {
    final normalized = path.startsWith("/") ? path : "/$path";
    return Uri.parse("$baseUrl$normalized");
  }

  static Future<http.Response> get(
    String path, {
    bool requiresAuth = false,
  }) async {
    final headers = await _headers(requiresAuth: requiresAuth);
    return http.get(uri(path), headers: headers);
  }

  static Future<http.Response> post(
    String path, {
    Object? body,
    bool requiresAuth = false,
  }) async {
    final headers = await _headers(requiresAuth: requiresAuth);
    return http.post(
      uri(path),
      headers: headers,
      body: body == null ? null : jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String path, {
    Object? body,
    bool requiresAuth = false,
  }) async {
    final headers = await _headers(requiresAuth: requiresAuth);
    return http.put(
      uri(path),
      headers: headers,
      body: body == null ? null : jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
    String path, {
    bool requiresAuth = false,
  }) async {
    final headers = await _headers(requiresAuth: requiresAuth);
    return http.delete(uri(path), headers: headers);
  }
}
