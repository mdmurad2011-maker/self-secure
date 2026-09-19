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

    return values.map((value) {
      return ReminderModel.fromJson(
        jsonDecode(value)
            as Map<String, dynamic>,
      );
    }).toList()
      ..sort(
        (a, b) =>
            a.scheduledAt.compareTo(
          b.scheduledAt,
        ),
      );
  }

  Future<void> saveReminder(
    ReminderModel reminder,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final reminders =
        await getReminders();

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
      reminders.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }

  Future<void> deleteReminder(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final reminders =
        await getReminders();

    reminders.removeWhere(
      (item) => item.id == id,
    );

    await prefs.setStringList(
      _key,
      reminders.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }
}
