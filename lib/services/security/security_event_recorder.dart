import '../../models/security_event.dart';
import 'security_event_service.dart';

class SecurityEventRecorder {
  SecurityEventRecorder._();

  static final SecurityEventRecorder instance =
      SecurityEventRecorder._();

  final SecurityEventService _service =
      SecurityEventService();

  Future<void> record(
    SecurityEvent event,
  ) async {
    await _service.addEvent(event);
  }

  Future<List<SecurityEvent>> all() {
    return _service.getEvents();
  }

  Future<void> clear() {
    return _service.clearEvents();
  }
}
