class RejectDoctorResponse {
  final bool success;
  final String message;

  RejectDoctorResponse({
    required this.success,
    required this.message,
  });

  factory RejectDoctorResponse.fromJson(Map<String, dynamic> json) {
    return RejectDoctorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}