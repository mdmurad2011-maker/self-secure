import 'package:flutter/material.dart';

import '../../models/private_app.dart';
import '../../services/storage/private_storage_service.dart';

class PrivateAppsScreen extends StatefulWidget {
  const PrivateAppsScreen({super.key});

  @override
  State<PrivateAppsScreen> createState() =>
      _PrivateAppsScreenState();
}

class _PrivateAppsScreenState
    extends State<PrivateAppsScreen> {
  final PrivateStorageService _storage =
      PrivateStorageService();

  List<PrivateApp> _apps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final apps =
        await _storage.getApps();

    if (!mounted) return;

    setState(() {
      _apps = apps;
      _loading = false;
    });
  }

  Future<void> _addApp() async {
    final nameController =
        TextEditingController();

    final packageController =
        TextEditingController();

    final result =
        await showDialog<PrivateApp>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Add Private App'),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText: 'App Name',
                ),
              ),
              TextField(
                controller:
                    packageController,
                decoration:
                    const InputDecoration(
                  labelText: 'Package Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child:
                  const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name =
                    nameController.text.trim();

                final package =
                    packageController.text.trim();

                if (name.isEmpty ||
                    package.isEmpty) {
                  return;
                }

                Navigator.pop(
                  context,
                  PrivateApp(
                    id: DateTime.now()
                        .microsecondsSinceEpoch
                        .toString(),
                    name: name,
                    packageName: package,
                    createdAt:
                        DateTime.now(),
                  ),
                );
              },
              child:
                  const Text('Add'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    packageController.dispose();

    if (result == null) return;

    _apps.add(result);
    await _storage.saveApps(_apps);

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _removeApp(
    PrivateApp app,
  ) async {
    _apps.removeWhere(
      (item) => item.id == app.id,
    );

    await _storage.saveApps(_apps);

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Private Apps'),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: _addApp,
        child:
            const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _apps.isEmpty
              ? const Center(
                  child: Text(
                    'No private apps added.',
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(12),
                  itemCount:
                      _apps.length,
                  itemBuilder:
                      (context, index) {
                    final app =
                        _apps[index];

                    return Card(
                      child: ListTile(
                        leading:
                            const Icon(
                          Icons.apps,
                        ),
                        title:
                            Text(app.name),
                        subtitle:
                            Text(
                          app.packageName,
                        ),
                        trailing:
                            IconButton(
                          onPressed: () =>
                              _removeApp(
                            app,
                          ),
                          icon:
                              const Icon(
                            Icons.delete,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
