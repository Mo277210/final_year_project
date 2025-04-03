// lib/model/patient_setting/logout_response.dart
class PatientLogoutResponse {
  final bool success;
  final String message;

  PatientLogoutResponse({
    required this.success,
    required this.message,
  });

  factory PatientLogoutResponse.fromJson(Map<String, dynamic> json) {
    return PatientLogoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}