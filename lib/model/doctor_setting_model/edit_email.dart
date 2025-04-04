class EditEmailResponse {
  final bool success;
  final String message;

  EditEmailResponse({
    required this.success,
    required this.message,
  });

  factory EditEmailResponse.fromJson(Map<String, dynamic> json) {
    return EditEmailResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
  };
}