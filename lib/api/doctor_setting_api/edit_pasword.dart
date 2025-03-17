import 'package:collogefinalpoject/model/doctor_setting_model/edit_pasword.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorAPIService_edit_password {
  // Constant for the API URL
  static const String _editPasswordUrl =
      'https://nagel-production.up.railway.app/api/doctor/editPassword';

  Future<EditPasswordResponse> editPassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final url = Uri.parse(_editPasswordUrl);

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "current_password": currentPassword,
          "new_password": newPassword,
          "new_password_confirmation": newPasswordConfirmation,
        }),
      );

      final responseBody = json.decode(response.body);

      // Handle different HTTP status codes
      if (response.statusCode == 200) {
        return EditPasswordResponse.fromJson(responseBody);
      } else if (response.statusCode == 400) {
        throw Exception("Bad request: ${responseBody["error"] ?? "Invalid data"}");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: ${responseBody["error"] ?? "Invalid token"}");
      } else {
        throw Exception(
            "Failed to update password: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      // Log the error for debugging
      print("Error in editPassword API: $e");
      throw Exception("Network error: $e");
    }
  }
}