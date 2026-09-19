import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  PermissionUtils._();

  static Future<bool> requestLocation() async {
    final status =
        await Permission.location.request();

    return status.isGranted;
  }

  static Future<bool> requestCamera() async {
    final status =
        await Permission.camera.request();

    return status.isGranted;
  }

  static Future<bool> requestNotifications() async {
    final status =
        await Permission.notification.request();

    return status.isGranted;
  }

  static Future<bool> isLocationGranted() async {
    return Permission.location.isGranted;
  }

  static Future<bool> isCameraGranted() async {
    return Permission.camera.isGranted;
  }

  static Future<bool> isNotificationGranted() async {
    return Permission.notification.isGranted;
  }

  static Future<bool> openSettings() async {
    return openAppSettings();
  }
}
