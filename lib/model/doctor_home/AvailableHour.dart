class AvailableHour {
  final int id;
  final String availableHours;

  AvailableHour({
    required this.id,
    required this.availableHours,
  });

  factory AvailableHour.fromJson(Map<String, dynamic> json) {
    return AvailableHour(
      id: json['id'] ?? 0,
      availableHours: json['available_hours'] ?? '',
    );
  }

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

  factory AvailableHoursResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return AvailableHoursResponse(
      data: dataList.map((item) => AvailableHour.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((hour) => hour.toJson()).toList(),
    };
  }
}

class DeleteAvailableHoursResponse {
  final bool success;
  final String message;

  DeleteAvailableHoursResponse({
    required this.success,
    required this.message,
  });

  factory DeleteAvailableHoursResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAvailableHoursResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}