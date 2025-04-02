import 'dart:convert';
import 'package:collogefinalpoject/model/patient_setting/editphone.dart';
import 'package:http/http.dart' as http;

class PatientEditPhoneApiService {
  final String _baseUrl = 'https://nagel-production.up.railway.app/api';
  final String authToken;

  PatientEditPhoneApiService(this.authToken);

  Future<PatientPhoneResponse> updatePhone(String phone) async {
    final url = Uri.parse('$_baseUrl/patient/editPhone');
    final request = PatientPhoneRequest(phone: phone);

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
        return PatientPhoneResponse.fromJson(json.decode(response.body));
      } else {
        throw ApiException.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw ApiException('Failed to update phone: $e');
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
