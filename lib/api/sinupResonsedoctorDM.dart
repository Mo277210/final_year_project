import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import '../model/sinup_doctor.dart';

class APIServiceDm {
  Future<SinupResponseModelDM> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String specialization, // Changed from speciality to specialization
    required File proof,
  }) async {
    String url = "https://nagel-production.up.railway.app/api/doctor/register";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Adding fields to the request
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['password_confirmation'] = passwordConfirmation;
      request.fields['phone'] = phone;
      request.fields['specialization'] = specialization; // Changed from speciality to specialization

      // Attaching the proof file
      var fileExtension = proof.path.split('.').last;
      request.files.add(await http.MultipartFile.fromPath(
        'proof',
        proof.path,
        contentType: MediaType('image', fileExtension), // Adjust dynamically
      ));

      // Sending the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return SinupResponseModelDM.fromJson(responseBody);
      } else {
        return SinupResponseModelDM.fromJson({
          "success": false,
          "token": "",
          "error": responseBody["error"] ?? "Registration failed",
          "message": responseBody["message"] ?? "An error occurred",
          "doctore": null,
        });
      }
    } catch (e) {
      print("Network error: $e"); // Log the error for debugging
      throw Exception("Network error: $e");
    }
  }
}