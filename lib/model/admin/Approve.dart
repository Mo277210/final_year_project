class ApproveDoctorResponse {
  final bool success;
  final String message;

  ApproveDoctorResponse({
    required this.success,
    required this.message,
  });

  factory ApproveDoctorResponse.fromJson(Map<String, dynamic> json) {
    return ApproveDoctorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}