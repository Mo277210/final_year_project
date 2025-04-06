import 'dart:convert';
import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../model/doctor_home/add_clinic.dart';

class DoctorAddClinicApiService {
  static const String baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  final TokenProvider tokenProvider; // Inject TokenProvider

  DoctorAddClinicApiService(this.tokenProvider);

  // Function to add a clinic
  Future<ClinicResponse> addClinic(String name, String address, String phone) async {
    final url = Uri.parse('$baseUrl/AddClinic');
    final body = {
      'name': name,
      'address': address,
      'phone': phone,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenProvider.token}', // Include the token here
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = jsonDecode(response.body);
        return ClinicResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your token.');
      } else {
        throw Exception('Failed to add clinic. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}