import 'dart:convert';
import 'package:collogefinalpoject/model/patient_home/name_patient.dart';
import 'package:http/http.dart' as http;

class patient_info_ApiService {
  final String _baseUrl = 'https://nagel-production.up.railway.app/api';

  // Fetch patient info
  Future<PatientInfo> fetchPatientInfo(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/patient/info'),
      headers: {
        'Authorization': 'Bearer $token', // Include the token in the request header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response and return a PatientInfo object
      return PatientInfo.fromJson(json.decode(response.body));
    } else {
      // Throw an exception if the request fails
      throw Exception('Failed to load patient info: ${response.statusCode}');
    }
  }
}