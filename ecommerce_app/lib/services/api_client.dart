import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(String url) async {
    final headers = await _headers();
    return http.get(Uri.parse(url), headers: headers);
  }

  static Future<http.Response> post(String url, dynamic body) async {
    final headers = await _headers();
    return http.post(Uri.parse(url), headers: headers, body: body);
  }
}
