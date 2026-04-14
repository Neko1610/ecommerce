  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  import '../widgets/profile/profile_header.dart';
  import '../widgets/profile/profile_stats.dart';
  import '../widgets/profile/profile_order_status.dart';
  import '../widgets/profile/profile_menu.dart';
  import 'login_screen.dart'; // nhớ import

  class ProfileScreen extends StatelessWidget {
    const ProfileScreen({super.key});

    Future<void> _logout(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();

      // 🔥 xoá token
      await prefs.remove("token");

      // 🔥 về login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xfff6f7f8),

        appBar: AppBar(title: const Text("Profile"), centerTitle: true),

        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 🔥 TRUYỀN LOGOUT
            ProfileHeader(
              onLogout: () => _logout(context),
            ),

            const SizedBox(height: 20),
            const ProfileStats(),
            const SizedBox(height: 20),
            const ProfileOrderStatus(),
            const SizedBox(height: 20),
            const ProfileMenu(),
          ],
        ),
      );
    }
  }