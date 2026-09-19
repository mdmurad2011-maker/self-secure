class CctvDevice {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final bool enabled;

  const CctvDevice({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    this.enabled = true,
  });

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

  factory CctvDevice.fromJson(
    Map<String, dynamic> json,
  ) {
    return CctvDevice(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      host: json['host']?.toString() ?? '',
      port: (json['port'] as num?)?.toInt() ?? 80,
      username:
          json['username']?.toString() ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}
