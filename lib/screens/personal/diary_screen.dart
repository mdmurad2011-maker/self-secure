import 'package:flutter/material.dart';

import '../../models/diary_entry.dart';
import '../../services/storage/diary_storage_service.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() =>
      _DiaryScreenState();
}

class _DiaryScreenState
    extends State<DiaryScreen> {
  final DiaryStorageService _storage =
      DiaryStorageService();

  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries =
        await _storage.getEntries();

    if (!mounted) return;

    setState(() {
      _entries = entries;
    });
  }

  Future<void> _editEntry([
    DiaryEntry? existing,
  ]) async {
    final title =
        TextEditingController(
      text: existing?.title ?? '',
    );

    final content =
        TextEditingController(
      text: existing?.content ?? '',
    );

    final result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            existing == null
                ? 'New Diary Entry'
                : 'Edit Diary Entry',
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration:
                      const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: content,
                  maxLines: 8,
                  decoration:
                      const InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                    border:
                        OutlineInputBorder(),
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
                if (title.text
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

    if (result != true) return;

    final now = DateTime.now();

    await _storage.saveEntry(
      DiaryEntry(
        id: existing?.id ??
            now.microsecondsSinceEpoch
                .toString(),
        title: title.text.trim(),
        content: content.text,
        createdAt:
            existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );

    await _load();
  }

  Future<void> _delete(
    DiaryEntry entry,
  ) async {
    await _storage.deleteEntry(
      entry.id,
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        actions: [
          IconButton(
            onPressed: _editEntry,
            icon:
                const Icon(Icons.add),
          ),
        ],
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
                'No diary entries yet.',
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount: _entries.length,
              itemBuilder:
                  (context, index) {
                final entry =
                    _entries[index];

                return Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.menu_book,
                    ),
                    title:
                        Text(entry.title),
                    subtitle:
                        Text(
                      entry.content,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                    onTap: () =>
                        _editEntry(entry),
                    trailing:
                        IconButton(
                      icon:
                          const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () =>
                          _delete(entry),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
