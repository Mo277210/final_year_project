class EditAddressResponse {
  final bool success;
  final String message;

  EditAddressResponse({required this.success, required this.message});

  factory EditAddressResponse.fromJson(Map<String, dynamic> json) {
    return EditAddressResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}
