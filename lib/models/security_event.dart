class SecurityEvent {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool critical;

  const SecurityEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.critical = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'critical': critical,
  };

  factory SecurityEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    return SecurityEvent(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description:
          json['description']?.toString() ?? '',
      timestamp:
          DateTime.tryParse(
            json['timestamp']?.toString() ?? '',
          ) ??
          DateTime.now(),
      critical:
          json['critical'] as bool? ?? false,
    );
  }
}
