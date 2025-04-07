class SinupPatientResponseModelDM {
  final bool success;
  final String message;
  final PatientModel? patient;

  SinupPatientResponseModelDM({
    required this.success,
    required this.message,
    this.patient,
  });

  factory SinupPatientResponseModelDM.fromJson(Map<String, dynamic> json) {
    return SinupPatientResponseModelDM(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      patient: json["patient"] != null ? PatientModel.fromJson(json["patient"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "patient": patient?.toJson(),
    };
  }
}

class PatientModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String DOB;
  final String gender;
  final String address;
  final int id;

  PatientModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.DOB,
    required this.gender,
    required this.address,
    required this.id,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      phone: json["phone"] ?? "",
      DOB: json["DOB"] ?? "",
      gender: json["gender"] ?? "",
      address: json["address"] ?? "",
      id: json["id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "DOB": DOB,
      "gender": gender,
      "address": address,
      "id": id,
    };
  }
}
