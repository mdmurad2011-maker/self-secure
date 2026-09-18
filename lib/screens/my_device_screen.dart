
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class MyDeviceScreen extends StatefulWidget {
  const MyDeviceScreen({super.key});

  @override
  State<MyDeviceScreen> createState() => _MyDeviceScreenState();
}

class _MyDeviceScreenState extends State<MyDeviceScreen> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();

  String _model = 'Loading...';
  String _manufacturer = 'Loading...';
  String _androidVersion = 'Loading...';
  String _deviceId = 'Loading...';
  String _batteryLevel = 'Loading...';
  String _batteryState = 'Loading...';
  String _securityPatch = 'Loading...';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    setState(() {
      _loading = true;
    });

    try {
      final android = await _deviceInfo.androidInfo;
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;

      if (!mounted) return;

      setState(() {
        _model = android.model.isNotEmpty
            ? android.model
            : 'Unknown';

        _manufacturer = android.manufacturer.isNotEmpty
            ? android.manufacturer
            : 'Unknown';

        _androidVersion =
            'Android ${android.version.release}';

        _deviceId =
            android.id.isNotEmpty ? android.id : 'Unavailable';

        _batteryLevel = '$batteryLevel%';

        _batteryState = _batteryStateText(
          batteryState,
        );

        _securityPatch =
            android.version.securityPatch.isNotEmpty
                ? android.version.securityPatch
                : 'Unavailable';

        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _model = 'Unavailable';
        _manufacturer = 'Unavailable';
        _androidVersion = 'Unavailable';
        _deviceId = 'Unavailable';
        _batteryLevel = 'Unavailable';
        _batteryState = 'Unavailable';
        _securityPatch = 'Unavailable';
        _loading = false;
      });
    }
  }

  String _batteryStateText(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Charging';

      case BatteryState.discharging:
        return 'Discharging';

      case BatteryState.full:
        return 'Full';

      case BatteryState.connectedNotCharging:
        return 'Connected';

      case BatteryState.unknown:
        return 'Unknown';
    }
  }

  IconData _batteryIcon() {
    if (_batteryLevel == 'Loading...' ||
        _batteryLevel == 'Unavailable') {
      return Icons.battery_unknown_rounded;
    }

    final value = int.tryParse(
          _batteryLevel.replaceAll('%', ''),
        ) ??
        0;

    if (value >= 80) {
      return Icons.battery_full_rounded;
    }

    if (value >= 50) {
      return Icons.battery_5_bar_rounded;
    }

    if (value >= 20) {
      return Icons.battery_3_bar_rounded;
    }

    return Icons.battery_1_bar_rounded;
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF07111F),
        elevation: 0,
        title: const Text(
          'My Device',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading
                ? null
                : _loadDeviceInfo,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadDeviceInfo,
        color: const Color(0xFFFFD66B),
        backgroundColor: const Color(0xFF101D2D),

        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            // DEVICE HEADER
            Container(
              padding: const EdgeInsets.all(22),
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
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(27),
                      color: const Color(0x16D9A441),
                      border: Border.all(
                        color: const Color(0x33D9A441),
                      ),
                    ),
                    child: const Icon(
                      Icons.phone_android_rounded,
                      color: Color(0xFFFFD66B),
                     
