class ClinicResponse {
  final bool success;
  final Clinic clinic;
  final String message;

  ClinicResponse({
    required this.success,
    required this.clinic,
    required this.message,
  });

  // Factory method to parse JSON into a ClinicResponse object
  factory ClinicResponse.fromJson(Map<String, dynamic> json) {
    return ClinicResponse(
      success: json['success'],
      clinic: Clinic.fromJson(json['clinic']),
      message: json['message'],
    );
  }

  // Method to convert the object back to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'clinic': clinic.toJson(),
      'message': message,
    };
  }
}

class Clinic {
  final String name;
  final String address;
  final String phone;
  final int doctorId;
  final int id;

  Clinic({
    required this.name,
    required this.address,
    required this.phone,
    required this.doctorId,
    required this.id,
  });

  // Factory method to parse JSON into a Clinic object
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      doctorId: json['doctor_id'],
      id: json['id'],
    );
  }

  // Method to convert the object back to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'doctor_id': doctorId,
      'id': id,
    };
  }
}