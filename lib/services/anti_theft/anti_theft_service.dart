class AntiTheftService {
  bool _armed = false;
  bool _lostMode = false;

  bool get isArmed => _armed;
  bool get isLostMode => _lostMode;

  Future<void> arm() async {
    _armed = true;
  }

  Future<void> disarm() async {
    _armed = false;
    _lostMode = false;
  }

  Future<void> enableLostMode() async {
    _lostMode = true;
    _armed = true;
  }

  Future<void> disableLostMode() async {
    _lostMode = false;
  }

  Future<void> triggerTheftEvent() async {
    if (!_armed) return;

    // Event handling is intentionally kept separate
    // so the security event service can record it.
  }
}
