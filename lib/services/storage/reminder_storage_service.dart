import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/reminder_model.dart';

class ReminderStorageService {
  static const String _key =
      'self_secure_reminders';

  Future<List<ReminderModel>> getReminders() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    final reminders = <ReminderModel>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          reminders.add(
            ReminderModel.fromJson(decoded),
          );
        }
      } catch (_) {
        // Ignore invalid stored entries.
      }
    }

    return reminders;
  }

  Future<void> saveReminder(
    ReminderModel reminder,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final reminders = await getReminders();

    final index = reminders.indexWhere(
      (item) => item.id == reminder.id,
    );

    if (index >= 0) {
      reminders[index] = reminder;
    } else {
      reminders.add(reminder);
    }

    await prefs.setStringList(
      _key,
      reminders
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> deleteReminder(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final reminders = await getReminders();

    reminders.removeWhere(
      (item) => item.id == id,
    );

    await prefs.setStringList(
      _key,
      reminders
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> clearReminders() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
