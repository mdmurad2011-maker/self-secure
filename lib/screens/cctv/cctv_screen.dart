import 'package:flutter/material.dart';

class CctvScreen extends StatelessWidget {
  const CctvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV'),
      ),
      body: const Center(
        child: Text(
          'Select a CCTV device to continue.',
        ),
      ),
    );
  }
}
