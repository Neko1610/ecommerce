import 'package:flutter/material.dart';
import '../../screens/profiledetail_screen.dart';
import '../../screens/shipping_address_screen.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _item(Icons.account_circle, "Profile Setting", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileDetailScreen()),
          );
        }),

        _item(Icons.location_on, "Shipping Address", () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> const ShippingAddressScreen()),
          );
        }),

        _item(Icons.credit_card, "Payment Methods", () {}),

        _item(Icons.shield, "Privacy Settings", () {}),

        _item(Icons.help, "Help Center", () {}),
      ],
    );
  }

  Widget _item(IconData icon, String text, VoidCallback onTap) {
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
        onTap: onTap, // 🔥 dùng callback
      ),
    );
  }
}
