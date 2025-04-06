// lib/services/doctor_service.dart
import 'package:collogefinalpoject/model/patient_home/DoctorSearch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorService {
  Future<List<Doctor>> fetchDoctors() async {
    final response = await http.get(
      Uri.parse('https://nagel-production.up.railway.app/api/patient/showDoctors'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> doctorsJson = data['data'];
      return doctorsJson.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}