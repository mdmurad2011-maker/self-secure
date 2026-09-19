import 'package:flutter/material.dart';

import '../../models/security_event.dart';
import '../../services/security/security_event_service.dart';

class SecurityEventsScreen extends StatefulWidget {
  const SecurityEventsScreen({super.key});

  @override
  State<SecurityEventsScreen> createState() =>
      _SecurityEventsScreenState();
}

class _SecurityEventsScreenState
    extends State<SecurityEventsScreen> {
  final SecurityEventService _service =
      SecurityEventService();

  List<SecurityEvent> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final events =
        await _service.getEvents();

    if (!mounted) return;

    setState(() {
      _events = events;
      _loading = false;
    });
  }

  Future<void> _clear() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Clear Security Events'),
          content: const Text(
            'Delete all locally stored security events?',
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
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _service.clearEvents();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Security Events'),
        actions: [
          if (_events.isNotEmpty)
            IconButton(
              onPressed: _clear,
              icon:
                  const Icon(Icons.delete_sweep),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _events.isEmpty
              ? const Center(
                  child: Text(
                    'No security events recorded.',
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(12),
                  itemCount:
                      _events.length,
                  itemBuilder:
                      (context, index) {
                    final event =
                        _events[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          event.critical
                              ? Icons.warning
                              : Icons.security,
                        ),
                        title:
                            Text(event.title),
                        subtitle:
                            Text(
                          '${event.description}\n'
                          '${event.timestamp}',
                        ),
                        isThreeLine: true,
                        trailing:
                            Text(event.type),
                      ),
                    );
                  },
                ),
    );
  }
}
