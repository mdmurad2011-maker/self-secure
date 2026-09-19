class DeviceModel {
  final String model;
  final String manufacturer;
  final String androidVersion;
  final String deviceId;
  final int batteryLevel;
  final bool isCharging;
  final String securityPatch;

  const DeviceModel({
    required this.model,
    required this.manufacturer,
    required this.androidVersion,
    required this.deviceId,
    required this.batteryLevel,
    required this.isCharging,
    required this.securityPatch,
  });
}
