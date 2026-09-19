import 'package:flutter/material.dart';

class MyDiskScreen extends StatelessWidget {
  const MyDiskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('My Disk'),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading:
                  const Icon(
                Icons.folder_special,
              ),
              title:
                  const Text(
                'Private Storage',
              ),
              subtitle:
                  const Text(
                'Secure personal files and documents',
              ),
              trailing:
                  const Icon(
                Icons.lock,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_off,
                    size: 52,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Private Disk',
                    style:
                        TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The private storage foundation '
                    'is ready. File picker and encrypted '
                    'file vault can be connected here.',
                    textAlign:
                        TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
