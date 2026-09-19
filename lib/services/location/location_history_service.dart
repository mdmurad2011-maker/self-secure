import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/location_model.dart';

class LocationHistoryService {
  static const String _key =
      'self_secure_location_history';

  Future<List<LocationModel>> getHistory() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    return values.map((value) {
      return LocationModel.fromJson(
        jsonDecode(value)
            as Map<String, dynamic>,
      );
    }).toList()
      ..sort(
        (a, b) =>
            b.timestamp.compareTo(
          a.timestamp,
        ),
      );
  }

  Future<void> saveLocation(
    LocationModel location,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final history =
        await getHistory();

    history.removeWhere(
      (item) => item.id == location.id,
    );

    history.insert(
      0,
      location,
    );

    // Keep local history bounded.
    final limited =
        history.take(500).toList();

    await prefs.setStringList(
      _key,
      limited.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }

  Future<void> clearHistory() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
