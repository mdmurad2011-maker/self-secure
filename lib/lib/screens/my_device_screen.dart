import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';

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

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final android = await _deviceInfo.androidInfo;
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;

      if (!mounted) return;

      setState(() {
        _model = android.model;
        _manufacturer = android.manufacturer;
        _androidVersion =
            'Android ${android.version.release}';

        _deviceId = android.id;

        _batteryLevel = '$batteryLevel%';

        _batteryState = _batteryStateText(
          batteryState,
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _model = 'Unavailable';
        _manufacturer = 'Unavailable';
        _androidVersion = 'Unavailable';
        _deviceId = 'Unavailable';
        _batteryLevel = 'Unavailable';
        _batteryState = 'Unavailable';
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
        title: const Text(
          'My Device',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _loadDeviceInfo,
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
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF182A40),
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
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(25),
                      color: const Color(0x16D9A441),
                    ),
                    child: const Icon(
                      Icons.phone_android_rounded,
                      color: Color(0xFFFFD66B),
                      size: 45,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    _model,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _manufacturer,
                    style: const TextStyle(
                      color: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1622C55E),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 9,
                          color: Color(0xFF4ADE80),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Device Active',
                          style: TextStyle(
                            color: Color(0xFF86EFAC),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Device Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 13),

            _infoCard(
              icon: Icons.phone_android_rounded,
              title: 'Device Model',
              value: _model,
            ),

            _infoCard(
              icon: Icons.business_rounded,
              title: 'Manufacturer',
              value: _manufacturer,
            ),

            _infoCard(
              icon: Icons.android_rounded,
              title: 'Operating System',
              value: _androidVersion,
            ),

            _infoCard(
              icon: Icons.battery_std_rounded,
              title: 'Battery Level',
              value: _batteryLevel,
            ),

            _infoCard(
              icon: Icons.bolt_rounded,
              title: 'Battery Status',
              value: _batteryState,
            ),

            _infoCard(
              icon: Icons.fingerprint_rounded,
              title: 'Device Identifier',
              value: _deviceId,
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFF101D2D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0x1FD9A441),
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFFFD66B),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Device information is read locally from this device and is used by SELF SECURE for authorized security features.',
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
          ],
        ),
      ),
    );
  }
}
