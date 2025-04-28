import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Get the current position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  // Get city name from coordinates
  Future<String> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Return city, region, or administrative area, depending on availability
        return place.locality?.isNotEmpty ?? false 
            ? place.locality! 
            : place.subAdministrativeArea?.isNotEmpty ?? false 
                ? place.subAdministrativeArea! 
                : place.administrativeArea?.isNotEmpty ?? false
                    ? place.administrativeArea!
                    : 'Unknown location';
      }
      return 'Unknown location';
    } catch (e) {
      print('Error while fetching address: $e');
      return 'Unknown location';
    }
  }
}