import 'package:flutter/material.dart';

import 'router_devices_screen.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});

  void _openDevices(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RouterDevicesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Router'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.router,
                    size: 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Router Security',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage and monitor your configured '
                    'network router devices.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Router Devices'),
              subtitle: const Text(
                'Add, manage and check router connections',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () => _openDevices(context),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.network_check),
              title: const Text('Network Status'),
              subtitle: const Text(
                'Check configured router connectivity',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () => _openDevices(context),
            ),
          ),
        ],
      ),
    );
  }
}
