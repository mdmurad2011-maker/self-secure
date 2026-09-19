import 'app_lock_service.dart';
import 'biometric_service.dart';
import 'pin_service.dart';
import 'security_event_factory.dart';
import 'security_event_recorder.dart';
import 'security_lockout_service.dart';
import 'security_session_service.dart';

class AppLockController {
  AppLockController._();

  static final AppLockController instance =
      AppLockController._();

  final AppLockService _lockService =
      AppLockService.instance;

  final BiometricService _biometric =
      BiometricService.instance;

  final PinService _pin =
      PinService.instance;

  final SecurityLockoutService _lockout =
      SecurityLockoutService();

  final SecuritySessionService _session =
      SecuritySessionService.instance;

  final SecurityEventRecorder _events =
      SecurityEventRecorder.instance;

  Future<bool> isLocked() {
    return _lockService.isLocked();
  }

  Future<bool> isUnlocked() {
    return _session.isUnlocked();
  }

  Future<void> lock() async {
    await _session.endSession();
    await _lockService.lock();
  }

  Future<void> unlock() async {
    await _lockService.unlock();
    await _session.startSession();
    await _lockout.registerSuccess();
  }

  Future<bool> hasPin() {
    return _pin.hasPin();
  }

  Future<int> failedAttempts() {
    return _lockout.getFailedAttempts();
  }

  Future<bool> isLockoutActive() {
    return _lockout.isLocked();
  }

  Future<Duration?> remainingLockTime() {
    return _lockout.remainingLockTime();
  }

  Future<bool> verifyPin(String pin) async {
    if (await _lockout.isLocked()) {
      return false;
    }

    final valid =
        await _pin.verifyPin(pin);

    if (valid) {
      await unlock();
      return true;
    }

    final attempts =
        await _lockout.registerFailure();

    await _events.record(
      SecurityEventFactory.appLockFailed(
        attempt: attempts,
      ),
    );

    return false;
  }

  Future<bool> canUseBiometric() {
    return _biometric.isAvailable();
  }

  Future<bool> unlockWithBiometric() async {
    if (await _lockout.isLocked()) {
      return false;
    }

    final authenticated =
        await _biometric.authenticate();

    if (authenticated) {
      await unlock();
      return true;
    }

    final attempts =
        await _lockout.registerFailure();

    await _events.record(
      SecurityEventFactory.appLockFailed(
        attempt: attempts,
      ),
    );

    return false;
  }
}
