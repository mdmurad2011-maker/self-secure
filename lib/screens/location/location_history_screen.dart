import 'package:flutter/material.dart';

import '../../models/location_model.dart';
import '../../services/location/location_history_service.dart';

class LocationHistoryScreen
    extends StatefulWidget {
  const LocationHistoryScreen({
    super.key,
  });

  @override
  State<LocationHistoryScreen>
      createState() =>
          _LocationHistoryScreenState();
}

class _LocationHistoryScreenState
    extends State<LocationHistoryScreen> {
  final LocationHistoryService _service =
      LocationHistoryService();

  List<LocationModel> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final history =
        await _service.getHistory();

    if (!mounted) return;

    setState(() {
      _history = history;
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
              const Text('Clear History'),
          content: const Text(
            'Delete all saved location history?',
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

    await _service.clearHistory();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Location History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              onPressed: _clear,
              icon:
                  const Icon(
                Icons.delete_sweep,
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _history.isEmpty
              ? const Center(
                  child: Text(
                    'No location history.',
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(12),
                  itemCount:
                      _history.length,
                  itemBuilder:
                      (context, index) {
                    final item =
                        _history[index];

                    return Card(
                      child: ListTile(
                        leading:
                            const Icon(
                          Icons.location_on,
                        ),
                        title: Text(
                          '${item.latitude.toStringAsFixed(6)}, '
                          '${item.longitude.toStringAsFixed(6)}',
                        ),
                        subtitle:
                            Text(
                          '${item.timestamp}'
                          '\nAccuracy: '
                          '${item.accuracy.toStringAsFixed(1)} m',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
