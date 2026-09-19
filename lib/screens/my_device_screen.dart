import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import '../services/device/battery_service.dart';
import '../services/device/device_info_service.dart';

class MyDeviceScreen extends StatefulWidget {
  const MyDeviceScreen({super.key});

  @override
  State<MyDeviceScreen> createState() => _MyDeviceScreenState();
}

class _MyDeviceScreenState extends State<MyDeviceScreen> {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  final BatteryService _batteryService = BatteryService();

  String _model = 'Loading...';
  String _manufacturer = 'Loading...';
  String _androidVersion = 'Loading...';
  String _deviceId = 'Loading...';
  String _securityPatch = 'Loading...';

  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final model = await _deviceInfoService.getModel();
      final manufacturer =
          await _deviceInfoService.getManufacturer();
      final androidVersion =
          await _deviceInfoService.getAndroidVersion();
      final deviceId =
          await _deviceInfoService.getDeviceId();
      final securityPatch =
          await _deviceInfoService.getSecurityPatch();

      final batteryLevel =
          await _batteryService.getLevel();
      final batteryState =
          await _batteryService.getState();

      if (!mounted) return;

      setState(() {
        _model = model;
        _manufacturer = manufacturer;
        _androidVersion = androidVersion;
        _deviceId = deviceId;
        _securityPatch = securityPatch;
        _batteryLevel = batteryLevel;
        _batteryState = batteryState;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _model = 'Unavailable';
        _manufacturer = 'Unavailable';
        _androidVersion = 'Unavailable';
        _deviceId = 'Unavailable';
        _securityPatch = 'Unavailable';
      });
    }
  }

  String _batteryStatus() {
  switch (_batteryState) {
    case BatteryState.charging:
      return 'Charging';

    case BatteryState.discharging:
      return 'Discharging';

    case BatteryState.full:
      return 'Full';

    case BatteryState.connectedNotCharging:
      return 'Connected, not charging';

    case BatteryState.unknown:
      return 'Unknown';
  }
}

  IconData _batteryIcon() {
    if (_batteryState == BatteryState.charging) {
      return Icons.battery_charging_full;
    }

    if (_batteryLevel >= 80) {
      return Icons.battery_full;
    }

    if (_batteryLevel >= 50) {
      return Icons.battery_5_bar;
    }

    if (_batteryLevel >= 20) {
      return Icons.battery_3_bar;
    }

    return Icons.battery_alert;
  }

  Widget _infoCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Device'),
        actions: [
          IconButton(
            onPressed: _loadDeviceInfo,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadDeviceInfo,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            child: Icon(
                              _batteryIcon(),
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Battery',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$_batteryLevel% • '
                                  '${_batteryStatus()}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _infoCard(
                    'Device Model',
                    _model,
                    Icons.phone_android,
                  ),

                  _infoCard(
                    'Manufacturer',
                    _manufacturer,
                    Icons.business,
                  ),

                  _infoCard(
                    'Android Version',
                    _androidVersion,
                    Icons.android,
                  ),

                  _infoCard(
                    'Device ID',
                    _deviceId,
                    Icons.fingerprint,
                  ),

                  _infoCard(
                    'Security Patch',
                    _securityPatch,
                    Icons.security,
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text('Device Binding'),
                      subtitle: const Text(
                        'Securely bind this device '
                        'to SELF SECURE.',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/device-binding',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
