import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/predictionResponseModel.dart';


class PredictionAPIService {
  Future<PredictionResponseModel> predictImage(File imageFile) async {
    String url = "https://41d7-196-153-115-245.ngrok-free.app/predict/";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

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