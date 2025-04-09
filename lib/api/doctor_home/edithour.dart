import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_home/edithour.dart';
import 'package:http/http.dart' as http;

class edithourseDoctorApiService {
  static const String baseUrl = 'https://nagel-production.up.railway.app/api';

  static Future<EditAvailableHoursResponse?> editAvailableHours({
    required int scheduleId,
    required String availableHours,
  }) async {
    final url = Uri.parse('$baseUrl/doctor/EditAvailableHours/$scheduleId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'available_hours': availableHours,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return EditAvailableHoursResponse.fromJson(jsonData);
    } else {
      print('Failed to update schedule: ${response.statusCode}');
      return null;
    }
  }
}
