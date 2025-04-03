// lib/api/patient_setting/logout_api.dart
import 'package:collogefinalpoject/model/patient_setting/Logout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PatientLogoutApiService {
  final String token;

  PatientLogoutApiService(this.token);

  Future<PatientLogoutResponse> logout() async {
    final url = Uri.parse('https://nagel-production.up.railway.app/api/patient/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return PatientLogoutResponse.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }
}