import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService._();

  static final DeviceInfoService instance =
      DeviceInfoService._();

  final DeviceInfoPlugin _plugin =
      DeviceInfoPlugin();

  Future<AndroidDeviceInfo?> _getAndroidInfo() async {
    try {
      return await _plugin.androidInfo;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getInfo() async {
    final android = await _getAndroidInfo();

    if (android == null) {
      return {
        'platform': 'unknown',
      };
    }

    return {
      'platform': 'android',
      'brand': android.brand,
      'manufacturer': android.manufacturer,
      'model': android.model,
      'device': android.device,
      'product': android.product,
      'androidVersion': android.version.release,
      'sdkInt': android.version.sdkInt,
      'physicalDevice': android.isPhysicalDevice,
      'securityPatch': android.version.securityPatch,
      'id': android.id,
    };
  }

  Future<String> getModel() async {
    final android = await _getAndroidInfo();

    return android?.model ?? 'Unknown Device';
  }

  Future<String> getManufacturer() async {
    final android = await _getAndroidInfo();

    return android?.manufacturer ?? 'Unknown';
  }

  Future<String> getAndroidVersion() async {
    final android = await _getAndroidInfo();

    return android?.version.release ?? 'Unknown';
  }

  Future<String> getDeviceId() async {
    final android = await _getAndroidInfo();

    return android?.id ?? 'Unknown';
  }

  Future<String> getSecurityPatch() async {
    final android = await _getAndroidInfo();

    return android?.version.securityPatch ?? 'Unknown';
  }

  Future<String> getPlatform() async {
    final android = await _getAndroidInfo();

    return android == null ? 'unknown' : 'android';
  }
}