import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SecurityAuditService {
  static const String _key =
      'self_secure_audit_log';

  static const int _maxEntries = 1000;

  Future<List<Map<String, dynamic>>> getLogs() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    final logs = <Map<String, dynamic>>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          logs.add(decoded);
        }
      } catch (_) {}
    }

    logs.sort((a, b) {
      final aTime = DateTime.tryParse(
        a['timestamp']?.toString() ?? '',
      );

      final bTime = DateTime.tryParse(
        b['timestamp']?.toString() ?? '',
      );

      if (aTime == null) return 1;
      if (bTime == null) return -1;

      return bTime.compareTo(aTime);
    });

    return logs;
  }

  Future<void> record({
    required String action,
    String? details,
  }) async {
    final prefs =
        await SharedPreferences.getInstance();

    final logs = await getLogs();

    logs.insert(0, {
      'id':
          '${DateTime.now().microsecondsSinceEpoch}',
      'action': action,
      'details': details,
      'timestamp':
          DateTime.now().toIso8601String(),
    });

    final limited =
        logs.take(_maxEntries).toList();

    await prefs.setStringList(
      _key,
      limited.map(jsonEncode).toList(),
    );
  }

  Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
