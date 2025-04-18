class EditClinic {
  final int id;
  final String? name;
  final String? address;
  final String? location;
  final int doctorId;
  final String? phone;

  EditClinic({
    required this.id,
    this.name,
    this.address,
    this.location,
    required this.doctorId,
    this.phone,
  });

  factory EditClinic.fromJson(Map<String, dynamic> json) {
    return EditClinic(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      location: json['location'],
      doctorId: json['doctor_id'],
      phone: json['phone'],
    );
  }
}

class EditClinicResponse {
  final bool success;
  final EditClinic clinic;
  final String message;

  EditClinicResponse({
    required this.success,
    required this.clinic,
    required this.message,
  });

  factory EditClinicResponse.fromJson(Map<String, dynamic> json) {
    return EditClinicResponse(
      success: json['success'],
      clinic: EditClinic.fromJson(json['clinic']),
      message: json['message'],
    );
  }
}
