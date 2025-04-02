// patient_api_service.dart
import 'dart:convert';
import 'package:collogefinalpoject/model/patient_setting/editname.dart';
import 'package:http/http.dart' as http;

class PatientApiService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api';
  final String authToken;

  PatientApiService(this.authToken);

  Future<PatientNameResponse> editPatientName(String newName) async {
    final url = Uri.parse('$_baseUrl/patient/editName');
    final request = PatientNameRequest(name: newName);

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
        return PatientNameResponse.fromJson(data);
      } else {
        throw Exception('Failed to update name: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }
}