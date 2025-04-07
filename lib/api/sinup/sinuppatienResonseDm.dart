import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import '../../model/sinup/sinup_patient.dart'; // Update the import to refer to the correct model

class APIPatientServiceDm { // Renamed to reflect that it's for patients
  Future<SinupPatientResponseModelDM> registerPatient({ // Updated to use SinupPatientResponseModelDM
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String DOB,
    required String gender,
    required String address,
  }) async {
    String url = "https://nagel-production.up.railway.app/api/patient/register";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Adding fields to the request
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['password_confirmation'] = passwordConfirmation;
      request.fields['phone'] = phone;
      request.fields['DOB'] = DOB;
      request.fields['gender'] = gender;
      request.fields['address'] = address;

      // Sending the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return SinupPatientResponseModelDM.fromJson(responseBody);
      } else {
        return SinupPatientResponseModelDM.fromJson({
          "success": false,
          "message": responseBody["message"] ?? "An error occurred",
          "patient": null,
        });
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
