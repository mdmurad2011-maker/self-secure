import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../models/location_model.dart';
import 'location_history_service.dart';

class LocationTrackingService {
  LocationTrackingService._();

  static final LocationTrackingService instance =
      LocationTrackingService._();

  final LocationHistoryService _history =
      LocationHistoryService.instance;

  StreamSubscription<Position>? _subscription;

  bool get isTracking => _subscription != null;

  Future<Position?> _getPosition() async {
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

  LocationModel _toLocationModel(
    Position position,
  ) {
    return LocationModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      timestamp:
          position.timestamp,
    );
  }

  Future<LocationModel?> getCurrentLocation() async {
    final position = await _getPosition();

    if (position == null) {
      return null;
    }

    return _toLocationModel(position);
  }

  Future<bool> startTracking() async {
    if (isTracking) {
      return true;
    }

    final position = await _getPosition();

    if (position == null) {
      return false;
    }

    await _history.saveLocation(
      _toLocationModel(position),
    );

    _subscription =
        Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) async {
      await _history.saveLocation(
        _toLocationModel(position),
      );
    });

    return true;
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> dispose() async {
    await stopTracking();
  }
}