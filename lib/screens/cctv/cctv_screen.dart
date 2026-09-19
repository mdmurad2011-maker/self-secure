import 'package:flutter/material.dart';

import '../../models/cctv_device.dart';
import '../../services/cctv/cctv_connection_service.dart';
import '../../services/cctv/cctv_service.dart';

class CctvScreen extends StatefulWidget {
  const CctvScreen({super.key});

  @override
  State<CctvScreen> createState() => _CctvScreenState();
}

class _CctvScreenState extends State<CctvScreen> {
  final CctvService _service = CctvService();
  final CctvConnectionService _connection =
      CctvConnectionService();

  List<CctvDevice> _devices = [];
  bool _loading = true;
  final Map<String, bool> _status = {};

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

  Future<void> _check(CctvDevice device) async {
    setState(() {
      _status[device.id] = false;
    });

    final reachable = await _connection.isReachable(
      host: device.host,
      port: device.port,
    );

    if (!mounted) return;

    setState(() {
      _status[device.id] = reachable;
    });

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

  Future<void> _delete(CctvDevice device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete CCTV'),
          content: Text(
            'Delete "${device.name}" from SELF SECURE?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
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

  Future<void> _addDevice() async {
    final nameController = TextEditingController();
    final hostController = TextEditingController();
    final portController =
        TextEditingController(text: '80');
    final usernameController = TextEditingController();

    final result = await showDialog<CctvDevice>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add CCTV Device'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Camera Name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hostController,
                  keyboardType:
                      TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'IP / Host',
                    hintText: '192.168.1.100',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: portController,
                  keyboardType:
                      TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                  ),
                ),
                const SizedBox(height: 12),
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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
                    port < 1 ||
                    port > 65535) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  CctvDevice(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV'),
        actions: [
          IconButton(
            onPressed: _addDevice,
            tooltip: 'Add CCTV',
            icon: const Icon(Icons.add_a_photo),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _devices.isEmpty
              ? Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.videocam_off,
                          size: 72,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No CCTV devices added.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add an IP camera or CCTV device to manage it from SELF SECURE.',
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _addDevice,
                          icon: const Icon(
                            Icons.add,
                          ),
                          label: const Text(
                            'Add CCTV Device',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(12),
                    itemCount: _devices.length,
                    itemBuilder:
                        (context, index) {
                      final device =
                          _devices[index];

                      final reachable =
                          _status[device.id];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              reachable == true
                                  ? Icons
                                      .videocam
                                  : reachable ==
                                          false
                                      ? Icons
                                          .videocam_off
                                      : Icons
                                          .videocam,
                            ),
                          ),
                          title:
                              Text(device.name),
                          subtitle: Text(
                            '${device.host}:${device.port}'
                            '${device.username.isEmpty ? '' : '\nUser: ${device.username}'}',
                          ),
                          isThreeLine:
                              device.username
                                  .isNotEmpty,
                          trailing: PopupMenuButton<
                              String>(
                            onSelected: (value) {
                              if (value ==
                                  'check') {
                                _check(device);
                              } else if (value ==
                                  'delete') {
                                _delete(device);
                              }
                            },
                            itemBuilder:
                                (context) => [
                              const PopupMenuItem(
                                value: 'check',
                                child: Text(
                                  'Check Connection',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Delete',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
