import '../../models/security_event.dart';

class SecurityEventFactory {
  SecurityEventFactory._();

  static SecurityEvent create({
    required String type,
    required String title,
    required String description,
    bool critical = false,
  }) {
    return SecurityEvent(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      type: type,
      title: title,
      description: description,
      timestamp: DateTime.now(),
      critical: critical,
    );
  }

  static SecurityEvent antiTheft({
    required String reason,
  }) {
    return create(
      type: 'anti_theft',
      title: 'Anti-Theft Alert',
      description: reason,
      critical: true,
    );
  }

  static SecurityEvent antiTheftTriggered({
    String reason =
        'An anti-theft event was detected.',
  }) {
    return antiTheft(
      reason: reason,
    );
  }

  static SecurityEvent lostMode({
    required bool enabled,
  }) {
    return create(
      type: 'lost_mode',
      title: enabled
          ? 'Lost Mode Enabled'
          : 'Lost Mode Disabled',
      description: enabled
          ? 'Lost Mode has been enabled.'
          : 'Lost Mode has been disabled.',
    );
  }

  static SecurityEvent lostModeEnabled() {
    return lostMode(
      enabled: true,
    );
  }

  static SecurityEvent appLockFailed({
    int? attempt,
  }) {
    return create(
      type: 'app_lock_failed',
      title: 'Failed App Unlock',
      description:
          'An unsuccessful app unlock attempt was detected.',
      critical: true,
    );
  }

  static SecurityEvent deviceBindingChanged() {
    return create(
      type: 'device_binding_changed',
      title: 'Device Binding Changed',
      description:
          'The device binding state has changed.',
      critical: true,
    );
  }
}
