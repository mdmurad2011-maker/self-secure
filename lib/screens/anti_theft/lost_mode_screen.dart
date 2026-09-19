import 'package:flutter/material.dart';

import '../../services/anti_theft/lost_mode_service.dart';

class LostModeScreen extends StatefulWidget {
  const LostModeScreen({super.key});

  @override
  State<LostModeScreen> createState() =>
      _LostModeScreenState();
}

class _LostModeScreenState
    extends State<LostModeScreen> {
  final LostModeService _service =
      LostModeService();

  bool _enabled = false;

  Future<void> _toggle() async {
    if (_enabled) {
      await _service.disable();
    } else {
      await _service.enable();
    }

    if (!mounted) return;

    setState(() {
      _enabled = !_enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Mode'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                _enabled
                    ? Icons.lock
                    : Icons.lock_open,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                _enabled
                    ? 'Lost Mode is ACTIVE'
                    : 'Lost Mode is OFF',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Lost Mode is a local security state '
                'for marking the device as lost.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _toggle,
                icon: Icon(
                  _enabled
                      ? Icons.lock_open
                      : Icons.lock,
                ),
                label: Text(
                  _enabled
                      ? 'Disable Lost Mode'
                      : 'Enable Lost Mode',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
