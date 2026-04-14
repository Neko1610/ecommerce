import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../screens/map_picker_screen.dart';

class AddressMapPreview extends StatefulWidget {
  final Function(double, double, String) onSelected;
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const AddressMapPreview({
    super.key,
    required this.onSelected,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  @override
  State<AddressMapPreview> createState() => _AddressMapPreviewState();
}

class _AddressMapPreviewState extends State<AddressMapPreview> {
  double lat = 0;
  double lng = 0;
  String address = "";
  @override
  void initState() {
    super.initState();

    if (widget.initialLat != null && widget.initialLng != null) {
      lat = widget.initialLat!;
      lng = widget.initialLng!;
      address = widget.initialAddress ?? "";
    }
  }

  void openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialLat: lat == 0 ? null : lat,
          initialLng: lng == 0 ? null : lng,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        lat = result['lat'];
        lng = result['lng'];
        address = result['address'];
      });

      widget.onSelected(lat, lng, address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Map Location",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: openMap,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: lat == 0
                ? const Center(child: Text("Chọn vị trí trên bản đồ"))
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(lat, lng),
                            initialZoom: 15,
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
                                  point: LatLng(lat, lng),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// 🔥 overlay địa chỉ
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
