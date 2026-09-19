import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/security_event.dart';

class SecurityEventService {
  static const String _key =
      'self_secure_security_events';

  Future<List<SecurityEvent>> getEvents() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    return values.map((value) {
      return SecurityEvent.fromJson(
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

  Future<void> addEvent(
    SecurityEvent event,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final events =
        await getEvents();

    events.removeWhere(
      (item) => item.id == event.id,
    );

    events.insert(0, event);

    final limited =
        events.take(500).toList();

    await prefs.setStringList(
      _key,
      limited.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }

  Future<void> clearEvents() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
