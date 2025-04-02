import 'dart:convert';
import 'package:collogefinalpoject/model/patient_setting/history.dart';
import 'package:http/http.dart' as http;

class NailApiService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api';
  final String authToken;

  NailApiService(this.authToken);

  Future<List<NailImageHistory>> getPatientHistory() async {
    final url = Uri.parse('$_baseUrl/patient/showHistory');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> nailImages = data['nail_images'];
          return nailImages.map((json) => NailImageHistory.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load history: API returned success=false');
        }
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }
}