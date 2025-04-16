import 'dart:convert';
import 'package:collogefinalpoject/model/patient_home/patient_info.dart';
import 'package:http/http.dart' as http;

class PatientInfoApiService {
  final String baseUrl = 'https://nagel-production.up.railway.app/api';

  Future<PatientInfoResponse?> getPatientInfo(String token) async {
    final url = Uri.parse('$baseUrl/patient/info');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PatientInfoResponse.fromJson(jsonData);
      } else {
        print('Failed to fetch patient info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patient info: $e');
    }
    return null;
  }
}