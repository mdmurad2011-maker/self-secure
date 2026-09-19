class SecurityConstants {
  static const int minPinLength = 4;
  static const int maxPinLength = 6;

  static const String appName = 'SELF SECURE';

  static const String eventUnlockSuccess = 'unlock_success';
  static const String eventUnlockFailed = 'unlock_failed';
  static const String eventBiometricSuccess = 'biometric_success';
  static const String eventBiometricFailed = 'biometric_failed';
  static const String eventDeviceBound = 'device_bound';
}
