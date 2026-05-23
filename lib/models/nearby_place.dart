class NearbyPlace {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String type; // 'police', 'hospital', 'shelter', 'ngo', 'fire_station'
  final String address;
  final String? phone;

  NearbyPlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.address = '',
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'address': address,
      'phone': phone,
    };
  }

  factory NearbyPlace.fromMap(Map<String, dynamic> map) {
    return NearbyPlace(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] ?? 'police',
      address: map['address'] ?? '',
      phone: map['phone'],
    );
  }
}
