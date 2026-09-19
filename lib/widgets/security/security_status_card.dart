import 'package:flutter/material.dart';

class SecurityStatusCard extends StatelessWidget {
  final bool secure;
  final String message;

  const SecurityStatusCard({
    super.key,
    required this.secure,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              secure
                  ? Icons.verified_user
                  : Icons.warning_amber,
              size: 42,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    secure ? 'SECURE' : 'ATTENTION',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
