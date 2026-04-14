import 'package:flutter/material.dart';

class MapAddressCard extends StatelessWidget {
  final String address;
  final bool isLoading;

  const MapAddressCard({
    super.key,
    required this.address,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? const Text("Đang lấy địa chỉ...")
            : Text(address.isEmpty ? "Chọn vị trí" : address),
      ),
    );
  }
}