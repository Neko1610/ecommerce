import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

class UserService {
  final String baseUrl = "http://10.0.2.2:8080/api/user";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

 Future<Profile> getProfile() async {
  final token = await getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/profile"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  if (res.statusCode != 200) {
    throw Exception("API error: ${res.statusCode}");
  }

  if (res.body.isEmpty) {
    throw Exception("Empty response from server");
  }

  final data = jsonDecode(res.body);
  return Profile.fromJson(data);
}
  Future<void> updateProfile(String fullName, String phone) async {
    final token = await getToken();

    await http.put(
      Uri.parse("$baseUrl/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "fullName": fullName,
        "phone": phone,
      }),
    );
  }
}