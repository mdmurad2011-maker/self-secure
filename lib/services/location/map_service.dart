import 'package:geolocator/geolocator.dart';

class MapService {
  String buildGoogleMapsUrl(
    double latitude,
    double longitude,
  ) {
    return 'https://www.google.com/maps/search/?api=1'
        '&query=$latitude,$longitude';
  }

  double distanceInMeters(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
