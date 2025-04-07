import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/patient_home/patient_home_image_sender_Model.dart';

class PredictionAPIService {
  final String token; // Add token for Bearer authentication

  PredictionAPIService({required this.token});

  Future<PredictionResponseModel> predictImage(File imageFile) async {
    String url = "https://nagel-production.up.railway.app/api/patient/uploadNailImage";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add Bearer token to headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add the image file with the correct key
      request.files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );

      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Handle the response
      if (response.statusCode == 200) {
        return PredictionResponseModel.fromJson(json.decode(responseBody));
      } else {
        throw Exception("Failed to get prediction: ${json.decode(responseBody)['error']}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}