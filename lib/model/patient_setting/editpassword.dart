class PatientPasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  PatientPasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }
}

class PatientPasswordResponse {
  final bool success;
  final String message;

  PatientPasswordResponse({required this.success, required this.message});

  factory PatientPasswordResponse.fromJson(Map<String, dynamic> json) {
    return PatientPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'No message provided',
    );
  }
}
