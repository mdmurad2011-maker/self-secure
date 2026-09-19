import 'package:flutter/material.dart';

import 'self_secure_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const SelfSecureApp(),
  );
}

class SelfSecureApp extends StatelessWidget {
  const SelfSecureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SELF SECURE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const SelfSecureHome(),
    );
  }
}
