class LocationModel {
  final String id;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final DateTime timestamp;

  const LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LocationModel(
      id: json['id']?.toString() ?? '',
      latitude:
          (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude:
          (json['longitude'] as num?)?.toDouble() ?? 0,
      accuracy:
          (json['accuracy'] as num?)?.toDouble() ?? 0,
      altitude:
          (json['altitude'] as num?)?.toDouble() ?? 0,
      timestamp:
          DateTime.tryParse(
                json['timestamp']?.toString() ?? '',
              ) ??
              DateTime.now(),
    );
  }
}
