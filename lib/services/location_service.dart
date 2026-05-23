import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/unsafe_place.dart';

class LocationService {
  // Check location permission
  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current coordinate (fallback to Pune default if permission denied or offline)
  Future<Position> getCurrentLocation() async {
    final hasPermission = await handlePermission();
    if (!hasPermission) {
      return Position(
        longitude: 73.8567,
        latitude: 18.5204,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (_) {
      // Fallback
      return Position(
        longitude: 73.8567,
        latitude: 18.5204,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  // Position updates stream
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).handleError((error) {
      // Return periodic simulated stream in case of errors/permissions denied
      return Stream.periodic(const Duration(seconds: 6), (i) {
        // Gently move coordinates in Pune to simulate movement
        final offset = i * 0.00015;
        return Position(
          longitude: 73.8567 + offset,
          latitude: 18.5204 + (offset * 0.8),
          timestamp: DateTime.now(),
          accuracy: 100,
          altitude: 0,
          heading: 0,
          speed: 0.5,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });
    });
  }

  // Check if coordinates overlap with an unsafe place
  UnsafePlace? getActiveThreat(Position position, List<UnsafePlace> unsafePlaces) {
    for (final place in unsafePlaces) {
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        place.latitude,
        place.longitude,
      );

      if (distanceInMeters <= place.radius) {
        return place; // Entered unsafe hotspot
      }
    }
    return null;
  }

  // Reverse geocoding helper (simulated local names to avoid API keys and internet failures)
  String getApproximateAddress(double lat, double lng) {
    // Basic coordinate bounds mapping for Pune simulation
    if (lat > 18.540 && lng < 73.830) {
      return 'Near SPPU University, Shivajinagar';
    } else if (lat > 18.525 && lat < 18.535 && lng > 73.840 && lng < 73.852) {
      return 'Model Colony Lakaki Road, Pune';
    } else if (lat > 18.520 && lat < 18.525 && lng > 73.835 && lng < 73.845) {
      return 'FC Road near BMCC, Pune';
    } else if (lat < 18.510 && lng > 73.860) {
      return 'Swargate Square Metro Entrance';
    }
    return 'Shivajinagar, Pune Metropolitan Area';
  }

  // Get real address using Nominatim reverse geocoding API
  Future<String> getRealAddress(double lat, double lng) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&zoom=18&addressdetails=1');
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'com.basic.hutter/1.0',
          'Accept-Language': 'en',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['display_name'] != null) {
          final displayName = data['display_name'] as String;
          // Extract specific address elements for a shorter display name
          final address = data['address'];
          if (address != null) {
            final road = address['road'] ?? address['suburb'] ?? address['neighbourhood'] ?? address['hamlet'] ?? '';
            final city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? '';
            if (road.isNotEmpty && city.isNotEmpty) {
              return '$road, $city';
            }
          }
          final parts = displayName.split(',');
          if (parts.length > 3) {
            return parts.take(3).join(',').trim();
          }
          return displayName.trim();
        }
      }
    } catch (e) {
      print("Reverse geocoding lookup failed: $e");
    }
    return '';
  }
}
