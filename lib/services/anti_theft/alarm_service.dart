class AlarmService {
  bool _running = false;

  bool get isRunning => _running;

  Future<void> startAlarm() async {
    _running = true;
  }

  Future<void> stopAlarm() async {
    _running = false;
  }
}
