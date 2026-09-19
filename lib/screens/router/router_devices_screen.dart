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
  final RouterService _service =
      RouterService();

  final RouterConnectionService _connection =
      RouterConnectionService();

  List<RouterDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final devices =
        await _service.getDevices();

    if (!mounted) return;

    setState(() {
      _devices = devices;
    });
  }

  Future<void> _addDevice() async {
    final name =
        TextEditingController();

    final host =
        TextEditingController();

    final port =
        TextEditingController(
      text: '80',
    );

    final username =
        TextEditingController();

    final result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Add Router'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration:
                      const InputDecoration(
                    labelText: 'Device Name',
                  ),
                ),
                TextField(
                  controller: host,
                  decoration:
                      const InputDecoration(
                    labelText: 'IP / Host',
                  ),
                ),
                TextField(
                  controller: port,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      const InputDecoration(
                    labelText: 'Port',
                  ),
                ),
                TextField(
                  controller: username,
                  decoration:
                      const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child:
                  const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.text
                        .trim()
                        .isEmpty ||
                    host.text
                        .trim()
                        .isEmpty) {
                  return;
                }

                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
                  const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    final device = RouterDevice(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      name: name.text.trim(),
      host: host.text.trim(),
      port: int.tryParse(
            port.text.trim(),
          ) ??
          80,
      username:
          username.text.trim(),
    );

    await _service.saveDevice(
      device,
    );

    await _load();
  }

  Future<void> _test(
    RouterDevice device,
  ) async {
    final reachable =
        await _connection.isReachable(
      host: device.host,
      port: device.port,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          reachable
              ? '${device.name}: network reachable'
              : '${device.name}: not reachable',
        ),
      ),
    );
  }

  Future<void> _delete(
    RouterDevice device,
  ) async {
    await _service.deleteDevice(
      device.id,
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Router Devices'),
        actions: [
          IconButton(
            onPressed: _addDevice,
            icon:
                const Icon(Icons.add),
          ),
        ],
      ),
      body: _devices.isEmpty
          ? const Center(
              child: Text(
                'No router devices added.',
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount:
                  _devices.length,
              itemBuilder:
                  (context, index) {
                final device =
                    _devices[index];

                return Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.router,
                    ),
                    title:
                        Text(device.name),
                    subtitle:
                        Text(
                      '${device.host}:${device.port}',
                    ),
                    trailing:
                        PopupMenuButton(
                      itemBuilder:
                          (_) => [
                        const PopupMenuItem(
                          value: 'test',
                          child: Text(
                            'Test Connection',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                          ),
                        ),
                      ],
                      onSelected:
                          (value) {
                        if (value ==
                            'test') {
                          _test(device);
                        } else {
                          _delete(
                            device,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
