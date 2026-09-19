import 'security_email_service.dart';
import 'security_notification_factory.dart';
import 'security_notification_recorder.dart';

class SecurityAlertService {
  SecurityAlertService._();

  static final SecurityAlertService instance =
      SecurityAlertService._();

  final SecurityEmailService _email =
      SecurityEmailService();

  final SecurityNotificationRecorder
      _notifications =
      SecurityNotificationRecorder.instance;

  Future<void> sendAlert({
    required String title,
    required String message,
  }) async {
    final notification =
        SecurityNotificationFactory.create(
      title: title,
      message: message,
    );

    await _notifications.record(
      notification,
    );

    final enabled =
        await _email.isEnabled();

    final email =
        await _email.getEmail();

    if (enabled &&
        email != null &&
        email.trim().isNotEmpty) {
      await _email.send(
        to: email.trim(),
        subject: title,
        body: message,
      );
    }
  }
}
