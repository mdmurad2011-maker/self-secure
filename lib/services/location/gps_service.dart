import 'package:geolocator/geolocator.dart';

class GpsService {
  GpsService();

  static final GpsService instance =
      GpsService();

  Future<Position?> getCurrentPosition() async {
    try {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        return null;
      }

      var permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Position?> getCurrentLocation() {
    return getCurrentPosition();
  }

  Future<bool> isAvailable() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return false;
      }

      final permission =
          await Geolocator.checkPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }
}
