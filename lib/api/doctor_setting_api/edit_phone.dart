// api/doctor_setting_api/edit_phone.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collogefinalpoject/model/doctor_setting_model/edit_phone.dart';

class DoctorAPIService_edit_phone {
  final String baseUrl = "https://nagel-production.up.railway.app/api/doctor";

  Future<EditPhoneResponse> editPhone({
    required String token,
    required String newPhone,
  }) async {
    final url = Uri.parse('$baseUrl/editPhone');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'phone': newPhone,
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return EditPhoneResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update phone number');
    }
  }
}