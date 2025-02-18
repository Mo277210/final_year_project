class DoctorRegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String speciality;
  final String proof;

  DoctorRegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.speciality,
    required this.proof,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "password_confirmation": passwordConfirmation.trim(),
      "phone": phone.trim(),
      "speciality": speciality.trim(),
      "proof": proof.trim(),
    };
  }
}

class DoctorRegisterResponseModel {
  final String message;
  final String? token;
  final String? error;

  DoctorRegisterResponseModel({
    required this.message,
    this.token,
    this.error,
  });

  factory DoctorRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorRegisterResponseModel(
      message: json["message"] ?? "",
      token: json["token"],
      error: json["error"],
    );
  }
}
