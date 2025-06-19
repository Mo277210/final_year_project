import 'dart:convert';
import 'package:collogefinalpoject/model/patient_setting/edit_birthdate_response.dart';
import 'package:http/http.dart' as http;

class ApiEditBirthdate {
  final String baseUrl = "https://nagel-production.up.railway.app/api";

  Future<EditBirthdateResponse> updateBirthdate({
    required String token,
    required String dob,
  }) async {
    final url = Uri.parse("$baseUrl/patient/editBirthdate");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'DOB': dob}),
    );

    if (response.statusCode == 200) {
      return EditBirthdateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update birthdate. Status code: ${response.statusCode}");
    }
  }
}

