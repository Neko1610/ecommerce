import 'package:flutter/material.dart';

class MapConfirmButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onConfirm;

  const MapConfirmButton({
    super.key,
    required this.isEnabled,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: ElevatedButton(
        onPressed: isEnabled ? onConfirm : null,
        child: const Text("Xác nhận"),
      ),
    );
  }
}