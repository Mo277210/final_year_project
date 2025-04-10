class DeleteAvailableHoursResponse {
  final bool success;
  final String message;

  DeleteAvailableHoursResponse({
    required this.success,
    required this.message,
  });

  // Factory constructor to parse JSON into a DeleteAvailableHoursResponse object
  factory DeleteAvailableHoursResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAvailableHoursResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}