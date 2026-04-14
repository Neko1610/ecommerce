import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  // 🔥 WEB dùng localhost
  final String baseUrl = "http://10.0.2.2:8080/api";
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "454865683716-nlifbf708q6he4oihvgu7vc55k9254is.apps.googleusercontent.com",
  );

  Future<String?> signInWithGoogle() async {
    try {
      final gUser = await _googleSignIn.signIn();
      if (gUser == null) return null;

      final gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null) return null;

      return await _sendToBackend(idToken); // 🔥 FIX
    } catch (e) {
      print("Google login error: $e");
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      final idToken = await user.getIdToken();
      if (idToken == null) return null;

      return await _sendToBackend(idToken);
    } catch (e) {
      print("Email login error: $e");
      return null;
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      final idToken = await user.getIdToken();
      if (idToken == null) return null;

      return await _sendToBackend(idToken);
    } catch (e) {
      print("Signup error: $e");
      return null;
    }
  }

  Future<String?> _sendToBackend(String idToken) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/firebase"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": idToken}),
    );

    print("🔥 backend: ${res.body}");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body); // 🔥 PARSE JSON

      final jwt = data['token']; // 🔥 lấy đúng token

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", jwt);

      return jwt;
    }

    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
