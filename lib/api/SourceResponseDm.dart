import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_patient_model.dart';

class APIService {
  Future<LoginResponseModel> login(
      String userType, LoginRequestModel requestModel) async {
    String url = "";
    if (userType == "patient") {
      url = "https://nagel-production.up.railway.app/api/patient/login";
    } else if (userType == "doctor") {
      url = "https://nagel-production.up.railway.app/api/doctor/login";
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestModel.toJson()),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(responseBody);
      } else {
        return LoginResponseModel.fromJson({
          "token": "",
          "error":
              responseBody["error"] ?? "Invalid credentials or server error",
        });
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
