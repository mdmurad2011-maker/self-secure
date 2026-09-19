import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends State<SecuritySettingsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _biometricEnabled = true;
  bool _securityNotifications = true;
  bool _screenshotProtection = true;

  bool _loading = true;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bool biometricAvailable = false;

      try {
        biometricAvailable =
            await _localAuth.canCheckBiometrics ||
            await _localAuth.isDeviceSupported();
      } catch (_) {
        biometricAvailable = false;
      }

      if (!mounted) return;

      setState(() {
        _biometricEnabled =
            prefs.getBool('biometric_enabled') ?? true;

        _securityNotifications =
            prefs.getBool('security_notifications') ?? true;

        _screenshotProtection =
            prefs.getBool('screenshot_protection') ?? true;

        _biometricAvailable = biometricAvailable;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _setBiometric(bool value) async {
    if (value && !_biometricAvailable) {
      _showMessage(
        'Biometric authentication is not available on this device.',
      );
      return;
    }

    if (value) {
      try {
        final authenticated = await _localAuth.authenticate(
          localizedReason:
              'Authenticate to enable biometric security',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );

        if (!authenticated) {
          return;
        }
      } catch (_) {
        _showMessage(
          'Biometric authentication could not be started.',
        );
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'biometric_enabled',
      value,
    );

    if (!mounted) return;

    setState(() {
      _biometricEnabled = value;
    });

    _showMessage(
      value
          ? 'Biometric security enabled'
          : 'Biometric security disabled',
    );
  }

  Future<void> _setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'security_notifications',
      value,
    );

    if (!mounted) return;

    setState(() {
      _securityNotifications = value;
    });

    _showMessage(
      value
          ? 'Security notifications enabled'
          : 'Security notifications disabled',
    );
  }

  Future<void> _setScreenshotProtection(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'screenshot_protection',
      value,
    );

    if (!mounted) return;

    setState(() {
      _screenshotProtection = value;
    });

    _showMessage(
      value
          ? 'Screenshot protection enabled'
          : 'Screenshot protection disabled',
    );
  }

  Future<void> _changePin() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101D2D),
          title: const Text(
            'Change Security PIN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _pinField(
                  controller: currentController,
                  label: 'Current PIN',
                ),
                const SizedBox(height: 12),
                _pinField(
                  controller: newController,
                  label: 'New PIN',
                ),
                const SizedBox(height: 12),
                _pinField(
                  controller: confirmController,
                  label: 'Confirm New PIN',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final prefs =
                    await SharedPreferences.getInstance();

                final savedPin =
                    prefs.getString('security_pin');

                if (savedPin == null ||
                    savedPin.isEmpty) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No existing PIN was found.',
                      ),
                    ),
                  );
                  return;
                }

                if (currentController.text != savedPin) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Current PIN is incorrect',
                      ),
                    ),
                  );
                  return;
                }

                if (!RegExp(
                  r'^\d{4,6}$',
                ).hasMatch(newController.text)) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'PIN must contain 4 to 6 digits',
                      ),
                    ),
                  );
                  return;
                }

                if (newController.text !=
                    confirmController.text) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'New PIN confirmation does not match',
                      ),
                    ),
                  );
                  return;
                }

                await prefs.setString(
                  'security_pin',
                  newController.text,
                );

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (result == true && mounted) {
      _showMessage(
        'Security PIN changed successfully',
      );
    }
  }

  Widget _pinField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      maxLength: 6,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white60,
        ),
        counterStyle: const TextStyle(
          color: Colors.white38,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0x335C6B80),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFD9A441),
          ),
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF101D2D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x1FD9A441),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0x16D9A441),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFFD66B),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07111F),
        elevation: 0,
        title: const Text(
          'Security Settings',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD9A441),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadSettings,
              color: const Color(0xFFD9A441),
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    margin:
                        const EdgeInsets.only(bottom: 22),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A2D44),
                          Color(0xFF0D1828),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0x33D9A441),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color:
                                const Color(0x16D9A441),
                            borderRadius:
                                BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            color: Color(0xFFFFD66B),
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'SELF SECURE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Protect your device and personal data',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    'Authentication',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _settingTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Authentication',
                    subtitle: _biometricAvailable
                        ? 'Use fingerprint or Face authentication'
                        : 'Biometric authentication unavailable',
                    trailing: Switch(
                      value: _biometricEnabled &&
                          _biometricAvailable,
                      onChanged:
                          _biometricAvailable
                              ? _setBiometric
                              : null,
                      activeThumbColor:
                          const Color(0xFFD9A441),
                    ),
                  ),

                  _settingTile(
                    icon: Icons.pin_rounded,
                    title: 'Security PIN',
                    subtitle:
                        'Change your application security PIN',
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white54,
                    ),
                    onTap: _changePin,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Privacy & Alerts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _settingTile(
                    icon: Icons.notifications_active_rounded,
                    title: 'Security Notifications',
                    subtitle:
                        'Receive alerts for security events',
                    trailing: Switch(
                      value: _securityNotifications,
                      onChanged: _setNotifications,
                      activeThumbColor:
                          const Color(0xFFD9A441),
                    ),
                  ),

                  _settingTile(
                    icon: Icons.screenshot_monitor_rounded,
                    title: 'Screenshot Protection',
                    subtitle:
                        'Prevent screenshots when supported by the platform',
                    trailing: Switch(
                      value: _screenshotProtection,
                      onChanged:
                          _setScreenshotProtection,
                      activeThumbColor:
                          const Color(0xFFD9A441),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1828),
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0x1FD9A441),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFFFD66B),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Biometric authentication uses the '
                            'security system provided by your device. '
                            'The application does not store your '
                            'fingerprint or Face ID data.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}