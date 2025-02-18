import 'package:http/http.dart' as http;
import 'dart:convert';

class APIServiceDm {
  Future<Map<String, dynamic>> registerPatient({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String address,
  }) async {
    String url = "http://127.0.0.1:8000/api/patient/register";

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phone,
      "address": address,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          "success": true,
          "message": "Registration successful",
          "data": responseBody,
        };
      } else {
        return {
          "success": false,
          "message": responseBody["error"] ?? "Registration failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Network error: $e",
      };
    }
  }
}
