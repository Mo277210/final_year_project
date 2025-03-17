import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/doctor_setting_model/edit_name.dart';

class DoctorAPIService_edit_name {
  // Constant for the API URL
  static const String _editNameUrl =
      'https://nagel-production.up.railway.app/api/doctor/editName';

  Future<EditNameResponse> editName(String token, String newName) async {
    final url = Uri.parse(_editNameUrl);

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "name": newName,
        }),
      );

      final responseBody = json.decode(response.body);

      // Handle different HTTP status codes
      if (response.statusCode == 200) {
        return EditNameResponse.fromJson(responseBody);
      } else if (response.statusCode == 400) {
        throw Exception("Bad request: ${responseBody["error"] ?? "Invalid data"}");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: ${responseBody["error"] ?? "Invalid token"}");
      } else {
        throw Exception(
            "Failed to update name: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      // Log the error for debugging
      print("Error in editName API: $e");
      throw Exception("Network error: $e");
    }
  }
}