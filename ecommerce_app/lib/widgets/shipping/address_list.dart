import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/add_address_screen.dart';
import '../../widgets/shipping/adress_card.dart';
import "../../screens/map_picker_screen.dart";

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => AddressListState();
}

class AddressListState extends State<AddressList> {
  List addresses = [];
  bool isLoading = true;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<void> loadAddress() async {
    final res = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/address"),
      headers: {"Authorization": "Bearer ${await getToken()}"},
    );

    final data = jsonDecode(res.body);

    setState(() {
      addresses = data;

      addresses.sort((a, b) {
        if (a['isDefault'] == true) return -1;
        if (b['isDefault'] == true) return 1;
        return 0;
      });

      isLoading = false;
    });
  }

  Future<void> deleteAddress(int id) async {
    final token = await getToken();

    await http.delete(
      Uri.parse("http://10.0.2.2:8080/api/address/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    loadAddress(); // 🔥 reload
  }

  Future<void> updateAddress(int id, Map data) async {
    final token = await getToken();

    await http.put(
      Uri.parse("http://10.0.2.2:8080/api/address/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    loadAddress(); // 🔥 reload
  }

  Future<void> setDefault(int id) async {
    final token = await getToken();

    await http.put(
      Uri.parse("http://10.0.2.2:8080/api/address/$id/default"),
      headers: {"Authorization": "Bearer $token"},
    );

    loadAddress();
  }

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (addresses.isEmpty) {
      return const Center(child: Text("No address"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final a = addresses[index];

        return AddressCard(
          address: a,

          onSetDefault: () {},

          onEdit: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddAddressScreen(
                  isEdit: true,
                  addressId: a['id'],
                  initialAddress: a['fullAddress'],
                  initialLat: a['latitude'],
                  initialLng: a['longitude'],
                  isDefault: a['default'],
                ),
              ),
            );

            if (result == true) {
              loadAddress(); // 🔥 chỉ reload thôi
            }
          },

          /// 🗑 DELETE
          onDelete: () async {
            await deleteAddress(a['id']);
          },
        );
      },
    );
  }
}
