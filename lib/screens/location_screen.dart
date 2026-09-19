import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/location/location_manager.dart';
import '../../services/location/location_history_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() =>
      _LocationScreenState();
}

class _LocationScreenState
    extends State<LocationScreen> {
  final LocationManager _manager =
      LocationManager();

  final LocationHistoryService _history =
      LocationHistoryService();

  Position? _position;
  bool _loading = false;
  String? _error;

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final location =
          await _manager.getCurrentLocation();

      if (location == null) {
        throw Exception(
          'Location permission or GPS service is unavailable.',
        );
      }

      await _history.saveLocation(
        location,
      );

      if (!mounted) return;

      setState(() {
        _position = Position(
          longitude: location.longitude,
          latitude: location.latitude,
          timestamp: location.timestamp,
          accuracy: location.accuracy,
          altitude: location.altitude,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
          floor: null,
          isMocked: false,
        );
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('My Current Location'),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 64,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    position == null
                        ? 'Location not loaded'
                        : 'Location available',
                    style:
                        Theme.of(context)
                            .textTheme
                            .titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (position != null) ...[
                    _InfoRow(
                      title: 'Latitude',
                      value:
                          position.latitude
                              .toStringAsFixed(6),
                    ),
                    _InfoRow(
                      title: 'Longitude',
                      value:
                          position.longitude
                              .toStringAsFixed(6),
                    ),
                    _InfoRow(
                      title: 'Accuracy',
                      value:
                          '${position.accuracy.toStringAsFixed(1)} m',
                    ),
                    _InfoRow(
                      title: 'Altitude',
                      value:
                          '${position.altitude.toStringAsFixed(1)} m',
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      _error!,
                      style:
                          TextStyle(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          FilledButton.icon(
            onPressed:
                _loading
                    ? null
                    : _getLocation,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                  ),
            label: Text(
              _loading
                  ? 'Getting Location...'
                  : 'Get Current Location',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            textAlign:
                TextAlign.right,
          ),
        ],
      ),
    );
  }
}
