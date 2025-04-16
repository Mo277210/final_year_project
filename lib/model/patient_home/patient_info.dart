class PatientInfo {
  final String name;
  final String address;
  final int age;
  final String gender;

  PatientInfo({
    required this.name,
    required this.address,
    required this.age,
    required this.gender,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      name: json['name'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}

class PatientInfoResponse {
  final PatientInfo data;

  PatientInfoResponse({required this.data});

  factory PatientInfoResponse.fromJson(Map<String, dynamic> json) {
    return PatientInfoResponse(
      data: PatientInfo.fromJson(json['data']),
    );
  }
}