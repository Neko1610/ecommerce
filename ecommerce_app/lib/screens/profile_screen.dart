import 'package:flutter/material.dart';

import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_order_status.dart';
import '../widgets/profile/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),

      appBar: AppBar(title: const Text("Profile"), centerTitle: true),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ProfileHeader(),
          SizedBox(height: 20),
          ProfileStats(),
          SizedBox(height: 20),
          ProfileOrderStatus(),
          SizedBox(height: 20),
          ProfileMenu(),
        ],
      ),
    );
  }
}
