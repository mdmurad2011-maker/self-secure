import 'battery_service.dart';
import 'network_service.dart';

class DeviceStatusService {
  DeviceStatusService._();

  static final DeviceStatusService instance =
      DeviceStatusService._();

  final BatteryService _battery =
      BatteryService.instance;

  final NetworkService _network =
      NetworkService.instance;

  Future<Map<String, dynamic>> getStatus() async {
    final battery =
        await _battery.getLevel();

    final charging =
        await _battery.isCharging();

    final network =
        await _network.isConnected();

    return {
      'batteryLevel': battery,
      'charging': charging,
      'online': network,
      'timestamp':
          DateTime.now().toIso8601String(),
    };
  }
}
