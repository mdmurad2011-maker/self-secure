import 'package:flutter/material.dart';

import '../../services/storage/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() =>
      _BackupScreenState();
}

class _BackupScreenState
    extends State<BackupScreen> {
  final BackupService _backup =
      BackupService();

  bool _hasBackup = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value =
        await _backup.hasBackup();

    if (!mounted) return;

    setState(() {
      _hasBackup = value;
      _loading = false;
    });
  }

  Future<void> _createBackup() async {
    await _backup.createBackup();

    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Backup created successfully.',
        ),
      ),
    );
  }

  Future<void> _restoreBackup() async {
    final backup =
        await _backup.getLastBackup();

    if (backup == null) {
      return;
    }

    if (!mounted) return;

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Restore Backup',
          ),
          content: const Text(
            'Restore saved SELF SECURE '
            'settings and local data?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              child: const Text(
                'Restore',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmed != true) {
      return;
    }

    final success =
        await _backup.restoreBackup(
      backup,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Backup restored successfully.'
              : 'Backup restore failed.',
        ),
      ),
    );
  }

  Future<void> _deleteBackup() async {
    await _backup.deleteBackup();

    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Backup deleted.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Backup'),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                _hasBackup
                    ? Icons.cloud_done
                    : Icons.cloud_off,
              ),
              title:
                  const Text(
                'Local Backup',
              ),
              subtitle: Text(
                _hasBackup
                    ? 'Backup available'
                    : 'No backup created',
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          FilledButton.icon(
            onPressed:
                _createBackup,
            icon:
                const Icon(Icons.backup),
            label:
                const Text(
              'Create Backup',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: _hasBackup
                ? _restoreBackup
                : null,
            icon:
                const Icon(Icons.restore),
            label:
                const Text(
              'Restore Backup',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: _hasBackup
                ? _deleteBackup
                : null,
            icon:
                const Icon(
              Icons.delete_outline,
            ),
            label:
                const Text(
              'Delete Backup',
            ),
          ),
        ],
      ),
    );
  }
}


