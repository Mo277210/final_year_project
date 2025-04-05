class showClinic {
  final String name;
  final String phone;
  final String address;

  showClinic({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory showClinic.fromJson(Map<String, dynamic> json) {
    return showClinic(
      name: json['name'] ?? 'Unnamed Clinic', // Handle null name
      phone: json['phone'] ?? 'N/A', // Handle null phone
      address: json['address'] ?? 'No address available', // Handle null address
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'Clinic(name: $name, phone: $phone, address: $address)';
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