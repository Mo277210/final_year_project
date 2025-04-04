import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_setting_model/edit_email.dart';
import 'package:http/http.dart' as http;

class DoctorEditEmailAPIService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api';
  final String authToken;

  DoctorEditEmailAPIService(this.authToken);

  Future<DoctorEditEmailResponse> editDoctorEmail(String newEmail) async {
    final url = Uri.parse('$_baseUrl/doctor/editEmail');
    final request = DoctorEditEmailRequest(email: newEmail);

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
        return DoctorEditEmailResponse.fromJson(data);
      } else {
        throw Exception('Failed to update email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update email: $e');
    }
  }
}
