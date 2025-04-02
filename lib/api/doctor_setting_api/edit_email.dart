import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_setting_model/edit_email.dart';
import 'package:http/http.dart' as http;

class DoctorAPIService_edit_email {
  static const String baseUrl = "https://nagel-production.up.railway.app/api/doctor";

  Future<EditEmailResponse> editEmail({
    required String token,
    required String newEmail,
    required int doctorId,
  }) async {
    final url = Uri.parse('$baseUrl/editEmail/$doctorId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': newEmail,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return EditEmailResponse.fromJson(responseBody);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to update email');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}