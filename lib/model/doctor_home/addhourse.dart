class ScheduleModel {
  final bool success;
  final Schedule schedule;
  final String message;

  ScheduleModel({
    required this.success,
    required this.schedule,
    required this.message,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      success: json['success'],
      schedule: Schedule.fromJson(json['schedule']),
      message: json['message'],
    );
  }
}

class Schedule {
  final String availableHours;
  final int doctorId;
  final int id;

  Schedule({
    required this.availableHours,
    required this.doctorId,
    required this.id,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      availableHours: json['available_hours'],
      doctorId: json['doctor_id'],
      id: json['id'],
    );
  }
}
