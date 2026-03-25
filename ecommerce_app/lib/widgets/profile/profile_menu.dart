import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _item(Icons.favorite, "My Wishlist"),
        _item(Icons.location_on, "Shipping Address"),
        _item(Icons.credit_card, "Payment Methods"),
        _item(Icons.shield, "Privacy Settings"),
        _item(Icons.help, "Help Center"),
      ],
    );
  }

  Widget _item(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
