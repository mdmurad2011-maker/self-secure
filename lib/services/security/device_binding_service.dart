import 'package:shared_preferences/shared_preferences.dart';

class DeviceBindingService {
  static const String _bindingKey =
      'self_secure_device_binding_id';

  Future<String?> getBindingId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_bindingKey);
  }

  Future<bool> isBound() async {
    final id = await getBindingId();

    return id != null && id.trim().isNotEmpty;
  }

  Future<void> bindDevice(String deviceId) async {
    final cleanId = deviceId.trim();

    if (cleanId.isEmpty) {
      throw ArgumentError(
        'Device ID cannot be empty.',
      );
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _bindingKey,
      cleanId,
    );
  }

  Future<void> unbindDevice() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_bindingKey);
  }
}
