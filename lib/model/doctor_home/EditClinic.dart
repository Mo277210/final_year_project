import 'package:collogefinalpoject/model/doctor_home/show_clinc.dart';

class EditClinicResponse {
  final bool success;
  final showClinic clinic;
  final String message;

  EditClinicResponse({
    required this.success,
    required this.clinic,
    required this.message,
  });

  factory EditClinicResponse.fromJson(Map<String, dynamic> json) {
    return EditClinicResponse(
      success: json['success'] ?? false,
      clinic: showClinic.fromJson(json['clinic'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'clinic': clinic.toJson(),
      'message': message,
    };
  }
}
