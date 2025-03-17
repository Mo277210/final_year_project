class PendedDoctorModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String proof;
  final double rating;
  final int totalRatings;
  final String status;
  final String createdAt;
  final String updatedAt;

  PendedDoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.proof,
    required this.rating,
    required this.totalRatings,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory PendedDoctorModel.fromJson(Map<String, dynamic> json) {
    return PendedDoctorModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      specialization: json["specialization"] ?? "",
      proof: json["proof"] ?? "",
      rating: json["rateing"]?.toDouble() ?? 0.0, // Corrected typo in API response
      totalRatings: json["total_rateings"] ?? 0, // Corrected typo in API response
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "specialization": specialization,
      "proof": proof,
      "rateing": rating,
      "total_rateings": totalRatings,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}