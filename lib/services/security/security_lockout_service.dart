import 'package:shared_preferences/shared_preferences.dart';

class SecurityLockoutService {
  static const String _attemptsKey =
      'self_secure_failed_unlock_attempts';

  static const String _lockedUntilKey =
      'self_secure_locked_until';

  static const int maxAttempts = 5;

  static const Duration lockDuration =
      Duration(minutes: 5);

  Future<int> getFailedAttempts() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(_attemptsKey) ?? 0;
  }

  Future<bool> isLocked() async {
    final prefs =
        await SharedPreferences.getInstance();

    final value =
        prefs.getString(_lockedUntilKey);

    if (value == null || value.isEmpty) {
      return false;
    }

    final lockedUntil =
        DateTime.tryParse(value);

    if (lockedUntil == null) {
      await prefs.remove(_lockedUntilKey);
      return false;
    }

    if (DateTime.now().isBefore(lockedUntil)) {
      return true;
    }

    await reset();

    return false;
  }

  Future<int> registerFailure() async {
    final prefs =
        await SharedPreferences.getInstance();

    final attempts =
        (prefs.getInt(_attemptsKey) ?? 0) + 1;

    await prefs.setInt(
      _attemptsKey,
      attempts,
    );

    if (attempts >= maxAttempts) {
      final until =
          DateTime.now().add(lockDuration);

      await prefs.setString(
        _lockedUntilKey,
        until.toIso8601String(),
      );
    }

    return attempts;
  }

  Future<void> registerSuccess() async {
    await reset();
  }

  Future<void> reset() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_attemptsKey);
    await prefs.remove(_lockedUntilKey);
  }

  Future<Duration?> remainingLockTime() async {
    final prefs =
        await SharedPreferences.getInstance();

    final value =
        prefs.getString(_lockedUntilKey);

    if (value == null) {
      return null;
    }

    final until =
        DateTime.tryParse(value);

    if (until == null) {
      return null;
    }

    final remaining =
        until.difference(DateTime.now());

    if (remaining.isNegative) {
      await reset();
      return null;
    }

    return remaining;
  }
}
