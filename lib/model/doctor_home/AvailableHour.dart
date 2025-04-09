class AvailableHour {
  final int id;
  final String availableHours;

  AvailableHour({
    required this.id,
    required this.availableHours,
  });

  // Factory constructor to parse JSON into an AvailableHour object
  factory AvailableHour.fromJson(Map<String, dynamic> json) {
    return AvailableHour(
      id: json['id'] ?? 0,
      availableHours: json['available_hours'] ?? '',
    );
  }

  // Convert the object back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'available_hours': availableHours,
    };
  }
}

class AvailableHoursResponse {
  final List<AvailableHour> data;

  AvailableHoursResponse({
    required this.data,
  });

  // Factory constructor to parse JSON into an AvailableHoursResponse object
  factory AvailableHoursResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return AvailableHoursResponse(
      data: dataList.map((item) => AvailableHour.fromJson(item)).toList(),
    );
  }

  // Convert the object back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((hour) => hour.toJson()).toList(),
    };
  }
}