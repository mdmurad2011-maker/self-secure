class LostModeService {
  bool _enabled = false;

  bool get isEnabled => _enabled;

  Future<void> enable() async {
    _enabled = true;
  }

  Future<void> disable() async {
    _enabled = false;
  }

  Future<bool> status() async {
    return _enabled;
  }
}
