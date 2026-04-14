import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/address/address_map_review.dart';
import '../../widgets/address/address_switch.dart';

class AddressForm extends StatefulWidget {
  final bool isEdit;
  final int? addressId;
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;
  final bool isDefault;

  const AddressForm({
    super.key,
    this.isEdit = false,
    this.addressId,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
    this.isDefault = false,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();

  bool isDefault = false;
  bool isLoading = false;

  double lat = 0;
  double lng = 0;
  String mapAddress = "";

  @override
  void initState() {
    super.initState();

    /// 🔥 PREFILL EDIT
    if (widget.initialAddress != null) {
      mapAddress = widget.initialAddress!;
    }

    if (widget.initialLat != null && widget.initialLng != null) {
      lat = widget.initialLat!;
      lng = widget.initialLng!;
    }

    isDefault = widget.isDefault;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<void> save() async {
    if (mapAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn vị trí trên bản đồ")),
      );
      return;
    }

    final fullAddress = detailController.text.trim().isEmpty
        ? mapAddress
        : "${detailController.text.trim()}, $mapAddress";

    setState(() => isLoading = true);

    final token = await getToken();

    http.Response res;

    if (widget.isEdit) {
      /// 🔥 UPDATE
      res = await http.put(
        Uri.parse("http://10.0.2.2:8080/api/address/${widget.addressId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "fullAddress": fullAddress,
          "latitude": lat,
          "longitude": lng,
          "isDefault": isDefault,
        }),
      );
    } else {
      /// 🔥 CREATE
      res = await http.post(
        Uri.parse("http://10.0.2.2:8080/api/address"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "fullAddress": fullAddress,
          "latitude": lat,
          "longitude": lng,
          "isDefault": isDefault,
        }),
      );
    }

    setState(() => isLoading = false);

    if (res.statusCode == 200 || res.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// CONTACT
        const Text(
          "Contact Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// MAP PICKER
        AddressMapPreview(
          initialLat: widget.initialLat,
          initialLng: widget.initialLng,
          initialAddress: widget.initialAddress,
          onSelected: (la, ln, addr) {
            setState(() {
              lat = la;
              lng = ln;
              mapAddress = addr;
            });
          },
        ),

        const SizedBox(height: 16),

        /// ADDRESS SHOW
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(mapAddress.isEmpty ? "Chưa chọn vị trí" : mapAddress),
        ),

        const SizedBox(height: 16),

        /// DETAIL
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: detailController,
            decoration: const InputDecoration(
              hintText: "Số nhà, hẻm...",
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// DEFAULT
        AddressSwitchDefault(
          value: isDefault,
          onChanged: (v) => setState(() => isDefault = v),
        ),

        const SizedBox(height: 20),

        /// BUTTON
        ElevatedButton(
          onPressed: isLoading ? null : save,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(widget.isEdit ? "Update Address" : "Save Address"),
        ),
      ],
    );
  }
}
