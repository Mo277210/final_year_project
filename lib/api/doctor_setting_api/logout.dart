import 'package:collogefinalpoject/model/doctor_setting_model/logout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorAPIService_logout {
  // Constant for the API URL
  static const String _logoutUrl =
      'https://nagel-production.up.railway.app/api/doctor/logout';

  Future<DoctorLogoutResponse> logout(String token) async {
    final url = Uri.parse(_logoutUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final responseBody = json.decode(response.body);

      // Handle different HTTP status codes
      if (response.statusCode == 200) {
        return DoctorLogoutResponse.fromJson(responseBody);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: ${responseBody["error"] ?? "Invalid token"}");
      } else {
        throw Exception(
            "Failed to logout: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      // Log the error for debugging
      print("Error in logout API: $e");
      throw Exception("Network error: $e");
    }
  }
}