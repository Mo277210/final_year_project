class EditAvailableHoursResponse {
  final bool success;
  final Schedule schedule;
  final String message;

  EditAvailableHoursResponse({
    required this.success,
    required this.schedule,
    required this.message,
  });

  factory EditAvailableHoursResponse.fromJson(Map<String, dynamic> json) {
    return EditAvailableHoursResponse(
      success: json['success'],
      schedule: Schedule.fromJson(json['schedule']),
      message: json['message'],
    );
  }
}

class Schedule {
  final int id;
  final String availableHours;
  final int doctorId;

  Schedule({
    required this.id,
    required this.availableHours,
    required this.doctorId,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      availableHours: json['available_hours'],
      doctorId: json['doctor_id'],
    );
  }
}
