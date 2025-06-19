import 'dart:convert';
import 'package:collogefinalpoject/model/patient_setting/editAddress.dart';
import 'package:http/http.dart' as http;

class ApiEditAddress {
  final String baseUrl = "https://nagel-production.up.railway.app/api";

  Future<EditAddressResponse> updatePatientAddress({
    required String token,
    required String address,
  }) async {
    final url = Uri.parse("$baseUrl/patient/editAddress");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'address': address}),
    );

    if (response.statusCode == 200) {
      return EditAddressResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update address. Status code: ${response.statusCode}");
    }
  }
}

