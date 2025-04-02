// patient_email_model.dart
class PatientEmailRequest {
  final String email;

  PatientEmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class PatientEmailResponse {
  final bool success;
  final String message;

  PatientEmailResponse({required this.success, required this.message});

  factory PatientEmailResponse.fromJson(Map<String, dynamic> json) {
    return PatientEmailResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}