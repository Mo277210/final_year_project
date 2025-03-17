// api/doctor_setting_api/edit_email.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collogefinalpoject/model/doctor_setting_model/edit_email.dart';

class DoctorAPIService_edit_email {
  final String baseUrl = "https://nagel-production.up.railway.app/api/doctor";

  Future<EditEmailResponse> editEmail({
    required String token,
    required String newEmail,
    required int doctorId,
  }) async {
    final url = Uri.parse('$baseUrl/editEmail');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'email': newEmail,
      'doctor_id': doctorId, // Include the doctor ID in the request body
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return EditEmailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update email');
    }
  }
}