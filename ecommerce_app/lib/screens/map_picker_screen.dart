import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/map/map_view.dart';
import '../../widgets/map/map_search_box.dart';
import '../../widgets/map/map_address_card.dart';
import '../../widgets/map/map_confirm_button.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.initialLat != null && widget.initialLng != null) {
      selectedLocation = LatLng(widget.initialLat!, widget.initialLng!);

      /// 🔥 delay để map load xong rồi move
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapKey.currentState?.moveToLocation(selectedLocation!);
      });
    }
  }

  final GlobalKey<MapViewState> mapKey = GlobalKey();

  LatLng? selectedLocation;
  String address = "";
  bool isLoading = false;

  /// 🔥 khi chọn search
  void onSearchSelected(double lat, double lng) {
    final latLng = LatLng(lat, lng);

    setState(() {
      selectedLocation = latLng;
      isLoading = true;
    });

    mapKey.currentState?.moveToLocation(latLng);
  }

  /// 🔥 map trả về address
  void onLocationChanged(LatLng latLng, String addr) {
    setState(() {
      selectedLocation = latLng;
      address = addr;
      isLoading = false;
    });
  }

  void onLoading() {
    setState(() => isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapView(
            key: mapKey,
            onLocationChanged: onLocationChanged,
            onLoading: onLoading,
          ),

          MapSearchBox(onSelected: onSearchSelected),

          MapAddressCard(address: address, isLoading: isLoading),

          MapConfirmButton(
            isEnabled: selectedLocation != null && address.isNotEmpty,
            onConfirm: () {
              Navigator.pop(context, {
                "lat": selectedLocation!.latitude,
                "lng": selectedLocation!.longitude,
                "address": address,
              });
            },
          ),
        ],
      ),
    );
  }
}
