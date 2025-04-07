import 'package:collogefinalpoject/model/admin/Reject.dart';
import 'package:collogefinalpoject/model/admin/Approve.dart'; // New import for Approve model
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/admin/admin_home.dart';

class adminAPIService {
  static const String baseUrl = 'https://nagel-production.up.railway.app/api/admin';

  Future<List<PendedDoctorModel>> showPendedDoctors(String token) async {
    final url = Uri.parse('$baseUrl/showPendedDoctors');

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
        if (responseBody is List) {
          return responseBody.map<PendedDoctorModel>((doctor) => PendedDoctorModel.fromJson(doctor)).toList();
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception(
            "Failed to fetch pended doctors: ${responseBody["message"] ?? "Status code: ${response.statusCode}"}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<RejectDoctorResponse> rejectDoctor({
    required String token,
    required int doctorId,
  }) async {
    final url = Uri.parse('$baseUrl/rejectDoctor/$doctorId');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "status": "rejected",
        }),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return RejectDoctorResponse.fromJson(responseBody);
      } else {
        throw Exception(
            "Failed to reject doctor: ${responseBody["message"] ?? "Status code: ${response.statusCode}"}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<ApproveDoctorResponse> approveDoctor({
    required String token,
    required int doctorId,
  }) async {
    final url = Uri.parse('$baseUrl/approveDoctor/$doctorId');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "status": "approved",
        }),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return ApproveDoctorResponse.fromJson(responseBody);
      } else {
        throw Exception(
            "Failed to approve doctor: ${responseBody["message"] ?? "Status code: ${response.statusCode}"}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}