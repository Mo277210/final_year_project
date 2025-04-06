class PatientInfo {
  final String name;

  PatientInfo({required this.name});

  // Factory method to convert JSON into a PatientInfo object
  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      name: json['data']['name'],
    );
  }

  // Method to convert PatientInfo object back to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'name': name,
      },
    };
  }
}