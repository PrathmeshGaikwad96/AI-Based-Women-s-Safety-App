class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String avatarSeed;
  final String address;
  final double latitude;
  final double longitude;
  final int batteryLevel;
  final double safetyScore;
  final List<String> guardianIds;

  // New verification, activity, and guardian fields
  final String dob;
  final String guardianName;
  final String guardianPhone;
  final String guardianRelation;
  final String aadhaarImageUrl;
  final String verificationStatus;
  final bool isBlocked;
  final List<Map<String, dynamic>> activityLog;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarSeed = 'Maya',
    this.address = '123 Safety St, Downtown',
    this.latitude = 18.5204, // Default to Pune coords
    this.longitude = 73.8567,
    this.batteryLevel = 100,
    this.safetyScore = 98.0,
    this.guardianIds = const [],
    this.dob = '',
    this.guardianName = '',
    this.guardianPhone = '',
    this.guardianRelation = '',
    this.aadhaarImageUrl = '',
    this.verificationStatus = 'pending',
    this.isBlocked = false,
    this.activityLog = const [],
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? avatarSeed,
    String? address,
    double? latitude,
    double? longitude,
    int? batteryLevel,
    double? safetyScore,
    List<String>? guardianIds,
    String? dob,
    String? guardianName,
    String? guardianPhone,
    String? guardianRelation,
    String? aadhaarImageUrl,
    String? verificationStatus,
    bool? isBlocked,
    List<Map<String, dynamic>>? activityLog,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      safetyScore: safetyScore ?? this.safetyScore,
      guardianIds: guardianIds ?? this.guardianIds,
      dob: dob ?? this.dob,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      guardianRelation: guardianRelation ?? this.guardianRelation,
      aadhaarImageUrl: aadhaarImageUrl ?? this.aadhaarImageUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isBlocked: isBlocked ?? this.isBlocked,
      activityLog: activityLog ?? this.activityLog,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarSeed': avatarSeed,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'batteryLevel': batteryLevel,
      'safetyScore': safetyScore,
      'guardianIds': guardianIds,
      'dob': dob,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'guardianRelation': guardianRelation,
      'aadhaarImageUrl': aadhaarImageUrl,
      'verificationStatus': verificationStatus,
      'isBlocked': isBlocked,
      'activityLog': activityLog,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatarSeed: map['avatarSeed'] ?? 'Maya',
      address: map['address'] ?? '123 Safety St, Downtown',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 18.5204,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 73.8567,
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? 100,
      safetyScore: (map['safetyScore'] as num?)?.toDouble() ?? 98.0,
      guardianIds: List<String>.from(map['guardianIds'] ?? []),
      dob: map['dob'] ?? '',
      guardianName: map['guardianName'] ?? '',
      guardianPhone: map['guardianPhone'] ?? '',
      guardianRelation: map['guardianRelation'] ?? '',
      aadhaarImageUrl: map['aadhaarImageUrl'] ?? '',
      verificationStatus: map['verificationStatus'] ?? 'pending',
      isBlocked: map['isBlocked'] ?? false,
      activityLog: (map['activityLog'] as List?)
              ?.map((item) => Map<String, dynamic>.from(item as Map))
              .toList() ??
          [],
    );
  }
}
