import 'dart:convert';
import 'package:collogefinalpoject/model/patient_home/address.dart';
import 'package:http/http.dart' as http;

class PatientAddressAPIService {
  static Future<PatientAddress?> fetchPatientAddress(String token) async {
    final url = Uri.parse('https://nagel-production.up.railway.app/api/patient/address');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PatientAddress.fromJson(data);
      }
    } catch (e) {
      print('Error fetching patient address: $e');
    }
    return null;
  }
}
