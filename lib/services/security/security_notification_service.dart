import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/security_notification.dart';

class SecurityNotificationService {
  static const String _key =
      'self_secure_security_notifications';

  Future<List<SecurityNotification>>
      getNotifications() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    return values.map((value) {
      return SecurityNotification.fromJson(
        jsonDecode(value)
            as Map<String, dynamic>,
      );
    }).toList()
      ..sort(
        (a, b) =>
            b.createdAt.compareTo(
          a.createdAt,
        ),
      );
  }

  Future<void> addNotification(
    SecurityNotification notification,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final notifications =
        await getNotifications();

    notifications.removeWhere(
      (item) => item.id == notification.id,
    );

    notifications.insert(
      0,
      notification,
    );

    final limited =
        notifications.take(500).toList();

    await prefs.setStringList(
      _key,
      limited.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }

  Future<void> markAsRead(
    String id,
  ) async {
    final notifications =
        await getNotifications();

    final index = notifications.indexWhere(
      (item) => item.id == id,
    );

    if (index < 0) return;

    notifications[index] =
        notifications[index].copyWith(
      read: true,
    );

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      _key,
      notifications.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }

  Future<void> markAllAsRead() async {
    final notifications =
        await getNotifications();

    final updated =
        notifications.map(
      (item) => item.copyWith(
        read: true,
      ),
    ).toList();

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      _key,
      updated.map(
        (item) => jsonEncode(
          item.toJson(),
        ),
      ).toList(),
    );
  }

  Future<void> clearNotifications() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
