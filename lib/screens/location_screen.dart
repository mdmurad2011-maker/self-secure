import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _position;

  bool _loading = true;
  bool _serviceEnabled = false;
  String _status = 'Checking location...';
  String? _error;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
      _status = 'Checking location service...';
    });

    try {
      _serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!_serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _loading = false;
          _status = 'Location service is OFF';
          _error =
              'Please turn on Location/GPS on your phone.';
        });

        return;
      }

      setState(() {
        _status = 'Checking location permission...';
      });

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _loading = false;
          _status = 'Permission denied';
          _error =
              'Location permission was denied.';
        });

        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _loading = false;
          _status = 'Permission permanently denied';
          _error =
              'Please enable location permission from App Settings.';
        });

        return;
      }

      setState(() {
        _status = 'Getting your current location...';
      });

      final position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _position = position;
        _loading = false;
        _status = 'Location Active';
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _status = 'Unable to get location';
        _error =
            'Please check GPS and location permission.';
      });
    }
  }

  Future<void> _openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> _openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  String _formatCoordinate(double? value) {
    if (value == null) {
      return 'Unavailable';
    }

    return value.toStringAsFixed(6);
  }

  String _formatAccuracy(double? value) {
    if (value == null) {
      return 'Unavailable';
    }

    return '${value.toStringAsFixed(1)} m';
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF101D2D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x1FD9A441),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0x16D9A441),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFFD66B),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latitude = _position?.latitude;
    final longitude = _position?.longitude;

    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07111F),
        elevation: 0,
        title: const Text(
          'My Location',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loading
                ? null
                : _getCurrentLocation,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getCurrentLocation,
        color: const Color(0xFFFFD66B),
        backgroundColor: const Color(0xFF101D2D),
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A2D44),
                    Color(0xFF0D1828),
                  ],
                ),
                border: Border.all(
                  color: const Color(0x33D9A441),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0x16D9A441),
                      border: Border.all(
                        color: const Color(0x33D9A441),
                      ),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFFFD66B),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _error == null
                          ? const Color(0xFFFFD66B)
                          : Colors.orangeAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    _loading
                        ? 'Please wait...'
                        : _error ??
                            'Your current location is available.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (!_serviceEnabled && !_loading)
              Container(
                margin: const EdgeInsets.only(
                  bottom: 18,
                ),
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _openLocationSettings,
                    icon: const Icon(
                      Icons.gps_fixed_rounded,
                    ),
                    label: const Text(
                      'Turn On Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD9A441),
                      foregroundColor:
                          const Color(0xFF07111F),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

            if (_error != null &&
                _error!.contains('App Settings'))
              Container(
                margin: const EdgeInsets.only(
                  bottom: 18,
                ),
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _openAppSettings,
                    icon: const Icon(
                      Icons.settings_rounded,
                    ),
                    label: const Text(
                      'Open App Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD9A441),
                      foregroundColor:
                          const Color(0xFF07111F),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

            const Text(
              'Current Position',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 13),

            _infoCard(
              icon: Icons.north_rounded,
              title: 'Latitude',
              value:
                  _formatCoordinate(latitude),
            ),

            _infoCard(
              icon: Icons.east_rounded,
              title: 'Longitude',
              value:
                  _formatCoordinate(longitude),
            ),

            _infoCard(
              icon: Icons.gps_fixed_rounded,
              title: 'GPS Accuracy',
              value:
                  _formatAccuracy(
                    _position?.accuracy,
                  ),
            ),

            _infoCard(
              icon: Icons.height_rounded,
              title: 'Altitude',
              value: _position == null
                  ? 'Unavailable'
                  : '${_position!.altitude.toStringAsFixed(1)} m',
            ),

            _infoCard(
              icon: Icons.speed_rounded,
              title: 'Speed',
              value: _position == null
                  ? 'Unavailable'
                  : '${_position!.speed.toStringAsFixed(1)} m/s',
            ),

            _infoCard(
              icon: Icons.explore_rounded,
              title: 'Heading',
              value: _position == null
                  ? 'Unavailable'
                  : '${_position!.heading.toStringAsFixed(1)}°',
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF101D2D),
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0x1FD9A441),
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Color(0xFFFFD66B),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'SELF SECURE only requests location access when needed for an authorized security feature. Location access is controlled by your device permission settings.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed:
                    _loading ? null : _getCurrentLocation,
                icon: const Icon(
                  Icons.my_location_rounded,
                ),
                label: const Text(
                  'Get Current Location',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFD9A441),
                  foregroundColor:
                      const Color(0xFF07111F),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
