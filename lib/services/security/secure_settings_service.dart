import 'package:shared_preferences/shared_preferences.dart';

class SecureSettingsService {
  static const String _screenshotKey =
      'self_secure_screenshot_protection';

  static const String _autoLockKey =
      'self_secure_auto_lock';

  static const String _securityEmailKey =
      'self_secure_security_email';

  Future<bool> screenshotProtectionEnabled() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_screenshotKey) ?? false;
  }

  Future<bool> setScreenshotProtection(
    bool enabled,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setBool(
      _screenshotKey,
      enabled,
    );
  }

  Future<bool> autoLockEnabled() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_autoLockKey) ?? true;
  }

  Future<bool> setAutoLock(
    bool enabled,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setBool(
      _autoLockKey,
      enabled,
    );
  }

  Future<String?> getSecurityEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      _securityEmailKey,
    );
  }

  Future<bool> setSecurityEmail(
    String email,
  ) async {
    final value = email.trim();

    if (value.isEmpty ||
        !value.contains('@')) {
      return false;
    }

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setString(
      _securityEmailKey,
      value,
    );
  }

  Future<void> clearSecurityEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_securityEmailKey);
  }
}
