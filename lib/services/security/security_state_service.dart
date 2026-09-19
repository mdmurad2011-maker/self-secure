import 'package:shared_preferences/shared_preferences.dart';

class SecurityStateService {
  static const String _armedKey =
      'self_secure_security_armed';

  static const String _lostModeKey =
      'self_secure_security_lost_mode';

  static const String _lastEventKey =
      'self_secure_security_last_event';

  Future<bool> isArmed() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_armedKey) ?? false;
  }

  Future<bool> isLostMode() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_lostModeKey) ?? false;
  }

  Future<String?> lastEvent() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_lastEventKey);
  }

  Future<void> setArmed(bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _armedKey,
      value,
    );
  }

  Future<void> setLostMode(bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _lostModeKey,
      value,
    );
  }

  Future<void> setLastEvent(
    String event,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _lastEventKey,
      event,
    );
  }

  Future<Map<String, dynamic>> getState() async {
    return {
      'armed': await isArmed(),
      'lostMode': await isLostMode(),
      'lastEvent': await lastEvent(),
    };
  }

  Future<void> reset() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _armedKey,
      false,
    );

    await prefs.setBool(
      _lostModeKey,
      false,
    );

    await prefs.remove(_lastEventKey);
  }
}
