class EditPasswordResponse {
  final bool success;
  final String message;

  EditPasswordResponse({
    required this.success,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory EditPasswordResponse.fromJson(Map<String, dynamic> json) {
    return EditPasswordResponse(
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