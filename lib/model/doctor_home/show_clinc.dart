class showClinic {
  final int id; // New field added
  final String name;
  final String phone;
  final String address;

  showClinic({
    required this.id, // Include id in constructor
    required this.name,
    required this.phone,
    required this.address,
  });

  factory showClinic.fromJson(Map<String, dynamic> json) {
    return showClinic(
      id: json['id'] ?? 0, // Handle null id
      name: json['name'] ?? 'Unnamed Clinic',
      phone: json['phone'] ?? 'N/A',
      address: json['address'] ?? 'No address available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Add id to toJson
      'name': name,
      'phone': phone,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'Clinic(id: $id, name: $name, phone: $phone, address: $address)';
  }
}


// Clinic Response Model
class ClinicResponse {
  final List<showClinic> data;

  ClinicResponse({required this.data});

  factory ClinicResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List? ?? []; // Handle null data list
    List<showClinic> clinics =
    dataList.map((item) => showClinic.fromJson(item)).toList();
    return ClinicResponse(data: clinics);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((clinic) => clinic.toJson()).toList(),
    };
  }
}