import 'device_info_service.dart';

class DeviceInformationService {
  DeviceInformationService._();

  static final DeviceInformationService instance =
      DeviceInformationService._();

  final DeviceInfoService _service =
      DeviceInfoService.instance;

  Future<Map<String, dynamic>> getInformation() async {
    final info = await _service.getInfo();

    return {
      'device': info,
      'model': await _service.getModel(),
      'platform': await _service.getPlatform(),
      'timestamp':
          DateTime.now().toIso8601String(),
    };
  }
}
