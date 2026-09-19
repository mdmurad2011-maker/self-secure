import 'app_permission_service.dart';
import 'secure_settings_service.dart';
import 'security_email_service.dart';

class SecuritySettingsService {
  SecuritySettingsService._();

  static final SecuritySettingsService instance =
      SecuritySettingsService._();

  final SecureSettingsService _settings =
      SecureSettingsService();

  final SecurityEmailService _email =
      SecurityEmailService();

  final AppPermissionService _permissions =
      AppPermissionService.instance;

  Future<Map<String, dynamic>> getSettings() async {
    return {
      'screenshotProtection':
          await _settings.screenshotProtectionEnabled(),
      'autoLock':
          await _settings.autoLockEnabled(),
      'securityEmail':
          await _email.getEmail(),
      'emailAlerts':
          await _email.isEnabled(),
      'cameraPermission':
          await _permissions.isCameraGranted(),
      'locationPermission':
          await _permissions.isLocationGranted(),
      'notificationPermission':
          await _permissions.isNotificationGranted(),
    };
  }

  Future<bool> setScreenshotProtection(
    bool enabled,
  ) {
    return _settings.setScreenshotProtection(
      enabled,
    );
  }

  Future<bool> setAutoLock(
    bool enabled,
  ) {
    return _settings.setAutoLock(enabled);
  }

  Future<bool> setEmailAlerts(
    bool enabled,
  ) {
    return _email.setEnabled(enabled);
  }

  Future<bool> setSecurityEmail(
    String email,
  ) {
    return _email.setEmail(email);
  }
}
