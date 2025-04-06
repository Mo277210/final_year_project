import 'dart:io';
import 'package:collogefinalpoject/model/doctor_home/sendimage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://nagel-production.up.railway.app/api/doctor';

  // Function to upload profile picture
  Future<UploadProfilePictureResponse> uploadProfilePicture(File imageFile) async {
    final url = Uri.parse('$baseUrl/UploadProfilePicture');

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Attach the file to the request
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // Send the request and get the response
    final response = await request.send();

    // Read the response body
    final responseBody = await response.stream.bytesToString();

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(responseBody);
      return UploadProfilePictureResponse.fromJson(jsonResponse);
    } else {
      // Handle errors
      throw Exception('Failed to upload profile picture: ${response.statusCode}');
    }
  }
}