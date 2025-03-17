class DoctorLogoutResponse {
  final bool success;
  final String message;

  DoctorLogoutResponse({
    required this.success,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory DoctorLogoutResponse.fromJson(Map<String, dynamic> json) {
    return DoctorLogoutResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }
}