import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityService {
  SecurityService._();

  static final SecurityService instance =
      SecurityService._();

  final LocalAuthentication _auth =
      LocalAuthentication();

  static const String _pinKey = 'security_pin';
  static const String _biometricKey =
      'biometric_enabled';
  static const String _notificationKey =
      'security_notifications';
  static const String _bindingKey =
      'device_binding_id';

  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString(_pinKey);

    return pin != null && pin.isNotEmpty;
  }

  Future<bool> setPin(String pin) async {
    if (!RegExp(r'^\d{4,6}$').hasMatch(pin)) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(_pinKey, pin);
  }

  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_pinKey) == pin;
  }

  Future<bool> biometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> biometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_biometricKey) ?? false;
  }

  Future<bool> setBiometric(bool enabled) async {
    if (enabled && !await biometricAvailable()) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    return prefs.setBool(
      _biometricKey,
      enabled,
    );
  }

  Future<bool> authenticateBiometric() async {
    if (!await biometricEnabled()) {
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason:
            'Authenticate to access SELF SECURE',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> notificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_notificationKey) ?? true;
  }

  Future<bool> setNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setBool(
      _notificationKey,
      enabled,
    );
  }

  Future<String?> getDeviceBinding() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_bindingKey);
  }

  Future<bool> setDeviceBinding(String id) async {
    if (id.trim().isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(
      _bindingKey,
      id.trim(),
    );
  }
}
