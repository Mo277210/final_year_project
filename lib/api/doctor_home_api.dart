import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/doctor_home_model.dart';


class DoctorAPIService {
  Future<DoctorInfoModel> getDoctorInfo(String token) async {
    final url = Uri.parse('https://nagel-production.up.railway.app/api/doctor/info');

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
        // Assuming the response is a JSON object containing doctor info
        return DoctorInfoModel.fromJson(responseBody["data"]);
      } else {
        throw Exception(
            "Failed to fetch doctor info: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}