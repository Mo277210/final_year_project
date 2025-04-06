import 'dart:convert';

class NailImageHistory {
  final int id;
  final int patientId;
  final String imageFile;
  final String diagnosis;
  final double confidence;
  final Map<String, double> probabilities;
  final DateTime createdAt;
  final DateTime updatedAt;

  NailImageHistory({
    required this.id,
    required this.patientId,
    required this.imageFile,
    required this.diagnosis,
    required this.confidence,
    required this.probabilities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NailImageHistory.fromJson(Map<String, dynamic> json) {
    return NailImageHistory(
      id: json['id'],
      patientId: json['patient_id'],
      imageFile: json['image_file'],
      diagnosis: json['diagnosis'],
      confidence: double.parse(json['confidence'].toString()),
      probabilities: _parseProbabilities(json['probabilities']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static Map<String, double> _parseProbabilities(String probabilitiesJson) {
    final Map<String, dynamic> parsed = Map<String, dynamic>.from(json.decode(probabilitiesJson));
    return parsed.map((key, value) => MapEntry(key, double.parse(value.toString())));
  }

  String get fullImageUrl {
    // Assuming the API is hosted and the image paths are relative to the base URL
    return 'https://nagel-production.up.railway.app/storage/$imageFile';
  }
}