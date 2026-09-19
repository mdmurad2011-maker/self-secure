import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const String _key = 'security_pin';

  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString(_key);

    return pin != null && pin.isNotEmpty;
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<bool> savePin(String pin) async {
    if (!RegExp(r'^\d{4,6}$').hasMatch(pin)) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(_key, pin);
  }

  Future<bool> verify(String pin) async {
    final saved = await getPin();

    return saved != null && saved == pin;
  }

  Future<bool> change({
    required String currentPin,
    required String newPin,
  }) async {
    if (!await verify(currentPin)) {
      return false;
    }

    return savePin(newPin);
  }
}
