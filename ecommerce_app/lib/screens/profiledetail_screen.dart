import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ProfileProvider.dart';
import '../../widgets/profiledetail/profile_header.dart';
import '../../widgets/profiledetail/profile_form.dart';
import '../../widgets/profiledetail/address_section.dart';
import '../../widgets/profiledetail/security_section.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    // 🔥 loading
    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 🔥 chưa có data
    if (provider.profile == null) {
      return const Scaffold(body: Center(child: Text("No profile data")));
    }

    final profile = provider.profile!;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),

            // 🔥 truyền profile xuống
            ProfileForm(profile: profile),

            const AddressSection(),
            const SecuritySection(),
          ],
        ),
      ),
    );
  }
}
