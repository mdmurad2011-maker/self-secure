import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/location/gps_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GpsService _gpsService = GpsService();

  Position? _location;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    final position =
        await _gpsService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      _location = position;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = _location;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadLocation,
            tooltip: 'Refresh location',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : location == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_off,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Current location is unavailable.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _loadLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Current Location',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall,
                            ),
                            const SizedBox(height: 20),

                            SelectableText(
                              'Latitude: '
                              '${location.latitude.toStringAsFixed(6)}',
                            ),

                            const SizedBox(height: 8),

                            SelectableText(
                              'Longitude: '
                              '${location.longitude.toStringAsFixed(6)}',
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Accuracy: '
                              '${location.accuracy.toStringAsFixed(1)} m',
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Altitude: '
                              '${location.altitude.toStringAsFixed(1)} m',
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Speed: '
                              '${location.speed.toStringAsFixed(1)} m/s',
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Heading: '
                              '${location.heading.toStringAsFixed(1)}°',
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Time: '
                              '${_formatDate(location.timestamp)}',
                            ),

                            const SizedBox(height: 20),

                            Container(
                              height: 260,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline,
                                ),
                              ),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.map,
                                    size: 56,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Map View',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${location.latitude.toStringAsFixed(6)}, '
                                    '${location.longitude.toStringAsFixed(6)}',
                                    textAlign:
                                        TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Unknown';
    }

    final local = value.toLocal();

    String two(int number) =>
        number.toString().padLeft(2, '0');

    return '${local.year}-'
        '${two(local.month)}-'
        '${two(local.day)} '
        '${two(local.hour)}:'
        '${two(local.minute)}:'
        '${two(local.second)}';
  }
}