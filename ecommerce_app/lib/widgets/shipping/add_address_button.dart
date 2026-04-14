import 'package:flutter/material.dart';
import '../../screens/add_address_screen.dart';

class AddAddressButton extends StatelessWidget {
  final VoidCallback onAdded;

  const AddAddressButton({super.key, required this.onAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddAddressScreen(),
          ),
        );

        if (result == true) {
          onAdded();
        }
      },
      child: const Icon(Icons.add),
    );
  }
}