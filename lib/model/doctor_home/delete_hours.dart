class DeleteAvailableHourResponse {
  final bool success;
  final String message;

  DeleteAvailableHourResponse({
    required this.success,
    required this.message,
  });

  factory DeleteAvailableHourResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAvailableHourResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'No message provided.',
    );
  }
}
