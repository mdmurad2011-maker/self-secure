import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  AppPermissionService._();

  static final AppPermissionService instance =
      AppPermissionService._();

  Future<bool> requestCamera() async {
    final status =
        await Permission.camera.request();

    return status.isGranted;
  }

  Future<bool> requestLocation() async {
    final status =
        await Permission.location.request();

    return status.isGranted;
  }

  Future<bool> requestNotifications() async {
    final status =
        await Permission.notification.request();

    return status.isGranted;
  }

  Future<bool> isCameraGranted() async {
    return Permission.camera.isGranted;
  }

  Future<bool> isLocationGranted() async {
    return Permission.location.isGranted;
  }

  Future<bool> isNotificationGranted() async {
    return Permission.notification.isGranted;
  }

  Future<bool> openSettings() async {
    return openAppSettings();
  }
}
