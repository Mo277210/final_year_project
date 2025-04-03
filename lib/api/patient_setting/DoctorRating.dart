import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:collogefinalpoject/model/patient_setting/DoctorRating.dart';

class DoctorRatingApiService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api';

  static Future<DoctorRating> rateDoctor({
    required BuildContext context,
    required double rating,
  }) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final url = Uri.parse('$_baseUrl/doctors/5/rate'); // Ensure this matches the backend endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${tokenProvider.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'rateing': rating, // Note: Typo in 'rateing'
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return DoctorRating.fromJson(responseData);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}