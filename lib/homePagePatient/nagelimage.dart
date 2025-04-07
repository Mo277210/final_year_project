import 'dart:io';
import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/homePagePatient/questionsdiseasesScreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../api/patient_home/patient_home_image_sender_APIService.dart';
import '../model/patient_home/patient_home_image_sender_Model.dart';


class Nagelimage extends StatefulWidget {
  @override
  _Nagelimage createState() => _Nagelimage();
}

class _Nagelimage extends State<Nagelimage> {
  String? _selectedFile;
  PredictionResponseModel? _predictionResult;
  bool _isLoading = false;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.path;
      });
    }
  }

  void _sendImage() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an image before sending.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      File imageFile = File(_selectedFile!);
      // Retrieve the token from TokenProvider
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      String token = tokenProvider.token;

      PredictionAPIService apiService = PredictionAPIService(token: token);

      // Call the API to predict the image
      PredictionResponseModel response = await apiService.predictImage(imageFile);

      setState(() {
        _predictionResult = response;
        _isLoading = false;
      });

      // Show the prediction result in a dialog
      _showPredictionResult(response);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPredictionResult(PredictionResponseModel result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prediction Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Predicted Class: ${result.predictedClass}'),
              Text('Confidence: ${result.confidence.toStringAsFixed(2)}%'),
              const SizedBox(height: 10),
              const Text('Probabilities:'),
              ...result.probabilities.entries.map((entry) {
                return Text('${entry.key}: ${entry.value.toStringAsFixed(2)}%');
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
                // Navigate to FilterPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxHeight: double.infinity),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Upload nail image ",
                      style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedFile == null
                            ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.blue),
                              SizedBox(height: 10),
                              Text(
                                'Tap to add photo',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedFile!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF105DFB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Choose Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Send Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text(
                "Please upload a clear image of the affected area",
                style: TextStyle(fontSize: 14, color: Color(0xff5a5c60), fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}