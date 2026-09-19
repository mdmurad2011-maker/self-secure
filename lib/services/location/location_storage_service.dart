import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocationStorageService {
  static const String _key =
      'self_secure_location_history';

  Future<List<Map<String, dynamic>>> read() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    final result =
        <Map<String, dynamic>>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          result.add(decoded);
        }
      } catch (_) {
        // Ignore invalid records.
      }
    }

    return result;
  }

  Future<void> write(
    Map<String, dynamic> location,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    values.add(jsonEncode(location));

    await prefs.setStringList(
      _key,
      values,
    );
  }

  Future<void> replace(
    List<Map<String, dynamic>> locations,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        locations.map(jsonEncode).toList();

    await prefs.setStringList(
      _key,
      values,
    );
  }

  Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  Future<int> count() async {
    final values = await read();

    return values.length;
  }
}
