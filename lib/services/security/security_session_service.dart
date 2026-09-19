import 'package:shared_preferences/shared_preferences.dart';

class SecuritySessionService {
  SecuritySessionService._();

  static final SecuritySessionService instance =
      SecuritySessionService._();

  static const String _unlockedKey =
      'self_secure_session_unlocked';

  static const String _unlockedAtKey =
      'self_secure_session_unlocked_at';

  Future<bool> isUnlocked() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_unlockedKey) ?? false;
  }

  Future<DateTime?> unlockedAt() async {
    final prefs =
        await SharedPreferences.getInstance();

    final value =
        prefs.getString(_unlockedAtKey);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  Future<void> startSession() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _unlockedKey,
      true,
    );

    await prefs.setString(
      _unlockedAtKey,
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> endSession() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _unlockedKey,
      false,
    );

    await prefs.remove(
      _unlockedAtKey,
    );
  }

  Future<Map<String, dynamic>> getSession() async {
    return {
      'unlocked': await isUnlocked(),
      'unlockedAt':
          (await unlockedAt())?.toIso8601String(),
    };
  }

  Future<void> clear() {
    return endSession();
  }
}
