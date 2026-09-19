import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance =
      LocalDatabase._();

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  Future<void> setString(
    String key,
    String value,
  ) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(
    String key,
  ) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setBool(
    String key,
    bool value,
  ) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(
    String key,
  ) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<void> setInt(
    String key,
    int value,
  ) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(
    String key,
  ) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  Future<void> setJson(
    String key,
    Map<String, dynamic> value,
  ) async {
    final prefs = await _prefs;

    await prefs.setString(
      key,
      jsonEncode(value),
    );
  }

  Future<Map<String, dynamic>?> getJson(
    String key,
  ) async {
    final prefs = await _prefs;

    final value = prefs.getString(key);

    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(value);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Invalid JSON.
    }

    return null;
  }

  Future<void> remove(
    String key,
  ) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  Future<bool> containsKey(
    String key,
  ) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
