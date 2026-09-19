import '../../models/security_notification.dart';
import 'security_notification_service.dart';

class SecurityNotificationRecorder {
  SecurityNotificationRecorder._();

  static final SecurityNotificationRecorder instance =
      SecurityNotificationRecorder._();

  final SecurityNotificationService _service =
      SecurityNotificationService();

  Future<void> record(
    SecurityNotification notification,
  ) async {
    await _service.addNotification(
      notification,
    );
  }

  Future<List<SecurityNotification>> all() {
    return _service.getNotifications();
  }

  Future<void> markAsRead(String id) {
    return _service.markAsRead(id);
  }

  Future<void> markAllAsRead() {
    return _service.markAllAsRead();
  }

  Future<void> clear() {
    return _service.clearNotifications();
  }
}
