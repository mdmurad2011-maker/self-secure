import '../security/security_alert_manager.dart';
import '../security/security_event_factory.dart';
import '../security/security_event_recorder.dart';

class LostModeService {
  LostModeService();

  static final LostModeService instance =
      LostModeService();

  final SecurityAlertManager _alerts =
      SecurityAlertManager.instance;

  final SecurityEventRecorder _events =
      SecurityEventRecorder.instance;

  bool _enabled = false;

  bool get isEnabled => _enabled;

  Future<void> enable() async {
    if (_enabled) return;

    _enabled = true;

    final event = SecurityEventFactory.lostMode(
      enabled: true,
    );

    await _events.record(event);
    await _alerts.lostModeEnabled();
  }

  Future<void> disable() async {
    if (!_enabled) return;

    _enabled = false;

    final event = SecurityEventFactory.lostMode(
      enabled: false,
    );

    await _events.record(event);
    await _alerts.lostModeEnabled();
  }

  Future<void> toggle() async {
    if (_enabled) {
      await disable();
    } else {
      await enable();
    }
  }
}
