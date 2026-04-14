  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import '../../models/profile.dart';
  import '../../providers/ProfileProvider.dart';

  class ProfileForm extends StatefulWidget {
    final Profile profile;

    const ProfileForm({super.key, required this.profile});

    @override
    State<ProfileForm> createState() => _ProfileFormState();
  }

 class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool isSaving = false; 

  @override
  void initState() {
    super.initState();

    fullNameController =
        TextEditingController(text: widget.profile.fullName);

    emailController =
        TextEditingController(text: widget.profile.email);

    phoneController =
        TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> handleSave() async {
    final name = fullNameController.text.trim();
    final phone = phoneController.text.trim();

    // 🔥 VALIDATE
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty")),
      );
      return;
    }

    if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid phone number")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await context.read<ProfileProvider>().updateProfile(name, phone);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed")),
      );
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: emailController,
              enabled: false,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : handleSave,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}