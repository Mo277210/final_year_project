class DoctorEditEmailRequest {
  final String email;

  DoctorEditEmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class DoctorEditEmailResponse {
  final bool success;
  final String message;

  DoctorEditEmailResponse({required this.success, required this.message});

  factory DoctorEditEmailResponse.fromJson(Map<String, dynamic> json) {
    return DoctorEditEmailResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}