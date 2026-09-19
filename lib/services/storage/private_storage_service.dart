import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/private_app.dart';
import '../../models/private_website.dart';

class PrivateStorageService {
  static const String _key =
      'self_secure_private_storage';

  static const String _appsKey = 'apps';
  static const String _websitesKey = 'websites';

  Future<Map<String, dynamic>> getData() async {
    final prefs =
        await SharedPreferences.getInstance();

    final value = prefs.getString(_key);

    if (value == null || value.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(value);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    return {};
  }

  Future<void> _saveData(
    Map<String, dynamic> data,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(data),
    );
  }

  Future<void> setValue(
    String key,
    dynamic value,
  ) async {
    final data = await getData();

    data[key] = value;

    await _saveData(data);
  }

  Future<dynamic> getValue(
    String key,
  ) async {
    final data = await getData();

    return data[key];
  }

  Future<void> removeValue(
    String key,
  ) async {
    final data = await getData();

    data.remove(key);

    await _saveData(data);
  }

  Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  Future<bool> contains(
    String key,
  ) async {
    final data = await getData();

    return data.containsKey(key);
  }

  Future<List<PrivateApp>> getApps() async {
    final data = await getData();
    final raw = data[_appsKey];

    if (raw is! List) {
      return [];
    }

    return raw
        .whereType<Map>()
        .map(
          (item) => PrivateApp.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveApps(
    List<PrivateApp> apps,
  ) async {
    final data = await getData();

    data[_appsKey] =
        apps.map((app) => app.toJson()).toList();

    await _saveData(data);
  }

  Future<List<PrivateWebsite>> getWebsites() async {
    final data = await getData();
    final raw = data[_websitesKey];

    if (raw is! List) {
      return [];
    }

    return raw
        .whereType<Map>()
        .map(
          (item) => PrivateWebsite.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveWebsites(
    List<PrivateWebsite> websites,
  ) async {
    final data = await getData();

    data[_websitesKey] =
        websites
            .map((website) => website.toJson())
            .toList();

    await _saveData(data);
  }
}
