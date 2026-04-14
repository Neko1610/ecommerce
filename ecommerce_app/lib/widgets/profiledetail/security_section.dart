import 'package:flutter/material.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security),
            title: Text("Two-Factor Authentication"),
            trailing: Switch(value: true, onChanged: null),
          ),
        ],
      ),
    );
  }
}