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

        // Extract and save IDs
        List<int> clinicIds = clinicResponse.data.map((clinic) => clinic.id).toList();
        print('Extracted Clinic IDs: $clinicIds'); // Debugging output

        return clinicResponse.data;
      } else {
        throw Exception('Failed to load clinics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load clinics: $e');
    }
  }

  // Method to fetch only clinic IDs
  Future<List<int>> getClinicIds(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/DisplayClinics'),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final clinicResponse = ClinicResponse.fromJson(jsonData);

        // Extract and return IDs
        return clinicResponse.data.map((clinic) => clinic.id).toList();
      } else {
        throw Exception('Failed to load clinic IDs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load clinic IDs: $e');
    }
  }
}