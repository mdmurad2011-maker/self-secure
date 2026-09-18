import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const AppLockScreen({
    super.key,
    required this.onUnlocked,
  });

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  String _pin = '';
  String _savedPin = '';
  bool _biometricAvailable = false;
  bool _loading = true;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadSecurity();
  }

  Future<void> _loadSecurity() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedPin = prefs.getString('security_pin');

    if (savedPin == null || savedPin.isEmpty) {
      savedPin = '1234';

      await prefs.setString(
        'security_pin',
        savedPin,
      );
    }

    bool biometric = false;

    try {
      biometric = await _auth.canCheckBiometrics &&
          await _auth.isDeviceSupported();
    } catch (_) {
      biometric = false;
    }

    if (!mounted) return;

    setState(() {
      _savedPin = savedPin!;
      _biometricAvailable = biometric;
      _loading = false;
    });
  }

  void _addNumber(String number) {
    if (_pin.length >= 6) return;

    setState(() {
      _pin += number;
      _message = '';
    });

    if (_pin.length == 4) {
      _checkPin();
    }
  }

  void _removeNumber() {
    if (_pin.isEmpty) return;

    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _message = '';
    });
  }

  void _checkPin() {
    if (_pin == _savedPin) {
      widget.onUnlocked();
      return;
    }

    setState(() {
      _pin = '';
      _message = 'Incorrect PIN';
    });
  }

  Future<void> _authenticateWithBiometric() async {
    if (!_biometricAvailable) return;

    try {
      final authenticated = await _auth.authenticate(
        localizedReason:
            'Authenticate to open SELF SECURE',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (authenticated && mounted) {
        widget.onUnlocked();
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _message = 'Biometric authentication failed';
      });
    }
  }

  Widget _pinButton(String value) {
    return SizedBox(
      width: 72,
      height: 58,
      child: FilledButton(
        onPressed: () => _addNumber(value),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF101D2D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
        backgroundColor: Color(0xFF07111F),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFD66B),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            child: Column(
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(27),
                    gradient:
                        const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFD66B),
                        Color(0xFF9B6A18),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66D9A441),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 43,
                    color: Color(0xFF07111F),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'SELF SECURE',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Enter your security PIN',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) {
                      final filled =
                          index < _pin.length;

                      return Container(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? const Color(0xFFFFD66B)
                              : const Color(0xFF243449),
                          boxShadow: filled
                              ? const [
                                  BoxShadow(
                                    color:
                                        Color(0x66D9A441),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
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
                    style: const TextStyle(
                      color: Colors.redAccent,
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
                        onPressed: _removeNumber,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF101D2D),
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),
                        child: const Icon(
                          Icons.backspace_outlined,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                if (_biometricAvailable)
                  TextButton.icon(
                    onPressed:
                        _authenticateWithBiometric,
                    icon: const Icon(
                      Icons.fingerprint_rounded,
                      color: Color(0xFFFFD66B),
                      size: 28,
                    ),
                    label: const Text(
                      'Use Biometrics',
                      style: TextStyle(
                        color: Color(0xFFFFD66B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
