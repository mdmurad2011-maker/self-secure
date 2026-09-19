import 'security_alert_service.dart';
import 'security_event_factory.dart';
import 'security_event_recorder.dart';
import 'security_notification_factory.dart';
import 'security_notification_recorder.dart';

class SecurityAlertManager {
  SecurityAlertManager._();

  static final SecurityAlertManager instance =
      SecurityAlertManager._();

  final SecurityAlertService _alertService =
      SecurityAlertService.instance;

  final SecurityEventRecorder _eventRecorder =
      SecurityEventRecorder.instance;

  final SecurityNotificationRecorder
      _notificationRecorder =
      SecurityNotificationRecorder.instance;

  Future<void> appLockFailed({
    int? attempt,
  }) async {
    await _alertService.sendAlert(
      title: 'Failed App Unlock',
      message:
          'An unsuccessful app unlock attempt was detected.',
    );

    await _eventRecorder.record(
      SecurityEventFactory.appLockFailed(
        attempt: attempt,
      ),
    );

    await _notificationRecorder.record(
      SecurityNotificationFactory.appLockFailed(),
    );
  }

  Future<void> antiTheftTriggered({
    String reason = 'An anti-theft event was detected.',
  }) async {
    await _alertService.sendAlert(
      title: 'Anti-Theft Alert',
      message: reason,
    );

    await _eventRecorder.record(
      SecurityEventFactory.antiTheft(
        reason: reason,
      ),
    );

    await _notificationRecorder.record(
      SecurityNotificationFactory.antiTheftAlert(),
    );
  }

  Future<void> lostModeEnabled() async {
    await _alertService.sendAlert(
      title: 'Lost Mode Enabled',
      message: 'Lost Mode has been enabled.',
    );

    await _eventRecorder.record(
      SecurityEventFactory.lostMode(
        enabled: true,
      ),
    );

    await _notificationRecorder.record(
      SecurityNotificationFactory.lostModeEnabled(),
    );
  }

  Future<void> lostModeDisabled() async {
    await _alertService.sendAlert(
      title: 'Lost Mode Disabled',
      message: 'Lost Mode has been disabled.',
    );

    await _eventRecorder.record(
      SecurityEventFactory.lostMode(
        enabled: false,
      ),
    );
  }

  Future<void> deviceBindingChanged() async {
    await _alertService.sendAlert(
      title: 'Device Binding Changed',
      message:
          'The device binding state has changed.',
    );

    await _eventRecorder.record(
      SecurityEventFactory.deviceBindingChanged(),
    );

    await _notificationRecorder.record(
      SecurityNotificationFactory.deviceBindingChanged(),
    );
  }
}
