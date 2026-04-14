import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/add_address_screen.dart';

class AddressSection extends StatefulWidget {
  final Function(int) onSelect;

  const AddressSection({super.key, required this.onSelect});

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

    /// 🔥 lấy default
    final defaultAddress = data.firstWhere(
      (e) => e['default'] == true,
      orElse: () => data[0],
    );

    setState(() {
      address = defaultAddress;
      isLoading = false;
    });

    widget.onSelect(defaultAddress['id']);
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

    /// ❌ chưa có address
    if (address == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Text("Bạn chưa có địa chỉ"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAddressScreen()),
                );

                if (result == true) {
                  setState(() => isLoading = true);
                  loadAddress();
                }
              },
              child: const Text("Thêm địa chỉ"),
            ),
          ],
        ),
      );
    }

    /// ✅ UI chính giống Tailwind
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  "Shipping Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAddressScreen()),
                );

                if (result == true) {
                  setState(() => isLoading = true);
                  loadAddress();
                }
              },
              child: const Text("Change"),
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// CARD
        GestureDetector(
          onTap: () {
            widget.onSelect(address!['id']);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Row(
              children: [
                /// LEFT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LABEL
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.15),
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
                          const SizedBox(width: 6),
                          const Text(
                            "Address",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// ADDRESS
                      Text(
                        address!['fullAddress'] ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),

                      const SizedBox(height: 4),

                      /// DEFAULT TEXT
                      const Text(
                        "Mặc định",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// MINI MAP (FREE)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          address!['latitude'],
                          address!['longitude'],
                        ),
                        initialZoom: 11.5,
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
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// CHECK ICON
                const Icon(Icons.check, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
