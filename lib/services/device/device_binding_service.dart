import 'package:shared_preferences/shared_preferences.dart';

class DeviceBindingService {
  static const String _key =
      'self_secure_device_binding';

  Future<String?> getBindingId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_key);
  }

  Future<bool> bind(String deviceId) async {
    final id = deviceId.trim();

    if (id.isEmpty) {
      return false;
    }

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setString(
      _key,
      id,
    );
  }

  Future<bool> isBound() async {
    final id = await getBindingId();

    return id != null && id.isNotEmpty;
  }

  Future<bool> matches(String deviceId) async {
    final current =
        await getBindingId();

    if (current == null ||
        current.isEmpty ||
        deviceId.trim().isEmpty) {
      return false;
    }

    return current == deviceId.trim();
  }

  Future<void> unbind() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
