import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  BatteryService._();

  static final BatteryService instance =
      BatteryService._();

  final Battery _battery = Battery();

  Future<int> getLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (_) {
      return -1;
    }
  }

  Future<BatteryState> getState() async {
    try {
      return await _battery.batteryState;
    } catch (_) {
      return BatteryState.unknown;
    }
  }

  Future<bool> isCharging() async {
    final state = await getState();

    return state == BatteryState.charging ||
        state == BatteryState.full;
  }

  Future<bool> isFull() async {
    final state = await getState();

    return state == BatteryState.full;
  }
}
