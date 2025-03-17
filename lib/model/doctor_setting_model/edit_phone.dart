// model/doctor_setting_model/edit_phone.dart
class EditPhoneResponse {
  final bool success;
  final String message;

  EditPhoneResponse({
    required this.success,
    required this.message,
  });

  factory EditPhoneResponse.fromJson(Map<String, dynamic> json) {
    return EditPhoneResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}