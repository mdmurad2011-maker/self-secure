import 'package:shared_preferences/shared_preferences.dart';

class SecurityAttemptService {
  static const String _key =
      'self_secure_security_attempts';

  Future<int> getAttempts() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(_key) ?? 0;
  }

  Future<int> increment() async {
    final prefs =
        await SharedPreferences.getInstance();

    final attempts =
        (prefs.getInt(_key) ?? 0) + 1;

    await prefs.setInt(
      _key,
      attempts,
    );

    return attempts;
  }

  Future<void> reset() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  Future<bool> hasAttempts() async {
    return (await getAttempts()) > 0;
  }
}
