import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/shipping_address_screen.dart'; // sửa path nếu khác

class AddressSection extends StatefulWidget {
  const AddressSection({super.key});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  Map<String, dynamic>? address;
  bool isLoading = true;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  Future<void> loadAddress() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:8080/api/address"),
        headers: {"Authorization": "Bearer ${await getToken()}"},
      );

      final data = jsonDecode(res.body);

      if (data.isEmpty) {
        setState(() {
          address = null;
          isLoading = false;
        });
        return;
      }

      final defaultAddress = data.firstWhere(
        (e) => e['default'] == true,
        orElse: () => data[0],
      );

      setState(() {
        address = defaultAddress;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    }

    if (address == null) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text("Chưa có địa chỉ"),
          trailing: TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShippingAddressScreen(),
                ),
              );
              setState(() => isLoading = true);
              loadAddress();
            },
            child: const Text("Thêm"),
          ),
        ),
      );
    }

  return Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
  
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 6),
      )
    ],
    border: Border.all(color: Colors.grey.shade300,
      width: 1.2,
    ),
  ),
  child: Row(
    children: [
      /// LEFT
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  "Địa chỉ mặc định",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// LABEL
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                (address!['label'] ?? "HOME")
                    .toString()
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// ADDRESS
            Text(
              address!['fullAddress'] ?? "",
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 6),

            /// DEFAULT TEXT
            const Text(
              "Mặc định",
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 12),

      /// MINI MAP (FREE)
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 85,
          height: 85,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                address!['latitude'],
                address!['longitude'],
              ),
              initialZoom: 11.5, // 🔥 đẹp nhất
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      address!['latitude'],
                      address!['longitude'],
                    ),
                    width: 30,
                    height: 30,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      const SizedBox(width: 10),

      /// EDIT BUTTON
      Column(
        children: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShippingAddressScreen(),
                ),
              );

              setState(() => isLoading = true);
              loadAddress();
            },
            icon: const Icon(Icons.edit, size: 20),
          ),
        ],
      ),
    ],
  ),
);
  }
}