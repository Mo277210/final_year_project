import 'dart:convert';
import 'dart:io';
import 'package:collogefinalpoject/model/doctor_home/sendimage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DoctorApiService {
  static const String baseUrl = 'https://nagel-production.up.railway.app';

  Future<UploadPhotoResponse> uploadProfilePicture(File imageFile, String token) async {
    final url = Uri.parse('$baseUrl/api/doctor/UploadProfilePicture');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return UploadPhotoResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to upload photo');
    }
  }
}
