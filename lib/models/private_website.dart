class PrivateWebsite {
  final String id;
  final String name;
  final String url;
  final DateTime createdAt;

  const PrivateWebsite({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PrivateWebsite.fromJson(
    Map<String, dynamic> json,
  ) {
    return PrivateWebsite(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(
                json['createdAt']?.toString() ?? '',
              ) ??
              DateTime.now(),
    );
  }
}
