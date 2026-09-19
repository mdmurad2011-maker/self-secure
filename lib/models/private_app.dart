class PrivateApp {
  final String id;
  final String name;
  final String packageName;
  final DateTime createdAt;

  const PrivateApp({
    required this.id,
    required this.name,
    required this.packageName,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'packageName': packageName,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PrivateApp.fromJson(
    Map<String, dynamic> json,
  ) {
    return PrivateApp(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      packageName:
          json['packageName']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(
            json['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}
