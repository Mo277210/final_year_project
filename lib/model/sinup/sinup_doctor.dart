class SinupResponseModelDM {
  final bool success;
  final String token;
  final String error;
  final String message;
  final DoctorModel? doctor;

  SinupResponseModelDM({
    required this.success,
    required this.token,
    required this.error,
    required this.message,
    this.doctor,
  });

  factory SinupResponseModelDM.fromJson(Map<String, dynamic> json) {
    return SinupResponseModelDM(
      success: json["success"] ?? false,
      token: json["token"] ?? "",
      error: json["error"] ?? "",
      message: json["message"] ?? "",
      doctor: json["doctore"] != null ? DoctorModel.fromJson(json["doctore"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "token": token,
      "error": error,
      "message": message,
      "doctore": doctor?.toJson(),
    };
  }
}

class DoctorModel {
  final String name;
  final String email;
  final String phone;
  final String specialization; // Changed from speciality to specialization
  final Map<String, dynamic> proof;
  final String updatedAt;
  final String createdAt;
  final int id;

  DoctorModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization, // Changed from speciality to specialization
    required this.proof,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      specialization: json["specialization"] ?? "", // Changed from speciality to specialization
      proof: json["proof"] ?? {},
      updatedAt: json["updated_at"] ?? "",
      createdAt: json["created_at"] ?? "",
      id: json["id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "specialization": specialization, // Changed from speciality to specialization
      "proof": proof,
      "updated_at": updatedAt,
      "created_at": createdAt,
      "id": id,
    };
  }
}