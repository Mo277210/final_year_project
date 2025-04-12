import 'dart:convert';

class PredictionResponseModel {
  final bool success;
  final NailImage nailImage;

  PredictionResponseModel({
    required this.success,
    required this.nailImage,
  });

  factory PredictionResponseModel.fromJson(Map<String, dynamic> json) {
    return PredictionResponseModel(
      success: json['success'] ?? false,
      nailImage: NailImage.fromJson(json['nailImage'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'nailImage': nailImage.toJson(),
  };
}

class NailImage {
  final int patientId;
  final String imageFile;
  final String diagnosis;
  final double confidence;
  final Map<String, double> probabilities;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  NailImage({
    required this.patientId,
    required this.imageFile,
    required this.diagnosis,
    required this.confidence,
    required this.probabilities,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory NailImage.fromJson(Map<String, dynamic> json) {
    Map<String, double> parsedProbs = {};

    if (json['probabilities'] != null && json['probabilities'] is String) {
      try {
        final decoded = jsonDecode(json['probabilities']);
        parsedProbs = (decoded as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
        );
      } catch (e) {
        print('Error decoding probabilities: $e');
      }
    }

    return NailImage(
      patientId: json['patient_id'] ?? 0,
      imageFile: json['image_file'] ?? '',
      diagnosis: json['diagnosis'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
      probabilities: parsedProbs,
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'image_file': imageFile,
    'diagnosis': diagnosis,
    'confidence': confidence,
    'probabilities': jsonEncode(probabilities),
    'updated_at': updatedAt.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'id': id,
  };
}
