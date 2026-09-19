import 'package:flutter/material.dart';

import '../../models/router_device.dart';
import '../../services/router/router_service.dart';
import '../../services/router/router_connection_service.dart';

class RouterDevicesScreen extends StatefulWidget {
  const RouterDevicesScreen({super.key});

  @override
  State<RouterDevicesScreen> createState() =>
      _RouterDevicesScreenState();
}

class _RouterDevicesScreenState
    extends State<RouterDevicesScreen> {
  final RouterService _service = RouterService();
  final RouterConnectionService _connection =
      RouterConnectionService();

  List<RouterDevice> _devices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final devices = await _service.getDevices();

    if (!mounted) return;

    setState(() {
      _devices = devices;
      _loading = false;
    });
  }

  Future<void> _addDevice() async {
    final nameController = TextEditingController();
    final hostController = TextEditingController();
    final portController =
        TextEditingController(text: '80');
    final usernameController = TextEditingController();

    final result = await showDialog<RouterDevice>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Router Device'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Router Name',
                  ),
                ),
                TextField(
                  controller: hostController,
                  decoration: const InputDecoration(
                    labelText: 'Host / IP Address',
                  ),
                  keyboardType:
                      TextInputType.url,
                ),
                TextField(
                  controller: portController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                  ),
                  keyboardType:
                      TextInputType.number,
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name =
                    nameController.text.trim();
                final host =
                    hostController.text.trim();
                final port =
                    int.tryParse(
                          portController.text.trim(),
                        ) ??
                        80;
                final username =
                    usernameController.text.trim();

                if (name.isEmpty ||
                    host.isEmpty ||
                    port <= 0 ||
                    port > 65535) {
                  return;
                }

                Navigator.pop(
                  context,
                  RouterDevice(
                    id: DateTime.now()
                        .microsecondsSinceEpoch
                        .toString(),
                    name: name,
                    host: host,
                    port: port,
                    username: username,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    hostController.dispose();
    portController.dispose();
    usernameController.dispose();

    if (result == null) return;

    await _service.saveDevice(result);
    await _load();
  }

  Future<void> _check(RouterDevice device) async {
    final reachable =
        await _connection.isReachable(
      host: device.host,
      port: device.port,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          reachable
              ? '${device.name} is reachable.'
              : '${device.name} is not reachable.',
        ),
      ),
    );
  }

  Future<void> _delete(RouterDevice device) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Router'),
          content: Text(
            'Delete "${device.name}"?',
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _service.deleteDevice(device.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Router Devices'),
        actions: [
          IconButton(
            onPressed: _addDevice,
            icon: const Icon(Icons.add),
            tooltip: 'Add Router',
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _devices.isEmpty
              ? const Center(
                  child: Text(
                    'No router devices added.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device =
                        _devices[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          device.enabled
                              ? Icons.router
                              : Icons.router_outlined,
                        ),
                        title: Text(device.name),
                        subtitle: Text(
                          '${device.host}:${device.port}'
                          '${device.username.isEmpty ? '' : '\nUser: ${device.username}'}',
                        ),
                        isThreeLine:
                            device.username.isNotEmpty,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'check') {
                              _check(device);
                            } else if (value == 'delete') {
                              _delete(device);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'check',
                              child: Text(
                                'Check Connection',
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: _devices.isEmpty
          ? FloatingActionButton(
              onPressed: _addDevice,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
