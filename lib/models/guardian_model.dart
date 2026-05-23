class GuardianModel {
  final String id;
  final String name;
  final String phone;
  final String relation;
  final String email;
  final bool isInvitationAccepted;

  GuardianModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
    this.email = '',
    this.isInvitationAccepted = true,
  });

  GuardianModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? relation,
    String? email,
    bool? isInvitationAccepted,
  }) {
    return GuardianModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      email: email ?? this.email,
      isInvitationAccepted: isInvitationAccepted ?? this.isInvitationAccepted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
      'email': email,
      'isInvitationAccepted': isInvitationAccepted,
    };
  }

  factory GuardianModel.fromMap(Map<String, dynamic> map) {
    return GuardianModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relation: map['relation'] ?? '',
      email: map['email'] ?? '',
      isInvitationAccepted: map['isInvitationAccepted'] ?? true,
    );
  }
}
