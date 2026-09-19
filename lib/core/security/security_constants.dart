class SecurityConstants {
  SecurityConstants._();

  static const int minPinLength = 4;
  static const int maxPinLength = 6;

  static const int maxSecurityEvents = 500;
  static const int maxSecurityNotifications = 500;
  static const int maxLocationHistory = 1000;

  static const Duration authenticationTimeout =
      Duration(seconds: 30);

  static const Duration notificationTimeout =
      Duration(seconds: 5);

  static const String appName = 'SELF SECURE';

  static const String securityChannelId =
      'self_secure_security';

  static const String securityChannelName =
      'Security Notifications';

  static const String securityChannelDescription =
      'SELF SECURE security alerts and notifications';
}
