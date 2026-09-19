import 'dart:async';

import 'package:flutter/material.dart';

import '../services/security/app_lock_controller.dart';

class AppLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const AppLockScreen({
    super.key,
    required this.onUnlocked,
  });

  @override
  State<AppLockScreen> createState() =>
      _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final AppLockController _controller =
      AppLockController.instance;

  String _pin = '';
  bool _biometricAvailable = false;
  bool _loading = true;
  bool _busy = false;
  bool _lockedOut = false;
  String _message = '';
  Duration? _remaining;

  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    _loadSecurity();
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSecurity() async {
    try {
      final biometric =
          await _controller.canUseBiometric();

      final locked =
          await _controller.isLockoutActive();

      final remaining =
          await _controller.remainingLockTime();

      if (!mounted) return;

      setState(() {
        _biometricAvailable = biometric;
        _lockedOut = locked;
        _remaining = remaining;
        _loading = false;
      });

      if (locked) {
        _startLockoutTimer();
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _biometricAvailable = false;
      });
    }
  }

  void _startLockoutTimer() {
    _lockoutTimer?.cancel();

    _lockoutTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final remaining =
            await _controller.remainingLockTime();

        if (!mounted) return;

        if (remaining == null) {
          _lockoutTimer?.cancel();

          setState(() {
            _lockedOut = false;
            _remaining = null;
            _message = '';
          });

          return;
        }

        setState(() {
          _lockedOut = true;
          _remaining = remaining;
          _pin = '';
        });
      },
    );
  }

  String _formatRemaining(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60);
    final seconds =
        duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _addNumber(String number) {
    if (_busy || _lockedOut) return;

    if (_pin.length >= 8) return;

    setState(() {
      _pin += number;
      _message = '';
    });

    if (_pin.length == 4) {
      _checkPin();
    }
  }

  void _removeNumber() {
    if (_busy || _lockedOut || _pin.isEmpty) {
      return;
    }

    setState(() {
      _pin =
          _pin.substring(0, _pin.length - 1);
      _message = '';
    });
  }

  Future<void> _checkPin() async {
    if (_busy ||
        _lockedOut ||
        _pin.length < 4) {
      return;
    }

    setState(() {
      _busy = true;
      _message = '';
    });

    final unlocked =
        await _controller.verifyPin(_pin);

    if (!mounted) return;

    if (unlocked) {
      widget.onUnlocked();
      return;
    }

    final locked =
        await _controller.isLockoutActive();

    final remaining =
        await _controller.remainingLockTime();

    final attempts =
        await _controller.failedAttempts();

    if (locked) {
      setState(() {
        _pin = '';
        _busy = false;
        _lockedOut = true;
        _remaining = remaining;
        _message =
            'Too many failed attempts';
      });

      _startLockoutTimer();
      return;
    }

    setState(() {
      _pin = '';
      _busy = false;
      _message =
          'Incorrect PIN • Attempt $attempts/5';
    });
  }

  Future<void> _authenticateWithBiometric() async {
    if (_busy ||
        _lockedOut ||
        !_biometricAvailable) {
      return;
    }

    setState(() {
      _busy = true;
      _message = '';
    });

    final authenticated =
        await _controller.unlockWithBiometric();

    if (!mounted) return;

    if (authenticated) {
      widget.onUnlocked();
      return;
    }

    final locked =
        await _controller.isLockoutActive();

    final remaining =
        await _controller.remainingLockTime();

    if (locked) {
      setState(() {
        _busy = false;
        _lockedOut = true;
        _remaining = remaining;
        _message =
            'Too many failed attempts';
      });

      _startLockoutTimer();
      return;
    }

    setState(() {
      _busy = false;
      _message =
          'Biometric authentication failed';
    });
  }

  Widget _pinButton(String value) {
    return SizedBox(
      width: 72,
      height: 58,
      child: FilledButton(
        onPressed:
            (_busy || _lockedOut)
                ? null
                : () => _addNumber(value),
        style: FilledButton.styleFrom(
          backgroundColor:
              const Color(0xFF101D2D),
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              const Color(0xFF101D2D),
          disabledForegroundColor:
              Colors.white38,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
            side: const BorderSide(
              color: Color(0x1FD9A441),
            ),
          ),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _pinRow(
    String a,
    String b,
    String c,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        _pinButton(a),
        const SizedBox(width: 12),
        _pinButton(b),
        const SizedBox(width: 12),
        _pinButton(c),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor:
            Color(0xFF07111F),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFD66B),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFF07111F),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            child: Column(
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration:
                      BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(27),
                    gradient:
                        const LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFD66B),
                        Color(0xFF9B6A18),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                            Color(0x66D9A441),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 43,
                    color:
                        Color(0xFF07111F),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'SELF SECURE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight:
                        FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _lockedOut
                      ? 'Security lockout active'
                      : 'Enter your security PIN',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                if (_lockedOut &&
                    _remaining != null) ...[
                  const Icon(
                    Icons.lock_clock_rounded,
                    color:
                        Color(0xFFFFD66B),
                    size: 42,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _formatRemaining(
                      _remaining!,
                    ),
                    style: const TextStyle(
                      color:
                          Color(0xFFFFD66B),
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Please wait before trying again',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children:
                        List.generate(
                      4,
                      (index) {
                        final filled =
                            index < _pin.length;

                        return Container(
                          margin:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 7,
                          ),
                          width: 14,
                          height: 14,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color: filled
                                ? const Color(
                                    0xFFFFD66B)
                                : const Color(
                                    0xFF243449),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 25,
                    child: Text(
                      _message,
                      style:
                          const TextStyle(
                        color:
                            Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  _pinRow('1', '2', '3'),
                  const SizedBox(height: 12),
                  _pinRow('4', '5', '6'),
                  const SizedBox(height: 12),
                  _pinRow('7', '8', '9'),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 72),
                      const SizedBox(width: 12),

                      _pinButton('0'),

                      const SizedBox(width: 12),

                      SizedBox(
                        width: 72,
                        height: 58,
                        child: FilledButton(
                          onPressed:
                              (_busy ||
                                      _lockedOut)
                                  ? null
                                  : _removeNumber,
                          style:
                              FilledButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF101D2D,
                            ),
                            foregroundColor:
                                Colors.white,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .backspace_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  if (_biometricAvailable)
                    TextButton.icon(
                      onPressed:
                          (_busy ||
                                  _lockedOut)
                              ? null
                              : _authenticateWithBiometric,
                      icon: const Icon(
                        Icons
                            .fingerprint_rounded,
                        color:
                            Color(0xFFFFD66B),
                        size: 28,
                      ),
                      label: const Text(
                        'Use Biometrics',
                        style: TextStyle(
                          color:
                              Color(0xFFFFD66B),
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                  if (_busy)
                    const Padding(
                      padding:
                          EdgeInsets.only(
                        top: 8,
                      ),
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                            Color(0xFFFFD66B),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
