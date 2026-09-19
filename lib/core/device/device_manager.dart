import '../../models/device_model.dart';
import '../../services/device/battery_service.dart';
import '../../services/device/device_info_service.dart';

class DeviceManager {
  DeviceManager._();

  static final DeviceManager instance =
      DeviceManager._();

  final DeviceInfoService _deviceInfo =
      DeviceInfoService.instance;

  final BatteryService _battery =
      BatteryService.instance;

  Future<DeviceModel> getDeviceInfo() async {
    final info =
        await _deviceInfo.getInfo();

    return DeviceModel(
      model:
          info['model']?.toString() ??
              'Unknown Device',

      manufacturer:
          info['manufacturer']?.toString() ??
              'Unknown Manufacturer',

      androidVersion:
          info['androidVersion']?.toString() ??
              'Unknown Android',

      deviceId:
          info['device']?.toString() ??
              'Unknown Device ID',

      batteryLevel:
          await _battery.getLevel(),

      isCharging:
          await _battery.isCharging(),

      securityPatch:
          'Not available',
    );
  }
}
