class UploadProfilePictureResponse {
  final bool success;
  final String message;
  final String photoUrl;

  UploadProfilePictureResponse({
    required this.success,
    required this.message,
    required this.photoUrl,
  });

  // Factory constructor to parse JSON into the model
  factory UploadProfilePictureResponse.fromJson(Map<String, dynamic> json) {
    return UploadProfilePictureResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      photoUrl: json['photo_url'] as String,
    );
  }

  // Optional: Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'photo_url': photoUrl,
    };
  }
}