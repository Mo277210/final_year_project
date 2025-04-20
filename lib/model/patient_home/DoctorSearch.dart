// lib/models/doctor.dart
class Doctor {
  final int id;  // Added id field
  final String name;
  final String email;
  final String phone;
  final double? rating;
  final String specialization;
  final num totalRatings;
  final String? photo;
  final List<Clinic> clinics;
  final List<String> availableHours;

  Doctor({
    required this.id,  // Added id parameter
    required this.name,
    required this.email,
    required this.phone,
    this.rating,
    required this.specialization,
    required this.totalRatings,
    this.photo,
    required this.clinics,
    required this.availableHours,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],  // Added id mapping
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      rating: json['rating']?.toDouble(),
      specialization: json['specialization'],
      totalRatings: json['total_ratings'] ?? 0,
      photo: json['photo'],
      clinics: (json['clinics'] as List? ?? [])
          .map((clinic) => Clinic.fromJson(clinic))
          .toList(),
      availableHours: List<String>.from(json['available_hours'] ?? []),
    );
  }
}

class Clinic {
  final int clinic_id;  // Changed from String name to int clinic_id
  final String name;
  final String address;
  final String phone;

  Clinic({
    required this.clinic_id,  // Added clinic_id parameter
    required this.name,
    required this.address,
    required this.phone,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinic_id: json['clinic_id'],  // Added clinic_id mapping
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}