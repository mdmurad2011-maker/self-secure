import '../../models/security_notification.dart';

class SecurityNotificationFactory {
  SecurityNotificationFactory._();

  static SecurityNotification create({
    required String title,
    required String message,
  }) {
    return SecurityNotification(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      title: title,
      message: message,
      createdAt: DateTime.now(),
      read: false,
    );
  }

  static SecurityNotification antiTheft({
    String message =
        'An anti-theft event was detected.',
  }) {
    return create(
      title: 'Anti-Theft Alert',
      message: message,
    );
  }

  static SecurityNotification antiTheftAlert() {
    return antiTheft();
  }

  static SecurityNotification lostMode({
    required bool enabled,
  }) {
    return create(
      title: enabled
          ? 'Lost Mode Enabled'
          : 'Lost Mode Disabled',
      message: enabled
          ? 'Lost Mode is now active.'
          : 'Lost Mode has been disabled.',
    );
  }

  static SecurityNotification lostModeEnabled() {
    return lostMode(
      enabled: true,
    );
  }

  static SecurityNotification appLockFailed({
    int? attempt,
  }) {
    final suffix = attempt == null
        ? ''
        : ' Attempt: $attempt.';

    return create(
      title: 'Security Alert',
      message:
          'A failed app unlock attempt was detected.$suffix',
    );
  }

  static SecurityNotification deviceBindingChanged() {
    return create(
      title: 'Device Binding Changed',
      message:
          'The device binding state has changed.',
    );
  }
}
