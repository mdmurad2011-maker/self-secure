import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapScreen({
    super.key,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Map'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map,
              size: 72,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Map module',
            ),
            if (latitude != null &&
                longitude != null) ...[
              const SizedBox(
                height: 12,
              ),
              Text(
                'Latitude: '
                '${latitude!.toStringAsFixed(6)}',
              ),
              Text(
                'Longitude: '
                '${longitude!.toStringAsFixed(6)}',
              ),
            ],
            const SizedBox(
              height: 16,
            ),
            const Text(
              'GPS data is available for map integration.',
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
