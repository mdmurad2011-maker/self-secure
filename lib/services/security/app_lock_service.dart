import 'package:local_auth/local_auth.dart';

import 'pin_service.dart';

class AppLockService {
  AppLockService._();

  static final AppLockService instance =
      AppLockService._();

  final LocalAuthentication _auth =
      LocalAuthentication();

  final PinService _pinService =
      PinService.instance;

  bool _locked = false;

  bool get isLockedState => _locked;

  Future<bool> isLocked() async {
    return _locked;
  }

  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateBiometric() async {
    if (!await isBiometricAvailable()) {
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason:
            'Authenticate to unlock SELF SECURE',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateWithPin(
    String pin,
  ) async {
    return _pinService.verifyPin(pin);
  }

  Future<bool> authenticate({
    String? pin,
    bool useBiometric = true,
  }) async {
    if (useBiometric) {
      final biometricResult =
          await authenticateBiometric();

      if (biometricResult) {
        _locked = false;
        return true;
      }
    }

    if (pin != null && pin.isNotEmpty) {
      final pinResult =
          await authenticateWithPin(pin);

      if (pinResult) {
        _locked = false;
      }

      return pinResult;
    }

    return false;
  }

  Future<bool> canUsePin() async {
    return _pinService.hasPin();
  }

  Future<void> lock() async {
    _locked = true;
  }

  Future<void> unlock() async {
    _locked = false;
  }
}
