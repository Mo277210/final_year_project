import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/admin_home.dart'; // Import the PendedDoctorModel

class APIService {
  Future<List<PendedDoctorModel>> showPendedDoctors(String token) async {
    final url = Uri.parse('https://nagel-production.up.railway.app/api/admin/showPendedDoctors');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // Assuming the response is a list of pended doctors
        List<PendedDoctorModel> pendedDoctors = (responseBody as List)
            .map((doctor) => PendedDoctorModel.fromJson(doctor))
            .toList();
        return pendedDoctors;
      } else {
        throw Exception(
            "Failed to fetch pended doctors: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}