import 'dart:convert';

import 'package:collogefinalpoject/model/doctor_home/AvailableHour.dart';
import 'package:http/http.dart' as http;
class DoctorAvailableHourAPIService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  Future<AvailableHoursResponse> getAvailableHours(String token) async {
    final url = Uri.parse('$_baseUrl/DisplayAvailableHours');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return AvailableHoursResponse.fromJson(responseBody);
      } else {
        throw Exception(
            "Failed to fetch available hours: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<DeleteAvailableHoursResponse> deleteAvailableHour({
    required int id,
    required String token,
  }) async {
    final url = Uri.parse("$_baseUrl/DeleteAvailableHours/$id");

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return DeleteAvailableHoursResponse.fromJson(jsonBody);
    } else {
      throw Exception("Failed to delete available hour. Status code: ${response.statusCode}");
    }
  }
}