import 'dart:async';

class DeviceHeartbeatService {
  Timer? _timer;

  bool _running = false;

  bool get isRunning => _running;

  void start({
    Duration interval =
        const Duration(minutes: 1),
    required Future<void> Function() onHeartbeat,
  }) {
    stop();

    _running = true;

    onHeartbeat();

    _timer = Timer.periodic(
      interval,
      (_) {
        onHeartbeat();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  void dispose() {
    stop();
  }
}
