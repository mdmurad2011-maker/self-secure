import '../security/security_alert_manager.dart';
import '../security/security_event_factory.dart';
import '../security/security_event_recorder.dart';
import 'alarm_service.dart';

class AntiTheftService {
  AntiTheftService._();

  static final AntiTheftService instance =
      AntiTheftService._();

  final AlarmService _alarm =
      AlarmService.instance;

  final SecurityAlertManager _alerts =
      SecurityAlertManager.instance;

  final SecurityEventRecorder _events =
      SecurityEventRecorder.instance;

  bool _armed = false;

  bool get isArmed => _armed;

  Future<void> arm() async {
    if (_armed) return;

    _armed = true;
  }

  Future<void> disarm() async {
    if (!_armed) return;

    _armed = false;

    await _alarm.stop();
  }

  Future<void> trigger({
    String reason = 'Anti-theft event detected',
  }) async {
    if (!_armed) return;

    await _alarm.start();

    final event =
        SecurityEventFactory.antiTheft(
      reason: reason,
    );

    await _events.record(event);

    await _alerts.antiTheftTriggered();
  }

  Future<void> testAlarm() {
    return _alarm.start();
  }

  Future<void> stopAlarm() {
    return _alarm.stop();
  }
}
