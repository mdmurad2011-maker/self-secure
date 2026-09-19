import '../../models/device_model.dart';
import '../../services/device/battery_service.dart';
import '../../services/device/device_info_service.dart';

class DeviceManager {
  final DeviceInfoService _deviceInfo =
      DeviceInfoService();

  final BatteryService _battery =
      BatteryService();

  Future<DeviceModel> getDeviceInfo() async {
    return DeviceModel(
      model: await _deviceInfo.getModel(),
      manufacturer:
          await _deviceInfo.getManufacturer(),
      androidVersion:
          await _deviceInfo.getAndroidVersion(),
      deviceId:
          await _deviceInfo.getDeviceId(),
      batteryLevel:
          await _battery.getLevel(),
      isCharging:
          await _battery.isCharging(),
      securityPatch:
          await _deviceInfo.getSecurityPatch(),
    );
  }
}
