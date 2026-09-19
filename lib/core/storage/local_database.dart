import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  static const String _prefix =
      'self_secure_';

  Future<void> setString(
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

  Future<String?> getString(
    String key,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      '$_prefix$key',
    );
  }

  Future<void> setJson(
    String key,
    Map<String, dynamic> value,
  ) async {
    await setString(
      key,
      jsonEncode(value),
    );
  }

  Future<Map<String, dynamic>?> getJson(
    String key,
  ) async {
    final value =
        await getString(key);

    if (value == null ||
        value.trim().isEmpty) {
      return null;
    }

    try {
      final decoded =
          jsonDecode(value);

      if (decoded is Map) {
        return Map<String, dynamic>.from(
          decoded,
        );
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<void> setBool(
    String key,
    bool value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      '$_prefix$key',
      value,
    );
  }

  Future<bool> getBool(
    String key, {
    bool defaultValue = false,
  }) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          '$_prefix$key',
        ) ??
        defaultValue;
  }

  Future<void> remove(
    String key,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      '$_prefix$key',
    );
  }
}
