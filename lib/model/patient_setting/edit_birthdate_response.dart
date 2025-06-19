class EditBirthdateResponse {
  final bool success;
  final String message;

  EditBirthdateResponse({required this.success, required this.message});

  factory EditBirthdateResponse.fromJson(Map<String, dynamic> json) {
    return EditBirthdateResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}
