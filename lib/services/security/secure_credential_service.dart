import 'package:shared_preferences/shared_preferences.dart';

class SecureCredentialService {
  static const String _usernameKey =
      'self_secure_username';

  static const String _securityEmailKey =
      'self_secure_security_email';

  Future<void> setUsername(String username) async {
    final value = username.trim();

    if (value.isEmpty) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _usernameKey,
      value,
    );
  }

  Future<String?> getUsername() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_usernameKey);
  }

  Future<void> setSecurityEmail(
    String email,
  ) async {
    final value = email.trim();

    if (value.isEmpty) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _securityEmailKey,
      value,
    );
  }

  Future<String?> getSecurityEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      _securityEmailKey,
    );
  }

  Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_usernameKey);
    await prefs.remove(_securityEmailKey);
  }
}
