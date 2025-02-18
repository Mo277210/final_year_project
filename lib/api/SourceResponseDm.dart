import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_patient_model.dart';


class APIService {
  Future<LoginResponseModel> login(String userType, LoginRequestModel requestModel) async {
    String baseUrl = "http://127.0.0.1:8000/api";
    String url = "$baseUrl/$userType/login"; // Dynamically select patient or doctor

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestModel.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data!');
    }
  }
}