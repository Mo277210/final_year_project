import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorAvailableHourAPIService {
  static const String _baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  Future<AvailableHoursResponse> getAvailableHours(String token) async {
    final url = Uri.parse('$_baseUrl/DisplayAvailableHours');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Decode the response body
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // Parse the response into the AvailableHoursResponse model
        return AvailableHoursResponse.fromJson(responseBody);
      } else {
        // Throw an exception if the API returns an error
        throw Exception(
            "Failed to fetch available hours: ${responseBody["error"] ?? "Unknown error"}");
      }
    } catch (e) {
      // Handle network or other exceptions
      throw Exception("Network error: $e");
    }
  }
}

class AvailableHour {
  final String availableHours;

  AvailableHour({
    required this.availableHours,
  });

  // Factory constructor to parse JSON into an AvailableHour object
  factory AvailableHour.fromJson(Map<String, dynamic> json) {
    return AvailableHour(
      availableHours: json['available_hours'] ?? '',
    );
  }

  // Convert the object back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'available_hours': availableHours,
    };
  }
}

class AvailableHoursResponse {
  final List<AvailableHour> data;

  AvailableHoursResponse({
    required this.data,
  });

  // Factory constructor to parse JSON into an AvailableHoursResponse object
  factory AvailableHoursResponse.fromJson(Map<String, dynamic> json) {
    // Ensure the 'data' field exists and is a list
    final dataList = json['data'] as List? ?? [];
    return AvailableHoursResponse(
      data: dataList.map((item) => AvailableHour.fromJson(item)).toList(),
    );
  }

  // Convert the object back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((hour) => hour.toJson()).toList(),
    };
  }
}