import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_home/EditClinic.dart';
import 'package:http/http.dart' as http;
import 'package:collogefinalpoject/model/doctor_home/show_clinc.dart';

class editClinicApiService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  // Method to fetch clinics
  Future<List<showClinic>> getClinics(String token) async {
    final url = Uri.parse('$_baseUrl/GetClinics'); // Adjust the endpoint if needed

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('GetClinics Status Code: ${response.statusCode}');
      print('GetClinics Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> clinicsData = jsonData['data']; // Adjust based on API response structure
        return clinicsData.map((clinic) => showClinic.fromJson(clinic)).toList();
      } else {
        throw Exception('Failed to fetch clinics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch clinics: $e');
    }
  }

  // Method to edit a clinic
  Future<EditClinicResponse> editClinic({
    required String token,
    required int clinicId,
    required String name,
    required String address,
    required String phone,
    required String location,
  }) async {
    final url = Uri.parse('$_baseUrl/EditClinic/$clinicId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'address': address,
          'phone': phone,
          'location': location,
        }),
      );

      print('EditClinic Status Code: ${response.statusCode}');
      print('EditClinic Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return EditClinicResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to edit clinic: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to edit clinic: $e');
    }
  }
}