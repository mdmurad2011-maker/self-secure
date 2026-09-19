import 'package:flutter/material.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Router'),
      ),
      body: const Center(
        child: Text(
          'Select a router device to continue.',
        ),
      ),
    );
  }
}
