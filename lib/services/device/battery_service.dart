import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> getLevel() {
    return _battery.batteryLevel;
  }

  Future<BatteryState> getState() {
    return _battery.batteryState;
  }

  Future<bool> isCharging() async {
    final state = await getState();

    return state == BatteryState.charging ||
        state == BatteryState.full;
  }

  Stream<BatteryState> get stateStream {
    return _battery.onBatteryStateChanged;
  }
}
