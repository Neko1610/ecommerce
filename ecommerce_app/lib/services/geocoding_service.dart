import 'package:geocoding/geocoding.dart';

class GeocodingService {
  static Future<String> getAddress(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final p = placemarks.first;

    return "${p.street}, ${p.locality}, ${p.administrativeArea}";
  }
}