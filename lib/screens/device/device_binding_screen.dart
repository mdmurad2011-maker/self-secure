import 'package:flutter/material.dart';

import '../../services/security/device_binding_service.dart';

class DeviceBindingScreen extends StatefulWidget {
  final String? deviceId;

  const DeviceBindingScreen({
    super.key,
    this.deviceId,
  });

  @override
  State<DeviceBindingScreen> createState() =>
      _DeviceBindingScreenState();
}

class _DeviceBindingScreenState
    extends State<DeviceBindingScreen> {
  final DeviceBindingService _service =
      DeviceBindingService();

  String? _bindingId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = await _service.getBindingId();

    if (!mounted) return;

    setState(() {
      _bindingId = id;
      _loading = false;
    });
  }

  Future<void> _bind() async {
    final id = widget.deviceId?.trim();

    if (id == null || id.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No device ID is available.',
          ),
        ),
      );

      return;
    }

    final success = await _service.bind(id);

    if (!success) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Device binding failed.',
          ),
        ),
      );

      return;
    }

    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Device bound successfully.',
        ),
      ),
    );
  }

  Future<void> _unbind() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unbind Device'),
          content: const Text(
            'Remove the current device binding?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Unbind'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _service.unbind();
    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Device unbound successfully.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final bound =
        _bindingId != null &&
        _bindingId!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Binding'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    bound
                        ? Icons.link
                        : Icons.link_off,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    bound
                        ? 'Device Bound'
                        : 'Device Not Bound',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bound
                        ? 'This SELF SECURE installation '
                          'has a local device binding.'
                        : 'Bind this installation to '
                          'the detected device.',
                    textAlign: TextAlign.center,
                  ),
                  if (bound) ...[
                    const SizedBox(height: 20),
                    SelectableText(_bindingId!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!bound)
            FilledButton.icon(
              onPressed: _bind,
              icon: const Icon(Icons.link),
              label: const Text(
                'Bind This Device',
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: _unbind,
              icon: const Icon(Icons.link_off),
              label: const Text(
                'Unbind Device',
              ),
            ),
        ],
      ),
    );
  }
}
