import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const String _prefix =
      'self_secure_secret_';

  Future<void> write(
    String key,
    String value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      '$_prefix$key',
      value,
    );
  }

  Future<String?> read(String key) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      '$_prefix$key',
    );
  }

  Future<void> delete(String key) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      '$_prefix$key',
    );
  }

  Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    final keys = prefs
        .getKeys()
        .where(
          (key) => key.startsWith(_prefix),
        )
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
