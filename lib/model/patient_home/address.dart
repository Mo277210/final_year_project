class PatientAddress {
  final String address;

  PatientAddress({required this.address});

  factory PatientAddress.fromJson(Map<String, dynamic> json) {
    return PatientAddress(address: json['data']['address'] ?? '');
  }
}
