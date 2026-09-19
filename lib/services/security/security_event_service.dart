import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/security_event.dart';

class SecurityEventService {
  static const String _key = 'self_secure_security_events';

  Future<List<SecurityEvent>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_key) ?? <String>[];
    final events = <SecurityEvent>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          events.add(SecurityEvent.fromJson(decoded));
        }
      } catch (_) {}
    }

    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return events;
  }

  Future<void> addEvent(SecurityEvent event) async {
    final prefs = await SharedPreferences.getInstance();
    final events = await getEvents();
    events.removeWhere((item) => item.id == event.id);
    events.insert(0, event);
    final limited = events.take(500).toList();

    await prefs.setStringList(
      _key,
      limited.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  Future<void> clearEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
