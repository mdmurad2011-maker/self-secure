import 'package:shared_preferences/shared_preferences.dart';

class SecurityEmailService {
  static const String _emailKey =
      'self_secure_alert_email';

  static const String _enabledKey =
      'self_secure_email_alert_enabled';

  Future<String?> getEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_emailKey);
  }

  Future<bool> setEmail(String email) async {
    final value = email.trim();

    if (!RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(value)) {
      return false;
    }

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.setString(
      _emailKey,
      value,
    );
  }

  Future<bool> isEnabled() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          _enabledKey,
        ) ??
        false;
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

  Future<bool> send({
    required String to,
    required String subject,
    required String body,
  }) async {
    // Email transport will be connected
    // through a real backend/provider.
    // No fake email delivery is performed.
    return false;
  }

  Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_emailKey);
    await prefs.remove(_enabledKey);
  }
}
