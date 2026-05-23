class AlertModel {
  final String id;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String address;
  final int batteryLevel;
  final String status; // 'active' or 'resolved'
  final bool isVoiceTriggered;
  final String aiMonitoringStatus;

  AlertModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.address = 'Unknown Location',
    this.batteryLevel = 100,
    this.status = 'active',
    this.isVoiceTriggered = false,
    this.aiMonitoringStatus = 'Analyzing threats...',
  });

  AlertModel copyWith({
    String? id,
    String? userId,
    String? userName,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? address,
    int? batteryLevel,
    String? status,
    bool? isVoiceTriggered,
    String? aiMonitoringStatus,
  }) {
    return AlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      status: status ?? this.status,
      isVoiceTriggered: isVoiceTriggered ?? this.isVoiceTriggered,
      aiMonitoringStatus: aiMonitoringStatus ?? this.aiMonitoringStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'batteryLevel': batteryLevel,
      'status': status,
      'isVoiceTriggered': isVoiceTriggered,
      'aiMonitoringStatus': aiMonitoringStatus,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] ?? 'Unknown Location',
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? 100,
      status: map['status'] ?? 'active',
      isVoiceTriggered: map['isVoiceTriggered'] ?? false,
      aiMonitoringStatus: map['aiMonitoringStatus'] ?? 'Analyzing...',
    );
  }
}
