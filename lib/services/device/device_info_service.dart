import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  Future<AndroidDeviceInfo> getDeviceInfo() {
    return _plugin.androidInfo;
  }

  Future<String> getModel() async {
    final info = await getDeviceInfo();
    return info.model;
  }

  Future<String> getManufacturer() async {
    final info = await getDeviceInfo();
    return info.manufacturer;
  }

  Future<String> getAndroidVersion() async {
    final info = await getDeviceInfo();
    return info.version.release;
  }

  Future<String> getDeviceId() async {
    final info = await getDeviceInfo();
    return info.id;
  }

  Future<String> getSecurityPatch() async {
    final info = await getDeviceInfo();
    return info.version.securityPatch ?? 'Unknown';
  }
}
