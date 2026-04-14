import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class MapSearchBox extends StatefulWidget {
  final Function(double, double) onSelected;

  const MapSearchBox({super.key, required this.onSelected});

  @override
  State<MapSearchBox> createState() => _MapSearchBoxState();
}

class _MapSearchBoxState extends State<MapSearchBox> {
  List results = [];
  Timer? debounce;

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => results = []);
      return;
    }

    final url =
        "https://nominatim.openstreetmap.org/search"
        "?q=${Uri.encodeComponent("$keyword, Vietnam")}"
        "&format=json&limit=5";

    final res = await http.get(
      Uri.parse(url),
      headers: {"User-Agent": "ecommerce-app"},
    );

    if (res.statusCode == 200) {
      setState(() => results = jsonDecode(res.body));
    }
  }

  void onSearchChanged(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: "Tìm địa chỉ...",
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          if (results.isNotEmpty)
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (_, i) {
                  final item = results[i];

                  return ListTile(
                    title: Text(item['display_name']),
                    onTap: () {
                      final lat = double.parse(item['lat']);
                      final lng = double.parse(item['lon']);

                      widget.onSelected(lat, lng);

                      setState(() => results = []);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}