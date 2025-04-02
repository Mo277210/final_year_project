class PendedDoctorModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String proof;
  final String? photo; // Added photo field
  final double rating;
  final int totalRatings;
  final String status;
  final DateTime createdAt; // Changed to DateTime
  final DateTime updatedAt; // Changed to DateTime

  PendedDoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.proof,
    this.photo,
    required this.rating,
    required this.totalRatings,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendedDoctorModel.fromJson(Map<String, dynamic> json) {
    return PendedDoctorModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      specialization: json["specialization"] ?? "",
      proof: json["proof"] ?? "",
      photo: json["photo"],
      rating: (json["rateing"] ?? 0).toDouble(),
      totalRatings: json["total_rateings"] ?? 0,
      status: json["status"] ?? "",
      createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "specialization": specialization,
      "proof": proof,
      "photo": photo,
      "rateing": rating,
      "total_rateings": totalRatings,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  // Helper method to get full proof URL
  String get fullProofUrl {
    if (proof.startsWith('http')) return proof;
    return 'https://nagel-production.up.railway.app/$proof';
  }

  // Helper method to get full photo URL if exists
  String? get fullPhotoUrl {
    if (photo == null) return null;
    if (photo!.startsWith('http')) return photo;
    return 'https://nagel-production.up.railway.app/$photo';
  }
}