class PatientPhoneRequest {
  final String phone;

  PatientPhoneRequest({required this.phone});

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }
}

class PatientPhoneResponse {
  final bool success;
  final String message;

  PatientPhoneResponse({required this.success, required this.message});

  factory PatientPhoneResponse.fromJson(Map<String, dynamic> json) {
    return PatientPhoneResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'No message provided',
    );
  }
}
