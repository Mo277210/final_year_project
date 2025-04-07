class PredictionResponseModel {
  final String predictedClass;
  final double confidence;
  final Map<String, double> probabilities;

  PredictionResponseModel({
    required this.predictedClass,
    required this.confidence,
    required this.probabilities,
  });

  // Factory constructor to create an instance from JSON
  factory PredictionResponseModel.fromJson(Map<String, dynamic> json) {
    return PredictionResponseModel(
      predictedClass: json["class"] ?? "Unknown",
      confidence: (json["confidence"] ?? 0.0).toDouble(),
      probabilities: Map<String, double>.from(json["probabilities"] ?? {}),
    );
  }

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      "class": predictedClass,
      "confidence": confidence,
      "probabilities": probabilities,
    };
  }
}