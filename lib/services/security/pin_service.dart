import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  PinService._();

  static final PinService instance =
      PinService._();

  static const String _pinKey =
      'self_secure_pin';

  Future<bool> hasPin() async {
    final prefs =
        await SharedPreferences.getInstance();

    final pin = prefs.getString(_pinKey);

    return pin != null && pin.isNotEmpty;
  }

  Future<bool> setPin(String pin) async {
    final value = pin.trim();

    if (!_isValidPin(value)) {
      return false;
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _pinKey,
      value,
    );

    return true;
  }

  Future<bool> verifyPin(String pin) async {
    final prefs =
        await SharedPreferences.getInstance();

    final savedPin =
        prefs.getString(_pinKey);

    if (savedPin == null) {
      return false;
    }

    return savedPin == pin.trim();
  }

  Future<void> clearPin() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_pinKey);
  }

  Future<bool> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    final valid =
        await verifyPin(currentPin);

    if (!valid) {
      return false;
    }

    return setPin(newPin);
  }

  bool _isValidPin(String pin) {
    if (pin.length < 4 ||
        pin.length > 8) {
      return false;
    }

    return RegExp(
      r'^[0-9]+$',
    ).hasMatch(pin);
  }
}
