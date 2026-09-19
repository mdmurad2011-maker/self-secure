import 'package:shared_preferences/shared_preferences.dart';

class DeviceRegistrationService {
  static const String _registeredKey =
      'self_secure_device_registered';

  static const String _deviceIdKey =
      'self_secure_registered_device_id';

  static const String _registeredAtKey =
      'self_secure_device_registered_at';

  Future<bool> isRegistered() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_registeredKey) ?? false;
  }

  Future<bool> register(
    String deviceId,
  ) async {
    final id = deviceId.trim();

    if (id.isEmpty) {
      return false;
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _registeredKey,
      true,
    );

    await prefs.setString(
      _deviceIdKey,
      id,
    );

    await prefs.setString(
      _registeredAtKey,
      DateTime.now().toIso8601String(),
    );

    return true;
  }

  Future<String?> getDeviceId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_deviceIdKey);
  }

  Future<DateTime?> getRegisteredAt() async {
    final prefs =
        await SharedPreferences.getInstance();

    final value =
        prefs.getString(_registeredAtKey);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  Future<void> unregister() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_registeredKey);
    await prefs.remove(_deviceIdKey);
    await prefs.remove(_registeredAtKey);
  }
}
