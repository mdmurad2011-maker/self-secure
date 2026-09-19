import 'package:flutter/services.dart';

class AlarmService {
  AlarmService();

  static final AlarmService instance =
      AlarmService();

  bool _running = false;

  bool get isRunning => _running;

  Future<void> startAlarm() async {
    if (_running) return;

    _running = true;

    try {
      await SystemSound.play(
        SystemSoundType.alert,
      );
    } catch (_) {
      // System sound may not be available.
    }
  }

  Future<void> stopAlarm() async {
    _running = false;
  }

  Future<void> start() => startAlarm();

  Future<void> stop() => stopAlarm();
}
