import 'package:geolocator/geolocator.dart';

import '../../models/location_model.dart';

class LocationManager {
  Future<bool> ensurePermission() async {
    final enabled =
        await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return false;
    }

    var permission =
        await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LocationModel?> getCurrentLocation() async {
    final allowed =
        await ensurePermission();

    if (!allowed) {
      return null;
    }

    final position =
        await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(
        accuracy:
            LocationAccuracy.high,
      ),
    );

    return LocationModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      timestamp: position.timestamp,
    );
  }

  Stream<Position> positionStream() {
    return Geolocator.getPositionStream(
      locationSettings:
          const LocationSettings(
        accuracy:
            LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
