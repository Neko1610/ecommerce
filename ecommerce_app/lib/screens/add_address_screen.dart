import 'package:flutter/material.dart';
import '../widgets/address/address_form.dart';

class AddAddressScreen extends StatelessWidget {
  final bool isEdit;
  final int? addressId;
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;
  final bool isDefault;

  const AddAddressScreen({
    super.key,
    this.isEdit = false,
    this.addressId,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f8),
      appBar: AppBar(
        title: Text(isEdit ? "Edit Address" : "Add Address"),
        centerTitle: true,
      ),
      body: AddressForm(
        isEdit: isEdit,
        addressId: addressId,
        initialAddress: initialAddress,
        initialLat: initialLat,
        initialLng: initialLng,
        isDefault: isDefault,
      ),
    );
  }
}