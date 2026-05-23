class UnsafePlace {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double radius; // In meters
  final String riskLevel; // 'Safe', 'Moderate Risk', 'High Risk'
  final String description;
  final int incidentCount;

  UnsafePlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.riskLevel,
    this.description = '',
    this.incidentCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'riskLevel': riskLevel,
      'description': description,
      'incidentCount': incidentCount,
    };
  }

  factory UnsafePlace.fromMap(Map<String, dynamic> map) {
    return UnsafePlace(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      radius: (map['radius'] as num?)?.toDouble() ?? 100.0,
      riskLevel: map['riskLevel'] ?? 'Safe',
      description: map['description'] ?? '',
      incidentCount: (map['incidentCount'] as num?)?.toInt() ?? 0,
    );
  }
}
