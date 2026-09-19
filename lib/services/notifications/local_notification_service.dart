import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService instance =
      LocalNotificationService._();

  LocalNotificationService._();

  final FlutterLocalNotificationsPlugin
      _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings);

    _initialized = true;
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();

    const details =
        NotificationDetails(
      android: AndroidNotificationDetails(
        'self_secure_security',
        'SELF SECURE Security',
        channelDescription:
            'Security alerts and notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id,
      title,
      body,
      details,
    );
  }
}
