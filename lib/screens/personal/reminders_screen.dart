import 'package:flutter/material.dart';

import '../../models/reminder_model.dart';
import '../../services/storage/reminder_storage_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() =>
      _RemindersScreenState();
}

class _RemindersScreenState
    extends State<RemindersScreen> {
  final ReminderStorageService _storage =
      ReminderStorageService();

  List<ReminderModel> _reminders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final reminders =
        await _storage.getReminders();

    if (!mounted) return;

    setState(() {
      _reminders = reminders;
    });
  }

  Future<void> _addReminder() async {
    final title =
        TextEditingController();

    final note =
        TextEditingController();

    DateTime selected =
        DateTime.now().add(
      const Duration(hours: 1),
    );

    final result =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title:
                  const Text(
                'New Reminder',
              ),
              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller: title,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Reminder',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: note,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Note (optional)',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.zero,
                      leading:
                          const Icon(
                        Icons.schedule,
                      ),
                      title:
                          const Text(
                        'Schedule',
                      ),
                      subtitle:
                          Text(
                        '${selected.day}/'
                        '${selected.month}/'
                        '${selected.year} '
                        '${selected.hour}:'
                        '${selected.minute.toString().padLeft(2, '0')}',
                      ),
                      onTap:
                          () async {
                        final date =
                            await showDatePicker(
                          context: dialogContext,
                          initialDate:
                              selected,
                          firstDate:
                              DateTime.now(),
                          lastDate:
                              DateTime.now()
                                  .add(
                            const Duration(
                              days: 3650,
                            ),
                          ),
                        );

                        if (date == null) {
                          return;
                        }

                        if (!mounted) return;

                        final time =
                            await showTimePicker(
                          context: this.context,
                          initialTime:
                              TimeOfDay.fromDateTime(
                            selected,
                          ),
                        );

                        if (time ==
                            null) {
                          return;
                        }

                        setDialogState(() {
                          selected =
                              DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      },
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
      },
    );

    if (result != true) return;

    await _storage.saveReminder(
      ReminderModel(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        title: title.text.trim(),
        note: note.text.trim().isEmpty
            ? null
            : note.text.trim(),
        scheduledAt: selected,
      ),
    );

    await _load();
  }

  Future<void> _toggle(
    ReminderModel reminder,
    bool value,
  ) async {
    await _storage.saveReminder(
      reminder.copyWith(
        completed: value,
      ),
    );

    await _load();
  }

  Future<void> _delete(
    ReminderModel reminder,
  ) async {
    await _storage.deleteReminder(
      reminder.id,
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Reminders'),
        actions: [
          IconButton(
            onPressed: _addReminder,
            icon:
                const Icon(Icons.add),
          ),
        ],
      ),
      body: _reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders yet.',
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount:
                  _reminders.length,
              itemBuilder:
                  (context, index) {
                final reminder =
                    _reminders[index];

                return Card(
                  child: CheckboxListTile(
                    value:
                        reminder.completed,
                    onChanged: (value) {
                      if (value !=
                          null) {
                        _toggle(
                          reminder,
                          value,
                        );
                      }
                    },
                    title:
                        Text(
                      reminder.title,
                      style: TextStyle(
                        decoration:
                            reminder.completed
                                ? TextDecoration
                                    .lineThrough
                                : null,
                      ),
                    ),
                    subtitle:
                        Text(
                      '${reminder.scheduledAt.day}/'
                      '${reminder.scheduledAt.month}/'
                      '${reminder.scheduledAt.year} '
                      '${reminder.scheduledAt.hour}:'
                      '${reminder.scheduledAt.minute.toString().padLeft(2, '0')}'
                      '${reminder.note == null ? '' : '\n${reminder.note}'}',
                    ),
                    secondary:
                        IconButton(
                      icon:
                          const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () =>
                          _delete(
                        reminder,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

