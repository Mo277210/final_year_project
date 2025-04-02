// patient_name_model.dart
class PatientNameRequest {
  final String name;

  PatientNameRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class PatientNameResponse {
  final bool success;
  final String message;

  PatientNameResponse({required this.success, required this.message});

  factory PatientNameResponse.fromJson(Map<String, dynamic> json) {
    return PatientNameResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}