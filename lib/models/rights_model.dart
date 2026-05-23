class RightsModel {
  final String id;
  final String title;
  final String description;
  final String lawSection;
  final String penalty;
  final String filingProcess;
  final String downloadPdfUrl;

  RightsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lawSection,
    required this.penalty,
    required this.filingProcess,
    this.downloadPdfUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lawSection': lawSection,
      'penalty': penalty,
      'filingProcess': filingProcess,
      'downloadPdfUrl': downloadPdfUrl,
    };
  }

  factory RightsModel.fromMap(Map<String, dynamic> map) {
    return RightsModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      lawSection: map['lawSection'] ?? '',
      penalty: map['penalty'] ?? '',
      filingProcess: map['filingProcess'] ?? '',
      downloadPdfUrl: map['downloadPdfUrl'] ?? '',
    );
  }
}
