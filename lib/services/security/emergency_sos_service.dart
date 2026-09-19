import 'package:shared_preferences/shared_preferences.dart';

class EmergencySosService {
  static const String _enabledKey =
      'self_secure_sos_enabled';

  static const String _numberKey =
      'self_secure_sos_number';

  Future<bool> isEnabled() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<bool> setEnabled(
    bool enabled,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setBool(
      _enabledKey,
      enabled,
    );
  }

  Future<String?> getNumber() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_numberKey);
  }

  Future<bool> setNumber(
    String number,
  ) async {
    final value = number.trim();

    if (value.isEmpty) {
      return false;
    }

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setString(
      _numberKey,
      value,
    );
  }

  Future<void> clearNumber() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_numberKey);
  }
}
