class DoctorInfoModel {
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final int totalRatings;

  DoctorInfoModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.totalRatings,
  });

  // Factory constructor to create an instance from JSON
  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      specialization: json["specialization"] ?? "",
      totalRatings: json["total_rateings"] ?? 0,
    );
  }

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "specialization": specialization,
      "total_rateings": totalRatings,
    };
  }
}