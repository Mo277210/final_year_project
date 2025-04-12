import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/patient_home/patient_home_image_sender_Model.dart';

class PredictionAPIService {
  final String token;

  PredictionAPIService({required this.token});

  Future<PredictionResponseModel> predictImage(File imageFile) async {
    const String url = "https://nagel-production.up.railway.app/api/patient/uploadNailImage";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // إضافة التوكن
      request.headers['Authorization'] = 'Bearer $token';

      // إرفاق الصورة
      request.files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );

      // إرسال الطلب واستقبال الرد
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // تحويل JSON
      final decodedJson = json.decode(responseBody);
      final parsedMap = Map<String, dynamic>.from(decodedJson);

      // التحقق من نجاح الاستجابة
      if (parsedMap['success'] == true || response.statusCode == 200) {
        return PredictionResponseModel.fromJson(parsedMap);
      } else {
        final errorMessage = parsedMap['error'] ?? 'Unknown error occurred';
        throw Exception('Prediction failed: $errorMessage');
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
