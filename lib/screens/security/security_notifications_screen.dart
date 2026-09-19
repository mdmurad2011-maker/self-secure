import 'package:flutter/material.dart';

import '../../models/security_notification.dart';
import '../../services/security/security_notification_service.dart';

class SecurityNotificationsScreen
    extends StatefulWidget {
  const SecurityNotificationsScreen({
    super.key,
  });

  @override
  State<SecurityNotificationsScreen>
      createState() =>
          _SecurityNotificationsScreenState();
}

class _SecurityNotificationsScreenState
    extends State<
        SecurityNotificationsScreen> {
  final SecurityNotificationService
      _service =
      SecurityNotificationService();

  List<SecurityNotification> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items =
        await _service.getNotifications();

    if (!mounted) return;

    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _markRead(
    SecurityNotification item,
  ) async {
    await _service.markAsRead(item.id);
    await _load();
  }

  Future<void> _markAllRead() async {
    await _service.markAllAsRead();
    await _load();
  }

  Future<void> _clear() async {
    await _service.clearNotifications();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final unread =
        _items.where(
      (item) => !item.read,
    ).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          unread == 0
              ? 'Security Notifications'
              : 'Security Notifications ($unread)',
        ),
        actions: [
          if (unread > 0)
            IconButton(
              onPressed: _markAllRead,
              tooltip: 'Mark all as read',
              icon:
                  const Icon(Icons.done_all),
            ),
          if (_items.isNotEmpty)
            IconButton(
              onPressed: _clear,
              tooltip: 'Clear',
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
          : _items.isEmpty
              ? const Center(
                  child: Text(
                    'No security notifications.',
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(12),
                  itemCount:
                      _items.length,
                  itemBuilder:
                      (context, index) {
                    final item =
                        _items[index];

                    return Card(
                      child: ListTile(
                        tileColor: item.read
                            ? null
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        leading: Icon(
                          item.read
                              ? Icons.notifications_none
                              : Icons
                                  .notifications_active,
                        ),
                        title:
                            Text(item.title),
                        subtitle:
                            Text(
                          '${item.message}\n'
                          '${item.createdAt}',
                        ),
                        isThreeLine: true,
                        onTap: item.read
                            ? null
                            : () =>
                                _markRead(
                              item,
                            ),
                      ),
                    );
                  },
                ),
    );
  }
}
