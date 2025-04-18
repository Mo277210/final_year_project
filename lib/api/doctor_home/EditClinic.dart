import 'dart:convert';
import 'package:collogefinalpoject/model/doctor_home/EditClinic.dart';
import 'package:http/http.dart' as http;

class EditClinicAPI {
  static const String baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  Future<EditClinicResponse?> editClinic({
    required int clinicId,
    required String token,
    required String name,
    String? address,
    String? phone,
    String? location,
  }) async {
    final url = Uri.parse('$baseUrl/EditClinic/$clinicId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
      'address': address ?? '',
      'phone': phone ?? '',
      'location': location ?? '',
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return EditClinicResponse.fromJson(json);
    } else {
      print('Failed to edit clinic: ${response.statusCode} => ${response.body}');
      return null;
    }
  }
}
