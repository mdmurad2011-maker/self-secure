class DeviceBinding {
  final String id;
  final DateTime createdAt;

  const DeviceBinding({
    required this.id,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DeviceBinding.fromJson(Map<String, dynamic> json) {
    return DeviceBinding(
      id: json['id'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }
}
