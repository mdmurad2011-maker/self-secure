import 'battery_service.dart';
import 'device_info_service.dart';
import 'device_status_service.dart';
import 'network_service.dart';

class DeviceOverviewService {
  DeviceOverviewService._();

  static final DeviceOverviewService instance =
      DeviceOverviewService._();

  final DeviceInfoService _info =
      DeviceInfoService.instance;

  final BatteryService _battery =
      BatteryService.instance;

  final NetworkService _network =
      NetworkService.instance;

  final DeviceStatusService _status =
      DeviceStatusService.instance;

  Future<Map<String, dynamic>> getOverview() async {
    final info =
        await _info.getInfo();

    final battery =
        await _battery.getLevel();

    final charging =
        await _battery.isCharging();

    final online =
        await _network.isConnected();

    final status =
        await _status.getStatus();

    return {
      'device': info,
      'batteryLevel': battery,
      'charging': charging,
      'online': online,
      'status': status,
      'timestamp':
          DateTime.now().toIso8601String(),
    };
  }
}
