// patient_api_service.dart
import 'dart:convert';
import 'package:collogefinalpoject/model/patient_setting/editemail.dart';
import 'package:http/http.dart' as http;

class PatientApiService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api';
  final String authToken;

  PatientApiService(this.authToken);

  Future<PatientEmailResponse> editPatientEmail(String newEmail) async {
    final url = Uri.parse('$_baseUrl/patient/editEmail');
    final request = PatientEmailRequest(email: newEmail);

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PatientEmailResponse.fromJson(data);
      } else {
        throw Exception('Failed to update email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update email: $e');
    }
  }
}