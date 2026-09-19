class ReminderModel {
  final String id;
  final String title;
  final String? note;
  final DateTime scheduledAt;
  final bool completed;

  const ReminderModel({
    required this.id,
    required this.title,
    this.note,
    required this.scheduledAt,
    this.completed = false,
  });

  ReminderModel copyWith({
    String? title,
    String? note,
    DateTime? scheduledAt,
    bool? completed,
  }) {
    return ReminderModel(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      scheduledAt:
          scheduledAt ?? this.scheduledAt,
      completed:
          completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'scheduledAt':
        scheduledAt.toIso8601String(),
    'completed': completed,
  };

  factory ReminderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReminderModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      note: json['note']?.toString(),
      scheduledAt:
          DateTime.tryParse(
            json['scheduledAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      completed:
          json['completed'] as bool? ?? false,
    );
  }
}
