class RouterDevice {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final bool enabled;

  const RouterDevice({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    this.enabled = true,
  });

  RouterDevice copyWith({
    String? name,
    String? host,
    int? port,
    String? username,
    bool? enabled,
  }) {
    return RouterDevice(
      id: id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'enabled': enabled,
    };
  }

  factory RouterDevice.fromJson(
    Map<String, dynamic> json,
  ) {
    return RouterDevice(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      host: json['host']?.toString() ?? '',
      port: (json['port'] as num?)?.toInt() ?? 80,
      username: json['username']?.toString() ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}
