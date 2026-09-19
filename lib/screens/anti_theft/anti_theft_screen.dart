import 'package:flutter/material.dart';

import '../../services/anti_theft/alarm_service.dart';
import '../../services/anti_theft/lost_mode_service.dart';

class AntiTheftScreen extends StatefulWidget {
  const AntiTheftScreen({super.key});

  @override
  State<AntiTheftScreen> createState() =>
      _AntiTheftScreenState();
}

class _AntiTheftScreenState
    extends State<AntiTheftScreen> {
  final LostModeService _lostModeService =
      LostModeService();

  final AlarmService _alarmService =
      AlarmService();

  bool _lostModeEnabled = false;
  bool _alarmRunning = false;

  Future<void> _enableLostMode() async {
    await _lostModeService.enable();

    if (!mounted) return;

    setState(() {
      _lostModeEnabled = true;
    });
  }

  Future<void> _disableLostMode() async {
    await _lostModeService.disable();

    if (!mounted) return;

    setState(() {
      _lostModeEnabled = false;
    });
  }

  Future<void> _startAlarm() async {
    await _alarmService.startAlarm();

    if (!mounted) return;

    setState(() {
      _alarmRunning = true;
    });
  }

  Future<void> _stopAlarm() async {
    await _alarmService.stopAlarm();

    if (!mounted) return;

    setState(() {
      _alarmRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anti-Theft'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title:
                  const Text('Lost Mode'),
              subtitle: const Text(
                'Protect this device when it is lost.',
              ),
              value: _lostModeEnabled,
              onChanged: (value) {
                if (value) {
                  _enableLostMode();
                } else {
                  _disableLostMode();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(
                _alarmRunning
                    ? Icons.volume_up
                    : Icons.volume_off,
              ),
              title: const Text(
                'Anti-Theft Alarm',
              ),
              subtitle: Text(
                _alarmRunning
                    ? 'Alarm is running'
                    : 'Alarm is stopped',
              ),
              trailing: FilledButton(
                onPressed: _alarmRunning
                    ? _stopAlarm
                    : _startAlarm,
                child: Text(
                  _alarmRunning
                      ? 'STOP'
                      : 'START',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
