class SchemeModel {
  final String id;
  final String title;
  final String description;
  final String eligibility;
  final List<String> applicationSteps;
  final String officialUrl;
  final String category;

  SchemeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.applicationSteps,
    required this.officialUrl,
    this.category = 'Welfare',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eligibility': eligibility,
      'applicationSteps': applicationSteps,
      'officialUrl': officialUrl,
      'category': category,
    };
  }

  factory SchemeModel.fromMap(Map<String, dynamic> map) {
    return SchemeModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      eligibility: map['eligibility'] ?? '',
      applicationSteps: List<String>.from(map['applicationSteps'] ?? []),
      officialUrl: map['officialUrl'] ?? '',
      category: map['category'] ?? 'Welfare',
    );
  }
}
