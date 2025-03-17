class EditEmailResponse {
  final bool success;
  final String message;

  EditEmailResponse({
    required this.success,
    required this.message,
  });

  factory EditEmailResponse.fromJson(Map<String, dynamic> json) {
    return EditEmailResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}