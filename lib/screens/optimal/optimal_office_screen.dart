import 'package:flutter/material.dart';

class OptimalOfficeScreen extends StatefulWidget {
  const OptimalOfficeScreen({super.key});

  @override
  State<OptimalOfficeScreen> createState() =>
      _OptimalOfficeScreenState();
}

class _OptimalOfficeScreenState
    extends State<OptimalOfficeScreen> {
  final TextEditingController _urlController =
      TextEditingController();

  String? configuredUrl;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    final value = _urlController.text.trim();

    if (value.isEmpty) {
      return;
    }

    setState(() {
      configuredUrl = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OPTIMAL OFFICE'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.business_center,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'OPTIMAL OFFICE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'OPTIMAL OFFICE Server URL',
              hintText: 'https://your-office-server.example',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save Connection'),
          ),
          if (configuredUrl != null) ...[
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                ),
                title: const Text('Server configured'),
                subtitle: Text(configuredUrl!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
