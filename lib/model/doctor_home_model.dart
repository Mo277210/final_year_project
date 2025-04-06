class DoctorInfoModel {
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final num totalRatings;
   String photo; // Add this field

  DoctorInfoModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.totalRatings,
    required this.photo, // Include this field in the constructor
  });

  // Factory constructor to create an instance from JSON
  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      specialization: json["specialization"] ?? "",
      totalRatings: json["total_rateings"] ?? 0,
      photo: json["photo"] ?? "", // Parse the photo field
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
      "photo": photo, // Include the photo field in the JSON representation
    };
  }
}