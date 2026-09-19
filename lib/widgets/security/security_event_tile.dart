import 'package:flutter/material.dart';

class SecurityEventTile extends StatelessWidget {
  final String title;
  final String description;
  final DateTime time;
  final IconData icon;

  const SecurityEventTile({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.icon = Icons.security,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Text(
          '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}',
        ),
      ),
    );
  }
}
