import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = true;
  bool _securityNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _biometricEnabled =
          prefs.getBool('biometric_enabled') ?? true;
      _securityNotifications =
          prefs.getBool('security_notifications') ?? true;
    });
  }

  Future<void> _setBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'biometric_enabled',
      value,
    );

    if (!mounted) return;

    setState(() {
      _biometricEnabled = value;
    });
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
  }

  Future<void> _changePin() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101D2D),
          title: const Text('Change Security PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                ),
              ),
              TextField(
                controller: newController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'New PIN',
                ),
              ),
              TextField(
                controller: confirmController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Confirm New PIN',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final prefs =
                    await SharedPreferences.getInstance();

                final savedPin =
                    prefs.getString('security_pin');

                if (currentController.text != savedPin) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Current PIN is incorrect'),
                    ),
                  );
                  return;
                }

                if (newController.text.length < 4) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'PIN must contain at least 4 digits',
                      ),
                    ),
                  );
                  return;
                }

                if (newController.text !=
                    confirmController.text) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
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

                if (!context.mounted) return;

                Navigator.pop(context, true);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security PIN changed successfully'),
        ),
      );
    }
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
          vertical: 5,
        ),
        leading: Container(
          width: 44,
          height: 44,
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
            fontWeight: Font
