import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BackupService {
  static const String _backupKey =
      'self_secure_backup';

  Future<String> createBackup() async {
    final prefs =
        await SharedPreferences.getInstance();

    final keys = prefs.getKeys();

    final Map<String, dynamic> data = {};

    for (final key in keys) {
      final value = prefs.get(key);

      if (value is String ||
          value is bool ||
          value is int ||
          value is double ||
          value is List<String>) {
        data[key] = value;
      }
    }

    final backup = jsonEncode({
      'app': 'SELF SECURE',
      'version': 1,
      'createdAt':
          DateTime.now().toIso8601String(),
      'data': data,
    });

    await prefs.setString(
      _backupKey,
      backup,
    );

    return backup;
  }

  Future<String?> getLastBackup() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      _backupKey,
    );
  }

  Future<bool> restoreBackup(
    String backup,
  ) async {
    try {
      final decoded =
          jsonDecode(backup);

      if (decoded is! Map) {
        return false;
      }

      final data =
          decoded['data'];

      if (data is! Map) {
        return false;
      }

      final prefs =
          await SharedPreferences.getInstance();

      for (final entry in data.entries) {
        final key =
            entry.key.toString();

        final value = entry.value;

        if (value is String) {
          await prefs.setString(
            key,
            value,
          );
        } else if (value is bool) {
          await prefs.setBool(
            key,
            value,
          );
        } else if (value is int) {
          await prefs.setInt(
            key,
            value,
          );
        } else if (value is double) {
          await prefs.setDouble(
            key,
            value,
          );
        } else if (value is List) {
          await prefs.setStringList(
            key,
            value
                .map(
                  (item) =>
                      item.toString(),
                )
                .toList(),
          );
        }
      }

      await prefs.setString(
        _backupKey,
        backup,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteBackup() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _backupKey,
    );
  }

  Future<bool> hasBackup() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.containsKey(
      _backupKey,
    );
  }
}
