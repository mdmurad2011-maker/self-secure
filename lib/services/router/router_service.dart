import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/router_device.dart';

class RouterService {
  static const String _key =
      'self_secure_router_devices';

  Future<List<RouterDevice>> getDevices() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    return values.map((value) {
      return RouterDevice.fromJson(
        jsonDecode(value)
            as Map<String, dynamic>,
      );
    }).toList();
  }

  Future<void> saveDevice(
    RouterDevice device,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final devices = await getDevices();

    final index = devices.indexWhere(
      (item) => item.id == device.id,
    );

    if (index >= 0) {
      devices[index] = device;
    } else {
      devices.add(device);
    }

    await prefs.setStringList(
      _key,
      devices
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> deleteDevice(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final devices = await getDevices();

    devices.removeWhere(
      (item) => item.id == id,
    );

    await prefs.setStringList(
      _key,
      devices
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }
}
