import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapView extends StatefulWidget {
  final Function(LatLng, String) onLocationChanged;
  final Function() onLoading;

  const MapView({
    super.key,
    required this.onLocationChanged,
    required this.onLoading,
  });

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final mapController = MapController();
  Timer? debounce;

  LatLng? center;

  Future<void> getAddress(LatLng latLng) async {
    widget.onLoading();

    final url =
        "https://nominatim.openstreetmap.org/reverse"
        "?format=json"
        "&lat=${latLng.latitude}"
        "&lon=${latLng.longitude}";

    final res = await http.get(
      Uri.parse(url),
      headers: {"User-Agent": "ecommerce-app"},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final addr = data['address'];

      final ward =
          addr['quarter'] ?? addr['suburb'] ?? addr['neighbourhood'] ?? "";

      final district =
          addr['city_district'] ??
          addr['district'] ??
          addr['county'] ??
          addr['town'] ??
          "";

      final city =
          addr['city'] ??
          addr['state'] ??
          addr['province'] ??
          addr['region'] ??
          "";

      widget.onLocationChanged(latLng, buildAddress(ward, district, city));
    }
  }

  String buildAddress(String ward, String district, String city) {
    final parts = [ward, district, city].where((e) => e.isNotEmpty).toList();

    return parts.join(", ");
  }

  void moveToLocation(LatLng latLng) {
    mapController.move(latLng, 16);
    getAddress(latLng);

    setState(() => center = latLng);
  }

  void onMapMove(LatLng latLng) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      getAddress(latLng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(10.76, 106.66),
        initialZoom: 13,
        onPositionChanged: (pos, hasGesture) {
          if (hasGesture && pos.center != null) {
            center = pos.center;
            onMapMove(center!);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
          subdomains: ['a', 'b', 'c', 'd'],
        ),
        if (center != null)
          MarkerLayer(
            markers: [
              Marker(
                point: center!,
                child: const Icon(Icons.location_on, color: Colors.red),
              ),
            ],
          ),
      ],
    );
  }
}
