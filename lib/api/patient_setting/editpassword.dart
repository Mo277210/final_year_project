import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collogefinalpoject/model/patient_setting/editpassword.dart';

class PatientEditPasswordApiService {
  final String _baseUrl = 'https://nagel-production.up.railway.app/api';
  final String authToken;

  PatientEditPasswordApiService(this.authToken);

  Future<PatientPasswordResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final url = Uri.parse('$_baseUrl/patient/editPassword');
    final request = PatientPasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

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
        return PatientPasswordResponse.fromJson(json.decode(response.body));
      } else {
        throw ApiException.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw ApiException('Failed to change password: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  factory ApiException.fromJson(Map<String, dynamic> json) {
    return ApiException(json['message'] ?? 'Unknown error occurred');
  }
  @override
  String toString() => 'ApiException: $message';
}
