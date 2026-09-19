import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService._();

  static final BiometricService instance =
      BiometricService._();

  final LocalAuthentication _auth =
      LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> availableBiometrics() async {
    try {
      if (!await isAvailable()) {
        return <BiometricType>[];
      }

      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate() async {
    try {
      if (!await isAvailable()) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason:
            'Authenticate to access SELF SECURE',
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

  Future<bool> hasFingerprintOrFace() async {
    final biometrics =
        await availableBiometrics();

    return biometrics.isNotEmpty;
  }
}
