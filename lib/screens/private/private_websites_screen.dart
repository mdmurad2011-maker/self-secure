import 'package:flutter/material.dart';

import '../../models/private_website.dart';
import '../../services/storage/private_storage_service.dart';

class PrivateWebsitesScreen
    extends StatefulWidget {
  const PrivateWebsitesScreen({
    super.key,
  });

  @override
  State<PrivateWebsitesScreen>
      createState() =>
          _PrivateWebsitesScreenState();
}

class _PrivateWebsitesScreenState
    extends State<PrivateWebsitesScreen> {
  final PrivateStorageService _storage =
      PrivateStorageService();

  List<PrivateWebsite> _websites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final websites =
        await _storage.getWebsites();

    if (!mounted) return;

    setState(() {
      _websites = websites;
      _loading = false;
    });
  }

  Future<void> _addWebsite() async {
    final nameController =
        TextEditingController();

    final urlController =
        TextEditingController();

    final result =
        await showDialog<PrivateWebsite>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Add Private Website'),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText: 'Website Name',
                ),
              ),
              TextField(
                controller:
                    urlController,
                keyboardType:
                    TextInputType.url,
                decoration:
                    const InputDecoration(
                  labelText: 'Website URL',
                  hintText:
                      'https://example.com',
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

                final url =
                    urlController.text.trim();

                if (name.isEmpty ||
                    url.isEmpty) {
                  return;
                }

                Navigator.pop(
                  context,
                  PrivateWebsite(
                    id: DateTime.now()
                        .microsecondsSinceEpoch
                        .toString(),
                    name: name,
                    url: url,
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
    urlController.dispose();

    if (result == null) return;

    _websites.add(result);
    await _storage.saveWebsites(
      _websites,
    );

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _removeWebsite(
    PrivateWebsite website,
  ) async {
    _websites.removeWhere(
      (item) => item.id == website.id,
    );

    await _storage.saveWebsites(
      _websites,
    );

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Private Websites'),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: _addWebsite,
        child:
            const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _websites.isEmpty
              ? const Center(
                  child: Text(
                    'No private websites added.',
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(12),
                  itemCount:
                      _websites.length,
                  itemBuilder:
                      (context, index) {
                    final website =
                        _websites[index];

                    return Card(
                      child: ListTile(
                        leading:
                            const Icon(
                          Icons.language,
                        ),
                        title:
                            Text(
                          website.name,
                        ),
                        subtitle:
                            Text(
                          website.url,
                        ),
                        trailing:
                            IconButton(
                          onPressed: () =>
                              _removeWebsite(
                            website,
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
