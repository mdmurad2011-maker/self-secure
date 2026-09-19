import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  Future<bool> isServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> getPermission() {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<bool> isAllowed() async {
    final permission =
        await Geolocator.checkPermission();

    return permission ==
            LocationPermission.always ||
        permission ==
            LocationPermission.whileInUse;
  }

  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }
}
