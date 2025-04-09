import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_home/delete_hours.dart';
import 'package:http/http.dart' as http;

class DeleteHourApiService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  static Future<DeleteAvailableHourResponse?> deleteAvailableHour(int scheduleId) async {
    final url = Uri.parse('$_baseUrl/DeleteAvailableHours/$scheduleId');

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DeleteAvailableHourResponse.fromJson(jsonData);
      } else {
        print('Failed to delete schedule. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error deleting schedule: $e');
      return null;
    }
  }
}
