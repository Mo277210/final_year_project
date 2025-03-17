class EditNameResponse {
  final bool success;
  final String message;

  EditNameResponse({
    required this.success,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory EditNameResponse.fromJson(Map<String, dynamic> json) {
    return EditNameResponse(
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