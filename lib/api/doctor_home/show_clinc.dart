import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collogefinalpoject/model/doctor_home/show_clinc.dart';

class ClinicApiService {
  // Define the base URL for the API
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  // Method to fetch clinics with authentication token
  Future<List<showClinic>> getClinics(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/DisplayClinics'),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      // Log the response for debugging purposes
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final clinicResponse = ClinicResponse.fromJson(jsonData);
        return clinicResponse.data;
      } else {
        throw Exception('Failed to load clinics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load clinics: $e');
    }
  }
}