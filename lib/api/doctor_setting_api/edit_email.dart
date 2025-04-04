import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_setting_model/edit_email.dart';
import 'package:http/http.dart' as http;

class DoctorEditEmailAPIService {
  static const String baseUrl = "https://nagel-production.up.railway.app/api/doctor";
  static const int timeoutSeconds = 30;

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
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': newEmail,
        }),
      ).timeout(const Duration(seconds: timeoutSeconds));

      final responseBody = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return EditEmailResponse.fromJson(responseBody);
        case 400:
          throw Exception(responseBody['message'] ?? 'Bad request');
        case 401:
          throw Exception('Unauthorized - Please login again');
        case 404:
          throw Exception('Doctor not found');
        case 422:
          throw Exception(responseBody['errors']?.values.join('\n') ?? 'Validation failed');
        case 500:
          throw Exception('Server error - Please try again later');
        default:
          throw Exception('Failed to update email: Status ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Data parsing error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}