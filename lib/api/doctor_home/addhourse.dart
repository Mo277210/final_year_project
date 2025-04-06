import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_home/addhourse.dart';
import 'package:http/http.dart' as http;

class DoctoraddhoursApiService {
  static const String baseUrl = 'https://nagel-production.up.railway.app';

  Future<ScheduleModel> addAvailableHours(String token, String availableHours) async {
    final url = Uri.parse('$baseUrl/api/doctor/AddAvailableHours');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'available_hours': availableHours}),
    );

    if (response.statusCode == 200) {
      return ScheduleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add available hours');
    }
  }
}
