class UploadPhotoResponse {
  final bool success;
  final String message;
  final String photoUrl;

  UploadPhotoResponse({
    required this.success,
    required this.message,
    required this.photoUrl,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) {
    return UploadPhotoResponse(
      success: json['success'],
      message: json['message'],
      photoUrl: json['photo_url'],
    );
  }
}
