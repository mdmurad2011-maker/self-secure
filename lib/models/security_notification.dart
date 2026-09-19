class SecurityNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;

  const SecurityNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.read = false,
  });

  SecurityNotification copyWith({
    String? title,
    String? message,
    DateTime? createdAt,
    bool? read,
  }) {
    return SecurityNotification(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'read': read,
    };
  }

  factory SecurityNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return SecurityNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(
            json['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      read: json['read'] == true,
    );
  }
}
